import 'package:chck_smth_in_flutter/data/api/service/backend_service.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/backend_repository_module.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../domain/model/user_model.dart';
import 'home_page.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  String? error;
  final logger = Logger();
  void _register(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final result = await BackendRepositoryModule.backendManager().register(
          _usernameController.text,
          _passwordController.text,
          _emailController.text);

      logger.i(
          "id: ${result.id} username: ${result.username} email: ${result.email}");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Регистрация успешна!')),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
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
              logger.i(401);
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

  void saveUser(UserModel user) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите логин';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Почта',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите email';
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}")
                      .hasMatch(value)) {
                    return 'Неверный формат email';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите пароль';
                  } else if (value.length < 8) {
                    return 'Пароль должен быть не менее 6 символов';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _register(context),
                child: const Text('Зарегистрироваться'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Уже есть аккаунт? Войдите'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
