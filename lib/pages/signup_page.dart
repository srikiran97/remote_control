import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_control/constants.dart';
import 'package:remote_control/pages/login_page.dart';
import 'package:remote_control/utils/error_dialog.dart';
import 'package:validators/validators.dart';

import '../blocs/signup_cubit/signup_cubit.dart';

class SignUpUser extends StatefulWidget {
  static const String routeName = '/signUp';
  const SignUpUser({super.key});

  @override
  State<SignUpUser> createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AutovalidateMode _autoValidateMode;
  late final TextEditingController _passwordController;
  late bool _isObscure;
  String? _name, _email, _password;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _autoValidateMode = AutovalidateMode.disabled;
    _isObscure = true;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _autoValidateMode = AutovalidateMode.always;
    });
    final FormState? form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    context
        .read<SignupCubit>()
        .signup(name: _name!, email: _email!, password: _password!);
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
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autoValidateMode,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(
                          height: 50,
                          child: Center(
                              child: Text(
                            'Sign Up',
                            style: headingTextStyle,
                          )),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Name',
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
                              return 'Name is required';
                            }
                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _name = newValue;
                          },
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
                        const SizedBox(height: 10),
                        StatefulBuilder(builder: (context, setState) {
                          return TextFormField(
                            controller: _passwordController,
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
                        const SizedBox(height: 10),
                        TextFormField(
                          obscureText: _isObscure,
                          decoration: const InputDecoration(
                            hintText: 'Confirm password',
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
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (value) {
                            if (_passwordController.text != value) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _password = newValue;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              BlocConsumer<SignupCubit, SignupState>(
                                listener: (context, state) {
                                  if (state.signupStatus ==
                                      SignupStatus.failure) {
                                    errorDialog(context, state.error);
                                  }
                                },
                                builder: (context, state) {
                                  return SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                    child: TextButton(
                                      onPressed: state.signupStatus ==
                                              SignupStatus.loading
                                          ? null
                                          : () {
                                              FocusScope.of(context).unfocus();
                                              _submit();
                                            },
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
                                        state.signupStatus ==
                                                SignupStatus.loading
                                            ? 'Loading...'
                                            : 'Sign Up',
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
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      LogInUser.routeName, (route) => false);
                                },
                                child: Text(
                                  'Already a member? Log In!',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
