import 'dart:async';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'planner_functions.dart';

class PlannerPage extends StatefulWidget {
  @override
  _PlannerPageState createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  QuerySnapshot planner;
  String moduleName;
  String todo;
  plannerMedthods plannerObj = new plannerMedthods();

  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add what you have to do, then click refresh',
                style: TextStyle(fontSize: 15.0)),
            content: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Module Name'),
                  onChanged: (value) {
                    this.moduleName = value;
                  },
                ),
                SizedBox(height: 7.0),
                TextField(
                  decoration:
                  InputDecoration(hintText: 'Enter your to do list'),
                  onChanged: (value) {
                    this.todo = value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add Module'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();    //apparent fix to bug looking up deactivated widgets ancestor is unsafe.
                  plannerObj.addData({
                    'Name of Module': this.moduleName,
                    'To-Do For Module': this.todo
//                  }).then((result) {
//                    dialogTrigger(context);
//                  }).catchError((e) {
//                    print(e);
//                  });
                  });
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    plannerObj.getData().then((results) {
      setState(() {
        planner = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,        //get rid of the back bar
          centerTitle: true,  //centres the title
          title: Text('Your study to do list'),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Colors.cyan ),
              onPressed: () {
                addDialog(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.cyan),
              onPressed: () {
                plannerObj.getData().then((results) {
                  setState(() {
                    planner = results;
                  });
                });
              },
            )
          ],
        ),
        body: _carList());
  }

  Widget _carList() {
    if (planner != null) {
      return ListView.builder(
        itemCount: planner.documents.length,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, i) {                    //todo add update to the app
          return ListTile(
            leading: Icon(Icons.arrow_right, color: Colors.cyan),
            title: Text(planner.documents[i].data['Name of Module']),
            subtitle: Text(planner.documents[i].data['To-Do For Module']),
            onLongPress: () {
              plannerObj.deleteData(planner.documents[i]);
              showDialog(context: context,
              builder: (BuildContext context) {
                return AlertDialog( //not coming up
                  title: new Text("Item deleted"),
                  content: new Text(
                      "Please refresh to see your updated To-Do list"),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Close"),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ],
                );
              },
              );
            },
          );
        },
      );

    } else {    //for the loader
      return SplashScreen(
        seconds: 8,
        image: new Image.asset('logo_transparent.png'),
        backgroundColor: Colors.black,
        photoSize: 100.0,
        loaderColor: Colors.cyan,
      );
    }
  }


}