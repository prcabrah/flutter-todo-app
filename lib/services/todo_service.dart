import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/todo.dart';

class TodoService {
  static const String baseUrl = "https://jsonplaceholder.typicode.com/todos";

  // Define common headers to be used in all requests
  static const Map<String, String> _headers = {
    "Content-Type": "application/json",
    // This header makes our request look like it's from a browser
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36'
  };

  static Future<List<Todo>> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl), headers: _headers);
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load todos with status code: ${response.statusCode}");
      }
    } catch (e) {
      // print("THE REAL ERROR in fetchTodos IS: $e");
      throw Exception("Failed to load todos");
    }
  }

  static Future<Todo> createTodo(String title) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: _headers,
      body: jsonEncode({"title": title, "completed": false, "userId": 1}),
    );

    if (response.statusCode == 201) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create todo");
    }
  }

  static Future<Todo> updateTodoStatus(Todo todo) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${todo.id}"),
      headers: _headers,
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update todo");
    }
  }

  static Future<void> deleteTodo(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to delete todo");
    }
  }
}
