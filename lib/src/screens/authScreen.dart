import 'package:flutter/material.dart';
import 'package:flutter_todo/src/screens/login.dart';
import 'package:flutter_todo/src/screens/register.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _currentView = 0;
  final _authViews = <Widget>[
    Login(),
    Register(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _authViews[_currentView],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentView,
          onTap: (index) {
            setState(() {
              _currentView = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.login),
                label: 'Login',
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.app_registration),
                label: 'Register',
                backgroundColor: Colors.black)
          ],
        ));
  }
}
