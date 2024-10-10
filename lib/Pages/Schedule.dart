import 'package:flutter/material.dart';
import 'package:cp_schedule/https/apiGetter.dart';
import 'package:cp_schedule/Parts/ContestCard.dart'; // Ensure this path is correct
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late apiGetter api;
  List<Contest> contests = [];
  String selectedResource = 'codeforces.com';

  @override
  void initState() {
    super.initState();
    api = apiGetter(selectedResource);
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
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              value: selectedResource,
              items: ['codeforces.com', 'atcoder.jp', 'ac.nowcoder.com']
                  .map((String resource) {
                return DropdownMenuItem<String>(
                  value: resource,
                  child: Text(resource),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedResource = newValue!;
                  api = apiGetter(selectedResource);
                  fetchContests();
                });
              },
              hint: Text('Select Resource'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contests.length,
              itemBuilder: (context, index) {
                return ContestCard(contests[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
