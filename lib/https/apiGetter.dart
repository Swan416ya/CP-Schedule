import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class apiGetter {
  static void get(String url, Function callback,
      {Map<String, String> params = const {}, required Function errorCallback}) async {
    if (params != null && params.isNotEmpty) {
      StringBuffer sb = new StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=" + "$value" + "&");
      });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url += paramStr;
    }
    print("$url");
    try {
      Dio dio = new Dio();
      var cookieJar = CookieJar();
      dio.interceptors.add(CookieManager(cookieJar));
      Response res = await dio.get(url);
      if (callback != null) {
        callback(res.data);
      }
    } catch (exception) {
      if (errorCallback != null) {
        errorCallback(exception);
      }
    }
  }

  static void post(String url, Function callback,
      {Map<String, String> params = const {}, required Function errorCallback}) async {
    try {
      Dio dio = new Dio();
      var cookieJar = CookieJar();
      dio.interceptors.add(CookieManager(cookieJar));
      Response res = await dio.post(url, data: params);
      if (callback != null) {
        callback(res.data);
      }
    } catch (e) {
      if (errorCallback != null) {
        errorCallback(e);
      }
    }
  }
}