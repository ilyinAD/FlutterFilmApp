import 'package:chck_smth_in_flutter/data/api/model/api_film_card.dart';
import 'package:chck_smth_in_flutter/data/api/model/api_film_list.dart';
import 'package:chck_smth_in_flutter/domain/model/film_list_model.dart';
import 'film_card_mapper.dart';

class FilmListMapper {
  static FilmListModel fromApi(ApiFilmList film) {
    return FilmListModel(
        results: film.results
            .map((ApiFilmCard e) => FilmCardMapper.fromApi(e))
            .toList());
  }
}
