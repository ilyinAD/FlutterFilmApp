import 'package:chck_smth_in_flutter/internal/dependencies/user_repository_module.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/model/user_model.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int? id;
  Logger logger = Logger();
  bool isLoading = true;
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  UserModel? userInfo = null;
  void loadInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id');
    });
    if (id == null) {
      logger.e("no id in sharedPref");
      return;
    }
    userInfo = await UserRepositoryModule.userRepositoryModule().getUser(id!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == false
        ? Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Login',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(userInfo!.username,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text('Email',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(userInfo!.email, style: const TextStyle(fontSize: 16)),
                  const Spacer(),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            child: Text("hx"),
          );
  }
}
