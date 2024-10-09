import 'package:flutter/material.dart';
import 'package:cp_schedule/https/apiGetter.dart';
import 'package:cp_schedule/Parts/ContestCard.dart'; // Ensure this path is correct

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  var ApiGetter = new apiGetter("codeforces.com");
  List ret = [];
  late Future fetchContestFuture;

  @override
  void initState() {
    super.initState();
    fetchContestFuture = fetchContestData();
  }

  Future fetchContestData() async {
    var data = await ApiGetter.getContestCardList();
    setState(() {
      ret = data;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              items: ['codeforces.com', 'atcoder.jp', 'ac.nowcoder.com']
                  .map((String resource) {
                return DropdownMenuItem<String>(
                  value: resource,
                  child: Text(resource),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  // Update the resource and refresh the page
                  ApiGetter = new apiGetter(newValue!);
                  // Fetch new data and update the contest card list
                  fetchContestFuture = fetchContestData();
                });
              },
              hint: Text('Select Resource'),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchContestFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: ret.length,
                    itemBuilder: (context, index) {
                      return ContestCard(
                        ret[index]['resource']['name'],
                        ret[index]['start'],
                        ret[index]['end'],
                        ret[index]['event'],
                        ret[index]['duration'].toString(),
                        ret[index]['href'],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
