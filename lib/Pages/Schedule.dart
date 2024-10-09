import 'package:flutter/material.dart';
import 'package:cp_schedule/https/apiGetter.dart';
import 'package:cp_schedule/Parts/ContestCard.dart'; // Ensure this path is correct

class schedulePage extends StatefulWidget {
  @override
  _schedulePage createState() => _schedulePage();
}

class _schedulePage extends State<schedulePage> {
  String Resource = "codeforces.com";
  List<Contest> contests = []; // Define the contests variable

  @override
  void initState() {
    super.initState();
    // Initialize contests with some data
    fetchContests();
  }

  void fetchContests() async {
    // Fetch contests from API or any other source
    // For example:
    apiGetter getter = new apiGetter(Resource);
    List<Contest> fetchedContests = (await getter.getContests(Resource)).cast<Contest>();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      body: ListView.builder(
        itemCount: contests.length + 1,
        itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
            return ListTile(
              title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: Colors.grey),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                value: Resource,
                onChanged: (String? newValue) {
                  setState(() {
                  Resource = newValue!;
                  fetchContests(); // Fetch contests again when resource changes
                  });
                },
                items: <String>['codeforces.com', 'atcoder.jp']
                  .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                  );
                }).toList(),
                ),
              ),
              ),
            );
            } else {
            //列举所有比赛卡
            return ContestCard(Resource, index - 1);
          }
        },
      ),
    );
  }
}