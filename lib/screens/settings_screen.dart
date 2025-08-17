import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _snoozeEnabled = true;
  int _snoozeCount = 3;
  int _snoozeInterval = 5; // minutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Enable Snooze'),
            value: _snoozeEnabled,
            onChanged: (bool value) {
              setState(() {
                _snoozeEnabled = value;
              });
            },
          ),
          if (_snoozeEnabled)
            Column(
              children: [
                ListTile(
                  title: const Text('Snooze Count'),
                  trailing: SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      controller: TextEditingController(text: _snoozeCount.toString()),
                      onChanged: (value) {
                        setState(() {
                          _snoozeCount = int.tryParse(value) ?? _snoozeCount;
                        });
                      },
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Snooze Interval (minutes)'),
                  trailing: SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      controller: TextEditingController(text: _snoozeInterval.toString()),
                      onChanged: (value) {
                        setState(() {
                          _snoozeInterval = int.tryParse(value) ?? _snoozeInterval;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
