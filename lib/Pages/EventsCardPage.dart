import 'package:flutter/material.dart';
import 'package:cp_schedule/Parts/EventsCard.dart';
import 'package:cp_schedule/Schedule_io/contestEvent.dart';

class ShowCardPage extends StatefulWidget {
  @override
  _ShowCardPageState createState() => _ShowCardPageState();
}

class _ShowCardPageState extends State<ShowCardPage> {
  List<EventsCard> contests = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    contests.add(EventsCard(
      event: contestEvent(
        title: 'Codeforces Round #744 (Div. 3)',
        startTime: '2021-09-26T07:05:00',
        endTime: '2021-09-26T09:05:00',
        href: 'https://codeforces.com/contest/1585',
        resource: 'codeforces.com',
        duration: '7200',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShowCard'),
      ),
      body: ListView.builder(
        itemCount: contests.length,
        itemBuilder: (context, index) {
          return EventsCard(event: contests[index].event);
        },
      ),
    );
  }
}
