import 'package:chck_smth_in_flutter/domain/repository/tracked_film_map_repository.dart';

import '../../domain/model/film_card_model.dart';

class TrackedFilmMapDataRepository extends TrackedFilmMapRepository {
  Map<int, FilmCardModel> films = {};

  @override
  void addFilm({required FilmCardModel film}) {
    films[film.id] = film;
  }

  @override
  void deleteFilm({required FilmCardModel film}) {
    if (films.containsKey(film.id)) {
      films.remove(film.id);
    }
  }
}
