import 'package:flutter_todo/src/auth/firestore.dart';
import 'package:flutter_todo/src/models/TodoModel.dart';

class TodoInitData {
  TodoModel _todo;
  TodoInitData({String uid}) {
    _todo = TodoModel(
        belongsTo: uid,
        groupsTo: 'Welcome Project',
        comments: <String>["First Todo Comment", "Write comments here"],
        tags: <String>['Initial', 'Testing'],
        todo: 'First Todo');
  }

  Future<bool> _writeInitialData() async {
    bool result = await Firestore().addTodo(_todo);
    return result;
  }

  Future<bool> writeInitial() async {
    return await _writeInitialData();
  }
}
