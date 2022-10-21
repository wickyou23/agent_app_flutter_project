import 'package:agent_app/data/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppInitialState extends AppState {}

class AppReadyState extends AppState {}

class AppReadyWithAuthenticationState extends AppState {
  const AppReadyWithAuthenticationState({this.user});

  final User? user;

  @override
  List<Object?> get props => [user];

  @override
  String toString() => 'AppReadyWithAuthenticationState { crUser: $user }';
}
