import 'package:chck_smth_in_flutter/data/api/model/api_film_card.dart';
import 'package:chck_smth_in_flutter/data/api/request/get_list_body.dart';
import 'package:dio/dio.dart';

import '../model/api_film_list.dart';

class NetworkingManager {
  Dio dio = Dio();
  static const url = "https://api.tvmaze.com/search/shows";
  Future<ApiFilmList> getFilmList(GetListBody body) async {
    final response = await dio.get(url, queryParameters: body.toApi());
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
}
