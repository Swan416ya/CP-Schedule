import 'package:flutter/material.dart';
import 'package:cp_schedule/Parts/ContestCard.dart'; // 确保路径正确
import 'package:cp_schedule/https/apiGetter.dart'; // 确保路径正确
import 'package:url_launcher/url_launcher.dart';

class ShowCardPage extends StatefulWidget {
  @override
  _ShowCardPageState createState() => _ShowCardPageState();
}

class _ShowCardPageState extends State<ShowCardPage> {
  List<Contest> contests = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    contests.add(Contest(
      event: 'Codeforces Round #744 (Div. 3)',
      startTime: '2021-09-26T07:05:00',
      endTime: '2021-09-26T09:05:00',
      href: 'https://codeforces.com/contest/1585',
      resource: 'codeforces.com',
      duration: '7200',
    ));
    contests.add(Contest(
      event: 'AtCoder Beginner Contest 220',
      startTime: '2022-09-26T07:05:00',
      endTime: '2022-09-26T09:05:00',
      href: 'https://atcoder.jp/contests/abc220',
      resource: 'atcoder.jp',
      duration: '7200',
    ));
    contests.add(Contest(
      event: 'NowCoder 2021校招真题模拟赛',
      startTime: '2021-09-26T07:05:00',
      endTime: '2021-09-26T09:05:00',
      href: 'https://ac.nowcoder.com/acm/contest/10001',
      resource: 'ac.nowcoder.com',
      duration: '7200',
    ));
    contests.add(Contest(
      event: 'LeetCode Weekly Contest 261',
      startTime: '2021-09-26T07:05:00',
      endTime: '2021-09-26T09:05:00',
      href: 'https://leetcode.com/contest/weekly-contest-261',
      resource: 'leetcode.com',
      duration: '7200',
    ));
    contests.add(Contest(
      event: 'Google Kick Start 2021 - Round G',
      startTime: '2021-09-26T07:05:00',
      endTime: '2021-09-26T09:05:00',
      href: 'https://codingcompetitions.withgoogle.com/kickstart/round/00000000004362d6',
      resource: 'google.com',
      duration: '7200',
    ));
    contests.add(Contest(
      event: 'luogu P1000 2021年9月月赛',
      startTime: '2021-09-26T07:05:00',
      endTime: '2021-09-26T09:05:00',
      href: 'https://www.luogu.com.cn/contest/2021-09',
      resource: 'luogu.com.cn',
      duration: '7200',
    ));
    contests.add(
      Contest(
        event: 'SCAU2024每日一题',
        startTime: '2024-10-1T15:05:00',
        endTime: '2024-10-9T15:05:00',
        href: 'https://vjudge.net/contest/659288',
        resource: 'vjudge.net',
        duration: '691200',
      ),
    );
    contests.add(
      Contest(
        event: 'CodeChef September Long Challenge 2021',
        startTime: '2021-09-03T15:00:00',
        endTime: '2021-09-13T15:00:00',
        href: 'https://www.codechef.com/SEPT21',
        resource: 'CodeChef.com',
        duration: '864000',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShowCard'),
      ),
      body: ListView.builder(
        itemCount: contests.length,
        itemBuilder: (context, index) {
          return ContestCard(contest: contests[index]);
        },
      ),
    );
  }
}
