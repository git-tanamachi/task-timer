import 'package:flutter/material.dart';

class TaskRegistrationScreen extends StatelessWidget {
  const TaskRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Registration'),
      ),
      body: const Center(
        child: Text('This is the Task Registration Screen'),
      ),
    );
  }
}
