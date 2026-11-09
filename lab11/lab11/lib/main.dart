import 'package:flutter/material.dart';
import 'models/task.dart';
import 'repositories/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  // Khởi tạo sẵn một số task mẫu khi chạy ứng dụng thực tế
  final initialRepository = TaskRepository(
    initialTasks: [
      Task(id: '1', title: 'Học Flutter Unit & Widget Testing'),
      Task(id: '2', title: 'Thực hành DevTools Widget Inspector'),
      Task(id: '3', title: 'Hoàn thành báo cáo Lab 11'),
    ],
  );

  runApp(TasklyApp(repository: initialRepository));
}

class TasklyApp extends StatelessWidget {
  final TaskRepository? repository;

  const TasklyApp({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: TaskListScreen(repository: repository),
    );
  }
}
