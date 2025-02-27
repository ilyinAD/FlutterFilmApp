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
  // Future<void> _saveData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String jsonString = jsonEncode(
  //       TrackedFilmRepositoryModule.trackedFilmMapRepository().films.map(
  //             (key, value) => MapEntry(key.toString(), value.toJson()),
  //           ));
  //   await prefs.setString('myMap', jsonString);
  // }
  //
  // Future<void> _loadData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? jsonString = prefs.getString('myMap');
  //   if (jsonString != null) {
  //     Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  //     setState(() {
  //       TrackedFilmRepositoryModule.trackedFilmMapRepository().films =
  //           jsonMap.map(
  //         (key, value) =>
  //             MapEntry(int.parse(key), FilmCardModel.fromJson(value)),
  //       );
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    //_loadData();
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
      //_saveData();
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
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),
      },
      //home: Placeholder(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget? _widget;

  void _checkIfLogged() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    //print("OK");
    if (!mounted) {
      return;
    }
    //print("OK1");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => id != null ? const HomePage() : const LoginPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkIfLogged();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
