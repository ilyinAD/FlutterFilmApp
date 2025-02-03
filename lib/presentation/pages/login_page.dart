import 'dart:convert';

import 'package:chck_smth_in_flutter/internal/dependencies/backend_repository_module.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final logger = Logger();

  void _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final result = await BackendRepositoryModule.backendManager()
          .login(_usernameController.text, _passwordController.text);

      logger.i(
          "id: ${result.id} username: ${result.username} email: ${result.email}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Вход успешен!')),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String jsonString = jsonEncode(result.toJson());
      // await prefs.setString('user', jsonString);
    } on DioException catch (e) {
      if (mounted) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          final errorMessage =
              e.response!.data['error'] ?? 'Неизвестная ошибка';
          switch (statusCode) {
            case 400:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка: $errorMessage')),
              );
              break;
            case 401:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$errorMessage')),
              );
              break;
            case 500:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка сети')),
              );
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка: $errorMessage')),
              );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка сети: $e')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Неизвестная ошибка: $e')),
      );
    }
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
