import 'package:chck_smth_in_flutter/data/api/api_utils.dart';

class ApiModule {
  static ApiUtil? _apiUtil;
  static ApiUtil apiUtil() {
    _apiUtil ??= ApiUtil();
    return _apiUtil!;
  }
}
