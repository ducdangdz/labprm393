import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';

void main() {
  group('TaskRepository Unit Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('addTask() should add a new task to repository', () {
      // Arrange
      final task = Task(id: 'task-101', title: 'Write unit tests');

      // Act
      repository.addTask(task);

      // Assert
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.id, 'task-101');
      expect(repository.tasks.first.title, 'Write unit tests');
      expect(repository.getTaskById('task-101'), equals(task));
    });

    test('deleteTask() should remove task from repository by id', () {
      // Arrange
      final task1 = Task(id: 'task-101', title: 'Task to keep');
      final task2 = Task(id: 'task-102', title: 'Task to delete');
      repository.addTask(task1);
      repository.addTask(task2);
      expect(repository.tasks.length, 2);

      // Act
      repository.deleteTask('task-102');

      // Assert
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.id, 'task-101');
      expect(repository.getTaskById('task-102'), isNull);
    });

    test('updateTask() should update an existing task in repository', () {
      // Arrange
      final initialTask = Task(id: 'task-101', title: 'Initial Title', completed: false);
      repository.addTask(initialTask);

      final updatedTask = Task(id: 'task-101', title: 'Updated Title', completed: true);

      // Act
      repository.updateTask(updatedTask);

      // Assert
      expect(repository.tasks.length, 1);
      final retrieved = repository.getTaskById('task-101');
      expect(retrieved, isNotNull);
      expect(retrieved!.title, 'Updated Title');
      expect(retrieved.completed, isTrue);
    });

    test('clear() should remove all tasks from repository', () {
      // Arrange
      repository.addTask(Task(id: '1', title: 'Task 1'));
      repository.addTask(Task(id: '2', title: 'Task 2'));
      expect(repository.tasks.length, 2);

      // Act
      repository.clear();

      // Assert
      expect(repository.tasks, isEmpty);
    });
  });
}
