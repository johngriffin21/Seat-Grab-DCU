import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
  }

class _InfoState extends State<Info> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

    @override
    Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: new Stack(
            children: <Widget>[
              new Align(
                alignment: Alignment.bottomCenter,

                child: MaterialApp(
                  routes: {
                    "/": (_) => new WebviewScaffold(
                      url: "https://www.dcu.ie/library/Opening-Times-Block-for-Front-Page.shtml",
                    ),
                  },

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}