import 'package:chck_smth_in_flutter/data/repository/general_film_repository.dart';

class GeneralFilmRepositoryModule {
  static GeneralFilmRepository? _generalFilmRepository;
  static GeneralFilmRepository generalFilmRepository() {
    _generalFilmRepository ??= GeneralFilmRepository();
    return _generalFilmRepository!;
  }
}
