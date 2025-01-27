part of 'seasons_bloc.dart';

@immutable
class SeasonsState {
  final SeasonsListModel? seasonsListModel;
  final bool isLoading;
  final bool isGotten;
  const SeasonsState(
      {required this.seasonsListModel,
      required this.isLoading,
      required this.isGotten});

  SeasonsState copyWith(
      {bool? isLoading, SeasonsListModel? seasonsListModel, bool? isGotten}) {
    return SeasonsState(
        seasonsListModel: seasonsListModel ?? this.seasonsListModel,
        isLoading: isLoading ?? this.isLoading,
        isGotten: isGotten ?? this.isGotten);
  }
}
