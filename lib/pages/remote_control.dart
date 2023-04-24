import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:remote_control/blocs/remote_control/brush_switch_bloc/brush_switch_bloc.dart';
import 'package:remote_control/blocs/remote_control/clean_process+bloc/clean_process_bloc.dart';
import 'package:remote_control/blocs/remote_control/speed_slider_bloc/speed_slider_bloc.dart';
import 'package:remote_control/blocs/remote_control/water_switch_bloc/water_switch_bloc.dart';

import '../constants.dart';
import '../custom_widgets/gradient_button.dart';

class RemoteControl extends StatefulWidget {
  const RemoteControl({super.key});

  @override
  State<RemoteControl> createState() => _RemoteControlState();
}

class _RemoteControlState extends State<RemoteControl> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          backgroundImage,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: const Text('Remote Control'),
              titleTextStyle: appBarTitle,
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: CustomGradientContainer(
                        gradient: const LinearGradient(
                          stops: [0, 0.2, 0.4, 0.6, 0.8, 1],
                          colors: [
                            Colors.transparent,
                            Colors.white10,
                            Colors.white,
                            Colors.white,
                            Colors.white10,
                            Colors.transparent,
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RichText(
                                  text: const TextSpan(children: [
                                    WidgetSpan(
                                        child: Icon(
                                      Icons.water_drop_outlined,
                                      size: 18,
                                      color: Colors.white,
                                    )),
                                    TextSpan(
                                        text: ' Water',
                                        style: TextStyle(fontSize: 18))
                                  ]),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                BlocBuilder<WaterSwitchBloc, WaterSwitchState>(
                                  builder: (context, state) {
                                    return FlutterSwitch(
                                      height: 30,
                                      width: 50,
                                      toggleSize: 20,
                                      inactiveSwitchBorder: Border.all(
                                          width: 1, color: Colors.white),
                                      activeSwitchBorder: Border.all(
                                          width: 1, color: Colors.white),
                                      activeColor: Colors.blue,
                                      inactiveColor: Colors.transparent,
                                      value: state.isSwitched,
                                      onToggle: (value) {
                                        context
                                            .read<WaterSwitchBloc>()
                                            .add(WaterSwitchEvent(value));
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const VerticalDivider(
                              width: 1,
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RichText(
                                  text: const TextSpan(children: [
                                    WidgetSpan(
                                        child: Icon(
                                      Icons.cleaning_services_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    )),
                                    TextSpan(
                                        text: ' Brush',
                                        style: TextStyle(fontSize: 18))
                                  ]),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                BlocBuilder<BrushSwitchBloc, BrushSwitchState>(
                                  builder: (context, state) {
                                    return FlutterSwitch(
                                      height: 30,
                                      width: 50,
                                      toggleSize: 20,
                                      inactiveSwitchBorder: Border.all(
                                          width: 1, color: Colors.white),
                                      activeSwitchBorder: Border.all(
                                          width: 1, color: Colors.white),
                                      activeColor: Colors.blue,
                                      inactiveColor: Colors.transparent,
                                      value: state.isSwitched,
                                      onToggle: (value) {
                                        context
                                            .read<BrushSwitchBloc>()
                                            .add(BrushSwitchEvent(value));
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.all(75),
                    child: Joystick(
                      period: const Duration(milliseconds: 50),
                      stick: const CustomJoystickStick(),
                      base: const CustomJoystickBase(),
                      listener: (StickDragDetails details) {
                        // Do joystick operations here
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BlocBuilder<CleanProcessBloc, CleanProcessState>(
                    builder: (context, state) {
                      return CustomGradientButton(
                        height: 75,
                        width: double.infinity,
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: state.status == CleanProcessStatus.stopped
                                ? [
                                    Colors.blue,
                                    Colors.blue.shade600,
                                    Colors.blue.shade900,
                                  ]
                                : [
                                    Colors.red.shade400,
                                    Colors.red.shade600,
                                    Colors.red.shade900,
                                  ]),
                        borderRadius: BorderRadius.circular(15),
                        onPressed: () {
                          context.read<CleanProcessBloc>().add(
                              state.status == CleanProcessStatus.stopped
                                  ? const ChangeCleanProcessStatus(
                                      CleanProcessStatus.running)
                                  : const ChangeCleanProcessStatus(
                                      CleanProcessStatus.stopped));
                        },
                        child: state.status == CleanProcessStatus.stopped
                            ? const Text('START')
                            : const Text('STOP'),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        _getBottomSheet()
      ],
    );
  }

  Widget _getBottomSheet() {
    return DraggableScrollableSheet(
      maxChildSize: 0.25,
      minChildSize: 0.10,
      initialChildSize: 0.10,
      builder: (context, scrollController) {
        return Material(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 2,
                    blurRadius: 7,
                  ),
                ],
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue,
                      Colors.blue.shade600,
                      Colors.blue.shade900,
                    ]),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                )),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 15),
                      child: Center(
                          child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        width: 50,
                        height: 2.5,
                      ))),
                  const Icon(Icons.settings_outlined, color: Colors.white),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text('SETTINGS',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 15),
                      width: double.infinity,
                      child: BlocBuilder<SpeedSliderBloc, SpeedSliderState>(
                        builder: (context, state) {
                          return Text(
                            'Speed: ${state.speed}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          );
                        },
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      height: 25,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: SliderTheme(
                            data: SliderThemeData(
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 18),
                                trackHeight: 12,
                                tickMarkShape: SliderTickMarkShape.noTickMark,
                                trackShape: CustomTrackShape()),
                            child:
                                BlocBuilder<SpeedSliderBloc, SpeedSliderState>(
                              builder: (context, state) {
                                return Slider(
                                  min: 0,
                                  max: 50,
                                  divisions: 5,
                                  value: state.speed,
                                  inactiveColor: Colors.white,
                                  thumbColor: Colors.white,
                                  activeColor: const Color(0xFF156DE4),
                                  onChanged: (value) {},
                                  onChangeEnd: (value) {
                                    context.read<SpeedSliderBloc>().add(
                                        ChangeSpeedSliderValueEvent(value));
                                  },
                                );
                              },
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx + 2.5;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth - 5, trackHeight);
  }
}

class CustomGradientContainer extends StatelessWidget {
  CustomGradientContainer({
    super.key,
    required gradient,
    required this.child,
    this.strokeWidth = 1,
  }) : painter = CustomGradient(gradient: gradient, strokeWidth: strokeWidth);

  final CustomGradient painter;
  final Widget child;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: painter, child: child);
  }
}

class CustomGradient extends CustomPainter {
  CustomGradient({required this.gradient, required this.strokeWidth});

  final Gradient gradient;
  final double strokeWidth;
  final Paint p = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    Rect innerRect = Rect.fromLTRB(strokeWidth, strokeWidth,
        size.width - strokeWidth, size.height - strokeWidth);
    Rect outerRect = Offset.zero & size;

    p.shader = gradient.createShader(outerRect);
    Path borderPath = _calculateBorderPath(outerRect, innerRect);
    canvas.drawPath(borderPath, p);
  }

  Path _calculateBorderPath(Rect outerRect, Rect innerRect) {
    Path outerRectPath = Path()..addRect(outerRect);
    Path innerRectPath = Path()..addRect(innerRect);
    return Path.combine(PathOperation.difference, outerRectPath, innerRectPath);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CustomJoystickBase extends StatelessWidget {
  final JoystickMode mode;

  const CustomJoystickBase({
    this.mode = JoystickMode.all,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: _JoystickBasePainter(mode),
      ),
    );
  }
}

class _JoystickBasePainter extends CustomPainter {
  _JoystickBasePainter(this.mode);

  final JoystickMode mode;

  final _borderPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;
  final _centerPaint = Paint()
    ..color = Colors.indigo
    ..style = PaintingStyle.fill;
  final _linePaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.width / 2);
    final radius = size.width * 0.60;
    canvas.drawCircle(center, radius, _centerPaint);
    canvas.drawCircle(center, radius, _borderPaint);

    if (mode != JoystickMode.horizontal) {
      // draw vertical arrows

      canvas.drawLine(Offset(center.dx - 10, center.dy - 135),
          Offset(center.dx, center.dy - 150), _linePaint);
      canvas.drawLine(Offset(center.dx + 10, center.dy - 135),
          Offset(center.dx, center.dy - 150), _linePaint);
      canvas.drawLine(Offset(center.dx - 10, center.dy - 135),
          Offset(center.dx + 10, center.dy - 135), _linePaint);

      canvas.drawLine(Offset(center.dx - 10, center.dy + 135),
          Offset(center.dx, center.dy + 150), _linePaint);
      canvas.drawLine(Offset(center.dx + 10, center.dy + 135),
          Offset(center.dx, center.dy + 150), _linePaint);
      canvas.drawLine(Offset(center.dx - 10, center.dy + 135),
          Offset(center.dx + 10, center.dy + 135), _linePaint);
    }

    if (mode != JoystickMode.vertical) {
      // draw horizontal arrows
      canvas.drawLine(Offset(center.dx - 135, center.dy - 10),
          Offset(center.dx - 150, center.dy), _linePaint);
      canvas.drawLine(Offset(center.dx - 135, center.dy + 10),
          Offset(center.dx - 150, center.dy), _linePaint);
      canvas.drawLine(Offset(center.dx - 135, center.dy - 10),
          Offset(center.dx - 135, center.dy + 10), _linePaint);

      canvas.drawLine(Offset(center.dx + 135, center.dy - 10),
          Offset(center.dx + 150, center.dy), _linePaint);
      canvas.drawLine(Offset(center.dx + 135, center.dy + 10),
          Offset(center.dx + 150, center.dy), _linePaint);
      canvas.drawLine(Offset(center.dx + 135, center.dy - 10),
          Offset(center.dx + 135, center.dy + 10), _linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CustomJoystickStick extends StatelessWidget {
  const CustomJoystickStick({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              blurRadius: 25,
              color: Colors.black54,
              spreadRadius: 10,
              offset: Offset(0, 10))
        ],
      ),
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Colors.blue,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.blue.shade700,
                Colors.blue.shade400,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
