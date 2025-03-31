import 'package:chck_smth_in_flutter/constants/constants.dart';
import 'package:chck_smth_in_flutter/data/api/model/api_film_card.dart';

import '../../../domain/model/film_card_model.dart';
import '../../utils/utils.dart';

class FilmCardMapper {
  static FilmCardModel fromApi(ApiFilmCard film) {
    String needDescription = parseHtmlString(film.description ?? "");
    //String needDescription = film.description ?? "";
    return FilmCardModel(
        name: film.name,
        rating: film.rating,
        picture: film.picture,
        description: needDescription,
        status: untracked,
        id: film.id,
        filmURL: film.filmURL,
        genres: film.genres?.map((e) => e.toString()).toList());
  }
}
