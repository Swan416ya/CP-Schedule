import 'package:flutter/material.dart';
import 'package:cp_schedule/homePage.dart';
import 'package:window_manager/window_manager.dart';
import 'package:cp_schedule/desktopWidget/overlayEntry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePageWithOverlay(),
    );
  }
}
