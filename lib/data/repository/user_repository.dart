import 'package:chck_smth_in_flutter/data/api/service/backend_service.dart';

import '../../domain/model/user_model.dart';

class UserRepository {
  BackendManager backendManager;
  UserRepository({required this.backendManager});
  Future<UserModel> register(
      String username, String password, String email) async {
    return backendManager.register(username, password, email);
  }

  Future<UserModel> login(String username, String password) async {
    return backendManager.login(username, password);
  }
}
