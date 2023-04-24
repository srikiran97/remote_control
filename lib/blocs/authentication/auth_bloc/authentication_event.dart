part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationStateChangedEvent extends AuthenticationEvent {
  final fauth.User? user;
  const AuthenticationStateChangedEvent({
    this.user,
  });

  @override
  List<Object?> get props => [user];
}

class SignOutRequestedEvent extends AuthenticationEvent {}
