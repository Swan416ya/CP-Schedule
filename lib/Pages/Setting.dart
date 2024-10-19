import 'package:flutter/material.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cp_schedule/https/WebHelper.dart';
import 'dart:io';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSessionIdDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Session ID'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Session ID'),
          ),
          actions: [
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
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Set CList Cookie'),
            trailing: ElevatedButton(
              onPressed: _showSessionIdDialog,
              child: Text('Set'),
            ),
          ),
        ],
      ),
    );
  }
}
