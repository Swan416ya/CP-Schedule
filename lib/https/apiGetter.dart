import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cp_schedule/Parts/ContestCard.dart';

class apiGetter {
  final String resource;

  apiGetter(this.resource);

  Future<List<Map<String, dynamic>>> fetchContests() async {
    // 获取当前本地时间并格式化为 ISO 8601 字符串
    DateTime now = DateTime.now();
    String currentTime = formatDateTime(now);

    // 构建请求 URL
    String url =
        'https://clist.by/api/v4/contest/?resource=$resource&start__gt=$currentTime&order_by=start';

    // 发送 HTTP GET 请求
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List contests = jsonData['objects'];
      return contests
          .map((contest) => {
                'resource': contest['resource']['name'],
                'startTime': DateTime.parse(contest['start']).toString(),
                'endTime': DateTime.parse(contest['end']).toString(),
                'event': contest['event'],
                'duration': contest['duration'].toString(),
                'href': contest['href'],
              })
          .toList();
    } else {
      throw Exception('Failed to load contests');
    }
  }

  String formatDateTime(DateTime dateTime) {
    String year = dateTime.year.toString();
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String second = dateTime.second.toString().padLeft(2, '0');
    return '$year-$month-$day'+'T$hour:$minute:$second';
  }
}
