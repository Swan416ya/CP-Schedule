import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  Future<List> getContest() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List contest = data['objects'];
      return contest;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> getContests(String resourse) async {
    this.resourse = resourse;
    this.url = "https://clist.by:443/api/v4/contest/?resource=" +
        resourse +
        "&start__gt=" +
        getLocalTime() +
        "&order_by=start";
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List contest = data['objects'];
      return contest;
    } else {
      throw Exception('Failed to load data');
    }
  }

  //如果json里面没有index对应的数据，返回布尔值false
  bool checkIndex(List contest, int index) {
    if (contest.length <= index) {
      return false;
    }
    return true;
  }
}
