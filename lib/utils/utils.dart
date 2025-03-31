// import 'package:html/parser.dart' as html_parser;
//
// String parseHtmlString(String htmlString) {
//   final document = html_parser.parse(htmlString);
//   return document.body?.text ?? '';
// }

import 'package:chck_smth_in_flutter/constants/constants.dart';
import 'package:chck_smth_in_flutter/domain/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/parser.dart' as htmlparser;

import '../internal/dependencies/backend_repository_module.dart';

Future<UserModel> registerOrLogin(
    {required String query,
    required String username,
    required String password,
    String? email}) async {
  final logger = Logger();
  try {
    late UserModel result;
    if (query == "register") {
      result = await BackendRepositoryModule.backendManager()
          .register(username, password, email ?? "");
    } else {
      result = await BackendRepositoryModule.backendManager().login(
        username,
        password,
      );
    }

    logger.i(
        "id: ${result.id} username: ${result.username} email: ${result.email}");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', result.id);
    return result;
  } on DioException catch (e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final errorMessage = e.response!.data['error'] ?? 'Неизвестная ошибка';
      switch (statusCode) {
        case 400:
          throw 'Ошибка: $errorMessage';
        case 401:
          throw '$errorMessage';
        case 500:
          throw 'Ошибка сети';
        default:
          throw 'Ошибка: $errorMessage';
      }
    } else {
      throw 'Ошибка сети: $e';
    }
  } catch (e) {
    throw 'Неизвестная ошибка: $e';
  }
}

String parseHtmlString(String htmlString) {
  final document = htmlparser.parse(htmlString);
  final String parsedString = document.body!.text;
  return parsedString;
}
