import 'package:flutter/material.dart';
import 'package:flutter_todo/src/screens/login.dart';
import 'package:flutter_todo/src/screens/register.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _currentView = 0;
  List<Widget> _authViews;

  void _sendLogin() => setState(() {
        _currentView = 0;
      });
  void _sendRegister() => setState(() {
        _currentView = 1;
      });

  @override
  void initState() {
    super.initState();
    _authViews = <Widget>[
      Login(registerCallback: _sendRegister),
      Register(loginCallback: _sendLogin),
    ];
  }

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
