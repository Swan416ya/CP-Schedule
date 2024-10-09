import 'package:flutter/material.dart';
import 'package:cp_schedule/https/apiGetter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';

class ContestCard extends StatefulWidget {
  final String resource;
  final int index;

  ContestCard(this.resource, this.index);

  @override
  _ContestCardState createState() => _ContestCardState();
}

class _ContestCardState extends State<ContestCard> {
  String resource = "";
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  String name = "";
  String url = "";
  Duration timeLength = Duration();
  Image logo = Image.asset('assets/img/logo/Codeforces.png');

  @override
  void initState() {
    super.initState();
    resource = widget.resource;
    apiGetter getter = apiGetter(resource);
    getter.getContest().then((value) {
      setState(() {
        name = value[widget.index]['event'];
        startTime = DateTime.parse(value[widget.index]['start']);
        endTime = DateTime.parse(value[widget.index]['end']);
        timeLength = endTime.difference(startTime);
        url = value[widget.index]['href'];
      });
    });
    switch (resource) {
      case "codeforces.com":
        logo = Image.asset('assets/img/logo/Codeforces.png');
        break;
      case "atcoder.jp":
        logo = Image.asset('assets/img/logo/Atcoder.png');
        break;
    }
  }

  void writeContestInfoToJson(Map<String, dynamic> contestInfo) {
    final contestInfoJson = jsonEncode(contestInfo);
    final file = File('assets/matchlist/subscribedMatches.json');
    file.writeAsString(contestInfoJson);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final contestInfo = {
          'name': name,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'timeLength': timeLength.inMinutes,
          'resource': resource,
          'url': url,
        };
        writeContestInfoToJson(contestInfo);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: logo,
                height: 50,
              ),
            ),
            ListTile(
              title: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text("Start Time: " + DateFormat('yyyy-MM-dd kk:mm').format(startTime)),
            ),
            ListTile(
              title: Text("End Time: " + DateFormat('yyyy-MM-dd kk:mm').format(endTime)),
              subtitle: Text("Time Length: " + timeLength.inHours.toString() + "h " + (timeLength.inMinutes % 60).toString() + "m"),
            ),
            ListTile(
              title: Text("Resource: " + resource),
              subtitle: Text(
                "URL: " + url,
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Contest
{
  String name;
  DateTime startTime;
  DateTime endTime;
  Duration timeLength;
  String url;
  String resource;
  Image logo;

  Contest({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.timeLength,
    required this.url,
    required this.resource,
    required this.logo,
  });
}