import 'package:flutter/material.dart';
import 'package:cp_schedule/Pages/about.dart';
import 'package:cp_schedule/Pages/Schedule.dart';
import 'package:cp_schedule/Parts/ContestCard.dart';
import 'package:cp_schedule/Pages/ShowCard.dart';
import 'package:cp_schedule/Pages/Setting.dart';
import 'package:unicons/unicons.dart';
import 'package:cp_schedule/Pages/ShowJson.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _selectedIndex = 0;

  final _Calendar = GlobalKey<NavigatorState>();
  final _Schedule = GlobalKey<NavigatorState>();
  final _Settings = GlobalKey<NavigatorState>();
  final _About = GlobalKey<NavigatorState>();
  final _ShowCard = GlobalKey<NavigatorState>();
  final _ShowJson = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //侧边栏NavigationRail
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            //背景色是249,240,245
            backgroundColor: Color.fromARGB(255, 249, 240, 245),
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.calendar_today),
                selectedIcon: Icon(Icons.calendar_today),
                label: Text('Calendar'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.schedule),
                selectedIcon: Icon(Icons.schedule),
                label: Text('Schedule'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.info),
                selectedIcon: Icon(Icons.info),
                label: Text('About'),
              ),
              NavigationRailDestination(
                icon: Icon(UniconsLine.card_atm),
                selectedIcon: Icon(UniconsLine.card_atm),
                label: Text('Card'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.web),
                selectedIcon: Icon(Icons.web),
                label: Text('Json'),
              ),
            ],
          ),
          //主体部分
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: <Widget>[
                Navigator(
                  key: _Calendar,
                  onGenerateRoute: (RouteSettings settings) {
                    return MaterialPageRoute(
                      builder: (context) => Text('Calendar'),
                    );
                  },
                ),
                Navigator(
                  key: _Schedule,
                  onGenerateRoute: (RouteSettings settings) {
                    return MaterialPageRoute(
                      builder: (context) => SchedulePage(),
                    );
                  },
                ),
                Navigator(
                  key: _Settings,
                  onGenerateRoute: (RouteSettings settings) {
                    return MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    );
                  },
                ),
                Navigator(
                  key: _About,
                  onGenerateRoute: (RouteSettings settings) {
                    return MaterialPageRoute(
                      builder: (context) => aboutPage(),
                    );
                  },
                ),
                Navigator(
                  key: _ShowCard,
                  onGenerateRoute: (RouteSettings settings) {
                    return MaterialPageRoute(
                      builder: (context) => ShowCardPage(),
                    );
                  },
                ),
                Navigator(
                  key: _ShowJson,
                  onGenerateRoute: (RouteSettings settings) {
                    return MaterialPageRoute(
                      builder: (context) => ShowJsonPage(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}