import 'package:bloc/bloc.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/backend_repository_module.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/general_film_repository_module.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/tracked_film_repository_module.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'backend_event.dart';
part 'backend_state.dart';

class BackendBloc extends Bloc<BackendEvent, BackendState> {
  BackendBloc() : super(const BackendState(isLoading: true)) {
    on<BackendLoadedEvent>(_onLoaded);
    on<BackendIsNotLoaded>(_onIsNotLoaded);
  }

  _onLoaded(BackendLoadedEvent event, Emitter<BackendState> emit) async {
    // TrackedFilmRepositoryModule.trackedFilmMapRepository().films = {};
    // final prefs = await SharedPreferences.getInstance();
    // final data = await BackendRepositoryModule.backendManager()
    //     .getFilms(prefs.getInt('id')!);
    // for (var i = 0; i < data.length; ++i) {
    //   TrackedFilmRepositoryModule.trackedFilmMapRepository()
    //       .addFilm(film: data[i]);
    // }
    await GeneralFilmRepositoryModule.generalFilmRepository().getFilms();
    print("END LOADING");
    emit(state.copyWith(isLoading: false));
  }

  _onIsNotLoaded(BackendIsNotLoaded event, Emitter<BackendState> emit) {
    emit(state.copyWith(isLoading: true));
  }
}
