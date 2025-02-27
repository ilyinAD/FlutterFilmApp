part of 'backend_bloc.dart';

@immutable
sealed class BackendEvent {}

class BackendLoadedEvent extends BackendEvent {}

class BackendIsNotLoaded extends BackendEvent {}
