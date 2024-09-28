part of 'home_bloc.dart';

@immutable
class HomeState {
  final int chosenIndex;
  final bool isLoading;
  final bool isGeted;
  final FilmListModel? filmList;
  HomeState(
      {required this.isLoading,
      required this.isGeted,
      required this.filmList,
      this.chosenIndex = -1});
  HomeState copyWith(
      {bool? isLoading,
      bool? isGeted,
      FilmListModel? filmList,
      int? chosenIndex}) {
    return HomeState(
        isLoading: isLoading ?? this.isLoading,
        isGeted: isGeted ?? this.isGeted,
        filmList: filmList ?? this.filmList,
        chosenIndex: chosenIndex ?? this.chosenIndex);
  }
}
