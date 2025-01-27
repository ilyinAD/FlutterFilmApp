import 'package:chck_smth_in_flutter/data/repository/season_list_data_repository.dart';

import '../../domain/repository/season_list_repository.dart';
import 'api_module.dart';

class SeasonListModule {
  static SeasonListRepository? _seasonListRepository;
  static SeasonListRepository seasonListRepository() {
    _seasonListRepository ??=
        SeasonListDataRepository(apiUtil: ApiModule.apiUtil());
    return _seasonListRepository!;
  }
}
