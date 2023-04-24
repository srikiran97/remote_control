import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'brush_switch_event.dart';
part 'brush_switch_state.dart';

class BrushSwitchBloc extends Bloc<BrushSwitchEvent, BrushSwitchState> {
  BrushSwitchBloc() : super(BrushSwitchState.initial()) {
    on<BrushSwitchEvent>((event, emit) {
      emit(state.copyWith(isSwitched: event.isSwitched));
    });
  }
}
