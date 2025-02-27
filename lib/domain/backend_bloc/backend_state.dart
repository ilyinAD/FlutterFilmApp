part of 'backend_bloc.dart';

@immutable
class BackendState {
  final bool isLoading;

  const BackendState({required this.isLoading});

  BackendState copyWith({bool? isLoading}) {
    return BackendState(isLoading: isLoading ?? this.isLoading);
  }
}
