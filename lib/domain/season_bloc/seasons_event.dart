part of 'seasons_bloc.dart';

@immutable
sealed class SeasonsEvent {}

class DataLoadedEvent extends SeasonsEvent {
  final int seriesId;
  DataLoadedEvent({required this.seriesId});
}

class DataIsNotLoaded extends SeasonsEvent {}

class DataIsNotGotten extends SeasonsEvent {}

class DataLoadEmpty extends SeasonsEvent {}
