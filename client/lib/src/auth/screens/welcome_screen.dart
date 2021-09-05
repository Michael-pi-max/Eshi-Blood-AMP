import 'package:eshiblood/src/auth/bloc/auth_event.dart';
import 'package:eshiblood/src/auth/bloc/auth_state.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:eshiblood/src/auth/widgets/horizontal_divider.dart';
import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/welcome_background_image.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 120.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/eshi_blood_logo.png',
                        height: 100.0,
                        width: 100.0,
                      ),
                      SizedBox(
                        width: 6.0,
                      ),
                      Text(
                        'Eshi Blood',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                ),
                RoundButton(
                  color: Color(0xffd32026),
                  onPressed: () {
                    // BlocProvider.of<AuthenticationBloc>(context).add(WelcomeScreenCompleted());
                    Navigator.of(context).pushNamed(RouteGenerator.loginScreen);
                  },
                  text: 'Login',
                  textColor: Color(0xffffffff),
                ),
                HorizontalDivider(label: 'or', height: 4.0),
                RoundButton(
                  text: 'Signup',
                  color: Color(0xffffffff),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(RouteGenerator.eligibilityNoticeScreen);
                  },
                  textColor: Color(0xffd32026),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
