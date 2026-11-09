import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository repository;

  TaskListScreen({super.key, TaskRepository? repository})
      : repository = repository ?? TaskRepository();

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskInputController = TextEditingController();

  @override
  void dispose() {
    _taskInputController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _taskInputController.text.trim();
    if (title.isEmpty) return;

    final newTask = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
    );

    setState(() {
      widget.repository.addTask(newTask);
      _taskInputController.clear();
    });
  }

  void _deleteTask(String id) {
    setState(() {
      widget.repository.deleteTask(id);
    });
  }

  void _toggleTask(Task task) {
    setState(() {
      task.toggle();
    });
  }

  Future<void> _openDetail(Task task) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          repository: widget.repository,
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.repository.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('taskInputField'),
                    controller: _taskInputController,
                    decoration: const InputDecoration(
                      labelText: 'Task title',
                      hintText: 'Enter task title',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  key: const Key('addTaskButton'),
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text('No tasks yet. Add one!'),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        key: Key('taskTile_${task.id}'),
                        leading: Checkbox(
                          value: task.completed,
                          onChanged: (_) => _toggleTask(task),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteTask(task.id),
                        ),
                        onTap: () => _openDetail(task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
