import 'package:flutter/material.dart';
import 'package:cp_schedule/homePage.dart';
import 'package:window_manager/window_manager.dart';
import 'package:cp_schedule/desktopWidget/overlayEntry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cp_schedule/https/WebHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // 获取应用程序的文档目录路径
  final directory = await getApplicationDocumentsDirectory();
  final cookiePath = '${directory.path}/cookies';

  // 确保在该路径下保存 cookie
  await _initializeCookieManager(cookiePath);

  WindowOptions windowOptions = WindowOptions(
    size: Size(900, 700),
    minimumSize: Size(900, 500),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(MyApp());
}

Future<void> _initializeCookieManager(String cookiePath) async {
  // 初始化 WebHelper 并设置 Cookie 管理器的路径
  WebHelper.initialize(cookiePath);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePageWithOverlay(),
    );
  }
}
