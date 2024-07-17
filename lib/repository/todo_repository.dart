import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/todo.dart';
import '../objectbox.g.dart';

class TodoRepository {
  late final Store _store;
  late final Box<Todo> _todoBox;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _store =
        Store(getObjectBoxModel(), directory: '${directory.path}/objectbox');
    _todoBox = _store.box<Todo>();
  }

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse('https://api.example.com/todos'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> todoList = jsonResponse['data'];

      // Convert the JSON response to a list of Todo objects
      final todos = todoList.map((json) => Todo.fromJson(json)).toList();

      // Save the todos to local storage
      _todoBox.putMany(todos);

      return todos;
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo(Todo todo) async {
    _todoBox.put(todo);
  }

  Future<void> updateTodo(Todo todo) async {
    _todoBox.put(todo);
  }

  Future<void> deleteTodo(int id) async {
    _todoBox.remove(id);
  }

  Future<void> completeTodo(int id) async {
    final todo = _todoBox.get(id);
    if (todo != null) {
      todo.completed = true;
      _todoBox.put(todo);
    }
  }
}
