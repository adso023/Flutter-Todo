import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_todo/src/models/TodoModel.dart';

class Firestore {
  FirebaseFirestore _firestore;

  Firestore() {
    _firestore = FirebaseFirestore.instance;
  }

  Stream<List<TodoModel>> overviewTodos(String uid) {
    return _firestore
        .collection('Todo')
        .where('owner', isEqualTo: uid)
        .snapshots()
        .map<List<TodoModel>>((event) => event.docs
            .map<TodoModel>((e) => TodoModel.fromJson(e.id, e.data()))
            .toList());
  }

  Stream<List<TodoSubTaskModel>> todoSubtasks(String todoId) {
    return _firestore
        .collection('Todo')
        .doc(todoId)
        .collection('SubTasks')
        .snapshots()
        .map<List<TodoSubTaskModel>>((e) => e.docs.map<TodoSubTaskModel>(
            (st) => TodoSubTaskModel.fromMap(st.id, st.data())));
  }

  Future<bool> addTodo(TodoModel todo) async {
    try {
      print('Writing [addTodo]');
      await _firestore.collection('Todo').doc().set(todo.toMap());
      return true;
    } catch (e) {
      print('Error on $e');
      return false;
    }
  }
}
