import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:cp_schedule/main.dart';
import 'package:cp_schedule/Schedule_io/contestEvent.dart';

class desktopWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    windowManager.waitUntilReadyToShow().then((_) {
      final initialSize = Size(400, 600);
      windowManager.setMinimumSize(initialSize);
      windowManager.setMaximumSize(initialSize);
      windowManager.setSize(initialSize);
      windowManager.setAlignment(Alignment.center);
      windowManager.show();
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: contestToday(),
    );// or any other widget you want to return
  }
}

class contestToday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    List<contestEvent> todayEvents = kContests[today] ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
            onPressed: () async {
            // 设置窗口大小
            await windowManager.setSize(Size(900, 700));
            await windowManager.setMinimumSize(Size(900, 500));
            await windowManager.setMaximumSize(Size.infinite);
            await windowManager.setAlignment(Alignment.center);
            // 返回到 MyApp
            runApp(MyApp());
          },
        ),
        title: Center(child: Text("Today's schedule")),
      ),
      body: ListView.builder(
        itemCount: todayEvents.length,
        itemBuilder: (context, index) {
          contestEvent event = todayEvents[index];
          return ListTile(
            leading: Image.asset(getLogoPath(event.resource)),
            title: Text('${DateTime.parse(event.startTime).hour}:${DateTime.parse(event.startTime).minute}'),
          );
        },
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
