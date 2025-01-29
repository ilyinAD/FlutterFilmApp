part of 'seasons_bloc.dart';

@immutable
sealed class SeasonsEvent {}

class SeasonsLoadedEvent extends SeasonsEvent {
  final int seriesId;
  SeasonsLoadedEvent({required this.seriesId});
}

class SeasonsIsNotLoaded extends SeasonsEvent {}

class SeasonsIsNotGotten extends SeasonsEvent {}

class SeasonsLoadEmpty extends SeasonsEvent {}
