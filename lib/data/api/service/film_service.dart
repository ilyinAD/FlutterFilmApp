import 'package:chck_smth_in_flutter/data/api/model/api_episodes_card.dart';
import 'package:chck_smth_in_flutter/data/api/model/api_film_card.dart';
import 'package:chck_smth_in_flutter/data/api/model/api_seasons_list.dart';
import 'package:chck_smth_in_flutter/data/api/request/get_list_body.dart';
import 'package:dio/dio.dart';

import '../model/api_film_list.dart';

class NetworkingManager {
  Dio dio = Dio();
  static const searchUrl = "https://api.tvmaze.com/search/shows";
  static const searchSeasons = "https://api.tvmaze.com/shows/";
  static const searchEpisodes = "https://api.tvmaze.com/seasons/";
  Future<ApiFilmList> getFilmList(GetListBody body) async {
    final response = await dio.get(searchUrl, queryParameters: body.toApi());
    if (response.statusCode == 200) {
      if (response.data != null) {
        List<ApiFilmCard> results = [];
        for (var i = 0; i < response.data.length; ++i) {
          results.add(ApiFilmCard.fromJson(response.data[i]));
        }
        return ApiFilmList(results: results);
      }
    }
    throw Exception("Wrong url");
  }

  Future<ApiSeasonsList> getSeasonsList(int seriesId) async {
    final seasons = await dio.get("$searchSeasons$seriesId/seasons");
    if (seasons.statusCode != 200) {
      throw Exception("wrong url");
    }

    if (seasons.data == null) {
      throw Exception("empty body");
    }

    List<ApiSeasonCard> results = [];

    for (var i = 0; i < seasons.data.length; ++i) {
      ApiSeasonCard seasonCard = ApiSeasonCard.fromJson(seasons.data[i]);
      final episodes =
          await dio.get("$searchEpisodes${seasonCard.id}/episodes");
      if (episodes.statusCode != 200) {
        throw Exception("wrong url");
      }

      if (episodes.data == null) {
        throw Exception("empty body");
      }
      List<ApiEpisodeCard> episodesList = [];

      for (var j = 0; j < episodes.data.length; ++j) {
        ApiEpisodeCard episodeCard = ApiEpisodeCard.fromJson(episodes.data[j]);
        episodesList.add(episodeCard);
      }

      seasonCard.episodes = episodesList;
      results.add(seasonCard);
    }
    return ApiSeasonsList(seasons: results);
  }
}
