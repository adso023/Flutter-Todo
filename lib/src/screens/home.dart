import 'package:flutter_todo/src/auth/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/src/auth/auth.dart';
import 'package:flutter_todo/src/auth/firestore.dart';
import 'package:flutter_todo/src/models/TodoModel.dart';
import 'package:flutter_todo/src/models/UserModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class Category {
  final CategoryType type;
  final int taskNum;

  Category({this.type, this.taskNum});
}

enum CategoryType { Design, Learning, Meeting }

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<Auth>(context).user;
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      endDrawerEnableOpenDragGesture: true,
      drawer: Drawer(),
      endDrawer: Drawer(),
      body: StreamBuilder<UserModel>(
        stream: userModel,
        builder: (context, model) {
          if (model.hasData) {
            // return Container(child: Text('${model.data.email}'));
            return _buildBody(context, model.data.email, model.data.uid);
          } else if (model.hasError) {
            return Center(child: Text('Error: ${model.error}'));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: FloatingActionButton(
            tooltip: 'Add new todo',
            onPressed: null,
            child: Icon(Icons.add),
            backgroundColor: Colors.blueGrey[900]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody(BuildContext context, String email, String uid) => Stack(
        children: [
          Container(color: Colors.blueGrey[900]),
          SafeArea(
              child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello',
                          style: GoogleFonts.peddana(
                              fontSize: 25.0, color: Colors.white),
                        ),
                        Text(email,
                            style: GoogleFonts.peddana(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: GestureDetector(
                          onTap: () async =>
                              await Provider.of<Auth>(context, listen: false)
                                  .signOut(),
                          child: FlutterLogo(
                            size: 50,
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                  child: TextField(
                    style: GoogleFonts.peddana(
                        fontSize: 20.0, color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: GoogleFonts.peddana(
                            fontSize: 20.0, color: Colors.white),
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        contentPadding: EdgeInsets.all(2.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        )),
                  )),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)),
                  child: Container(
                    color: Colors.white,
                    child: StreamBuilder<List<TodoModel>>(
                        stream: Firestore().overviewTodos(uid),
                        builder: (context, data) {
                          if (data.hasData) {
                            return Container(
                              child: Text(data.data[0].todo),
                            );
                          } else if (data.hasError) {
                            return Container();
                          }
                          return Center(child: CircularProgressIndicator());
                        }),
                  ),
                ),
              ),
            ],
          )),
        ],
      );
}
