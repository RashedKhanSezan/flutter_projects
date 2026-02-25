import 'package:get/get.dart';

import '../models/todomodel.dart';

class TodoController extends GetxController {
  final RxList<Todo> tasks = [
    Todo(id: '3', title: 'rashed', isChecked: true),
    Todo(id: '1', title: 'workout', isChecked: false),
    Todo(id: '2', title: 'ssd', isChecked: true)
  ].obs;

  void addTask(String title) {
    if (title.isNotEmpty) {
      tasks.add(
        Todo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
        ),
      );
    }
  }

  void deleteTask(Todo task) {
    tasks.remove(task);
  }

  void toggleTask(Todo task) {
    task.isChecked = !task.isChecked;
    tasks.refresh();
  }
}
