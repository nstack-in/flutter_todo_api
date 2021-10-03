import 'package:flutter/material.dart';
import 'package:flutter_todo_api/model/todo.dart';
import 'package:flutter_todo_api/services/todo.dart';

class AddPage extends StatefulWidget {
  final Todo? todo;
  const AddPage({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final todoService = TodoServices();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String pageTitle = 'Add Todo';
  String buttonText = 'Add';

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      pageTitle = 'Edit Todo';
      buttonText = 'Update';
      titleController.text = todo.title;
      contentController.text = todo.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          TextField(
            controller: titleController,
            maxLength: 16,
            maxLines: 1,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          TextField(
            controller: contentController,
            maxLength: 256,
            minLines: 4,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'Content',
            ),
          ),
          ElevatedButton(
            onPressed: updateOrAdd,
            child: Text(buttonText),
          )
        ],
      ),
    );
  }

  void updateOrAdd() {
    if (widget.todo == null) {
      addTodo();
    } else {
      updateTodo();
    }
  }

  Future<void> addTodo() async {
    final title = titleController.text;
    final content = contentController.text;
    if (title.isEmpty) {
      const snackBar = SnackBar(content: Text('Title is required'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (content.isEmpty) {
      const snackBar = SnackBar(content: Text('Content is required'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    final status = await todoService.addTodo(title: title, content: content);
    if (status) {
      titleController.text = '';
      contentController.text = '';
      const snackBar = SnackBar(content: Text('Todo Added Successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = SnackBar(content: Text('Something went wrong'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> updateTodo() async {
    final title = titleController.text;
    final content = contentController.text;
    if (title.isEmpty) {
      const snackBar = SnackBar(content: Text('Title is required'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (content.isEmpty) {
      const snackBar = SnackBar(content: Text('Content is required'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    final todo = widget.todo;
    if (todo == null) return;
    final id = todo.id;
    final completed = todo.completed;
    final status = await todoService.updateTodo(
      id: id,
      title: title,
      content: content,
      completed: completed,
    );
    if (status) {
      Navigator.pop(context);
      const snackBar = SnackBar(content: Text('Todo Update Successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = SnackBar(content: Text('Something went wrong'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
