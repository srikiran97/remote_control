part of 'clean_process_bloc.dart';

abstract class CleanProcessEvent extends Equatable {
  const CleanProcessEvent();

  @override
  List<Object> get props => [];
}

class ChangeCleanProcessStatus extends CleanProcessEvent {
  final CleanProcessStatus status;
  const ChangeCleanProcessStatus(this.status);

  @override
  List<Object> get props => [status];
}
