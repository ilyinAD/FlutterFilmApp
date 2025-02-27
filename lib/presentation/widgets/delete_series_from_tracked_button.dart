import 'package:chck_smth_in_flutter/internal/dependencies/general_film_repository_module.dart';
import 'package:flutter/material.dart';

import '../../domain/model/film_card_model.dart';
import '../../internal/dependencies/tracked_film_repository_module.dart';

class DeleteSeriesButton extends StatelessWidget {
  final FilmCardModel film;
  const DeleteSeriesButton({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawMaterialButton(
          onPressed: () {
            // TrackedFilmRepositoryModule.trackedFilmMapRepository()
            //     .deleteFilm(film: film);
            GeneralFilmRepositoryModule.generalFilmRepository()
                .deleteFilm(film);
            Navigator.pop(context, film);
          },
          elevation: 2.0,
          fillColor: Colors.white,
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
          child: const Icon(
            Icons.delete,
            size: 35,
          )),
    );
  }
}
