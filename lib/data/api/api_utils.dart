import 'package:chck_smth_in_flutter/data/api/request/get_list_body.dart';
import 'package:chck_smth_in_flutter/data/api/request/get_updates_body.dart';
import 'package:chck_smth_in_flutter/data/api/service/film_service.dart';
import 'package:chck_smth_in_flutter/data/mapper/film_list_mapper.dart';
import 'package:chck_smth_in_flutter/data/mapper/seasons_list_mapper.dart';
import 'package:chck_smth_in_flutter/domain/model/seasons_list_model.dart';
import 'package:chck_smth_in_flutter/domain/model/updates_type_enum.dart';
import '../../domain/model/film_list_model.dart';
import 'package:logger/logger.dart';

class ApiUtil {
  final networkingManager = NetworkingManager();
  Future<FilmListModel> getFilmList(String search,
      [List<String> selectedGenres = const []]) async {
    final body = GetListBody(search: search);
    final result = await networkingManager.getFilmList(body, selectedGenres);
    //print(FilmListMapper.fromApi(result));
    return FilmListMapper.fromApi(result);
  }

  Future<SeasonsListModel> getSeasonList(int seriesId) async {
    final result = await networkingManager.getSeasonsList(seriesId);
    return SeasonsListMapper.fromApi(result);
  }

  Future<FilmListModel> getUpdates(
      UpdatesType name, int pageNumber, int partNumber,
      [List<String> selectedGenres = const []]) async {
    final result = await networkingManager.getUpdates(
        name, pageNumber, partNumber, selectedGenres);
    return FilmListMapper.fromApi(result);
  }
}
