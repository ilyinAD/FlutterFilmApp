part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class FilmsLoadedEvent extends HomeEvent {
  final String search;
  final List<String> selectedGenres;
  FilmsLoadedEvent({required this.search, this.selectedGenres = const []});
}

class FilmsIsNotLoaded extends HomeEvent {}

class FilmsIsNotGeted extends HomeEvent {}

class ChangeIndex extends HomeEvent {
  final int index;
  ChangeIndex({required this.index});
}
