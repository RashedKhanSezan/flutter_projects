import 'package:flutter/material.dart';
import '../controllers/todo_controller.dart';
import '../widgets/todo_list.dart';
import '../widgets/add_task_dialog.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TodoController controller = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    // final taskCount = context.watch<TodoProvider>().allTasks.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Obx(
          () => Text('My To-Do Task ${controller.tasks.length}'),
        ),
      ),
      body: const TodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.dialog(AddTaskDialog()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
