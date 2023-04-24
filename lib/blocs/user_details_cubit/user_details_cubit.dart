import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:remote_control/models/custom_error.dart';
import 'package:remote_control/repositories/user_repository.dart';

import '../../models/user_model.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final UserRepository userRepository;
  UserDetailsCubit(
    this.userRepository,
  ) : super(UserDetailsState.initial());

  Future<void> getUserDetails({required String uid}) async {
    emit(state.copyWith(
      status: UserDetailsStatus.loading,
    ));

    try {
      final UserModel user = await userRepository.getUserDetails(uid: uid);
      emit(
          state.copyWith(status: UserDetailsStatus.success, userDetails: user));
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: UserDetailsStatus.failure,
        error: e,
      ));
    }
  }
}
