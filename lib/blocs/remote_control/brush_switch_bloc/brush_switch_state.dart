part of 'brush_switch_bloc.dart';

class BrushSwitchState extends Equatable {
  final bool isSwitched;
  const BrushSwitchState(
    this.isSwitched,
  );

  factory BrushSwitchState.initial() => const BrushSwitchState(false);

  @override
  List<Object> get props => [isSwitched];

  BrushSwitchState copyWith({
    bool? isSwitched,
  }) {
    return BrushSwitchState(
      isSwitched ?? this.isSwitched,
    );
  }
}
