# Taskly — Flutter Lab 11: Testing & Debugging

A Flutter task management application built to demonstrate comprehensive testing (Unit, Widget, Navigation, and Integration testing) and Flutter DevTools profiling.

## Project Structure
```
lab11/
 ├─ lib/
 │   ├─ models/
 │   │   └─ task.dart                 # Task entity model with toggle() & copyWith()
 │   ├─ repositories/
 │   │   └─ task_repository.dart      # TaskRepository with CRUD operations
 │   ├─ screens/
 │   │   ├─ task_list_screen.dart     # Primary task list UI & input controls
 │   │   └─ task_detail_screen.dart   # Detail screen with edit and save
 │   └─ main.dart                     # TasklyApp entrypoint
 ├─ test/
 │   ├─ unit/
 │   │   ├─ task_model_test.dart      # LAB 11.1: Unit tests for Task model
 │   │   └─ task_repository_test.dart # LAB 11.1: Unit tests for TaskRepository
 │   ├─ widget/
 │   │   ├─ task_list_widget_test.dart # LAB 11.2: Widget tests for TaskListScreen
 │   │   ├─ task_navigation_test.dart  # LAB 11.3: Navigation tests (List -> Detail)
 │   │   └─ task_integration_test.dart # LAB 11.4: End-to-end integration test
 │   └─ integration/
 │       └─ task_integration_test.dart # LAB 11.5: Consolidated integration suite
 ├─ screenshots/
 │   ├─ widget_inspector.png          # LAB 11.4 Part B: Widget Tree Screenshot
 │   └─ performance_timeline.png      # LAB 11.4 Part B: Performance Timeline Screenshot
 └─ reports/
     ├─ debugging_report.pdf          # LAB 11.4 Part B: DevTools Debugging Report
     ├─ debugging_report.docx
     ├─ test_summary.pdf              # LAB 11.5: Test Suite Summary Report
     └─ test_summary.docx
```

## Running Tests
Run all tests:
```bash
flutter test
```

Run tests with expanded detailed output:
```bash
flutter test --reporter=expanded
```

Run specific test categories:
```bash
flutter test test/unit
flutter test test/widget
flutter test test/integration
```

Analyze code quality:
```bash
flutter analyze
```

## Packaging Submission ZIP
From the parent folder `D:\PRM\PRMLAB\lab11`:
```powershell
.\package_submission.ps1 -StudentID "<YourStudentID>" -FullName "<YourFullName>"
```
Example:
```powershell
.\package_submission.ps1 -StudentID "SE181234" -FullName "DangHuynhDuc"
```
Output:
`Module11_Testing_SE181234_DangHuynhDuc.zip`
