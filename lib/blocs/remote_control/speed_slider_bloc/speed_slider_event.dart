part of 'speed_slider_bloc.dart';

abstract class SpeedSliderEvent extends Equatable {
  const SpeedSliderEvent();

  @override
  List<Object> get props => [];
}

class ChangeSpeedSliderValueEvent extends SpeedSliderEvent {
  final double speed;
  const ChangeSpeedSliderValueEvent(this.speed);

  @override
  List<Object> get props => [speed];
}
