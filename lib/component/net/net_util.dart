import 'dart:async';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

class NetUtil {

  static Future<String> GET({@required String url, Map<String, dynamic> params}) async {
    Response response = await Dio().get(url, queryParameters: params);
    return response.data.toString();
  }

}