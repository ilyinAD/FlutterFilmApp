part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class DataLoadedEvent extends HomeEvent {
  final String search;
  DataLoadedEvent({required this.search});
}

class DataIsNotLoaded extends HomeEvent {}

class DataIsNotGeted extends HomeEvent {}

class ChangeIndex extends HomeEvent {
  final int index;
  ChangeIndex({required this.index});
}
