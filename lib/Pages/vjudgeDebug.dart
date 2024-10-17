import 'package:flutter/material.dart';
import 'package:cp_schedule/https/vjudgeGetter.dart';
import 'package:cp_schedule/Schedule_io/contestEvent.dart';

class vjudgeDebug extends StatefulWidget {
  @override
  _vjudgeDebugState createState() => _vjudgeDebugState();
}

class _vjudgeDebugState extends State<vjudgeDebug> {
  //这里是一个测试页面，用来测试vjudgeGetter的功能
  //最上面要求用户输入一个网址，然后直接在下面输出getEvent返回的event的所有信息
  //这个页面不会被正式使用，只是用来测试
  String url = "";
  contestEvent? event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("vjudgeGetter测试"),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              url = value;
            },
          ),
          ElevatedButton(
            onPressed: () {
              vjudgeGetter getter = new vjudgeGetter(url);
              getter.getEvent().then((value) {
                setState(() {
                  event = value;
                });
              });
            },
            child: Text("获取"),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: event != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title: ${event!.title}'),
                        Text('Href: ${event!.href}'),
                        Text('Resource: ${event!.resource}'),
                        Text('Start Time: ${event!.startTime}'),
                        Text('End Time: ${event!.endTime}'),
                        Text('Duration: ${event!.duration}'),
                      ],
                    )
                  : Text('No event data'),
            ),
          ),
        ],
      ),
    );
  }
}
