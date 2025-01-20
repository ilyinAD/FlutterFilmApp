import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/tracked_film_repository_module.dart';
import 'package:chck_smth_in_flutter/presentation/widgets/add_film_in_tracked_button.dart';
import 'package:chck_smth_in_flutter/presentation/widgets/film_info.dart';
import 'package:flutter/material.dart';

import '../pages/add_card_page.dart';

class TrackedFilmWidget extends StatefulWidget {
  final int id;
  const TrackedFilmWidget({super.key, required this.id});

  @override
  State<TrackedFilmWidget> createState() => _TrackedFilmWidgetState();
}

class _TrackedFilmWidgetState extends State<TrackedFilmWidget> {
  late FilmCardModel film;
  void doUpdate() {
    setState(() {
      film = TrackedFilmRepositoryModule.trackedFilmMapRepository()
          .films[widget.id]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    film = TrackedFilmRepositoryModule.trackedFilmMapRepository()
        .films[widget.id]!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        if (context.mounted) {
          Navigator.pop(context, film);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Информация о фильме'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilmInfo.fromFilmCardModel(result: film),
            AddFilmButton(
              film: film,
              onUpdate: doUpdate,
            ),
          ],
        ),
      ),
    );
  }
}
