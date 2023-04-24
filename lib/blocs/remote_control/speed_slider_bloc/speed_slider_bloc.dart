import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'speed_slider_event.dart';
part 'speed_slider_state.dart';

class SpeedSliderBloc extends Bloc<SpeedSliderEvent, SpeedSliderState> {
  SpeedSliderBloc() : super(SpeedSliderState.initial()) {
    on<ChangeSpeedSliderValueEvent>(
      (event, emit) {
        emit(state.copyWith(speed: event.speed));
      },
    );
  }
}
