import 'package:flutter/material.dart';
import 'package:cp_schedule/Parts/ContestCard.dart'; // Ensure this path is correct
import 'package:url_launcher/url_launcher.dart';
import 'package:cp_schedule/https/WebHelper.dart';
import 'package:cp_schedule/https/vjudgeGetter.dart';
import 'package:cp_schedule/https/nowcoderGetter.dart';
import 'package:cp_schedule/Schedule_io/contestEvent.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:cp_schedule/https/CodeforcesGetter.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Contest> _contests = [];
  int maxContestsCnt = 100;
  bool _isLoading = false;
  var clist;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var data = await WebHelper().get(
        'https://clist.by/api/v4/contest/',
        queryParameters: {
          'order_by': 'start',
          'upcoming': true,
          'limit': maxContestsCnt,
          'start__gt': DateTime.now().subtract(Duration(hours: 8)).toIso8601String(),
          'filtered': true,
          'format_time': false,
        },
      );
      clist = data.data['objects'];
      _contests.clear();

      // Debugging: Print the fetched data
      print('Fetched data: $clist');

      int cnt = 1;
      for (var c in clist) {
        var contest = Contest(
          event: c['event'],
          resource: c['resource'],
          startTime: _formatDateTime(c['start']),
          endTime: _formatDateTime(c['end']),
          duration: c['duration'].toString(),
          href: c['href'],
        );
        _contests.add(contest);
        print("Success adding contest: $cnt\n");
        cnt++;
      }

      // Debugging: Print the contests list
      print('Contests list: $_contests');
    } catch (e) {
      print('Error fetching contests: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDateTime(String dateTime) {
    DateTime dt = DateTime.parse(dateTime).add(Duration(hours: 8));
    return "${dt.toIso8601String().split('.').first}Z";
  }

  void _showAddContestDialog() {
    TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('add custom contest'),
          content: TextField(
            controller: urlController,
            decoration: InputDecoration(hintText: 'please input contest url'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                String url = urlController.text;
                if (url.isNotEmpty) {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    contestEvent event = contestEvent(
                      title: 'Custom Contest',
                      href: url,
                      resource: 'Custom',
                      startTime: DateTime.now().toIso8601String(),
                      endTime: DateTime.now().add(Duration(days: 1)).toIso8601String(),
                      duration: '86400',
                    );
                    //url内包括vjudge.net则调用vjudgeGetter()方法
                    if (url.contains('vjudge.net'))
                    {
                      vjudgeGetter getter = vjudgeGetter(url);
                      event = await getter.getEvent();
                      addContest(event);
                    }
                    else if(url.contains('ac.nowcoder.com'))
                    {
                      nowcoderGetter getter = nowcoderGetter(url);
                      event = await getter.getEvent();
                      addContest(event);
                    }
                    else
                    {
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('This platform is not supported yet.'),
                        ),
                        );
                    }
                  } catch (e) {
                    print('Error adding custom contest: $e');
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
              child: Text('add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showAddVPDialog()
  {
    TextEditingController urlController = TextEditingController();
    DateTime? startDateTime;
    DateTime? endDateTime;

    showDialog(
      context: context,
      builder: (context) {
      return AlertDialog(
        title: Text('Add a virtual participation schedule'),
        content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
          controller: urlController,
          decoration: InputDecoration(hintText: 'Please input contest URL'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
          onPressed: () async {
            startDateTime = await showOmniDateTimePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            );
          },
          child: Text('Select Start Time'),
          ),
        ],
        ),
        actions: [
        TextButton(
          onPressed: () async {
          Navigator.of(context).pop();
          String url = urlController.text;
          if (url.isNotEmpty && startDateTime != null) {
            setState(() {
            _isLoading = true;
            });
            try {
            contestEvent event = contestEvent(
              title: 'Custom Contest',
              href: url,
              resource: 'Custom',
              startTime: startDateTime!.toIso8601String(),
              endTime: '',
              duration: '',
            );
            if(url.contains('codeforces.com'))
            {
              codeforcesGetter getter = codeforcesGetter(url);
              event = await getter.getEvent();
              addContest(contestEvent(
                title:event.title+'(VP)',
                href:url,
                startTime:startDateTime!.toIso8601String(),
                duration:event.duration,
                endTime: startDateTime!.add(Duration(seconds: int.parse(event.duration))).toIso8601String(),
                resource:"codeforces.com",
              ));
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('This platform is not supported yet.'),
              ),
              );
            }
            } catch (e) {
            print('Error adding custom contest: $e');
            } finally {
            setState(() {
              _isLoading = false;
            });
            }
          }
          },
          child: Text('Add'),
        ),
        TextButton(
          onPressed: () {
          Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ],
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        actions: [
          IconButton(
            icon: Text('VP'),
            onPressed: () {
              _showAddVPDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddContestDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              init();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _contests.isEmpty
              ? Center(
                  child: Text(
                      'No contests available\nTry add cookie in setting page and refresh'))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return ContestCard(
                      contest: _contests[index],
                    );
                  },
                  itemCount: _contests.length,
                ),
    );
  }
}
