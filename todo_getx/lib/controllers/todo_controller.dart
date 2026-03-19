import 'package:get/get.dart';
import 'package:todo_getx/models/todo.dart';

class TodoController extends GetxController {
  RxList<Todo> myTask = [
    Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'workout',
        isChecked: true),
    Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Shopping',
        isChecked: false),
  ].obs;

  void saveTask(String taskName) {
    myTask.add(
      Todo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: taskName),
    );
  }

  void deleteTask(String taskID) {
    myTask.removeWhere((aTask) => aTask.id == taskID);
  }

  void taskDone(Todo obj) {
    obj.isChecked;
  }
}
