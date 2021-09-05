import 'package:eshiblood/src/admin/screens/dashboard_screen.dart';
import 'package:eshiblood/src/role_management/bloc/role_bloc.dart';
import 'package:eshiblood/src/role_management/bloc/role_event.dart';
import 'package:eshiblood/src/role_management/bloc/role_state.dart';
import 'package:eshiblood/src/role_management/models/role_args.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleManage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<RoleBloc>(context)..add(RoleLoad());
    return BlocBuilder<RoleBloc, RoleState>(
      builder: (context, roleState) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xffd32026),
              title: Text('Role Management'),
            ),
            drawer: NavigationDrawerWidget(),
            body: Column(
              children: [
                Container(
                  height: 180,
                  padding: EdgeInsets.all(15.0),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Roles Available',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      BlocBuilder<RoleBloc, RoleState>(
                        builder: (context, roleState) {
                          if (roleState is RoleLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (roleState is RolesLoadSuccess) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '${roleState.roles.length} ',
                                          style: TextStyle(
                                              fontSize: 44,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFD32026))),
                                      TextSpan(
                                          text: 'Roles',
                                          style: TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<RoleBloc, RoleState>(
                    builder: (context, roleState) {
                      if (roleState is RoleLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (roleState is RolesLoadSuccess) {
                        return ListView.builder(
                            itemCount: roleState.roles.length,
                            itemBuilder: (context, index) {
                              final item = roleState.roles[index].roleName;
                              return Dismissible(
                                background: Container(
                                  color: Color(0xffd32026),
                                ),
                                key: Key(item),
                                onDismissed: (direction) {
                                  BlocProvider.of<RoleBloc>(context)
                                      .add(RoleDelete(roleState.roles[index]));
                                  print(
                                      '${roleState.roles[index].id} dissmissed');
                                },
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(
                                      roleState.roles[index].roleName
                                              .contains('admin')
                                          ? Icons.admin_panel_settings
                                          : Icons.admin_panel_settings_outlined,
                                      size: 56.0,
                                    ),
                                    title: Text(
                                      '${roleState.roles[index].roleName}',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    subtitle: Text('Here is a second line'),
                                    trailing: Wrap(
                                      spacing: 2.0,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                RouteGenerator.roleDetails,
                                                arguments: RoleArgument(
                                                    role:
                                                        roleState.roles[index],
                                                    edit: false));
                                          },
                                          child: Icon(Icons.article_outlined),
                                        ),
                                        SizedBox(width: 10.0),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  RouteGenerator.roleDetails,
                                                  arguments: RoleArgument(
                                                      role: roleState
                                                          .roles[index],
                                                      edit: true));
                                            },
                                            child: Icon(Icons.edit)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteGenerator.roleDetails,
                    arguments: RoleArgument(create: true));
              },
              child: Icon(Icons.add),
              backgroundColor: Color(0xffd32026),
            ));
      },
    );
  }
}
