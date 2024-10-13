import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cp_schedule/homePage.dart';
import 'package:cp_schedule/desktopWidget/contestToday.dart';

class HomePageWithOverlay extends StatefulWidget {
  @override
  _HomePageWithOverlayState createState() => _HomePageWithOverlayState();
}

class _HomePageWithOverlayState extends State<HomePageWithOverlay> {
  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayEntry = _createOverlayEntry();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context)?.insert(_overlayEntry);
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: 16.0,
        right: 16.0,
        child: FloatingActionButton(
          onPressed: () {
            WidgetsFlutterBinding.ensureInitialized();
            runApp(desktopWidget());
          },
          backgroundColor: Color.fromARGB(255, 123, 78, 127),
          child:
              Icon(Icons.play_arrow, color: Color.fromARGB(255, 244, 219, 241)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return homePage();
  }

  @override
  void dispose() {
    _overlayEntry.remove();
    super.dispose();
  }
}
