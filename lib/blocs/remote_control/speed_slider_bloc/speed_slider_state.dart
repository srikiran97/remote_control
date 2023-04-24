part of 'speed_slider_bloc.dart';

class SpeedSliderState extends Equatable {
  final double speed;
  const SpeedSliderState(
    this.speed,
  );

  factory SpeedSliderState.initial() => const SpeedSliderState(20.0);

  @override
  List<Object> get props => [speed];

  SpeedSliderState copyWith({
    double? speed,
  }) {
    return SpeedSliderState(
      speed ?? this.speed,
    );
  }
}
