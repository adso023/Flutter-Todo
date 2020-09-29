import 'package:flutter/material.dart';
import 'package:flutter_todo/src/auth/auth.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlatButton(
      child: Text('Sign out'),
      onPressed: () async {
        await Provider.of<Auth>(context, listen: false).signOut();
      },
    ));
  }
}
