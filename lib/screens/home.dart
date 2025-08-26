import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/widgets/controller.dart'; 
import 'package:todo_app/widgets/todo_list.dart'; 

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller to access the todos from the API.
    final Controller controller = Get.put(Controller());

    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO App'),
        actions: [
          // Show a saving indicator when the controller is saving.
          Obx(() {
            if (controller.isSaving.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Saving...'),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const CupertinoActivityIndicator();
            } else {
              return const TodosList();
            }
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Show a dialog to add a new todo.
        onPressed: () => Get.defaultDialog(
          titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          contentPadding: const EdgeInsets.all(16),
          title: 'Add Todo',
          content: TextField(
            // Connect the text field to the controller
            controller: controller.titleController,
            decoration: const InputDecoration(
              labelText: 'Todo',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Create a new todo when the user taps the 'Add' button.
                controller.createTodo();
              },
              child: const Text('Add'),
            ),
          ],
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
