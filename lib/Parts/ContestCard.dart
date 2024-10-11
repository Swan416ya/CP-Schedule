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

  ContestCard({required this.contest});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 第一行：显示 logo 和 resource
          Row(
          children: [
            Image.asset(
            getLogoPath(contest.resource),
            width: 30,
            height: 30,
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
            MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
              final url = "https://"+contest.resource;
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
              },
              child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 244, 219, 241),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                contest.resource,
                style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                ),
              ),
              ),
            ),
            ),
          ],
          ),
          SizedBox(height: 10),
          // 第二行：显示开始时间和结束时间
          RichText(
          text: TextSpan(
            children: [
            TextSpan(
              text: 'StartTime: ',
              style: TextStyle(
              color: Color.fromARGB(255, 123, 78, 127),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '${contest.startTime.replaceAll('T', ' ').replaceAll('Z', ' ')}\t\t\t\t',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            TextSpan(
              text: 'EndTime: ',
              style: TextStyle(
              color: Color.fromARGB(255, 123, 78, 127),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '${contest.endTime.replaceAll('T', ' ').replaceAll('Z', ' ')}\t\t\t\t',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            TextSpan(
              text: 'Duration: ',
              style: TextStyle(
              color: Color.fromARGB(255, 123, 78, 127),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '${formatDuration(contest.duration)}',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            ],
          ),
          ),
        ],
        ),
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
      case 'leetcode.com':
        return 'assets/img/logo/LeetCode.png';
      case 'luogu.com.cn':
        return 'assets/img/logo/Luogu.png';
      case 'vjudge.net':
        return 'assets/img/logo/vjudge.png';
      case 'CodeChef.com':
        return 'assets/img/logo/CodeChef.png';
      default:
        return 'assets/img/logo/default.png';
    }
  }

  String formatDuration(String duration) {
    int totalMinutes = int.parse(duration) ~/ 60;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
