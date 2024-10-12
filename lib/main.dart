import 'package:flutter/material.dart';
import 'package:cp_schedule/homePage.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ensure window settings are applied when the application is built
    doWhenWindowReady(() {
      final initialSize = Size(900, 700);
      appWindow.minSize = Size(900, 500);
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage(),
    );
  }
}
