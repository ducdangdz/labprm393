import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  group('Task Navigation Tests (Task List -> Task Detail)', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    testWidgets(
        'Tapping seeded task navigates to TaskDetailScreen with expected AppBar and TextField key',
        (WidgetTester tester) async {
      // 1. Seed repository with at least one task
      final seededTask = Task(
        id: 'task-nav-1',
        title: 'Prepare for Presentation',
      );
      repository.addTask(seededTask);

      // 2. Pump TaskListScreen
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      // Verify the task appears on TaskListScreen
      expect(find.text('Prepare for Presentation'), findsOneWidget);

      // 3. Tap seeded task -> call pumpAndSettle()
      await tester.tap(find.text('Prepare for Presentation'));
      await tester.pumpAndSettle();

      // 4. Validate:
      // - AppBar title: “Task Detail”
      expect(find.text('Task Detail'), findsOneWidget);

      // - TextField key: detailTitleField
      final detailTextFieldFinder = find.byKey(const Key('detailTitleField'));
      expect(detailTextFieldFinder, findsOneWidget);

      // Verify TextField has the seeded title as initial value
      final textField = tester.widget<TextField>(detailTextFieldFinder);
      expect(textField.controller?.text, 'Prepare for Presentation');
    });
  });
}
