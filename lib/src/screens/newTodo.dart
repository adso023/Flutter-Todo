import 'package:flutter/material.dart';
import 'package:flutter_todo/src/auth/firestore.dart';
import 'package:flutter_todo/src/models/TodoModel.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoBottomSheet extends StatefulWidget {
  final owner;
  TodoBottomSheet({this.owner});
  createState() => _TodoBSState();
}

class _TodoBSState extends State<TodoBottomSheet> {
  TextEditingController _controller;
  bool _submitting;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _submitting = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.grey[300], spreadRadius: 5),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
                controller: _controller,
                style: GoogleFonts.peddana(),
                decoration: InputDecoration.collapsed(
                    hintText: 'Enter todo', hintStyle: GoogleFonts.peddana())),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: (_submitting)
                ? CircularProgressIndicator()
                : MaterialButton(
                    child: Text(
                      'Submit Todo',
                      style: GoogleFonts.peddana(),
                    ),
                    onPressed: () async {
                      setState(() {
                        _submitting = true;
                      });
                      TodoModel tm = TodoModel(
                          completed: false,
                          owner: widget.owner,
                          todo: _controller.text);
                      bool res = await Firestore().addTodo(tm);
                      setState(() {
                        _submitting = false;
                      });
                      return (!res) ? Container() : Navigator.pop(context);
                    },
                  ),
          ),
          Divider(indent: 2.0, endIndent: 2.0, thickness: 2.0),
          
        ],
      ),
    );
  }
}
