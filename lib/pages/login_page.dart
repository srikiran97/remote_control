import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_control/blocs/login_cubit/login_cubit.dart';
import 'package:remote_control/constants.dart';
import 'package:remote_control/pages/signup_page.dart';
import 'package:remote_control/utils/error_dialog.dart';
import 'package:validators/validators.dart';

class LogInUser extends StatefulWidget {
  static const String routeName = '/login';
  const LogInUser({super.key});

  @override
  State<LogInUser> createState() => _LogInUserState();
}

class _LogInUserState extends State<LogInUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AutovalidateMode _autoValidateMode;
  late bool _isObscure;
  String? _email, _password;

  @override
  void initState() {
    super.initState();
    _autoValidateMode = AutovalidateMode.disabled;
    _isObscure = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submit() {
    setState(() {
      _autoValidateMode = AutovalidateMode.always;
    });
    final FormState? form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    context.read<LoginCubit>().logIn(email: _email!, password: _password!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Stack(
        children: [
          Image.asset(
            backgroundImage,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autoValidateMode,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(
                          height: 75,
                          child: Center(
                              child: Text(
                            'Log In',
                            style: headingTextStyle,
                          )),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: fieldBorderRadius),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: fieldBorderRadius),
                            border: OutlineInputBorder(
                                borderRadius: fieldBorderRadius),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!isEmail(value.trim())) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _email = newValue;
                          },
                        ),
                        const SizedBox(height: 20),
                        StatefulBuilder(builder: (context, setState) {
                          return TextFormField(
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                                hintText: 'Password',
                                filled: true,
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                hintStyle: const TextStyle(color: Colors.grey),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: fieldBorderRadius),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: fieldBorderRadius),
                                border: const OutlineInputBorder(
                                    borderRadius: fieldBorderRadius),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                suffixIcon: TextButton(
                                    style: ButtonStyle(
                                      overlayColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.transparent),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                    child: Text(
                                      !_isObscure ? 'Hide' : 'Show',
                                      style: TextStyle(
                                          color: !_isObscure
                                              ? Colors.grey
                                              : Colors.blue),
                                    ))),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Password is required';
                              }
                              if (value.trim().length < 6) {
                                return 'Password must be at least 6 characters in length';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _password = newValue;
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                resizeToAvoidBottomInset: false,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        BlocConsumer<LoginCubit, LoginState>(
                          listener: (context, state) async {
                            if (state.logInStatus == LoginStatus.failure) {
                              final bool? needSignUp =
                                  await errorDialog(context, state.error);
                              if (needSignUp != null && needSignUp && mounted) {
                                Navigator.pushNamed(
                                    context, SignUpUser.routeName);
                              }
                            }
                          },
                          builder: (context, state) {
                            return SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: TextButton(
                                onPressed:
                                    state.logInStatus == LoginStatus.loading
                                        ? null
                                        : _submit,
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                ),
                                child: Text(
                                  state.logInStatus == LoginStatus.loading
                                      ? 'Loading...'
                                      : 'Log In',
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, SignUpUser.routeName);
                          },
                          child: Text(
                            'Already have an account? Sign Up',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
