import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tayal/views/dashboard.dart';
import 'package:tayal/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loggedIn = false;
  final splashDelay = 1;

  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
    _loadWidget();
  }

  _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('isLoggedIn').toString() == "true") {
      setState(() {
        _loggedIn = true;
      });
    } else {
      setState(() {
        _loggedIn = false;
      });
    }
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => homeOrLog()));
  }

  Widget homeOrLog() {
    if(_loggedIn == true) {
      return Dashboard();
    } else {
      return LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/images/glen_logo.png', fit: BoxFit.fill, scale: 4)),
    );
  }
}
