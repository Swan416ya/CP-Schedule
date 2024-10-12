import 'package:flutter/material.dart';
import 'package:cp_schedule/Parts/ContestCard.dart'; // Ensure this path is correct
import 'package:url_launcher/url_launcher.dart';
import 'package:cp_schedule/https/WebHelper.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  //显示一行字“前面的区域以后再来探索吧”即可
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Center(
        child: Text('Explore the area in front of you later.'),
      ),
    );
  }
}
