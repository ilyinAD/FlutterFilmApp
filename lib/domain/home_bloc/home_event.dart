part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class FilmsLoadedEvent extends HomeEvent {
  final String search;
  FilmsLoadedEvent({required this.search});
}

class FilmsIsNotLoaded extends HomeEvent {}

class FilmsIsNotGeted extends HomeEvent {}

class ChangeIndex extends HomeEvent {
  final int index;
  ChangeIndex({required this.index});
}
