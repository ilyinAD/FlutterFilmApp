import 'package:bloc/bloc.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/repository_module.dart';
import 'package:meta/meta.dart';
import '../model/film_list_model.dart';
import '../updates_bloc/updates_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
      : super(HomeState(isLoading: false, isGeted: false, filmList: null)) {
    on<FilmsLoadedEvent>(_onLoaded);
    on<FilmsIsNotLoaded>(_onIsNotLoaded);
    on<FilmsIsNotGeted>(_onIsNotGeted);
    on<ChangeIndex>(_onChangeIndex);
  }

  _onChangeIndex(ChangeIndex event, Emitter<HomeState> emit) {
    emit(state.copyWith(chosenIndex: event.index));
  }

  _onIsNotGeted(FilmsIsNotGeted event, Emitter<HomeState> emit) {
    emit(state.copyWith(isGeted: false));
  }

  _onLoaded(FilmsLoadedEvent event, Emitter<HomeState> emit) async {
    final data = await RepositoryModule.filmListRepository().getFilmList(
        search: event.search, selectedGenres: event.selectedGenres);
    emit(state.copyWith(
      isGeted: true,
      isLoading: false,
      filmList: data,
    ));
  }

  _onIsNotLoaded(FilmsIsNotLoaded event, Emitter<HomeState> emit) {
    emit(state.copyWith(isLoading: true));
  }
}
