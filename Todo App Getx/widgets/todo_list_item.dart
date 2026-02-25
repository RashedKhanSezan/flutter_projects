import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_provider/controllers/todo_controller.dart';
import 'package:todo_app_provider/models/todomodel.dart';

class TodoListItem extends StatelessWidget {
  final Todo task;

  TodoListItem({
    required this.task,
    super.key,
  });
  final TodoController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isChecked,
        onChanged: (bool? value) {
          controller.toggleTask(task);
        },
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isChecked ? TextDecoration.lineThrough : null,
          color: task.isChecked ? Colors.grey : Colors.black,
        ),
      ),
      trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            controller.deleteTask(task);
          }),
    );
  }
}
