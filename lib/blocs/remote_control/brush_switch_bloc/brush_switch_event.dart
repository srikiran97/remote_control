part of 'brush_switch_bloc.dart';

class BrushSwitchEvent extends Equatable {
  final bool isSwitched;
  const BrushSwitchEvent(
    this.isSwitched,
  );

  @override
  List<Object> get props => [isSwitched];
}
