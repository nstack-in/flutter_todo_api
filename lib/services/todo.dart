import 'package:flutter_todo_api/model/todo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoServices {
  final String baseUrl = 'http://localhost:8080';

  Future<List<Todo>?> fetchTodo() async {
    final uri = baseUrl + '/todo';
    final url = Uri.parse(uri);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final stringResponse = response.body;
      final jsonResponse = json.decode(stringResponse);
      final data = jsonResponse['data'] as List<dynamic>;
      final todos = data.map((e) => Todo.fromJson(e)).toList();
      return todos;
    } else {
      return null;
    }
  }

  Future<bool> addTodo({
    required String title,
    required String content,
  }) async {
    final uri = baseUrl + '/todo/create';
    final url = Uri.parse(uri);
    final headers = {'Content-Type': 'application/json'};
    final body = {'title': title, 'content': content};
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteTodo({required String id}) async {
    final uri = baseUrl + '/todo/' + id;
    final url = Uri.parse(uri);
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateTodo({
    required String id,
    required String title,
    required String content,
    required bool completed,
  }) async {
    final uri = baseUrl + '/todo/' + id;
    final url = Uri.parse(uri);
    final headers = {'Content-Type': 'application/json'};
    final body = {
      'title': title,
      'content': content,
      'completed': completed,
    };
    final response = await http.put(
      url,
      headers: headers,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
