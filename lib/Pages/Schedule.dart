import 'package:flutter/material.dart';
import 'package:cp_schedule/Parts/ContestCard.dart'; // Ensure this path is correct
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cp_schedule/https/WebHelper.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) => Center(child: Text('只显示一行字就行了'));
}
