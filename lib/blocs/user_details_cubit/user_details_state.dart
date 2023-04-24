part of 'user_details_cubit.dart';

enum UserDetailsStatus { initial, loading, success, failure }

class UserDetailsState extends Equatable {
  final UserDetailsStatus status;
  final UserModel userDetails;
  final CustomError error;
  const UserDetailsState({
    required this.status,
    required this.userDetails,
    required this.error,
  });

  factory UserDetailsState.initial() {
    return UserDetailsState(
        status: UserDetailsStatus.initial,
        userDetails: UserModel.initialUser(),
        error: const CustomError());
  }

  @override
  List<Object?> get props => [status, userDetails];

  UserDetailsState copyWith({
    UserDetailsStatus? status,
    UserModel? userDetails,
    CustomError? error,
  }) {
    return UserDetailsState(
      status: status ?? this.status,
      userDetails: userDetails ?? this.userDetails,
      error: error ?? this.error,
    );
  }
}
