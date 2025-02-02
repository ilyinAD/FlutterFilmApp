import 'dart:convert';

import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/tracked_film_repository_module.dart';
import 'package:chck_smth_in_flutter/presentation/pages/home_page.dart';
import 'package:chck_smth_in_flutter/presentation/pages/login_page.dart';
import 'package:chck_smth_in_flutter/presentation/pages/registration_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // final logger = Logger();
  //
  // logger.v('Verbose message');
  // logger.d('Debug message');
  // logger.i("Info message");
  // logger.w("Warning message");
  // logger.e("Error message");
  // logger.wtf("What a terrible failure message");
  // logger.t("Trace log");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(
        TrackedFilmRepositoryModule.trackedFilmMapRepository().films.map(
              (key, value) => MapEntry(key.toString(), value.toJson()),
            ));
    await prefs.setString('myMap', jsonString);
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('myMap');
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      setState(() {
        TrackedFilmRepositoryModule.trackedFilmMapRepository().films =
            jsonMap.map(
          (key, value) =>
              MapEntry(int.parse(key), FilmCardModel.fromJson(value)),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _saveData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: HomePage(),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/registration': (context) => RegistrationPage(),
      },
    );
  }
}

// class RegistrationPage extends StatefulWidget {
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }
//
// class _RegistrationPageState extends State<RegistrationPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   Dio dio = Dio();
//   final logger = Logger();
//   Future<bool> f(String username, String password) async {
//     final data = {
//       'username': username,
//       'password': password,
//     };
//     logger.i("post query $username and $password");
//     final result = await dio.post(
//       'http://192.168.1.55:8080/register\n?Content-Type%09=application/json%0A',
//       data: data,
//       //options: Options(headers: {'Content-Type': 'application/json'}),
//     );
//
//     if (result.statusCode != 200) {
//       logger.w("status code is${result.statusCode}");
//       return false;
//     }
//
//     if (result.data["error"] != null) {
//       logger.i("error:${result.data["error"]}");
//       return false;
//     }
//
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Регистрация')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(labelText: 'Логин'),
//                 //keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Введите логин';
//                   }
//                   // else if (!RegExp(
//                   //         r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}")
//                   //     .hasMatch(value)) {
//                   //   return 'Неверный формат email';
//                   // }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'Пароль'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Введите пароль';
//                   } else if (value.length < 6) {
//                     return 'Пароль должен быть не менее 6 символов';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20.0),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (!_formKey.currentState!.validate()) {
//                     return;
//                   }
//                   final result = await f(
//                       _usernameController.text, _passwordController.text);
//                   if (result == false) {
//                     return;
//                   }
//                   if (mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Регистрация успешна!')),
//                     );
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const HomePage()));
//                   }
//                 },
//                 child: const Text('Зарегистрироваться'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
