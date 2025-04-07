import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/model/user_model.dart';

class BackendManager {
  Dio dio = Dio();

  final logger = Logger();
  static const host = "192.168.1.55";
  static const port = "3000";
  final String registerUrl = 'http://$host:$port/register';
  final String loginUrl = 'http://$host:$port/login';
  final String addFilmUrl = 'http://$host:$port/addFilm';
  final String delFilmUrl = 'http://$host:$port/deleteFilm';
  final String getFilmUrl = 'http://$host:$port/getFilm';
  final String getFilmsUrl = 'http://$host:$port/getFilms';
  final String getUser = 'http://$host:$port/getUser';
  Future<UserModel> register(
      String username, String password, String email) async {
    final data = {
      'username': username,
      'password': password,
      'email': email,
    };
    logger.i("post query $username and $password");

    try {
      final result = await dio.post(
        registerUrl,
        data: data,
        //options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (result.statusCode == 200) {
        return UserModel(
            username: result.data["username"],
            email: result.data["email"],
            id: result.data["id"]);
      }
      throw Exception("error");
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<UserModel> login(String username, String password) async {
    final data = {
      'username': username,
      'password': password,
    };
    logger.i("post query $username and $password");

    try {
      final result = await dio.post(
        loginUrl,
        data: data,
      );

      if (result.statusCode == 200) {
        return UserModel(
            username: result.data["username"],
            email: result.data["email"],
            id: result.data["id"]);
      }
      throw Exception("error");
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> addFilm(FilmCardModel film) async {
    print("OK");
    final prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    if (id == null) {
      throw Exception("not id in sharepref");
    }
    print("OK");
    final data = film.toJson();
    data["user_id"] = id;

    // final data = {
    //   "userID": id,
    //   "id": film.id,
    //   "picture": film.picture,
    //   "name": film.name,
    //   "rating": film.rating,
    //   "description": film.description,
    //   "status": film.status
    // };

    try {
      final result = await dio.post(addFilmUrl, data: data);
      print("result status code: ${result.statusCode}");
      if (result.statusCode == 200) {
        return;
      }
      print("ok");
      throw Exception("bad status code");
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> deleteFilm(int id) async {
    final prefs = await SharedPreferences.getInstance();

    final data = {
      "id": id,
      "user_id": prefs.getInt('id'),
    };

    try {
      final result = await dio.delete(delFilmUrl, data: data);
      if (result.statusCode == 200) {
        return;
      }
      throw Exception("bad status code");
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<FilmCardModel> getFilm(int id) async {
    final prefs = await SharedPreferences.getInstance();

    final data = {
      "id": id,
      "user_id": prefs.getInt('id'),
    };

    try {
      final result = await dio.get(getFilmUrl, data: data);
      if (result.statusCode == 200) {
        return FilmCardModel.fromJson(result.data);
      }
      throw Exception("status code isnt 200");
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<List<FilmCardModel>> getFilms(int userID) async {
    final data = {
      "user_id": userID,
    };

    try {
      logger.i("start query");
      final response = await dio.get(getFilmsUrl, data: data);
      if (response.statusCode == 200) {
        List<FilmCardModel> results = [];
        if (response.data == null) {
          return results;
        }
        for (var i = 0; i < response.data.length; ++i) {
          results.add(FilmCardModel.fromJson(response.data[i]));
        }

        return results;
      }
      throw Exception("status code isn't 200");
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<UserModel> getUserInfo(int userID) async {
    final data = {
      "user_id": userID,
    };

    try {
      final response = await dio.get(getUser, data: data);
      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception("no user found");
        }

        return UserModel.fromJson(response.data);
      }
      throw Exception("status code isn't 200");
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }
}
