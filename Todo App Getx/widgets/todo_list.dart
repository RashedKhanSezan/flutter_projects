import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import 'todo_list_item.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.find<TodoController>();

   
    return Obx(() {
      if (controller.tasks.isEmpty) {
        return const Center(child: Text('No tasks yet! Add one below.'));
      }

      return ListView.builder(
        itemCount: controller.tasks.length,
        itemBuilder: (context, index) {
          final task = controller.tasks[index];
          return TodoListItem(task: task);
        },
      );
    });
  }
}
