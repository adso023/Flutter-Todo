import 'package:flutter/material.dart';

class TodoBottomSheet extends StatefulWidget {
  createState() => _TodoBSState();
}

class _TodoBSState extends State<TodoBottomSheet> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
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
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            child: TextField(
              decoration: InputDecoration.collapsed(hintText: 'Enter todo')
            ),
          )
        ],
      ),
    );
  }
}
