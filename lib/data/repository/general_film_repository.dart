import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/backend_repository_module.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/tracked_film_repository_module.dart';

class GeneralFilmRepository {
  void addFilm(FilmCardModel film) {
    try {
      BackendRepositoryModule.backendManager().addFilm(film);
      TrackedFilmRepositoryModule.trackedFilmMapRepository()
          .addFilm(film: film);
    } catch (e) {
      rethrow;
    }
  }

  void deleteFilm(FilmCardModel film) {
    try {
      BackendRepositoryModule.backendManager().deleteFilm(film.id);
      TrackedFilmRepositoryModule.trackedFilmMapRepository()
          .deleteFilm(film: film);
    } catch (e) {
      rethrow;
    }
  }
}
