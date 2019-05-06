import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui show Codec;

class MyNetworkImage extends ImageProvider<MyNetworkImage> {
  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments must not be null.
  const MyNetworkImage(this.url,
      {this.scale = 1.0, this.headers, this.sdCache = true})
      : assert(url != null),
        assert(scale != null);

  /// The URL from which the image will be fetched.
  final String url;

  final bool sdCache; //加一个标志为  是否需要缓存到sd卡

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  /// The HTTP headers that will be used with [HttpClient.get] to fetch image from network.
  final Map<String, String> headers;

  @override
  Future<MyNetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<MyNetworkImage>(this);
  }

  @override
  ImageStreamCompleter load(MyNetworkImage key) {
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key),
        scale: key.scale,
        informationCollector: () sync* {
          yield DiagnosticsProperty<ImageProvider>('Image provider', this);
          yield DiagnosticsProperty<MyNetworkImage>('Image key', key);
        });
  }

  static final HttpClient _httpClient = HttpClient();

  Future<ui.Codec> _loadAsync(MyNetworkImage key) async {
    assert(key == this);
    //本地已经缓存过就直接返回图片
    if (sdCache != null && sdCache) {
      final Uint8List bytes = await _getFromSdcard(key.url);
      if (bytes != null &&
          bytes.lengthInBytes != null &&
          bytes.lengthInBytes != 0) {
//        print("success");
        return await PaintingBinding.instance.instantiateImageCodec(bytes);
      }
    }
    final Uri resolved = Uri.base.resolve(key.url);
    final HttpClientRequest request = await _httpClient.getUrl(resolved);
    headers?.forEach((String name, String value) {
      request.headers.add(name, value);
    });
    final HttpClientResponse response = await request.close();

    if (response.statusCode != HttpStatus.ok)
      throw Exception(
          'HTTP request failed, statusCode: ${response?.statusCode}, $resolved');

    final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
//网络请求结束后缓存图片到本地
    if (sdCache != null && sdCache && bytes.lengthInBytes != 0) {
      _saveToImage(bytes, key.url);
    }
    if (bytes.lengthInBytes == 0)
      throw Exception('MyNetworkImage is an empty file: $resolved');

    return await PaintingBinding.instance.instantiateImageCodec(bytes);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final MyNetworkImage typedOther = other;
    return url == typedOther.url && scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(url, scale);

  @override
  String toString() => '$runtimeType("$url", scale: $scale)';

//  图片路径MD5一下 缓存到本地
  void _saveToImage(Uint8List mUint8List, String name) async {
    name = md5.convert(utf8.encode(name)).toString();
    Directory dir = await getTemporaryDirectory();
    String path = dir.path + "/" + name;
    var file = File(path);
    bool exist = await file.exists();
//    print("path =${path}");
    if (!exist) File(path).writeAsBytesSync(mUint8List);
  }

  _getFromSdcard(String name) async {
    name = md5.convert(utf8.encode(name)).toString();
    Directory dir = await getTemporaryDirectory();
    String path = dir.path + "/" + name;
    var file = File(path);
    bool exist = await file.exists();
    if (exist) {
      final Uint8List bytes = await file.readAsBytes();
      return bytes;
    }
    return null;
  }
}
