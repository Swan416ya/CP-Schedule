import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:cp_schedule/Schedule_io/contestEvent.dart';

class codeforcesGetter {
  final String url;

  codeforcesGetter(this.url);

  Future<contestEvent> getEvent() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    var document = parser.parse(response.body);

    // 获取比赛标题
    var titleElement = document.querySelector('meta[property="og:title"]');
    if (titleElement == null) {
      throw Exception('Failed to find title element');
    }
    String title = titleElement.attributes['content']!.trim();
    // Remove 'Dashboard - ' from the beginning and ' - Codeforces' from the end
    if (title.startsWith('Dashboard - ')) {
      title = title.substring('Dashboard - '.length);
    }
    if (title.endsWith(' - Codeforces')) {
      title = title.substring(0, title.length - ' - Codeforces'.length);
    }

    String duration = '';
    if (url.contains('gym'))
      duration = '18000';
    else
      duration = '7200';

    return contestEvent(
      title: title,
      href: url,
      resource: "codeforces.com",
      startTime: '',
      endTime: '',
      duration: duration,
    );
  }
}
