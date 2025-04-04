import 'package:chck_smth_in_flutter/data/repository/user_repository.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/backend_repository_module.dart';

class UserRepositoryModule {
  static UserRepository? _userRepository;
  static UserRepository userRepositoryModule() {
    _userRepository ??= UserRepository(
        backendManager: BackendRepositoryModule.backendManager());
    return _userRepository!;
  }
}
