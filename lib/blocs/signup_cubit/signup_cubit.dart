import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:remote_control/repositories/auth_repository.dart';

import '../../models/custom_error.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository authRepository;

  SignupCubit(
    this.authRepository,
  ) : super(SignupState.initial());

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(signupStatus: SignupStatus.loading));
    try {
      await authRepository.signup(
        name: name,
        email: email,
        password: password,
      );

      emit(state.copyWith(signupStatus: SignupStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(
        signupStatus: SignupStatus.failure,
        error: e,
      ));
    }
  }
}
