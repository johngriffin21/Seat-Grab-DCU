import 'package:flutter/material.dart';
import 'map.dart';
import 'analytics.dart';
import 'auth.dart';
import 'google_sign_in.dart';
import 'admin_list.dart';
import 'admin_mapp.dart';




class HomeAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeAdmin> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    AdminMapp(),
    AdminSeatList(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              icon: Icon(Icons.map, color: Colors.cyan),
              title: Text('Check Map',
                  style: new TextStyle(color: Colors.cyan))),
          BottomNavigationBarItem(
              icon: Icon(Icons.build, color: Colors.cyan),
              title: Text('Alter Map',
                  style: new TextStyle(color: Colors.cyan))),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}