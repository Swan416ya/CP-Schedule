import 'package:flutter/material.dart';
import 'package:cp_schedule/Parts/ContestCard.dart'; // 确保路径正确
import 'package:cp_schedule/https/apiGetter.dart';

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
      resource: 'codeforces.com',
      startTime: '2021-09-01T00:00:00Z',
      endTime: '2021-09-02T00:00:00Z',
      event: 'Codeforces Round #123',
      duration: '7200',
      href: 'https://codeforces.com/contests/123',
    );
    ret.add(tmp);
    tmp = Contest(
      resource: 'atcoder.jp',
      startTime: '2021-09-01T00:00:00Z',
      endTime: '2021-09-02T00:00:00Z',
      event: 'AtCoder Beginner Contest 123',
      duration: '7200',
      href: 'https://atcoder.jp/contests/abc123',
    );
    ret.add(tmp);
    tmp = Contest(
      resource: 'ac.nowcoder.com',
      startTime: '2021-09-01T00:00:00Z',
      endTime: '2021-09-02T00:00:00Z',
      event: '牛客网月赛 123',
      duration: '7200',
      href: 'https://ac.nowcoder.com/contest/123',
    );
    ret.add(tmp);

    // 以下代码用于调试，模拟从网络获取数据
    apiGetter api = apiGetter(resource: 'codeforces.com');
    api.fetchContests().then((value) {
      setState(() {
        ret = value.map((e) => Contest(
          resource: e['resource'],
          startTime: e['startTime'],
          endTime: e['endTime'],
          event: e['event'],
          duration: e['duration'],
          href: e['href'],
        )).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Page'),
      ),
      body: FutureBuilder<List<Contest>>(
        future: apiGetter(resource: 'codeforces.com').fetchContests().then((value) => value.map((e) => Contest(
          resource: e['resource'],
          startTime: e['startTime'],
          endTime: e['endTime'],
          event: e['event'],
          duration: e['duration'],
          href: e['href'],
        )).toList()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No contests available'));
          } else {
        List<Contest> contests = snapshot.data!;
        return ListView.builder(
          itemCount: contests.length,
          itemBuilder: (context, index) {
            return ListTile(
          title: Text(contests[index].event),
          subtitle: Text('Resource: ${contests[index].resource}\nStart: ${contests[index].startTime}\nEnd: ${contests[index].endTime}'),
          onTap: () {
            // You can add any action here if needed
          },
            );
          },
        );
          }
        },
      ),
    );
  }
}