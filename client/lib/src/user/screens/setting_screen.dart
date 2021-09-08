import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/auth_event.dart';
import 'package:eshiblood/src/auth/bloc/login_bloc.dart';
import 'package:eshiblood/src/auth/bloc/login_event.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffd32026),
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              print('Logout Clicked From Home Screen');
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              BlocProvider.of<LoginBloc>(context).add(LoginLoggedOut());
              Navigator.of(context).popAndPushNamed(RouteGenerator.loginScreen);
            },
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            trailing: Icon(Icons.arrow_right),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(
              color: Colors.grey,
              height: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}
