import 'package:flutter/material.dart';
import 'auth.dart';
import 'home_widget.dart';
import 'planner_functions.dart';
import 'home_widget_admin.dart';
import 'pincode.dart';

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FlutterBase',
      home: Scaffold(
          body: Center(
            child: new Stack(children: <Widget>[
              new Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("actualback1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              new Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: new Image.asset('logo_transparent.png'),
                ),
              ),
              new Align(
                alignment: Alignment(0, .4),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: new Text("Welcome to SeatGrab",
                      style: new TextStyle(color: Colors.white, fontSize: 30.0)),
                ),
              ),
              new Align(
                alignment: Alignment(0, .5),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: new Text("We find you a seat so you wont have to.",
                      style: new TextStyle(color: Colors.white, fontSize: 20.0)),
                ),
              ),
              new Align(
                alignment: Alignment(0, 0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: MaterialButton(
                        //TODO testing out admin login, leave it as second else if it doesn't work
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Pincode()));
                          },
                          color: Colors.cyan,
                          textColor: Colors.black87,
                          child: Text('            Login as Admin             ')),
                    ), Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: MaterialButton(
                        //TODO testing out admin login, leave it as second else if it doesn't work
                        onPressed: () {
                          authService.googleSignIn();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        color: Colors.cyan,
                        textColor: Colors.black87,
                        child: Text('            Login as Student           '),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          )),
    );
  }
}
