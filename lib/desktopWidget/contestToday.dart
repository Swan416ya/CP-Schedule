import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class desktopWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}