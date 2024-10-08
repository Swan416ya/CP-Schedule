import 'package:flutter/material.dart';

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
                      builder: (context) => Text('Schedule'),
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
                      builder: (context) => Text('About'),
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