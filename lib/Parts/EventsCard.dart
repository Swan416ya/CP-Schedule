import 'package:flutter/material.dart';
import 'package:cp_schedule/Schedule_io/contestEvent.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsCard extends StatelessWidget {
  final contestEvent event;

  EventsCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (event.href != null) {
          launch(event.href);
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                getLogoPath(event.resource),
                width: 30,
                height: 30,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${DateTime.parse(event.startTime).toLocal().hour}:${DateTime.parse(event.startTime).toLocal().minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 16),
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
      case 'codechef.com':
        return 'assets/img/logo/CodeChef.png';
      default:
        return 'assets/img/logo/default.png';
    }
  }
}