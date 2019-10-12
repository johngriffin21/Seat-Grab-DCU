import 'package:flutter/material.dart';
import 'dart:async';
import 'home_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensors/sensors.dart';
import 'seat_found.dart';
import 'google_sign_in.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class StudyPage extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<StudyPage> {


  NfcData _nfcData;
  final db = Firestore.instance; //reference to our database
  var now = new DateTime.now();
  final DocumentReference totalRef= Firestore.instance.document('/library_capacity/capacity');
  Firestore firestore = Firestore();
  List<double> _userAccelerometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];

  Future<void> startNFC() async {
    if (this.mounted) {
      setState(() {
        _nfcData = NfcData();
        _nfcData.status = NFCStatus.reading;
      });
    }
    print('NFC: Scan started');
    print('NFC: Scan read NFC tag');
    FlutterNfcReader.read.listen((response) {
      if (this.mounted) {
        setState(() {
          _nfcData = response;
        });
      }
    });
    print(_nfcData);
  }

  Future<void> stopNFC() async {
    NfcData response;

    try {
      print('NFC: Stop scan by user');
      response = await FlutterNfcReader.stop;
    } on PlatformException {
      print('NFC: Stop scan exception');
      response = NfcData(
        id: '',
        content: '',
        error: 'NFC scan stop exception',
        statusMapper: '',
      );
      response.status = NFCStatus.error;
    }

    if (this.mounted) {
      setState(() {
        _nfcData = response;
      });
    }
  }

  void _takeSeat() {
//    print("${_nfcData} NOW HERE");
    final Stopwatch stopwatch = new Stopwatch();
    final DocumentReference documentReference =
    Firestore.instance.document("/baby/${_nfcData.id}");
    print(_nfcData);
    Map<String, bool> data = <String, bool>{
      "taken": true,
    };
    documentReference.updateData(data).whenComplete(() {
      print("Seat reserved");
    });
    showDialog(
      context: context,
    builder: (BuildContext context) {
    return AlertDialog(
        title: new Text(
            "A seat has been found for you !",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway'
            )
        ),
        content: new Text(
            "Please place you phone on the desk and click confirm to reserve the seat."
        ),
        actions: <Widget>[
          new FlatButton(
              child: new Text("Done"),
              onPressed: () {
                incrementCount();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SeatFound(myObject:_nfcData.id)
                    )
                );
              }
          )
        ]
    );
  },
  );
  }

//  void _freeSeat() {
//
//    final DocumentReference documentReference =
//    Firestore.instance.document("baby/${_nfcData.id}");
//    Map<String, bool> data = <String, bool>{
//      "taken": false,
//      "absent": false,
//    };
//    documentReference.updateData(data).whenComplete(() {
//      print("Seat available");
//    }).catchError((e) => print(e));
//  }

  Future<void> seatFound() async{
    await new Future.delayed(const Duration(seconds: 5), () {
      //print(_nfcData.id);
      _takeSeat();
  }
    );
  }

  void incrementCount(){
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(totalRef);
      if (postSnapshot.exists) {
        if(postSnapshot.data['c'] < 9){
          await tx.update(totalRef, <String, dynamic>{'c': postSnapshot.data['c'] + 1});      //increment count
          //print(postSnapshot.data['c']);
        }
      }
    });
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
                            horizontal: 10.0, vertical: 145.0),  //change vertical to move up and down
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
                              'To reserve a seat, please tap the button below to begin',
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
                              text: ['Searching....'],
                              textStyle: new TextStyle(
                                color: Colors.red,
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
                        startNFC();
                        new Icon(Icons.timer);
                        seatFound();
                      },
                      backgroundColor: Colors.cyan,
                      child: new Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
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
  }
}
