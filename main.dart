import 'package:flutter/material.dart';
import 'splashscreen.dart';
import 'package:flutter/services.dart';


void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) //lock phone in portrait mode
      .then((_) {
    runApp(new App());
  });
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DCU seat grab',
      home: Splashscreen(),
    );
  }
}
