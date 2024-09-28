import 'package:bloc/bloc.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/repository_module.dart';
import 'package:meta/meta.dart';
import '../model/film_list_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
      : super(HomeState(isLoading: false, isGeted: false, filmList: null)) {
    on<DataLoadedEvent>(_onLoaded);
    on<DataIsNotLoaded>(_onIsNotLoaded);
    on<DataIsNotGeted>(_onIsNotGeted);
    on<ChangeIndex>(_onChangeIndex);
  }

  _onChangeIndex(ChangeIndex event, Emitter<HomeState> emit) {
    emit(state.copyWith(chosenIndex: event.index));
  }

  _onIsNotGeted(DataIsNotGeted event, Emitter<HomeState> emit) {
    emit(state.copyWith(isGeted: false));
  }

  _onLoaded(DataLoadedEvent event, Emitter<HomeState> emit) async {
    final data = await RepositoryModule.filmListRepository()
        .getFilmList(search: event.search);
    emit(state.copyWith(
      isGeted: true,
      isLoading: false,
      filmList: data,
    ));
  }

  _onIsNotLoaded(DataIsNotLoaded event, Emitter<HomeState> emit) {
    emit(state.copyWith(isLoading: true));
  }
}
