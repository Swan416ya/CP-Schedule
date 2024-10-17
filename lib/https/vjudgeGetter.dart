import 'package:http/http.dart' as http;
import 'package:cp_schedule/Schedule_io/contestEvent.dart';
import 'package:html/parser.dart' as parser;

class vjudgeGetter {
  String url = "";
  vjudgeGetter(String url) {
    this.url = url;
  }

  //直接返回url网页返回的所有内容为字符串
  Future<String> returnInfo() async {
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  Future<contestEvent> getEvent() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    // 解析html中body部分中的class="container"中的内容
    var document = parser.parse(response.body);
    print('Document parsed successfully');

    var titleElement = document.querySelector('div.col-xs-6.text-xs-center h3');
    var beginElement =
        document.querySelector('div.col-xs-3.text-xs-left span.timestamp');
    var endElement =
        document.querySelector('div.col-xs-3.text-xs-right span.timestamp');

    if (titleElement == null) {
      throw Exception('Title element not found');
    }
    if (beginElement == null) {
      throw Exception('Begin element not found');
    }
    if (endElement == null) {
      throw Exception('End element not found');
    }

    // 存一下时间
    var beginTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(beginElement.text));
    var endTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(endElement.text));
    var duration = endTime.difference(beginTime).inSeconds;

    String title = titleElement.text;
    //除去title中第一个文字内容之前和最后一个文字内容之后的所有空格和回车
    title = title.substring(1, title.length - 1).trim();

    var event = contestEvent(
      title: title,
      href: url,
      resource: "vjudge.net",
      // 把纯数字改成toIso8601String()格式
      startTime: beginTime.toIso8601String(),
      endTime: endTime.toIso8601String(),
      duration: duration.toString(),
    );

    return event;
  }
}
