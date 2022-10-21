import 'package:agent_app/data/models/user.dart';
import 'package:agent_app/data/network/network_response_state.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitializeState extends AuthState {}

class AuthProcessingState extends AuthState {}

class AuthNotReadyState extends AuthState {}

class AuthReadyState extends AuthState {
  const AuthReadyState(this.crUser);

  final User crUser;

  @override
  List<Object?> get props => [crUser];

  @override
  String toString() => 'AuthReadyState { crUser: $crUser }';
}

// SIGNUP state

// class AuthSignupSuccessState extends AuthState {
//   const AuthSignupSuccessState(this.crUser);

//   final User crUser;

//   @override
//   List<Object> get props => [crUser];

//   @override
//   String toString() => 'AuthReadyState { crUser: $crUser }';
// }

// class AuthSignupFailedState extends AuthState {
//   const AuthSignupFailedState({required this.failedState});

//   final ResponseFailedState failedState;

//   @override
//   List<Object> get props => [failedState];

//   @override
//   String toString() => 'AuthSignupFailedState { failed: $failedState }';
// }

// SIGNIN state

class AuthSigninSuccessState extends AuthState {
  const AuthSigninSuccessState(this.crUser);
  final User crUser;

  @override
  List<Object> get props => [crUser];

  @override
  String toString() => 'AuthReadyState { crUser: $crUser }';
}

class AuthSigninFailedState extends AuthState {
  const AuthSigninFailedState({required this.failedState});
  final ResponseFailedState failedState;

  @override
  List<Object> get props => [failedState];

  @override
  String toString() => 'AuthSigninFailedState { failed: $failedState }';
}

// VERIFYCODE state

class AuthVerifyCodeFailedState extends AuthState {
  const AuthVerifyCodeFailedState({required this.failedState});
  final ResponseFailedState failedState;

  @override
  List<Object> get props => [failedState];

  @override
  String toString() => 'AuthVerifyCodeFailedState { failed: $failedState }';
}
