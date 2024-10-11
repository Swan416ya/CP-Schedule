import 'package:flutter/material.dart';
import 'package:cp_schedule/Pages/about.dart';
import 'dart:io';
import 'package:cp_schedule/https/apiGetter.dart';
import 'package:cp_schedule/https/WebHelper.dart';
import 'package:http/http.dart' as http;

class settingPage extends StatefulWidget {
  @override
  _settingPageState createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.cookie_outlined),
            title: const Text('Clist sessionid'),
            trailing: OutlinedButton(
              onPressed: () {
                _controller.clear();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    surfaceTintColor: Colors.transparent,
                    title: const Text('cookies'),
                    content: SizedBox(
                      width: 400,
                      height: 300,
                      child: TextField(
                        autofocus: true,
                        maxLines: null,
                        minLines: null,
                        expands: true,
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Clist sessonid',
                        ),
                        onSubmitted: (value) async {
                          await WebHelper.cookieManager.cookieJar
                              .saveFromResponse(Uri.parse('https://clist.by'),
                                  [Cookie('sessionid', value)]);
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Session ID saved successfully')),
                          );
                        },
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          String value = _controller.text;
                          await WebHelper.cookieManager.cookieJar
                              .saveFromResponse(Uri.parse('https://clist.by'),
                                  [Cookie('sessionid', value)]);
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Session ID saved successfully')),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Set'),
            ),
          ),
        ],
      ),
    );
  }
}
