import 'package:eshiblood/src/admin/screens/dashboard_screen.dart';

import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/auth_state.dart';
import 'package:eshiblood/src/userList/bloc/user_list_bloc.dart';
import 'package:eshiblood/src/userList/bloc/user_list_event.dart';
import 'package:eshiblood/src/userList/bloc/user_list_state.dart';
import 'package:eshiblood/src/userList/models/user_args.dart';
import 'package:eshiblood/src/utilities/constants.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UserListBloc>(context).add(UserListEvent([]));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffd32026),
        title: Text("Users List"),
      ),
      drawer: NavigationDrawerWidget(),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, authState) {
          return (authState is AuthenticationAuthenticated)
              ? BlocBuilder<UserListBloc, UserListState>(
                  builder: (context, userListState) {
                    print(userListState);
                    if (userListState is UserListStateLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (userListState is UserListStateLoaded) {
                      return (userListState is UserListStateLoading)
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                itemCount: userListState.users.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return (userListState.users[index].id !=
                                          authState.user?.id)
                                      ? Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    RouteGenerator.userDetails,
                                                    arguments: UserArguments(
                                                        user: userListState
                                                            .users[index]));
                                              },
                                              child: Container(
                                                height: 200,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.45,
                                                margin: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.025),
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 3,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 2),
                                                    )
                                                  ],
                                                ),
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundImage: NetworkImage(
                                                      '${Constants.imageBaseUrl}images/users/${userListState.users[index].image}'),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: userListState
                                                            .users[index]
                                                            .role["roleName"] ==
                                                        'admin'
                                                    ? Colors.blueAccent
                                                    : Colors.redAccent,
                                                child: Text(
                                                    '${authState.user?.id == userListState.users[index].id ? 'You' : userListState.users[index].role["roleName"]}'),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    RouteGenerator
                                                        .profileScreen);
                                              },
                                              child: Container(
                                                height: 200,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.45,
                                                margin: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.025),
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 3,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 2),
                                                    )
                                                  ],
                                                ),
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundImage: NetworkImage(
                                                      '${Constants.imageBaseUrl}images/users/${userListState.users[index].image}'),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: userListState
                                                            .users[index]
                                                            .role["roleName"] ==
                                                        'admin'
                                                    ? Colors.blueAccent
                                                    : Colors.redAccent,
                                                child: Text(
                                                    '${authState.user?.id == userListState.users[index].id ? 'you' : userListState.users[index].role["roleName"]}'),
                                              ),
                                            ),
                                          ],
                                        );
                                },
                              ),
                            );
                    }
                    return Container();
                  },
                )
              : Container();
        },
      ),
    );
  }
}
