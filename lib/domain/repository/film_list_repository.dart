import 'package:chck_smth_in_flutter/domain/model/updates_type_enum.dart';

import '../model/film_list_model.dart';

abstract class FilmListRepository {
  Future<FilmListModel> getFilmList(
      {required String search, List<String> selectedGenres});
  Future<FilmListModel> getUpdatedFilmList(
      {required UpdatesType name,
      required int pageNumber,
      required int partNumber,
      List<String> selectedGenres = const []});
}
