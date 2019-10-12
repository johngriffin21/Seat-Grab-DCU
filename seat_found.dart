import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensors/sensors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'map.dart';
import "study_page.dart";
import 'home_widget.dart';


class SeatFound extends StatefulWidget {
  final String myObject;
  SeatFound({
    Key key, this.myObject
  });
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<SeatFound> {
  QuerySnapshot seat;
  final db = Firestore.instance; //reference to our database
  var now = new DateTime.now();
  final DocumentReference totalRef= Firestore.instance.document('/library_capacity/capacity');
  Firestore firestore = Firestore();
  List<double> _userAccelerometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];


//  getDoc(x) {
//    x.documentID;
//  }

//  Future<String> getSeatNumber() async {
//    DocumentSnapshot snapshot= await Firestore.instance.collection('channels').document(getDoc(widget.myObject));
//    var channelName = snapshot['channelName'];
//    if (channelName is String) {
//    return channelName;
//    } else {
//    throw ......
//    }
//  }

  timer() async{
    await Future.delayed(Duration(seconds: 15), () {
      print("Were here");
      _overdueSeat();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: new Text(
                    "You have gone over your break limit ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway'
                    )
                ),
                content: new Text(
                    "An admin has been notified and may remove your items."
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        dispose();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home()
                            )
                        );
                      }
                  )
                ]
            );
          }
      );
    });
  }


  void accel() async {
    final Stopwatch stopwatch = new Stopwatch();
    print("Accelerometer started");
      accelerometerEvents.listen((AccelerometerEvent event) async{
        if (_userAccelerometerValues.last < -4.0) {
          timer();
          final DocumentReference documentReference = Firestore.instance
              .document("baby/${widget.myObject}");
          Map<String, bool> data =
          <String, bool>{"absent": true,}; //stops here.
          documentReference.updateData(data).whenComplete(() {
            print("Student Absent from seat");
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: new Text(
                        "You have left your seat at $now Please return within 45 minutes to keep your seat ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Raleway'
                        )
                    ),
                    content: new Text(
                        "Click yes if you're back at your seat"
                    ),
                    actions: <Widget>[
                      new FlatButton(
                          child: new Text("Yes"),
                          onPressed: () {
                            dispose();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudyPage()
                                )
                            );
                          }
                      )
                    ]
                );
              }
          );
        }
      }
      );
      /////////////////////////////////
  }

  void _freeSeat() {
    final DocumentReference documentReference =
    Firestore.instance.document("baby/${widget.myObject}");
    Map<String, bool> data = <String, bool>{
      "taken": false,
      "absent": false,
    };
    documentReference.updateData(data).whenComplete(() {
      print("Seat available");
    }).catchError((e) => print(e));
    decrementCount();
  }


  void _overdueSeat() {
    print("in overdue seat section");
    final DocumentReference documentReference =
    Firestore.instance.document("baby/${widget.myObject}");
    Map<String, bool> data = <String, bool>{
      "taken": true,
      "overdue": true,
    };
    documentReference.updateData(data).whenComplete(() {
      print("Seat available");
    }).catchError((e) => print(e));
    decrementCount();
  }

  void decrementCount(){
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(totalRef);
      if (postSnapshot.exists) {
        if(postSnapshot.data['c'] > 0){
          await tx.update(totalRef, <String, dynamic>{'c': postSnapshot.data['c'] - 1});      //increment count
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();




    return new MaterialApp(
      title: 'FlutterBase',
      home: Scaffold(
          body: Center(
            child: new Stack(children: <Widget>[
              new Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("back.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              new Align(
                alignment: Alignment(0,-2.5),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: new Image.asset('logo_transparent.png'),
                ),
              ),
              new Align(
                  alignment: Alignment(0,.5),
                  child: new Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: new Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 165.0),  //change vertical to move up and down
                        padding: const EdgeInsets.all(15.0),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(11.0),
                          shape: BoxShape.rectangle,
                          color: Colors.black.withOpacity(0.8),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5.0,
                              offset: new Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                        child: new Column(
                          children: <Widget>[
                            new Text(
                              'You are currently in seat number: 8',       //${seat.documents.firstWhere('${}')
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
//                            new Text(_nfcData == null ? 'Searching.....' : '',   //todo expected a procedure, a constructor or a function node.
//                              style: new TextStyle(
//                                color: Colors.red,
//                                fontSize: 20.0,
//                              )
//                            ),
                            new FadeAnimatedTextKit(
                              text: ['Connected'],
                              textStyle: new TextStyle(
                                color: Colors.green,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])),

              new Align(
                alignment: Alignment(0,.7),
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      onPressed: () {
                        _freeSeat();
                        dispose();
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()));
                      },
                      backgroundColor: Colors.red,
                      child: new Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
//
//              new Align(
//                alignment: Alignment(0,.7),
//                child: MaterialButton(
//                  onPressed: () {
//                    _takeSeat; },
//                  color: Colors.cyan,
//                  textColor: Colors.black87,
//                  child: Text('2. Click here to if you have a seat number'),
//                ),
////                    ),
////                  ],
////                ),
//              ),
//              new Align(
//                alignment: Alignment(0,.9),
//                child: MaterialButton(
//                  onPressed: () {
//                    stopNFC();
//                    _freeSeat();
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => StudyPage()));},
//                  color: Colors.cyan,
//                  textColor: Colors.black87,
//                  child: Text('3. Click here to clear up your seat for someone else '),
//                ),
////                    ),
////                  ],
////                ),
//              ),
            ]),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
      
    }));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => accel());
  }
}
