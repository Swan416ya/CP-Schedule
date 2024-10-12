import 'package:flutter/material.dart';
import 'package:cp_schedule/Parts/ContestCard.dart'; // Ensure this path is correct
import 'package:url_launcher/url_launcher.dart';
import 'package:cp_schedule/https/WebHelper.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Contest> _contests = [];
  int maxContestsCnt = 100;
  bool _isLoading = false;
  var clist;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var data = await WebHelper().get(
        'https://clist.by/api/v4/contest/',
        queryParameters: {
          'order_by': 'start',
          'upcoming': true,
          'limit': maxContestsCnt,
          'start__gt': DateTime.now().toIso8601String(),
          'filtered': true,
          'format_time': false,
        },
      );
      clist = data.data['objects'];
      _contests.clear();

      // Debugging: Print the fetched data
      print('Fetched data: $clist');

      int cnt = 1;
      for (var c in clist) {
        var contest = Contest(
          event: c['event'],
          resource: c['resource'],
          startTime: _formatDateTime(c['start']),
          endTime: _formatDateTime(c['end']),
          duration: c['duration'].toString(),
          href: c['href'],
        );
        _contests.add(contest);
        print("Success adding contest: $cnt\n");
        cnt++;
      }

      // Debugging: Print the contests list
      print('Contests list: $_contests');
    } catch (e) {
      print('Error fetching contests: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDateTime(String dateTime) {
    DateTime dt = DateTime.parse(dateTime).add(Duration(hours: 8));
    return "${dt.toIso8601String().split('.').first}Z";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              init();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _contests.isEmpty
              ? Center(
                  child: Text(
                      'No contests available\nTry add cookie in setting page and refresh'))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return ContestCard(
                      contest: _contests[index],
                    );
                  },
                  itemCount: _contests.length,
                ),
    );
  }
}
