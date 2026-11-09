import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/task.dart';

/// Provider managing the Task state for Taskly with high performance.
class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks;

  TaskProvider({List<Task>? initialTasks})
      : _tasks = initialTasks ??
            [
              Task(id: '1', title: 'Học Flutter Unit & Widget Testing'),
              Task(id: '2', title: 'Thực hành DevTools Widget Inspector'),
              Task(id: '3', title: 'Tối ưu hóa List Rebuild & Selector'),
              Task(id: '4', title: 'Tối ưu hóa hình ảnh & precacheImage'),
              Task(id: '5', title: 'Phân tích kích thước APK (App Size)'),
            ];

  /// Unmodifiable view of the tasks list to avoid accidental external mutation.
  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  int get taskCount => _tasks.length;

  int get completedCount => _tasks.where((t) => t.completed).length;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(completed: !_tasks[index].completed);
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks.removeAt(index);
      notifyListeners();
    }
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void clear() {
    _tasks.clear();
    notifyListeners();
  }
}
