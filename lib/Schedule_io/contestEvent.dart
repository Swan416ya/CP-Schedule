import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

class contestEvent{
  final String title;
  final String href;
  final String resource;
  final String startTime;
  final String endTime;
  final String duration;

  contestEvent(
    {
      required this.title,
      required this.href,
      required this.resource,
      required this.startTime,
      required this.endTime,
      required this.duration
    }
  );

  @override
  String toString() => title;

  Map<String, dynamic> toJson() => {
    'title': title,
    'href': href,
    'resource': resource,
    'startTime': startTime,
    'endTime': endTime,
    'duration': duration
  };

  factory contestEvent.fromJson(Map<String, dynamic> json) => contestEvent(
    title: json['title'],
    href: json['href'],
    resource: json['resource'],
    startTime: json['startTime'],
    endTime: json['endTime'],
    duration: json['duration']
  );
}

final kContests = LinkedHashMap<DateTime, List<contestEvent>>(
  equals: isSameDay,
  hashCode: (DateTime key) => key.day * 1000000 + key.month * 10000 + key.year,
);

void addContest(contestEvent contest) {
  final contestDate = DateTime.parse(contest.startTime).toLocal();
  if (kContests[contestDate] == null) {
    kContests[contestDate] = [];
  }
  kContests[contestDate]!.add(contest);
}