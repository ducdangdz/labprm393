import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  group('Task Integration Tests (End-to-End Flow)', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    testWidgets(
        'Full flow: Add "Original title" -> Tap task to open detail -> Edit to "Updated title" -> Save -> Verify in list',
        (WidgetTester tester) async {
      // 1. Arrange & Pump App
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      // Verify empty state initially
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);

      // 2. Add "Original title"
      final inputFinder = find.byKey(const Key('taskInputField'));
      final addButtonFinder = find.byKey(const Key('addTaskButton'));

      await tester.enterText(inputFinder, 'Original title');
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Verify "Original title" appears in the list
      expect(find.text('Original title'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);

      // 3. Tap task -> open detail
      await tester.tap(find.text('Original title'));
      await tester.pumpAndSettle();

      // Verify TaskDetailScreen is opened
      expect(find.text('Task Detail'), findsOneWidget);
      final detailFieldFinder = find.byKey(const Key('detailTitleField'));
      expect(detailFieldFinder, findsOneWidget);

      // 4. Edit -> "Updated title"
      await tester.enterText(detailFieldFinder, 'Updated title');
      await tester.pump();

      // 5. Save
      final saveButtonFinder = find.byKey(const Key('saveTaskButton'));
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();

      // 6. Verify updated title appears in list
      expect(find.text('Updated title'), findsOneWidget);
      expect(find.text('Original title'), findsNothing);
      expect(repository.tasks.first.title, 'Updated title');
    });
  });
}
