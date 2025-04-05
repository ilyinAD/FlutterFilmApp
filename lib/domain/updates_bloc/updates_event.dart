part of 'updates_bloc.dart';

@immutable
sealed class UpdatesEvent {}

class FilmsLoadedEvent extends UpdatesEvent {
  final UpdatesType name;
  final int pageNumber;
  final int partNumber;
  List<String> selectedGenres;
  FilmsLoadedEvent(
      {required this.name,
      required this.pageNumber,
      required this.partNumber,
      this.selectedGenres = const []});
}

class FilmsIsNotLoaded extends UpdatesEvent {}

class FilmsIsNotGeted extends UpdatesEvent {}

class ChangeIndex extends UpdatesEvent {
  final int index;
  ChangeIndex({required this.index});
}
