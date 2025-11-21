import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  final uuid = const Uuid();

  String? _selectedCategoryFilter; 

  List<Task> get tasks {
    final sortedTasks = List<Task>.from(_tasks);
    sortedTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));

 
    if (_selectedCategoryFilter == null) {
      return List.unmodifiable(sortedTasks);
    } else {
      return List.unmodifiable(sortedTasks
          .where((task) => task.category == _selectedCategoryFilter)
          .toList());
    }
  }


  void setCategoryFilter(String? category) {
    if (_selectedCategoryFilter == category) {
      _selectedCategoryFilter = null;
    } else {
      _selectedCategoryFilter = category;
    }
    notifyListeners();
  }

  String? get selectedCategoryFilter => _selectedCategoryFilter;

  void addTask(String title, String description, DateTime dateTime, String category) {
    _tasks.add(
      Task(
        id: uuid.v4(),
        title: title,
        description: description,
        dateTime: dateTime,
        category: category,
        isCompleted: false,
      ),
    );
    notifyListeners();
  }


  void updateTask(String id, String title, String description, DateTime dateTime, String category) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      final existingTask = _tasks[index];
      _tasks[index] = Task(
        id: id,
        title: title,
        description: description,
        dateTime: dateTime,
        category: category,
        isCompleted: existingTask.isCompleted,
      );
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  void toggleTask(String id) {
    final task = getTaskById(id);
    if (task != null) {
      task.toggleCompleted();
      notifyListeners();
    }
  }
  
    if (oldIndex < 0 || oldIndex >= _tasks.length) return;
    if (newIndex < 0) newIndex = 0;
    if (newIndex > _tasks.length) newIndex = _tasks.length;
    final task = _tasks.removeAt(oldIndex);
    if (newIndex > oldIndex) newIndex -= 1;
    _tasks.insert(newIndex, task);
    notifyListeners();
  
  }

  void sortByDateAscending() {
    _tasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
  }

  void sortByDateDescending() {
    _tasks.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    notifyListeners();
  }

  void sortByTitleAscending() {
    _tasks.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    notifyListeners();
  }

  void sortByTitleDescending() {
    _tasks.sort((a, b) => b.title.toLowerCase().compareTo(b.title.toLowerCase()));
    notifyListeners();
  }

  List<Task> tasksForToday() {
    final now = DateTime.now();
    return _tasks.where((t) =>
      t.dateTime.year == now.year &&
      t.dateTime.month == now.month &&
      t.dateTime.day == now.day
    ).toList();
  }

  List<Task> completedTasks() {
    return _tasks.where((t) => t.isCompleted).toList();
  }
}
