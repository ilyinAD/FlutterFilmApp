import 'package:flutter/material.dart';

import '../../internal/dependencies/tracked_film_repository_module.dart';
import '../widgets/film_button.dart';

class TrackedListOfFilms extends StatefulWidget {
  const TrackedListOfFilms({super.key});

  @override
  State<TrackedListOfFilms> createState() => _TrackedListOfFilmsState();
}

class _TrackedListOfFilmsState extends State<TrackedListOfFilms> {
  @override
  Widget build(BuildContext context) {
    //final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      body: ListView(
        children: TrackedFilmRepositoryModule.trackedFilmMapRepository()
            .films
            .entries
            .map((entry) {
          // print("OK");
          // print(entry.value.name);
          // print(entry.value.id.toString());
          return FilmButton(
            result: entry.value,
            isTracked: true,
          );
        }).toList(),
      ),
    );
  }
}
