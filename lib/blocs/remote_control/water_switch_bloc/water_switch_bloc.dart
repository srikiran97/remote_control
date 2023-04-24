import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'water_switch_event.dart';
part 'water_switch_state.dart';

class WaterSwitchBloc extends Bloc<WaterSwitchEvent, WaterSwitchState> {
  WaterSwitchBloc() : super(WaterSwitchState.initial()) {
    on<WaterSwitchEvent>((event, emit) {
      emit(state.copyWith(isSwitched: event.isSwitched));
    });
  }
}
