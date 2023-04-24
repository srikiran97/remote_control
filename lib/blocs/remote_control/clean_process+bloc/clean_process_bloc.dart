import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'clean_process_event.dart';
part 'clean_process_state.dart';

class CleanProcessBloc extends Bloc<CleanProcessEvent, CleanProcessState> {
  CleanProcessBloc() : super(CleanProcessState.initial()) {
    on<ChangeCleanProcessStatus>((event, emit) {
      emit(state.copyWith(status: event.status));
    });
  }
}
