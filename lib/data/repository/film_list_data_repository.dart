import 'package:chck_smth_in_flutter/domain/model/updates_type_enum.dart';

import '../../domain/model/film_list_model.dart';
import '../../domain/repository/film_list_repository.dart';
import '../api/api_utils.dart';

class FilmListDataRepository extends FilmListRepository {
  ApiUtil apiUtil;
  FilmListDataRepository({required this.apiUtil});
  @override
  Future<FilmListModel> getFilmList(
      {required String search, List<String> selectedGenres = const []}) {
    return apiUtil.getFilmList(search, selectedGenres);
  }

  @override
  Future<FilmListModel> getUpdatedFilmList(
      {required UpdatesType name,
      required int pageNumber,
      required int partNumber,
      List<String> selectedGenres = const []}) {
    return apiUtil.getUpdates(name, pageNumber, partNumber, selectedGenres);
  }
}
