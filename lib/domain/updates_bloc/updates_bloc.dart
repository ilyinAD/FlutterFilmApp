import 'package:bloc/bloc.dart';
import 'package:chck_smth_in_flutter/domain/model/updates_type_enum.dart';
import 'package:meta/meta.dart';

import '../../internal/dependencies/repository_module.dart';
import '../model/film_list_model.dart';

part 'updates_event.dart';
part 'updates_state.dart';

class UpdatesBloc extends Bloc<UpdatesEvent, UpdatesState> {
  UpdatesBloc()
      : super(UpdatesState(isLoading: false, isGeted: false, filmList: null)) {
    on<FilmsLoadedEvent>(_onLoaded);
    on<FilmsIsNotLoaded>(_onIsNotLoaded);
    on<FilmsIsNotGeted>(_onIsNotGeted);
    on<ChangeIndex>(_onChangeIndex);
  }

  _onChangeIndex(ChangeIndex event, Emitter<UpdatesState> emit) {
    emit(state.copyWith(chosenIndex: event.index));
  }

  _onIsNotGeted(FilmsIsNotGeted event, Emitter<UpdatesState> emit) {
    emit(state.copyWith(isGeted: false));
  }

  _onLoaded(FilmsLoadedEvent event, Emitter<UpdatesState> emit) async {
    final data = await RepositoryModule.filmListRepository().getUpdatedFilmList(
        name: event.name,
        pageNumber: event.pageNumber,
        partNumber: event.partNumber,
        selectedGenres: event.selectedGenres);
    emit(state.copyWith(
      isGeted: true,
      isLoading: false,
      filmList: data,
    ));
  }

  _onIsNotLoaded(FilmsIsNotLoaded event, Emitter<UpdatesState> emit) {
    emit(state.copyWith(isLoading: true));
  }
}
