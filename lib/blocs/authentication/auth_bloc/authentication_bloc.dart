import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:remote_control/repositories/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  late final StreamSubscription authSubscription;
  final AuthRepository authRepository;
  AuthenticationBloc(this.authRepository)
      : super(AuthenticationState.unknown()) {
    authSubscription = authRepository.user.listen((fauth.User? user) {
      add(AuthenticationStateChangedEvent(user: user));
    });

    on<AuthenticationStateChangedEvent>((event, emit) {
      if (event.user != null) {
        emit(state.copyWith(
            authenticationStatus: AuthenticationStatus.authenticated,
            user: event.user));
      } else {
        emit(state.copyWith(
            authenticationStatus: AuthenticationStatus.unauthenticated,
            user: null));
      }
    });

    on<SignOutRequestedEvent>((event, emit) async {
      await authRepository.logOut();
    });
  }
}
