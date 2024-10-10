import 'package:flutter/material.dart';
import 'package:cp_schedule/https/apiGetter.dart';
import 'package:cp_schedule/Parts/ContestCard.dart'; // Ensure this path is correct
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late apiGetter api;
  List<Contest> contests = [];
  String selectedResource = 'codeforces.com';
  final List<String> resources = [
    'codeforces.com',
    'atcoder.jp',
    'leetcode.com',
    // 添加更多资源
  ];

  @override
  void initState() {
    super.initState();
    api = apiGetter(resource: selectedResource);
    fetchContests();
  }

  Future<void> fetchContests() async {
    try {
      List<Map<String, dynamic>> contestData = await api.fetchContests();
      setState(() {
        contests = contestData
            .map((data) => Contest(
                  resource: data['resource'],
                  startTime: data['startTime'],
                  endTime: data['endTime'],
                  event: data['event'],
                  duration: data['duration'],
                  href: data['href'],
                ))
            .toList();
      });
    } catch (e) {
      print('Error fetching contests: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedResource,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedResource = newValue;
                    api = apiGetter(resource: selectedResource);
                    fetchContests();
                  });
                }
              },
              items: resources.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contests.length,
              itemBuilder: (context, index) {
                final contest = contests[index];
                return GestureDetector(
                  onTap: () async {
                    final url = contest.href;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
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
                              // 这里可以添加 logo 和 resource 的显示代码
                              Text(contest.resource),
                            ],
                          ),
                          // 其他比赛信息
                          Text('Event: ${contest.event}'),
                          Text('Start Time: ${contest.startTime}'),
                          Text('End Time: ${contest.endTime}'),
                          Text('Duration: ${contest.duration}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
