part of 'updates_bloc.dart';

final class UpdatesState {
  final int chosenIndex;
  final bool isLoading;
  final bool isGeted;
  final FilmListModel? filmList;
  const UpdatesState(
      {required this.isLoading,
      required this.isGeted,
      required this.filmList,
      this.chosenIndex = -1});
  UpdatesState copyWith(
      {bool? isLoading,
      bool? isGeted,
      FilmListModel? filmList,
      int? chosenIndex}) {
    return UpdatesState(
        isLoading: isLoading ?? this.isLoading,
        isGeted: isGeted ?? this.isGeted,
        filmList: filmList ?? this.filmList,
        chosenIndex: chosenIndex ?? this.chosenIndex);
  }
}
