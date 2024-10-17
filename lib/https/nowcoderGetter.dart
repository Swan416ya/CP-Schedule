import 'package:http/http.dart' as http;
import 'package:cp_schedule/Schedule_io/contestEvent.dart';
import 'package:html/parser.dart' as parser;

class nowcoderGetter {
  String url = "";
  nowcoderGetter(String url) {
    this.url = url;
  }

  Future<contestEvent> getEvent() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    // 解析html中body部分中的内容
    var document = parser.parse(response.body);
    print('Document parsed successfully');

    // 打印整个HTML文档的内容
    print(document.outerHtml);

    // 获取比赛标题和时间
    var scriptElements = document.querySelectorAll('script');
    String? title;
    DateTime? startTime;
    DateTime? endTime;
    for (var script in scriptElements) {
      if (script.text.contains('window.pageInfo')) {
        RegExp titleRegExp = RegExp(r'"competitionName_var":"(.*?)"');
        Match? titleMatch = titleRegExp.firstMatch(script.text);
        if (titleMatch != null) {
          title = titleMatch.group(1);
        }

        RegExp startTimeRegExp = RegExp(r'"startTime":(\d+)');
        Match? startTimeMatch = startTimeRegExp.firstMatch(script.text);
        if (startTimeMatch != null) {
          startTime = DateTime.fromMillisecondsSinceEpoch(
              int.parse(startTimeMatch.group(1)!));
        }

        RegExp endTimeRegExp = RegExp(r'"signUpEndTime":(\d+)');
        Match? endTimeMatch = endTimeRegExp.firstMatch(script.text);
        if (endTimeMatch != null) {
          endTime = DateTime.fromMillisecondsSinceEpoch(
              int.parse(endTimeMatch.group(1)!));
        }
        break;
      }
    }

    if (title == null) {
      print('Title element not found');
      throw Exception('Title element not found');
    }
    print('Title: $title');

    if (startTime == null || endTime == null) {
      print('Time elements not found');
      throw Exception('Time elements not found');
    }
    print('Start Time: $startTime');
    print('End Time: $endTime');

    var duration = endTime.difference(startTime).inSeconds;

    var event = contestEvent(
      title: title,
      href: url,
      resource: "ac.nowcoder.com",
      // 把纯数字改成toIso8601String()格式
      startTime: startTime.toIso8601String(),
      endTime: endTime.toIso8601String(),
      duration: duration.toString(),
    );

    return event;
  }
}
