import '../model/film_list_model.dart';
import '../model/film_card_model.dart';

abstract class TrackedFilmMapRepository {
  Map<int, FilmCardModel> films = {};
  void addFilm({required FilmCardModel film});
  void deleteFilm({required FilmCardModel film});
}
