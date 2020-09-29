import 'package:flutter/material.dart';
import 'package:flutter_todo/src/auth/auth.dart';
import 'package:flutter_todo/src/models/UserModel.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<Auth>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Today'),
      ),
      body: StreamBuilder<UserModel>(
        stream: userModel,
        builder: (context, model) {
          if (model.hasData) {
            return Container(child: Text('${model.data.email}'));
          } else if (model.hasError) {
            return Center(child: Text('Error: ${model.error}'));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
