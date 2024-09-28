import 'package:chck_smth_in_flutter/data/repository/film_list_data_repository.dart';
import 'package:chck_smth_in_flutter/domain/repository/film_list_repository.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/api_module.dart';

class RepositoryModule {
  static FilmListRepository? _filmListRepository;
  static FilmListRepository filmListRepository() {
    _filmListRepository ??=
        FilmListDataRepository(apiUtil: ApiModule.apiUtil());
    return _filmListRepository!;
  }
}
