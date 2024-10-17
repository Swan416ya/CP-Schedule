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

    // 获取比赛标题
    var titleElement = document.querySelector(
        '.nk-container .acm-container .topic-banner-box .topic-banner h1 span');
    if (titleElement == null) {
      print('Title element not found');
      throw Exception('Title element not found');
    }
    String title = titleElement.text;
    print('Title: $title');

    // 获取比赛时间
    var timeElement = document.querySelector('.match-time span');
    if (timeElement == null) {
      print('Time element not found');
      throw Exception('Time element not found');
    }
    print('Time element text: ${timeElement.text}');

    RegExp regExp = RegExp(
        r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) 至 (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})');
    Match? match = regExp.firstMatch(timeElement.text);

    if (match == null) {
      print('Time elements not found in text: ${timeElement.text}');
      throw Exception('Time elements not found');
    }

    DateTime beginTime = DateTime.parse(match.group(1)!);
    DateTime endTime = DateTime.parse(match.group(2)!);
    var duration = endTime.difference(beginTime).inSeconds;

    var event = contestEvent(
      title: title,
      href: url,
      resource: "ac.nowcoder.com",
      // 把纯数字改成toIso8601String()格式
      startTime: beginTime.toIso8601String(),
      endTime: endTime.toIso8601String(),
      duration: duration.toString(),
    );

    return event;
  }
}
