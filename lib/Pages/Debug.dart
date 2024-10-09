import 'package:flutter/material.dart';
import 'package:cp_schedule/Parts/ContestCard.dart'; // 确保路径正确

class DebugPage extends StatefulWidget {
  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  List<Contest> ret = []; // 使用泛型确保类型安全

  @override
  void initState() {
    super.initState();
    Contest tmp = Contest(
      resource: "codeforces.com",
      startTime: DateTime.parse("2022-01-01T00:00:00"),
      endTime: DateTime.parse("2022-01-01T00:00:00"),
      event: "Codeforces Round #745 (Div. 2)",
      duration: 7200,
      href: "https://codeforces.com/contests/1560",
    );
    ret.add(tmp);
    ret.add(tmp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Page'),
      ),
      body: ListView.builder(
        itemCount: ret.length,
        itemBuilder: (context, index) {
          return ContestCard(
            ret[index].resource,
            ret[index].startTime,
            ret[index].endTime,
            ret[index].event,
            ret[index].duration.toString(),
            ret[index].href,
          );
        },
      ),
    );
  }
}

class Contest {
  final String resource;
  final DateTime startTime;
  final DateTime endTime;
  final String event;
  final int duration;
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
  final String resource;
  final DateTime startTime;
  final DateTime endTime;
  final String event;
  final String duration;
  final String href;

  ContestCard(this.resource, this.startTime, this.endTime, this.event,
      this.duration, this.href);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text('Resource: $resource'),
          Text('Event: $event'),
          Text('Start Time: $startTime'),
          Text('End Time: $endTime'),
          Text('Duration: $duration'),
          Text('URL: $href'),
        ],
      ),
    );
  }
}
