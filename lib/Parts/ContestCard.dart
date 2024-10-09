import 'package:flutter/material.dart';
import 'package:cp_schedule/https/apiGetter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class contest
{
  String resourse = "";
  String startTime = "";
  String endTime = "";
  String event = "";
  int duration = 0;
  String href = "";
  String resourceLogo = "";

  contest(String resourse,String orgStartTime,String orgEndTime,String event,String orgDuration,String href){
    this.resourse = resourse;
    //将orgStartTime和orgEndTime里面的T和Z变成空格
    this.startTime = orgStartTime.replaceAll("T", " ").replaceAll("Z", "");
    this.endTime = orgEndTime.replaceAll("T", " ").replaceAll("Z", "");
    this.event = event;
    this.duration = int.parse(orgDuration);
    this.href = href;
    //根据resourse来选择对应的logo
    switch(resourse)
    {
      case "codeforces.com":
        this.resourceLogo = "assets/img/logo/Codeforces.png";
        break;
    }
  }
}

//先写contestCard和_ContestCardState作为单个比赛的展示卡片，然后再写一个contestCardList作为比赛列表展示所有比赛卡片
class ContestCard extends StatefulWidget {
  contest _contest = new contest("","","","","","");
  ContestCard(String resourse,String orgStartTime,String orgEndTime,String event,String orgDuration,String href){
    _contest = new contest(resourse,orgStartTime,orgEndTime,event,orgDuration,href);
  }

  @override
  _ContestCardState createState() => _ContestCardState();
}

class _ContestCardState extends State<ContestCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(widget._contest.resourceLogo),
              Text(
                widget._contest.resourse,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),
            ],
          ),
          Row(
            children: [
              Text(widget._contest.startTime),
              Text(widget._contest.endTime),
            ],
          ),
          Text(widget._contest.event),
          Text(widget._contest.duration.toString()),
          TextButton(
            onPressed: () {
              //跳转到比赛页面
              launch(widget._contest.href);
            },
            child: Text("Go to Contest"),
          ),
        ],
      ),
    );
  }
}

class ContestCardList extends StatefulWidget {
  List<contest> _contestList = [];
  ContestCardList(List<contest> contestList){
    _contestList = contestList;
  }

  @override
  _ContestCardListState createState() => _ContestCardListState();
}

class _ContestCardListState extends State<ContestCardList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget._contestList.length,
      itemBuilder: (context, index) {
        return ContestCard(
          widget._contestList[index].resourse,
          widget._contestList[index].startTime,
          widget._contestList[index].endTime,
          widget._contestList[index].event,
          widget._contestList[index].duration.toString(),
          widget._contestList[index].href,
        );
      },
    );
  }
}