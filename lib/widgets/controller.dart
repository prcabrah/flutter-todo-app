import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';

class Controller extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final RxList<Todo> todos = <Todo>[].obs;

  // Set isLoading to true initially because we will be fetching data.
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    // THIS IS THE CHANGE: We call fetchTodos() when the app starts.
    fetchTodos();
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  Future<void> fetchTodos() async {
    try {
      // Ensure isLoading is true at the start.
      isLoading.value = true;
      var fetchedTodos = await TodoService.fetchTodos();
      todos.assignAll(fetchedTodos);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch todos: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      // Set isLoading to false after fetching is complete (or fails).
      isLoading.value = false;
    }
  }

  Future<void> createTodo() async {
    if (titleController.text.isEmpty) {
      Get.snackbar('Error', 'Title cannot be empty');
      return;
    }
    isSaving.value = true;
    try {
      await TodoService.createTodo(titleController.text);
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: 1,
        title: titleController.text,
        completed: false,
      );
      todos.insert(0, newTodo);
      titleController.clear();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create todo');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateTodoStatus(Todo todo) async {
    isSaving.value = true;
    try {
      final index = todos.indexWhere((item) => item.id == todo.id);
      if (index != -1) {
        final updatedTodo = Todo(
          id: todo.id,
          userId: todo.userId,
          title: todo.title,
          completed: !todo.completed,
        );
        todos[index] = updatedTodo;
        if (updatedTodo.id is int) {
          await TodoService.updateTodoStatus(updatedTodo);
        }
      }
    } catch (e) {
      // Get.snackbar('Error', 'An unexpected error occurred during update');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteTodo(dynamic id) async {
    isSaving.value = true;
    try {
      todos.removeWhere((item) => item.id == id);
      if (id is int) {
        await TodoService.deleteTodo(id);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete todo');
    } finally {
      isSaving.value = false;
    }
  }
}