import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/auth_state.dart';
import 'package:eshiblood/src/auth/bloc/form_submission_status.dart';
import 'package:eshiblood/src/auth/bloc/login_bloc.dart';
import 'package:eshiblood/src/auth/bloc/login_event.dart';
import 'package:eshiblood/src/auth/bloc/login_state.dart';
import 'package:eshiblood/src/auth/bloc/password_visibility_bloc.dart';
import 'package:eshiblood/src/auth/bloc/password_visibility_state.dart';
import 'package:eshiblood/src/auth/widgets/horizontal_divider.dart';
import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:eshiblood/src/auth/widgets/text_input.dart';
import 'package:eshiblood/src/auth/widgets/wave_widget.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, stateLogin) async {
            final formStatus = stateLogin.formStatus;
            if (formStatus is SubmissionFailed) {
              _showSnackBar(context, formStatus.errorMessage.toString());
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) async {
          final userRole =
              await context.read<AuthenticationBloc>().userRepository.getRole();
          final token = await context
              .read<AuthenticationBloc>()
              .userRepository
              .hasToken();
          BlocProvider.of<LoginBloc>(context).add(LoginLoggedOut());
          if (token) {
            if (userRole == 'user') {
              Navigator.of(context).pushNamed(RouteGenerator.homeScreen);
            } else if (userRole == 'admin') {
              Navigator.of(context).pushNamed(RouteGenerator.dashboardScreen);
            }
          }
        }),
      ],
      child: BlocProvider(
        create: (context) => ToggleBloc(),
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: size.height - 200,
                color: Color(0xFFD32026),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeOutQuad,
                top: keyboardOpen ? -size.height / 3.7 : 0.0,
                child: WaveWidget(
                  size: size,
                  yOffset: size.height / 3.0,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 140.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: keyboardOpen
                          ? Container()
                          : Image.asset(
                              'assets/images/eshi_blood_logo.png',
                              width: 140.0,
                            ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text('Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0,
                        ),
                        BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                          return TextInput(
                            prefixIcon: Icons.phone,
                            labelText: 'Phone Number',
                            hintText: '09********',
                            keyboardType: TextInputType.phone,
                            obsecureText: false,
                            onChanged: (value) => context.read<LoginBloc>().add(
                                LoginPhoneNumberChanged(phoneNumber: value)),
                            onValidate: (value) => state.isPhoneNumberValid
                                ? null
                                : 'Invalid Phone Number',
                          );
                        }),
                        SizedBox(
                          height: 10.0,
                        ),
                        BlocBuilder<ToggleBloc, VisibilityState>(
                            builder: (context, toggleState) {
                          return BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              return TextInput(
                                prefixIcon: Icons.lock,
                                suffixIcon: toggleState.isVisible
                                    ? IconButton(
                                        onPressed: () {
                                          context.read<ToggleBloc>().add(
                                              ToggleEvent.toggleVisibility);
                                        },
                                        icon: Icon(Icons.visibility_off))
                                    : IconButton(
                                        onPressed: () {
                                          context.read<ToggleBloc>().add(
                                              ToggleEvent.toggleVisibility);
                                        },
                                        icon: Icon(Icons.visibility)),
                                labelText: 'Password',
                                hintText: '🔑🔑',
                                keyboardType: TextInputType.visiblePassword,
                                obsecureText: toggleState.isVisible,
                                onChanged: (value) => context
                                    .read<LoginBloc>()
                                    .add(LoginPasswordChanged(password: value)),
                                onValidate: (value) => state.isPasswordValid
                                    ? null
                                    : 'Password must be at least 4 character',
                              );
                            },
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            return state.formStatus is FormSubmitting
                                ? RoundButton(
                                    text: 'Loading...',
                                    onPressed: null,
                                    color: Colors.grey,
                                    textColor: Colors.white,
                                  )
                                : RoundButton(
                                    text: 'LogIn',
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        context
                                            .read<LoginBloc>()
                                            .add(LoginSubmitted());
                                      }
                                    },
                                    color: Color(0xFFD32026),
                                    textColor: Colors.white,
                                  );
                          },
                        ),
                        HorizontalDivider(
                          label: 'or',
                          height: 4.0,
                        ),
                        RoundButton(
                          text: 'Sign Up',
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RouteGenerator.registrationScreen);
                          },
                          color: Color(0xFFFFFFFF),
                          textColor: Color(0xFFD32026),
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
