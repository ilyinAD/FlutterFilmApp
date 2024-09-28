import 'package:chck_smth_in_flutter/data/api/request/get_list_body.dart';
import 'package:chck_smth_in_flutter/data/api/service/film_service.dart';
import 'package:chck_smth_in_flutter/data/mapper/film_list_mapper.dart';
import '../../domain/model/film_list_model.dart';
import 'package:logger/logger.dart';

class ApiUtil {
  final networkingManager = NetworkingManager();
  Future<FilmListModel> getFilmList(String search) async {
    final body = GetListBody(search: search);
    final result = await networkingManager.getFilmList(body);
    // final logger = Logger();
    // logger.i("Data has been received");
    return FilmListMapper.fromApi(result);
  }
}
