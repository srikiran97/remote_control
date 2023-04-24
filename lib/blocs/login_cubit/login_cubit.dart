import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:remote_control/repositories/auth_repository.dart';

import '../../models/custom_error.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  LoginCubit(this.authRepository) : super(LoginState.initial());

  Future<void> logIn({required String email, required String password}) async {
    emit(state.copyWith(
      logInStatus: LoginStatus.loading,
    ));
    try {
      await authRepository.logIn(
        email: email,
        password: password,
      );

      emit(state.copyWith(logInStatus: LoginStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(
        logInStatus: LoginStatus.failure,
        error: e,
      ));
    }
  }
}
