import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';

void main() {
  group('Task Model Unit Tests', () {
    test('Default completed value should be false', () {
      // Arrange & Act
      final task = Task(id: 'task-1', title: 'Complete Lab 11');

      // Assert
      expect(task.completed, isFalse);
      expect(task.isCompleted, isFalse);
    });

    test('toggle() switches completed status true <-> false', () {
      // Arrange
      final task = Task(id: 'task-1', title: 'Complete Lab 11');
      expect(task.completed, isFalse);

      // Act 1: toggle once (false -> true)
      task.toggle();

      // Assert 1
      expect(task.completed, isTrue);

      // Act 2: toggle again (true -> false)
      task.toggle();

      // Assert 2
      expect(task.completed, isFalse);
    });

    test('copyWith() returns a updated task instance without mutating original', () {
      // Arrange
      final originalTask = Task(id: 'task-1', title: 'Original Title', completed: false);

      // Act
      final updatedTask = originalTask.copyWith(
        title: 'Updated Title',
        completed: true,
      );

      // Assert
      expect(updatedTask.id, 'task-1');
      expect(updatedTask.title, 'Updated Title');
      expect(updatedTask.completed, isTrue);
      expect(originalTask.title, 'Original Title');
      expect(originalTask.completed, isFalse);
    });
  });
}
