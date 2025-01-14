import 'package:chck_smth_in_flutter/data/repository/tracked_film_map_data_repository.dart';
import 'package:chck_smth_in_flutter/domain/repository/tracked_film_map_repository.dart';

class TrackedFilmRepositoryModule {
  static TrackedFilmMapRepository? _trackedFilmMapRepository;
  static TrackedFilmMapRepository trackedFilmMapRepository() {
    _trackedFilmMapRepository ??= TrackedFilmMapDataRepository();
    return _trackedFilmMapRepository!;
  }
}
