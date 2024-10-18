import 'package:flutter/material.dart';
import 'package:cp_schedule/Parts/ContestCard.dart'; // Ensure this path is correct
import 'package:url_launcher/url_launcher.dart';
import 'package:cp_schedule/https/WebHelper.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cp_schedule/Schedule_io/util.dart';
import 'package:cp_schedule/Schedule_io/contestEvent.dart';
import 'package:cp_schedule/Parts/EventsCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final ValueNotifier<List<contestEvent>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  Future<void> _saveEvents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, List<String>> data = {};

    kContests.forEach((key, value) {
      data[key.toIso8601String()] =
          value.map((e) => json.encode(e.toJson())).toList();
    });

    await prefs.setString('events', json.encode(data));
  }

  // 从本地存储读取日程数据
  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsString = prefs.getString('events');
    if (eventsString != null) {
      final Map<String, dynamic> eventsJson = jsonDecode(eventsString);
      eventsJson.forEach((key, value) {
        final contestDate = DateTime.parse(key).toLocal();
        final contestsList = (value as List)
            .map((e) => contestEvent.fromJson(jsonDecode(e)))
            .toList();
        kContests[contestDate] = contestsList;
      });
    }
    setState(() {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    });
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _loadEvents();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<contestEvent> _getEventsForDay(DateTime day) {
    // Implementation example
    return kContests[day] ?? [];
  }

  List<contestEvent> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
      _saveEvents();
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      if (start != null) {
        _rangeStart = start;
        _rangeEnd = end;
        _focusedDay = focusedDay;
        _selectedDay = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOn;
      } else {
        _rangeStart = null;
        _rangeEnd = null;
        _focusedDay = focusedDay;
        _selectedDay = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      }
    });

    if (start != null) {
      _selectedEvents.value = _getEventsForRange(start, end!);
      _saveEvents();
    }
  }

  void _refreshEvents() {
    setState(() {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    });
  }

  void _deleteEvent(contestEvent event) {
    final contestDate = DateTime.parse(event.startTime).toLocal();
    kContests[contestDate]?.remove(event);
    if (kContests[contestDate]?.isEmpty ?? false) {
      kContests.remove(contestDate);
    }
    _saveEvents();
    _refreshEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshEvents,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TableCalendar<contestEvent>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              rangeStartDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<contestEvent>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onSecondaryTapDown: (details) {
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            details.globalPosition.dx,
                            details.globalPosition.dy,
                            details.globalPosition.dx,
                            details.globalPosition.dy,
                          ),
                          items: [
                            PopupMenuItem(
                              child: Text('Delete'),
                              onTap: () {
                                _deleteEvent(value[index]);
                              },
                            ),
                          ],
                        );
                      },
                      child: EventsCard(event: value[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
