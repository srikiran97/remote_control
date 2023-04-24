part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus logInStatus;
  final CustomError error;
  const LoginState({
    required this.logInStatus,
    required this.error,
  });

  factory LoginState.initial() {
    return const LoginState(
        logInStatus: LoginStatus.initial, error: CustomError());
  }

  @override
  List<Object?> get props => [logInStatus, error];

  LoginState copyWith({
    LoginStatus? logInStatus,
    CustomError? error,
  }) {
    return LoginState(
      logInStatus: logInStatus ?? this.logInStatus,
      error: error ?? this.error,
    );
  }
}
