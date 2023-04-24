part of 'water_switch_bloc.dart';

class WaterSwitchEvent extends Equatable {
  final bool isSwitched;
  const WaterSwitchEvent(
    this.isSwitched,
  );

  @override
  List<Object> get props => [isSwitched];
}
