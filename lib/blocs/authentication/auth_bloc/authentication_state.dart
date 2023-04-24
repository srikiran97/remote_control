part of 'authentication_bloc.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationState extends Equatable {
  final AuthenticationStatus authenticationStatus;
  final fauth.User? user;
  const AuthenticationState({
    required this.authenticationStatus,
    this.user,
  });

  factory AuthenticationState.unknown() {
    return const AuthenticationState(
      authenticationStatus: AuthenticationStatus.unknown,
    );
  }

  @override
  List<Object?> get props => [authenticationStatus, user];

  AuthenticationState copyWith({
    AuthenticationStatus? authenticationStatus,
    fauth.User? user,
  }) {
    return AuthenticationState(
      authenticationStatus: authenticationStatus ?? this.authenticationStatus,
      user: user ?? this.user,
    );
  }
}
