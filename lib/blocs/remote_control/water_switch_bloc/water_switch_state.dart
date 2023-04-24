part of 'water_switch_bloc.dart';

class WaterSwitchState extends Equatable {
  final bool isSwitched;
  const WaterSwitchState(
    this.isSwitched,
  );

  factory WaterSwitchState.initial() => const WaterSwitchState(false);

  @override
  List<Object> get props => [isSwitched];

  WaterSwitchState copyWith({
    bool? isSwitched,
  }) {
    return WaterSwitchState(
      isSwitched ?? this.isSwitched,
    );
  }
}
