import 'package:flutter/material.dart';
import 'package:cp_schedule/Schedule_io/contestEvent.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsCard extends StatelessWidget {
  final contestEvent event;

  EventsCard({required this.event});

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: () {
        if (event.href != null) {
          launch(event.href);
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    getLogoPath(event.resource),
                    width: 30,
                    height: 30,
                  ),
                  ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${DateTime.parse(event.startTime).hour}:${DateTime.parse(event.startTime).minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: StepProgressIndicator(
                        totalSteps: Duration(minutes: int.parse(event.duration)).inMinutes,
                        currentStep: DateTime.now().difference(DateTime.parse(event.startTime)).inMinutes,
                        size: 8,
                        padding: 0,
                        selectedColor: Colors.blue,
                        unselectedColor: Colors.grey[300]!,
                        roundedEdges: Radius.circular(10),
                      ),
                    ),
                  ),
                  Text(
                    '${DateTime.parse(event.endTime).hour}:${DateTime.parse(event.endTime).minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
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