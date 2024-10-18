import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
            Text('Version: 1.0.1'),
            Text('Author: Swan416ya'),
            Expanded(
              child: FutureBuilder(
                future: DefaultAssetBundle.of(context).loadString('assets/about.md'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Markdown(
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(fontSize: 18.0),
                      ),
                      data: snapshot.data ?? '',
                      onTapLink: (text, href, title) {
                        if (href != null) {
                          launchURL(href);
                        }
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            )
          ]
        ),
      ),
    );
  }
}