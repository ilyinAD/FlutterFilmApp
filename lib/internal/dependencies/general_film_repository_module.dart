import 'package:chck_smth_in_flutter/data/api/service/backend_service.dart';
import 'package:chck_smth_in_flutter/data/repository/general_film_repository.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/backend_repository_module.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/tracked_film_repository_module.dart';

class GeneralFilmRepositoryModule {
  static GeneralFilmRepository? _generalFilmRepository;
  static GeneralFilmRepository generalFilmRepository() {
    _generalFilmRepository ??= GeneralFilmRepository(
        backendManager: BackendRepositoryModule.backendManager(),
        trackedFilmMapRepository:
            TrackedFilmRepositoryModule.trackedFilmMapRepository());
    return _generalFilmRepository!;
  }
}
