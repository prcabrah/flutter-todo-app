import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/widgets/controller.dart';

class TodosList extends StatelessWidget {
  const TodosList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Controller>();

    return Obx(() => ListView.builder(
          itemCount: controller.todos.length,
          itemBuilder: (context, index) {
            final todo = controller.todos[index];
            return ListTile(
              leading: Checkbox(
                value: todo.completed,
                onChanged: (value) {
                  controller.updateTodoStatus(todo);
                },
              ),
              title: Text(
                todo.title,
                style: TextStyle(
                  decoration: todo.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  controller.deleteTodo(todo.id);
                },
              ),
            );
          },
        ));
  }
}