import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../screens/task_detail_screen.dart';

/// An optimized, standalone widget displaying an individual task item.
/// Uses [ValueKey] for proper element recycling and minimal rebuilds.
class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({
    required ValueKey<String> super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    // Read provider without subscribing to unnecessary rebuilds
    final provider = context.read<TaskProvider>();

    return ListTile(
      leading: Checkbox(
        value: task.completed,
        onChanged: (_) => provider.toggleTask(task.id),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.completed
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: task.completed ? Colors.grey : Colors.black87,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.redAccent),
        tooltip: 'Delete Task',
        onPressed: () => provider.deleteTask(task.id),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskDetailScreen(task: task),
          ),
        );
      },
    );
  }
}
