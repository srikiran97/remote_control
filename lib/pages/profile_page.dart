import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_control/blocs/authentication/auth_bloc/authentication_bloc.dart';
import 'package:remote_control/blocs/user_details_cubit/user_details_cubit.dart';
import 'package:remote_control/constants.dart';
import 'package:remote_control/utils/error_dialog.dart';
import 'package:toggle_switch/toggle_switch.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late double _coverheight;
  late double _profileheight;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    selectedIndex = 0;
  }

  void _getUserDetails() {
    final String uid = context.read<AuthenticationBloc>().state.user!.uid;
    context.read<UserDetailsCubit>().getUserDetails(uid: uid);
  }

  @override
  Widget build(BuildContext context) {
    _coverheight = MediaQuery.of(context).size.height * 0.30;
    _profileheight = MediaQuery.of(context).size.height * 0.15;
    return Scaffold(
      body: BlocConsumer<UserDetailsCubit, UserDetailsState>(
        listener: (context, state) {
          if (state.status == UserDetailsStatus.failure) {
            errorDialog(context, state.error);
          }
        },
        buildWhen: (previous, current) {
          return current.status == UserDetailsStatus.success ||
              current.status == UserDetailsStatus.loading;
        },
        builder: (context, state) {
          if (state.status == UserDetailsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              _buildTopCover(),
              const SizedBox(height: 25),
              _buildProfileDetails(),
              const SizedBox(height: 5),
              Expanded(child: _buildContent()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopCover() {
    final double top = _coverheight - _profileheight / 1.25;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        _buildCoverImage(),
        SafeArea(child: _buildTopBar()),
        Positioned(top: top, child: _buildProfileImage()),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {},
            child: const Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const Text('Profile', style: appBarTitle),
          InkWell(
            onTap: () {
              context.read<AuthenticationBloc>().add(SignOutRequestedEvent());
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage() {
    return Image.asset(
      backgroundImage,
      width: double.infinity,
      height: _coverheight,
      fit: BoxFit.fill,
    );
  }

  Widget _buildProfileImage() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black12, spreadRadius: 1)
        ],
      ),
      child: CircleAvatar(
        radius: _profileheight / 2,
        backgroundColor: Colors.white,
        child: CircleAvatar(
            radius: _profileheight / 2 - 5,
            backgroundImage: Image.asset(
              'assets/user_profile_avatar.webp',
              width: double.infinity,
              height: _coverheight,
              fit: BoxFit.fill,
            ).image),
      ),
    );
  }

  Widget _buildProfileDetails() {
    LinearGradient gradient = const LinearGradient(
      colors: [
        Color(0xFF1699FF),
        Color(0xFF2467F2),
        Color(0xFF834EC2),
        Color(0xFFE45487),
        Color(0xFFF56A67),
        Color(0xFFFFA766),
      ],
    );
    return BlocBuilder<UserDetailsCubit, UserDetailsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => gradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Text(state.userDetails.name,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    )),
              ),
              const SizedBox(height: 5),
              Text('Cleaning Hours: ${state.userDetails.cleaningHours}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    TextStyle timeStampStyle = const TextStyle(color: Colors.grey);
    final ScrollController controller = ScrollController();
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width / 2,
                  cornerRadius: 20.0,
                  activeBgColors: const [
                    [Colors.white],
                    [Colors.white]
                  ],
                  borderColor: [Colors.grey.shade300, Colors.grey.shade300],
                  borderWidth: 1,
                  activeFgColor: Colors.blue,
                  inactiveBgColor: Colors.grey.shade100,
                  inactiveFgColor: Colors.grey.shade500,
                  initialLabelIndex: selectedIndex,
                  totalSwitches: 2,
                  fontSize: 16,
                  labels: const ['Points', 'Badges'],
                  radiusStyle: true,
                  onToggle: (index) {
                    selectedIndex = index!;
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: BlocBuilder<UserDetailsCubit, UserDetailsState>(
                  builder: (context, state) {
                    if (state.userDetails.noOfPoints <= 0 &&
                        selectedIndex == 0) {
                      return const Center(
                        child: Text('No Points achieved yet!'),
                      );
                    } else if (state.userDetails.noOfBadges <= 0 &&
                        selectedIndex == 1) {
                      return const Center(
                        child: Text('No Badges achieved yet!'),
                      );
                    }
                    return ListView.separated(
                        controller: controller,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: selectedIndex == 0
                            ? state.userDetails.noOfPoints
                            : state.userDetails.noOfBadges,
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 1,
                            indent: 72,
                            color: Colors.grey,
                          );
                        },
                        itemBuilder: (context, index) {
                          index = index + 1;
                          if (selectedIndex == 0) {
                            return ListTile(
                              leading: const Icon(
                                Icons.badge,
                                size: 35,
                              ),
                              title: Text('Point $index Title'),
                              subtitle: Text('Point $index description'),
                              isThreeLine: true,
                              trailing: Text(
                                '0m ago',
                                style: timeStampStyle,
                              ),
                            );
                          }
                          return ListTile(
                            leading: const Icon(
                              Icons.star,
                              size: 35,
                            ),
                            title: Text('Badge $index Title'),
                            subtitle: Text('Badge $index description'),
                            isThreeLine: true,
                            trailing: Text(
                              '0m ago',
                              style: timeStampStyle,
                            ),
                          );
                        });
                  },
                ),
              )
            ],
          ));
    });
  }
}
