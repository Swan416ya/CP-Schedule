import 'package:flutter/material.dart';
import 'package:cp_schedule/Pages/about.dart';
import 'package:cp_schedule/Pages/Schedule.dart';
import 'package:cp_schedule/Parts/ContestCard.dart';
import 'package:cp_schedule/https/WebHelper.dart';

class ShowJsonPage extends StatefulWidget {
  const ShowJsonPage({Key? key}) : super(key: key);

  @override
  _ShowJsonPageState createState() => _ShowJsonPageState();
}

class _ShowJsonPageState extends State<ShowJsonPage> {

  final List<Contest> _contests = [];
  int maxContestsCnt = 100;
  var clist;

  void initState() {
    super.initState();
    init();
  }

  void init() async {
    try
    {var data = await WebHelper().get(
        'https://clist.by/api/v4/contest/',
        queryParameters: {
          'order_by': 'start',
          'upcoming': true,
          'limit': 100,
          'start__gt': DateTime.now().toIso8601String(),
          'filtered': true,
          'format_time': false,
        },
      );
    clist = data.data['objects'];
    for (var c in clist) {
      print(c);
    }
    setState(() {});}
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShowJson Page'),
      ),
      body: ListView.builder(
        itemCount: clist?.length ?? 0,
        itemBuilder: (context, index) {
          var contest = clist[index];
          return ListTile(
            title: Text('Event: ${contest['event']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Start: ${DateTime.parse(contest['start']).add(Duration(hours: 8)).toIso8601String()}'),
                Text('End: ${DateTime.parse(contest['end']).add(Duration(hours: 8)).toIso8601String()}'),
                Text('Duration: ${contest['duration']}'),
                Text('Href: ${contest['href']}'),
                Text('Resource: ${contest['resource']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

