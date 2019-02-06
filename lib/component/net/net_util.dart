import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

class NetUtil {
  static Future<String> GET(
      {@required String url, Map<String, dynamic> params}) async {
    Response response = await Dio().get(url, queryParameters: params);
    return response.data.toString();
  }

  static Future<dynamic> POST({@required String url, dynamic params}) async {
    Response response = await Dio().post("http://kmr.service.kugou.com/v1/author_image/audio", data: params);
    return response.data;
  }
}
