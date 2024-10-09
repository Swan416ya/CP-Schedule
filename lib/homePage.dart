import 'package:flutter/material.dart';
import 'package:cp_schedule/Pages/about.dart';
import 'package:cp_schedule/Pages/Schedule.dart';
import 'package:cp_schedule/Parts/ContestCard.dart';
import 'package:cp_schedule/Pages/Debug.dart';

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
  final _Debug = GlobalKey<NavigatorState>();

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
                icon: Icon(Icons.bug_report),
                selectedIcon: Icon(Icons.bug_report),
                label: Text('Debug'),
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
                      builder: (context) => Text('Settings'),
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
                  key: _Debug,
                  onGenerateRoute: (RouteSettings settings) {
                    return MaterialPageRoute(
                      builder: (context) => DebugPage(),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}