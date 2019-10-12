import 'package:pin_code_view/pin_code_view.dart';
import 'package:flutter/material.dart';
import 'home_widget_admin.dart';


class Pincode extends StatefulWidget {
  var entered_code;
  @override
  _PincodeState createState() => _PincodeState();
}

class _PincodeState extends State<Pincode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PinCode(
        title: Text(
          "Admin Login",
          style: TextStyle(
              color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        subTitle: Text(
          "Enter the Admin pin to enter",
          style: TextStyle(color: Colors.cyan),
        ),
        obscurePin: true,
        // to make pin * instead of number
        codeLength: 6,
        onCodeEntered: (code) {
          if (code == '123456') {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeAdmin()));
          } else {
            return AlertDialog(
                title: new Text(
                    "The code you entered was incorrect.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway',
                      color: Colors.black,
                    )
                ),
                content: new Text(
                    " Please try again"
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: new Text("Try Again"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PinCode()
                            )
                        );
                      }
                  )
                ]
            );
          }
          print(code);
        },
      ),
    );
  }
}