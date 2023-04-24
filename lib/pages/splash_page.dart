import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_control/pages/homepage.dart';
import 'package:remote_control/pages/login_page.dart';

import '../blocs/authentication/auth_bloc/authentication_bloc.dart';

class SplashPage extends StatelessWidget {
  static const String routeName = '/';
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        if (state.authenticationStatus ==
            AuthenticationStatus.unauthenticated) {
          await Future.delayed(const Duration(seconds: 2))
              .then((value) => Navigator.pushNamedAndRemoveUntil(
                    context,
                    LogInUser.routeName,
                    (route) {
                      return route.settings.name ==
                          ModalRoute.of(context)!.settings.name;
                    },
                  ));
        } else if (state.authenticationStatus ==
            AuthenticationStatus.authenticated) {
          await Future.delayed(const Duration(seconds: 2)).then(
            (value) {
              Navigator.pushNamed(context, HomePage.routeName);
            },
          );
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
