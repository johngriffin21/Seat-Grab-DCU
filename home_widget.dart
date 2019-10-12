import 'package:flutter/material.dart';
import 'map.dart';
import 'analytics.dart';
import 'auth.dart';
import 'study_page.dart';
import 'google_sign_in.dart';
import 'info.dart';


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    StudyPage(),
    Mapp(),
    PlannerPage(),
    Info(), //todo this is a tester.
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('SeatGrab'),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.directions_run, color: Colors.cyan),
              onPressed: () {
                authService.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.event_seat, color: Colors.cyan),
              title:
              new Text('Reserve', style: new TextStyle(color: Colors.cyan)),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.map, color: Colors.cyan),
                title: Text('Find a Seat',
                    style: new TextStyle(color: Colors.cyan))),
            BottomNavigationBarItem(
              icon: new Icon(Icons.assignment_turned_in, color: Colors.cyan),
              title:
              new Text('To-Do', style: new TextStyle(color: Colors.cyan)),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.directions_run, color: Colors.cyan),
              title: new Text('Info', style: new TextStyle(color: Colors.cyan)),
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}