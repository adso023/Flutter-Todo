class TodoModel {
  final String uid;
  final String todo;
  final String owner;
  final bool completed;

  TodoModel({this.uid, this.todo, this.owner, this.completed});

  factory TodoModel.fromJson(String uid, Map<String, dynamic> data) {
    return TodoModel(
      uid: uid,
      owner: data['owner'],
      todo: data['todo'],
      completed: data['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() =>
      {"todo": todo, "owner": owner, "completed": completed};
}

class TodoSubTaskModel {
  final String subTask;
  final String belongsTodo;

  TodoSubTaskModel({this.subTask, this.belongsTodo});

  factory TodoSubTaskModel.fromMap(String todoId, Map<String, dynamic> data) {
    print('SubTask Data: $data');
    return TodoSubTaskModel(subTask: data['subTask'], belongsTodo: todoId);
  }

  Map<String, dynamic> toMap() => {"subTask": subTask};
}
