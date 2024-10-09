import 'package:flutter/material.dart';
import 'package:cp_schedule/https/apiGetter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class Contest {
  final String resource;
  final String startTime;
  final String endTime;
  final String event;
  final String duration;
  final String href;

  Contest({
    required this.resource,
    required this.startTime,
    required this.endTime,
    required this.event,
    required this.duration,
    required this.href,
  });
}

class ContestCard extends StatelessWidget {
  final Contest contest;

  ContestCard(this.contest);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 第一行：显示 logo
            Row(
              children: [
                Image.asset(
                  getLogoPath(contest.resource),
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    contest.event,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // 第二行：显示开始时间和结束时间
            Text(
              '开始时间: ${contest.startTime}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '结束时间: ${contest.endTime}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            // 第三行：显示时长和资源
            Text(
              '时长: ${formatDuration(contest.duration)}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '资源: ${contest.resource}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String getLogoPath(String resource) {
    switch (resource) {
      case 'codeforces.com':
        return 'assets/img/logo/Codeforces.png';
      case 'atcoder.jp':
        return 'assets/img/logo/AtCoder.png';
      case 'ac.nowcoder.com':
        return 'assets/img/logo/NowCoder.png';
      default:
        return 'assets/img/logo/default.png';
    }
  }

  String formatDuration(String duration) {
    int totalMinutes = int.parse(duration) ~/ 60;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    return '${hours}小时${minutes}分钟';
  }
}
