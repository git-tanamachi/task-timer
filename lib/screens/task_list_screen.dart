import 'package:flutter/material.dart';
import 'package:task_timer/screens/settings_screen.dart';
import 'package:task_timer/screens/task_registration_screen.dart';
import 'package:task_timer/models/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [
    Task(
      name: 'Task 1',
      notificationTime: DateTime.now().add(const Duration(minutes: 5)),
      lastCompletionTime: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      name: 'Task 2',
      notificationTime: DateTime.now().add(const Duration(hours: 1)),
      lastCompletionTime: null,
    ),
  ];

  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmDeletion),
          content: Text(AppLocalizations.of(context)!.areYouSureDeleteTask),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks.removeAt(index);
                });
                Navigator.of(context).pop(true);
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.taskListTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Text(AppLocalizations.of(context)!.noTasksYet),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Dismissible(
                  key: Key(task.name), // Use a unique key for Dismissible
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.confirmDeletion),
                          content: Text(AppLocalizations.of(context)!.areYouSureDeleteTask),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(AppLocalizations.of(context)!.delete),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    _deleteTask(index);
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(task.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${AppLocalizations.of(context)!.notification}: ${task.notificationTime.toLocal()}'),
                          Text(
                              '${AppLocalizations.of(context)!.lastCompleted}: ${task.lastCompletionTime?.toLocal() ?? AppLocalizations.of(context)!.na}'),
                        ],
                      ),
                      onTap: () {
                        // Navigate to task update screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TaskRegistrationScreen()),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to task registration screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskRegistrationScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
