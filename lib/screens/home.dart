import 'package:flutter/material.dart';
import 'package:flutter_todo_api/model/todo.dart';
import 'package:flutter_todo_api/screens/add.dart';
import 'package:flutter_todo_api/services/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todoService = TodoServices();
  List<Todo>? todos;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: fetchTodo,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateAddScreen,
        child: const Icon(Icons.add),
      ),
      body: Visibility(
        visible: todos != null,
        child: Visibility(
          visible: todos?.isNotEmpty ?? false,
          child: ListView.builder(
            itemBuilder: (_, i) {
              final todo = todos![i];
              return _buildTodoItem(todo);
            },
            itemCount: todos?.length,
          ),
          replacement: Center(
            child: Text(
              'No Todo task to show',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildTodoItem(Todo todo) {
    return ListTile(
      leading: IconButton(
        onPressed: () => toggleTaskCompleteion(todo),
        icon: Icon(
          todo.completed ? Icons.check_box : Icons.check_box_outline_blank,
          color: todo.completed ? Colors.blue : Colors.grey,
        ),
      ),
      title: Text(todo.title),
      subtitle: Text(todo.content),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ];
        },
        onSelected: (String value) {
          popUpAction(value, todo);
        },
      ),
    );
  }

  Future<void> toggleTaskCompleteion(Todo todo) async {
    final status = await todoService.updateTodo(
      id: todo.id,
      completed: !todo.completed,
      content: todo.content,
      title: todo.title,
    );
    if (status) {
      fetchTodo();
    } else {
      final snackBar = SnackBar(content: Text('Mark Task ${todo.title}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> popUpAction(String option, Todo todo) async {
    if (option == 'delete') {
      final status = await todoService.deleteTodo(id: todo.id);
      if (status) {
        fetchTodo();
      } else {
        final snackBar = SnackBar(content: Text('Delete failed ${todo.title}'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else if (option == 'edit') {
      navigateAddScreen(todo: todo);
    } else {
      final snackBar = SnackBar(content: Text('$option Not Implemented'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchTodo() async {
    setState(() {
      todos = null;
    });
    final result = await todoService.fetchTodo();
    if (result != null) {
      setState(() {
        todos = result;
      });
    } else {
      const snackBar = SnackBar(content: Text('Something went wrong'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> navigateAddScreen({Todo? todo}) async {
    final route = MaterialPageRoute(builder: (_) => AddPage(todo: todo));
    await Navigator.push(context, route);
    fetchTodo();
  }
}
