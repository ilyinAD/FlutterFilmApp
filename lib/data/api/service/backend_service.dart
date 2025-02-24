import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../domain/model/user_model.dart';

class BackendManager {
  Dio dio = Dio();

  final logger = Logger();
  final String registerUrl = 'http://192.168.1.55:8080/register';
  final String loginUrl = 'http://192.168.1.55:8080/login';
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
}
