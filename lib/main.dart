import 'package:chck_smth_in_flutter/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
