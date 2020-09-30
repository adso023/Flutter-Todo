class TodoModel {
  final String todo;
  final List<String> comments;
  final List<String> tags;
  final String groupsTo;
  final String belongsTo;

  TodoModel(
      {this.todo, this.comments, this.tags, this.groupsTo, this.belongsTo});

  factory TodoModel.fromJson(Map<String, dynamic> data) {
    return TodoModel();
  }

  Map toMap() => {
    "todo": todo,
    "comments": comments,
    "tags": tags,
    "groupsTo": groupsTo,
    "belongsTo": belongsTo
  };
}
