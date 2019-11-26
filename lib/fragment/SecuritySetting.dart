import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ricwala_application/activity/drawer.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecuritySetting extends StatefulWidget {

  @override
  SecuritySettingState createState() => SecuritySettingState();
}

class SecuritySettingState extends State<SecuritySetting> {

  Future<bool> _onBackPressed() {

    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => HomePage(0)));
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return new WillPopScope(
        onWillPop: _onBackPressed,
   child: Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                new Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: new Text(
                    'On Progress',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
   ));
  }
}
