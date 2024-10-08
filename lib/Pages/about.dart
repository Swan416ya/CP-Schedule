import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class aboutPage extends StatefulWidget{
  @override
  _aboutPageState createState() => _aboutPageState();
}

class _aboutPageState extends State<aboutPage>{
  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Competitive Programming Schedule',
              style: TextStyle(
                //使用google_fonts中的Protest Strike字体
                fontFamily: 'Playwrite Deutschland Grundschrift',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Version: 1.0.0'),
            Text('Author: Swan416ya'),
            //加入一个链接到github项目链接的按钮
            ElevatedButton(
              onPressed: () {
                launchURL('https://github.com/Swan416ya/CP-Schedule');
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //使用github图标
                  Image.network('https://github.githubassets.com/assets/gh-desktop-7c9388a38509.png', width: 20),
                  SizedBox(width: 5),
                  Text('Github Repository'),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}