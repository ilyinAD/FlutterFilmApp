import 'dart:convert';

import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:chck_smth_in_flutter/domain/model/seasons_list_model.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/season_list_module.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/tracked_film_repository_module.dart';
import 'package:chck_smth_in_flutter/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // late SeasonsListModel seasonsListModel;
  //
  // void f() async {
  //   seasonsListModel = await SeasonListModule.seasonListRepository()
  //       .getSeasonList(seriesId: 169);
  //   print(seasonsListModel.seasons);
  // }

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
      home: HomePage(),
      // home: Column(
      //   children: [
      //     ElevatedButton(
      //         onPressed: () {
      //           f();
      //         },
      //         child: Container()),
      //   ],
      // ),
    );
  }
}
