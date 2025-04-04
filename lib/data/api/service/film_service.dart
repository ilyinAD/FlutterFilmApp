import 'package:chck_smth_in_flutter/data/api/model/api_episodes_card.dart';
import 'package:chck_smth_in_flutter/data/api/model/api_film_card.dart';
import 'package:chck_smth_in_flutter/data/api/model/api_seasons_list.dart';
import 'package:chck_smth_in_flutter/data/api/request/get_list_body.dart';
import 'package:chck_smth_in_flutter/data/api/request/get_updates_body.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../domain/model/updates_type_enum.dart';
import '../model/api_film_list.dart';

class NetworkingManager {
  Dio dio = Dio();
  final logger = Logger();
  static const baseURL = "https://api.tvmaze.com/";
  static const searchUrl = "${baseURL}search/shows";
  static const searchSeasons = "${baseURL}shows/";
  static const searchEpisodes = "${baseURL}seasons/";
  static const searchUpdates = "${baseURL}updates/shows";
  static const searchShowByID = "${baseURL}shows/";
  static const limit = 50;
  Future<ApiFilmList> getFilmList(GetListBody body,
      [List<String> selectedGenres = const []]) async {
    final response = await dio.get(searchUrl, queryParameters: body.toApi());
    if (response.statusCode == 200) {
      if (response.data != null) {
        List<ApiFilmCard> results = [];
        for (var i = 0; i < response.data.length; ++i) {
          ApiFilmCard card = ApiFilmCard.fromJson(response.data[i]);
          if (checkGenre(card.genres != null ? card.genres! : const [],
                  selectedGenres) ==
              true) {
            print("OK");
            results.add(card);
          }
        }
        return ApiFilmList(results: results);
      }
    }
    throw Exception("Wrong url");
  }

  bool checkGenre(List<dynamic> genres, List<String> selectedGenres) {
    print("Selected genres");
    print(selectedGenres);
    if (selectedGenres.isEmpty) {
      return true;
    }
    for (var i = 0; i < genres.length; ++i) {
      for (var j = 0; j < selectedGenres.length; ++j) {
        if (genres[i].toString() == selectedGenres[j]) {
          return true;
        }
      }
    }

    return false;
  }

  Future<ApiFilmList> getUpdates(GetUpdatesBody body) async {
    final response =
        await dio.get(searchUpdates, queryParameters: body.toAPI());
    if (response.statusCode == 200) {
      if (response.data != null) {
        List<ApiFilmCard> results = [];
        int cnt = 0;
        for (var entry in response.data.entries) {
          if (cnt >= limit) {
            break;
          }

          ++cnt;

          final filmResponse = await dio.get("$searchShowByID${entry.key}");
          if (filmResponse.statusCode != 200) {
            throw Exception("wrong url");
          }

          if (filmResponse.data == null) {
            throw Exception("empty body");
          }

          results.add(filmResponse.data);
        }

        return ApiFilmList(results: results);
      }
    }

    throw Exception("Wrong URL");
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
    logger.i("seasons were loaded");
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

      logger.i("episodes for season $i were loaded");

      List<ApiEpisodeCard> episodesList = [];

      for (var j = 0; j < episodes.data.length; ++j) {
        ApiEpisodeCard episodeCard = ApiEpisodeCard.fromJson(episodes.data[j]);
        episodesList.add(episodeCard);
      }

      seasonCard.episodes = episodesList;
      results.add(seasonCard);
    }
    logger.i("seasons list was created");
    return ApiSeasonsList(seasons: results);
  }
}
