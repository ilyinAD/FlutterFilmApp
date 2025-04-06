import 'package:chck_smth_in_flutter/data/api/service/backend_service.dart';
import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repository/tracked_film_map_repository.dart';

class GeneralFilmRepository {
  BackendManager backendManager;
  TrackedFilmMapRepository trackedFilmMapRepository;
  GeneralFilmRepository(
      {required this.backendManager, required this.trackedFilmMapRepository});
  Future<void> addFilm(FilmCardModel film) async {
    try {
      await backendManager.addFilm(film);
      print("no ok");
      trackedFilmMapRepository.addFilm(film: film);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFilm(FilmCardModel film) async {
    try {
      await backendManager.deleteFilm(film.id);
      trackedFilmMapRepository.deleteFilm(film: film);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getFilms() async {
    trackedFilmMapRepository.films = {};
    final prefs = await SharedPreferences.getInstance();
    final data = await backendManager.getFilms(prefs.getInt('id')!);
    for (var i = 0; i < data.length; ++i) {
      trackedFilmMapRepository.addFilm(film: data[i]);
    }
  }
}
