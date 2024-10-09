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
          return ContestCard(ret[index]);
        },
      ),
    );
  }
}