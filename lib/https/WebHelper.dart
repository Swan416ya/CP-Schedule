import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class WebHelper {
  static late final Dio dio;
  static late final CookieManager cookieManager;
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
    var cookiePath = 'cookies';
    cookieManager =
        CookieManager(PersistCookieJar(storage: FileStorage(cookiePath)));
    dio.interceptors.add(cookieManager);
  }

  Future<Response> get(
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

  Future<Response> post(
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

  Future<void> download(urlPath, savePath) async {
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
