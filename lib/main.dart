import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_control/blocs/authentication/auth_bloc/authentication_bloc.dart';
import 'package:remote_control/blocs/login_cubit/login_cubit.dart';
import 'package:remote_control/pages/homepage.dart';
import 'package:remote_control/pages/login_page.dart';

import 'blocs/remote_control/brush_switch_bloc/brush_switch_bloc.dart';
import 'blocs/remote_control/clean_process+bloc/clean_process_bloc.dart';
import 'blocs/remote_control/speed_slider_bloc/speed_slider_bloc.dart';
import 'blocs/remote_control/water_switch_bloc/water_switch_bloc.dart';
import 'blocs/signup_cubit/signup_cubit.dart';
import 'blocs/user_details_cubit/user_details_cubit.dart';
import 'firebase_options.dart';
import 'pages/signup_page.dart';
import 'pages/splash_page.dart';
import 'repositories/auth_repository.dart';
import 'repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseFirestore: FirebaseFirestore.instance,
              firebaseAuth: FirebaseAuth.instance),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) =>
              UserRepository(firebaseFirestore: FirebaseFirestore.instance),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) =>
                AuthenticationBloc(context.read<AuthRepository>()),
          ),
          BlocProvider<LoginCubit>(
              create: (context) => LoginCubit(context.read<AuthRepository>())),
          BlocProvider<SignupCubit>(
              create: (context) => SignupCubit(context.read<AuthRepository>())),
          BlocProvider<UserDetailsCubit>(
              create: (context) =>
                  UserDetailsCubit(context.read<UserRepository>())),
        ],
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.transparent,
            ),
          ),
          home: const SplashPage(),
          routes: {
            LogInUser.routeName: (context) => const LogInUser(),
            SignUpUser.routeName: (context) => const SignUpUser(),
            HomePage.routeName: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<CleanProcessBloc>(
                      create: (context) => CleanProcessBloc(),
                    ),
                    BlocProvider<WaterSwitchBloc>(
                      create: (context) => WaterSwitchBloc(),
                    ),
                    BlocProvider<BrushSwitchBloc>(
                      create: (context) => BrushSwitchBloc(),
                    ),
                    BlocProvider<SpeedSliderBloc>(
                      create: (context) => SpeedSliderBloc(),
                    )
                  ],
                  child: const HomePage(),
                ),
          },
        ),
      ),
    );
  }
}
