import 'package:bloc/bloc.dart';
import 'package:chck_smth_in_flutter/data/repository/season_list_data_repository.dart';
import 'package:chck_smth_in_flutter/domain/model/seasons_list_model.dart';
import 'package:chck_smth_in_flutter/domain/repository/season_list_repository.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/season_list_module.dart';
import 'package:meta/meta.dart';

import '../home_bloc/home_bloc.dart';

part 'seasons_event.dart';
part 'seasons_state.dart';

class SeasonsBloc extends Bloc<SeasonsEvent, SeasonsState> {
  SeasonsBloc()
      : super(const SeasonsState(
            seasonsListModel: null, isLoading: false, isGotten: false)) {
    on<SeasonsLoadedEvent>(_onLoaded);
    on<SeasonsIsNotLoaded>(_onIsNotLoaded);
    on<SeasonsIsNotGotten>(_onIsNotGotten);
    on<SeasonsLoadEmpty>(_onLoadEmpty);
  }

  _onLoaded(SeasonsLoadedEvent event, Emitter<SeasonsState> emit) async {
    final data = await SeasonListModule.seasonListRepository()
        .getSeasonList(seriesId: event.seriesId);
    emit(state.copyWith(
        isGotten: true, isLoading: false, seasonsListModel: data));
    print("data loaded");
  }

  _onIsNotLoaded(SeasonsIsNotLoaded event, Emitter<SeasonsState> emit) {
    emit(state.copyWith(isLoading: true));
  }

  _onIsNotGotten(SeasonsIsNotGotten event, Emitter<SeasonsState> emit) {
    emit(state.copyWith(isGotten: false));
  }

  _onLoadEmpty(SeasonsLoadEmpty event, Emitter<SeasonsState> emit) {
    emit(state.copyWith(
        isLoading: false, seasonsListModel: SeasonsListModel(seasons: [])));
  }
}
