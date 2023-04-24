part of 'clean_process_bloc.dart';

enum CleanProcessStatus { running, stopped }

class CleanProcessState extends Equatable {
  final CleanProcessStatus status;
  const CleanProcessState({
    this.status = CleanProcessStatus.stopped,
  });

  factory CleanProcessState.initial() => const CleanProcessState();

  @override
  List<Object> get props => [status];

  CleanProcessState copyWith({
    CleanProcessStatus? status,
  }) {
    return CleanProcessState(
      status: status ?? this.status,
    );
  }
}
