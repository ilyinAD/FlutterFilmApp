import 'package:chck_smth_in_flutter/data/api/model/api_film_card.dart';

import '../../../domain/model/film_card_model.dart';

class FilmCardMapper {
  static FilmCardModel fromApi(ApiFilmCard film) {
    return FilmCardModel(
        name: film.name,
        rating: film.rating,
        picture: film.picture,
        description: film.description);
  }
}
