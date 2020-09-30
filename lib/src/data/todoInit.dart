import 'package:flutter_todo/src/auth/firestore.dart';
import 'package:flutter_todo/src/models/TodoModel.dart';

class TodoInitData {
  TodoModel _todo;
  TodoInitData({String uid}) {
    _todo = TodoModel(
        owner: uid,
        completed: false,
        todo: 'First Todo');
  }

  Future<bool> _writeInitialData() async {
    print('Writing inside private');
    bool result = await Firestore().addTodo(_todo);
    return result;
  }

  Future<bool> writeInitial() async {
    print('Writing');
    return await _writeInitialData();
  }
}
