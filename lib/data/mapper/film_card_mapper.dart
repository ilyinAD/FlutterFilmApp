import 'package:chck_smth_in_flutter/constants/constants.dart';
import 'package:chck_smth_in_flutter/data/api/model/api_film_card.dart';

import '../../../domain/model/film_card_model.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

String parseHtmlString(String htmlString) {
  final document = html_parser.parse(htmlString);
  return document.body?.text ?? '';
}

class FilmCardMapper {
  static FilmCardModel fromApi(ApiFilmCard film) {
    String needDescription = parseHtmlString(film.description ?? "");
    return FilmCardModel(
        name: film.name,
        rating: film.rating,
        picture: film.picture,
        description: needDescription,
        status: untracked);
  }
}
