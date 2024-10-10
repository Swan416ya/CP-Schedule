import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class WebHelper {
  static late final Dio dio;
  static late CookieManager cookieManager;
  CancelToken _cancelToken = CancelToken();

  static final WebHelper _instance = WebHelper._internal();
  factory WebHelper() => _instance;
  WebHelper._internal() {
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 30).inMilliseconds,
      receiveTimeout: const Duration(seconds: 30).inMilliseconds,
      sendTimeout: const Duration(seconds: 30).inMilliseconds,
    );
    dio = Dio(options);
    var cookiePath = 'cp_schedule/cookies/';
    cookieManager =
        CookieManager(PersistCookieJar(storage: FileStorage(cookiePath)));
    dio.interceptors.add(cookieManager);
  }

  get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  post(
    String path, {
    Map<String, dynamic>? queryParameters,
    data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  download(urlPath, savePath) async {
    Response response;
    response = await dio.download(urlPath, savePath,
        onReceiveProgress: (int count, int total) {});
    return response.data;
  }

  void cancel({required CancelToken token}) {
    _cancelToken.cancel("cancelled");
    _cancelToken = token;
  }
}

class apiGetter{
  String resource = 'codeforces.com';
  apiGetter({required this.resource});

  static final WebHelper api = WebHelper();
  Future<List<Map<String, dynamic>>> fetchContests() async {
    var response = await api.get('https://clist.by/api/v2/contest/', queryParameters: {
      'resource__name': resource,
      'start__gt': DateTime.now().toIso8601String(),
      'order_by': 'start',
    });
    List<dynamic> contests = response.data['objects'];
    return contests.map((contest) {
      return {
        'resource': contest['resource']['name'],
        'startTime': contest['start'],
        'endTime': contest['end'],
        'event': contest['event'],
        'duration': contest['duration'],
        'href': contest['href'],
      };
    }).toList();
  }
}