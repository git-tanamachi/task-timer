import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum NotificationCycle {
  daily,
  weekly,
  monthly,
}

class TaskRegistrationScreen extends StatefulWidget {
  const TaskRegistrationScreen({super.key});

  @override
  State<TaskRegistrationScreen> createState() => _TaskRegistrationScreenState();
}

class _TaskRegistrationScreenState extends State<TaskRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  NotificationCycle _selectedCycle = NotificationCycle.daily;
  TimeOfDay _notificationTime = TimeOfDay.now();
  List<bool> _selectedWeekdays = List.generate(7, (index) => false); // Mon to Sun
  List<bool> _selectedMonthDays = List.generate(31, (index) => false); // 1 to 31

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.taskRegistrationTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _taskNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.taskName,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.pleaseEnterTaskName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.description,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: Text(AppLocalizations.of(context)!.notificationCycle),
                trailing: DropdownButton<NotificationCycle>(
                  value: _selectedCycle,
                  onChanged: (NotificationCycle? newValue) {
                    setState(() {
                      _selectedCycle = newValue!;
                    });
                  },
                  items: <DropdownMenuItem<NotificationCycle>>[
                    DropdownMenuItem(
                      value: NotificationCycle.daily,
                      child: Text(AppLocalizations.of(context)!.daily),
                    ),
                    DropdownMenuItem(
                      value: NotificationCycle.weekly,
                      child: Text(AppLocalizations.of(context)!.weekly),
                    ),
                    DropdownMenuItem(
                      value: NotificationCycle.monthly,
                      child: Text(AppLocalizations.of(context)!.monthly),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              _buildNotificationTimingInput(),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process data
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.processingData)),
                    );
                    // For now, just pop the screen
                    Navigator.pop(context);
                  }
                },
                child: Text(AppLocalizations.of(context)!.saveTask),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTimingInput() {
    switch (_selectedCycle) {
      case NotificationCycle.daily:
        return ListTile(
          title: Text(AppLocalizations.of(context)!.notificationTime),
          trailing: TextButton(
            onPressed: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: _notificationTime,
              );
              if (picked != null && picked != _notificationTime) {
                setState(() {
                  _notificationTime = picked;
                });
              }
            },
            child: Text(_notificationTime.format(context)),
          ),
        );
      case NotificationCycle.weekly:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.selectWeekdays, style: const TextStyle(fontSize: 16)),
            Wrap(
              spacing: 8.0,
              children: List.generate(7, (index) {
                final weekdayNames = [
                  AppLocalizations.of(context)!.mon,
                  AppLocalizations.of(context)!.tue,
                  AppLocalizations.of(context)!.wed,
                  AppLocalizations.of(context)!.thu,
                  AppLocalizations.of(context)!.fri,
                  AppLocalizations.of(context)!.sat,
                  AppLocalizations.of(context)!.sun,
                ];
                return ChoiceChip(
                  label: Text(weekdayNames[index]),
                  selected: _selectedWeekdays[index],
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedWeekdays[index] = selected;
                    });
                  },
                );
              }),
            ),
          ],
        );
      case NotificationCycle.monthly:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.selectDaysOfMonth, style: const TextStyle(fontSize: 16)),
            Wrap(
              spacing: 8.0,
              children: List.generate(31, (index) {
                return ChoiceChip(
                  label: Text((index + 1).toString()),
                  selected: _selectedMonthDays[index],
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedMonthDays[index] = selected;
                    });
                  },
                );
              }),
            ),
          ],
        );
    }
  }
}
