import 'package:chck_smth_in_flutter/data/api/service/backend_service.dart';

class BackendRepositoryModule {
  static BackendManager? _backendManager;
  static BackendManager backendManager() {
    _backendManager ??= BackendManager();
    return _backendManager!;
  }
}
