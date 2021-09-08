import 'package:eshiblood/src/admin/screens/dashboard_screen.dart';

import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/auth_state.dart';
import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:eshiblood/src/role_management/bloc/role_bloc.dart';
import 'package:eshiblood/src/role_management/bloc/role_event.dart';
import 'package:eshiblood/src/role_management/bloc/role_state.dart';
import 'package:eshiblood/src/userList/bloc/user_list_bloc.dart';
import 'package:eshiblood/src/userList/bloc/user_list_event.dart';
import 'package:eshiblood/src/userList/models/user_args.dart';
import 'package:eshiblood/src/utilities/constants.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetails extends StatefulWidget {
  final UserArguments args;
  UserDetails({required this.args});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String valueStr = '';
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<RoleBloc>(context).add(RoleLoad());
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Color(0xffd32026),
      ),
      drawer: NavigationDrawerWidget(),
      body: Column(
        children: [
          CircleAvatar(
            radius: 100.0,
            backgroundImage: NetworkImage(
                '${Constants.imageBaseUrl}images/users/${widget.args.user?.image}',
                scale: 1.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Name ${widget.args.user?.firstName} ${widget.args.user?.lastName}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Role ${widget.args.user?.role["roleName"]}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Phone Number ${widget.args.user?.phoneNumber}'),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<RoleBloc, RoleState>(
              builder: (context, roleState) {
                if (roleState is RolesLoadSuccess) {
                  return ListView.builder(
                    itemCount: roleState.roles.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                          activeColor: roleState.roles[index].roleName ==
                                  widget.args.user?.role
                              ? Colors.green
                              : Colors.grey,
                          title: Text(roleState.roles[index].roleName),
                          value: roleState.roles[index].roleName,
                          groupValue: valueStr,
                          onChanged: (String? value) {
                            setState(() {
                              valueStr = value!;
                            });
                          });
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, userState) {
              return (userState is AuthenticationAuthenticated)
                  ? BlocBuilder<RoleBloc, RoleState>(
                      builder: (context, roleState) {
                        return roleState is RolesLoadSuccess
                            ? RoundButton(
                                text: 'Update Role',
                                color: Color(0xffd32026),
                                textColor: Colors.white,
                                onPressed: () {
                                  roleState.roles.forEach((element) {
                                    if (element.roleName == valueStr) {
                                      BlocProvider.of<UserListBloc>(context)
                                          .add(UpdateUserEvent(
                                              userId: widget.args.user?.id,
                                              roleId: element.id));

                                      Navigator.pushNamed(context,
                                          RouteGenerator.userListScreen);
                                    }
                                  });
                                })
                            : Container();
                      },
                    )
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}
