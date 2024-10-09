import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cp_schedule/Parts/ContestCard.dart';

class apiGetter {
  String resourse = "";
  //获取本地时间
  String getLocalTime() {
    var now = new DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;
    int hour = now.hour;
    int minute = now.minute;
    int second = now.second;
    String ret = year.toString() +
        "-" +
        month.toString() +
        "-" +
        day.toString() +
        "T" +
        hour.toString() +
        '%3A' +
        minute.toString() +
        '%3A' +
        second.toString();
    return ret;
  }

  apiGetter(String resourse) {
    this.resourse = resourse;
    this.url = "https://clist.by:443/api/v4/contest/?resource=" +
        resourse +
        "&start__gt=" +
        getLocalTime() +
        "&order_by=start";
  }
  late String url;

  String getUrl() {
    return url;
  }

  List allContests = [];
  int contestsCount = 0;
  Future<void> getContests() async {
    var response = await http.get(Uri.parse(url));//获取数据
    var jsonData = jsonDecode(response.body);//解析数据
    //解析的格式为
    // {
    //   "meta": {
    //     "limit": 20,
    //     "offset": 0,
    //     "total_count": 1
    //   },
    //   "objects": [
    //     {
    //       "duration": 7200,
    //       "end": "2022-01-01T00:00:00",
    //       "event": "Codeforces Round #745 (Div. 2)",
    //       "href": "https://codeforces.com/contests/1560",
    //       "id": 1560,
    //       "resource": {
    //         "id": 1,
    //         "name": "Codeforces.com"
    //       },
    //       "start": "2021-12-31T22:35:00",
    //       "title": "Codeforces Round #745 (Div. 2)",
    //       "durationSeconds": 7200,
    //       "endSeconds": 1640995200,
    //       "startSeconds": 1640988900
    //     }
    //   ]
    // }
    allContests = jsonData['objects'];
    contestsCount = jsonData['meta']['total_count'];
  }

  List getContest(int index) {
    return allContests[index];
  }

  String getContestName(int index) {
    return allContests[index]['event'];
  }

  contest getContestCard(int index) {
    return new contest(
        allContests[index]['resource']['name'],
        allContests[index]['start'],
        allContests[index]['end'],
        allContests[index]['event'],
        allContests[index]['duration'].toString(),
        allContests[index]['href']);
  }

  List getContestCardList() {
    List ret = [];
    for (int i = 0; i < contestsCount; i++) {
      ret.add(getContestCard(i));
    }
    return ret;
  }
}
