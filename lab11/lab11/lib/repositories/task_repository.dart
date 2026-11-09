import '../models/task.dart';

class TaskRepository {
  final List<Task> _tasks;

  TaskRepository({List<Task>? initialTasks})
      : _tasks = initialTasks != null ? List<Task>.from(initialTasks) : [];

  /// Returns an unmodifiable view of all tasks in the repository.
  List<Task> get tasks => List.unmodifiable(_tasks);

  /// Adds a new task to the repository.
  void addTask(Task task) {
    _tasks.add(task);
  }

  /// Deletes a task by its unique ID.
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
  }

  /// Updates an existing task matching the task's ID.
  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }
  }

  /// Finds a task by its ID, returns null if not found.
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Clears all tasks from the repository.
  void clear() {
    _tasks.clear();
  }
}
