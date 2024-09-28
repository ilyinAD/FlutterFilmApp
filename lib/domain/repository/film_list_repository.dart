import '../model/film_list_model.dart';

abstract class FilmListRepository {
  Future<FilmListModel> getFilmList({required String search});
}
