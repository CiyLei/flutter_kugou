
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:palette_generator/palette_generator.dart';

class PaletteUtil {

  SendPort sendPort;

  PaletteUtil() {
    _init();
  }

  _init() async{
    var receivePort = new ReceivePort();
    await Isolate.spawn(_newIsolate, receivePort.sendPort);

    // 'echo'发送的第一个message，是它的SendPort
    this.sendPort = await receivePort.first;
  }

  /// 对某个port发送消息，并接收结果
  Future _sendReceive(SendPort port, msg) {
    ReceivePort response = new ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }

  Future<Color> sendImageProvider(ImageProvider imageProvider) async{
    return await _sendReceive(sendPort, imageProvider);
  }

  void close() async{
    _sendReceive(sendPort, "");
  }

  static _newIsolate(SendPort sendPort) async {
  // 实例化一个ReceivePort 以接收消息
    var port = new ReceivePort();

    // 把它的sendPort发送给宿主isolate，以便宿主可以给它发送消息
    sendPort.send(port.sendPort);

    // 监听消息
    await for (var msg in port) {
      if (msg[0] is ImageProvider) {
        ImageProvider imageProvider = msg[0];
        SendPort replyTo = msg[1];
        Color c = await _getImagePaletteColor(imageProvider);
        replyTo.send(c);
      } else {
        port.close();
      }
    }
  }

  // 获取图片主色调
  static Future<Color> _getImagePaletteColor(ImageProvider imageProvider) async {
    if (!_paletteCache.containsKey(imageProvider)){
      PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
      int num = 0; // 因为有可能失败，所以再给他3次机会
      while((paletteGenerator.dominantColor == null || paletteGenerator.dominantColor.color == null) && num < 3) {
        num++;
        paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
      }
      _paletteCache[imageProvider] = paletteGenerator.dominantColor?.color;
    }
    return _paletteCache[imageProvider];
  }

  static Map<ImageProvider, Color> _paletteCache = {};
}