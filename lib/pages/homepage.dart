import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:remote_control/pages/profile_page.dart';
import 'package:remote_control/pages/remote_control.dart';

import '../blocs/remote_control/brush_switch_bloc/brush_switch_bloc.dart';
import '../blocs/remote_control/clean_process+bloc/clean_process_bloc.dart';
import '../blocs/remote_control/speed_slider_bloc/speed_slider_bloc.dart';
import '../blocs/remote_control/water_switch_bloc/water_switch_bloc.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const <Widget>[
            UserProfile(),
            Center(
              child: Text("Messages..."),
            ),
            SizedBox(),
            Center(
              child: Text("Settings..."),
            ),
            SizedBox(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          padding: const EdgeInsets.only(top: 75),
          child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.blue,
              child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SvgPicture.asset(
                      'assets/robot.svg',
                      height: 45,
                      width: 45,
                      colorFilter:
                          const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                    ),
                  ))),
        ),
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            labelStyle: const TextStyle(fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            labelColor: Colors.blue,
            unselectedLabelColor: const Color.fromARGB(255, 0, 129, 201),
            labelPadding: EdgeInsets.zero,
            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
            onTap: (index) {
              if (index == 4) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) {
                    return BlocProvider.value(
                        value: context.read<CleanProcessBloc>(),
                        child: BlocProvider.value(
                          value: context.read<WaterSwitchBloc>(),
                          child: BlocProvider.value(
                            value: context.read<BrushSwitchBloc>(),
                            child: BlocProvider.value(
                              value: context.read<SpeedSliderBloc>(),
                              child: const RemoteControl(),
                            ),
                          ),
                        ));
                  },
                ));
                _tabController.index = 0;
              }
            },
            tabs: const <Widget>[
              Tab(
                iconMargin: EdgeInsets.only(bottom: 5),
                icon: Icon(
                  Icons.account_circle_outlined,
                  size: 35,
                ),
                text: 'Profile',
              ),
              Tab(
                iconMargin: EdgeInsets.only(bottom: 5),
                icon: Icon(
                  Icons.messenger_outline_rounded,
                  size: 35,
                ),
                text: 'Messages',
              ),
              SizedBox(),
              Tab(
                iconMargin: EdgeInsets.only(bottom: 5),
                icon: Icon(
                  Icons.settings_outlined,
                  size: 35,
                ),
                text: 'Settings',
              ),
              Tab(
                iconMargin: EdgeInsets.only(bottom: 5),
                icon: Icon(
                  Icons.settings_remote_outlined,
                  size: 35,
                ),
                text: 'Remote',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
