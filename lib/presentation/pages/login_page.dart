import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await f(_usernameController.text, _passwordController.text);
    if (result == false) {
      return;
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вход успешен!')),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  Dio dio = Dio();

  final logger = Logger();

  Future<bool> f(String username, String password) async {
    final data = {
      'username': username,
      'password': password,
    };
    logger.i("post query $username and $password");
    final result = await dio.post(
      'http://192.168.1.55:8080/login\n?Content-Type%09=application/json%0A',
      data: data,
      //options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (result.statusCode != 200) {
      logger.w("status code is${result.statusCode}");
      return false;
    }

    if (result.data["error"] != null) {
      logger.i("error:${result.data["error"]}");
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вход'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Логин',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _login(context),
                child: const Text('Войти'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/registration');
                },
                child: const Text('Еще нет аккаунта? Зарегистрируйтесь'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
