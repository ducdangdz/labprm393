import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  group('TaskListScreen Widget Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: TaskListScreen(repository: repository),
      );
    }

    testWidgets('Empty State: displays "No tasks yet. Add one!" when list is empty',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('Add Task: enter text -> tap add -> verify UI updates',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);

      // Act: Enter text into input field
      final inputFinder = find.byKey(const Key('taskInputField'));
      await tester.enterText(inputFinder, 'Read Flutter documentation');

      // Act: Tap Add button
      final addButtonFinder = find.byKey(const Key('addTaskButton'));
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Assert: Verify UI updates with new task
      expect(find.text('Read Flutter documentation'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('Multiple Tasks: add two tasks -> verify both visible',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());
      final inputFinder = find.byKey(const Key('taskInputField'));
      final addButtonFinder = find.byKey(const Key('addTaskButton'));

      // Act: Add first task
      await tester.enterText(inputFinder, 'First Task');
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Act: Add second task
      await tester.enterText(inputFinder, 'Second Task');
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Assert: Verify both tasks are rendered
      expect(find.text('First Task'), findsOneWidget);
      expect(find.text('Second Task'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('No tasks yet. Add one!'), findsNothing);
    });
  });
}
