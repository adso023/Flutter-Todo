import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_todo/src/models/TodoModel.dart';

class Firestore {
  FirebaseFirestore _firestore;

  Firestore() {
    _firestore = FirebaseFirestore.instance;
  }

  Stream<List<TodoModel>> overviewTodos(String uid) {
    return _firestore.collection('Todo').snapshots().map<List<TodoModel>>(
        (event) => event.docs
            .map<TodoModel>((e) => TodoModel.fromJson(e.data()))
            .toList());
  }

  Future<bool> addTodo(TodoModel todo) async {
    try {
      await _firestore.collection('Todo').doc().set(todo.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}
