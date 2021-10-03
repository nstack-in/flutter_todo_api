class Todo {
  final String id;
  final String title;
  final String content;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;

  Todo({
    required this.id,
    required this.title,
    required this.content,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    final id = json['_id'] as String;
    final title = json['title'] as String;
    final content = json['content'] as String;
    final completed = json['completed'] as bool;
    final createdAt = DateTime.parse(json['createdAt'] as String);
    final updatedAt = DateTime.parse(json['updatedAt'] as String);
    return Todo(
      id: id,
      title: title,
      content: content,
      completed: completed,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
