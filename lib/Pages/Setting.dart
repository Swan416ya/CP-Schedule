import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cp_schedule/https/WebHelper.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 确保 WebHelper 实例已初始化
    WebHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Session ID'),
          ),
          TextButton(
            onPressed: () async {
              try {
                String value = _controller.text;
                if (value.isEmpty) {
                  throw Exception('Session ID cannot be empty');
                }
                await WebHelper.cookieManager.cookieJar.saveFromResponse(
                  Uri.parse('https://clist.by'),
                  [Cookie('sessionid', value)],
                );
                if (!context.mounted) return;
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Session ID saved successfully')),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to save Session ID: $e')),
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
