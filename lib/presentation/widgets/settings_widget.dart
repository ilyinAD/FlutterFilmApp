import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int? id;
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  void loadID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id');
    });
  }

  @override
  void initState() {
    super.initState();
    loadID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Center(
              child: ElevatedButton(
            onPressed: () {
              _logout();
            },
            child: const Text("Выйти"),
          )),
          Text(id.toString()),
        ],
      ),
    );
  }
}
