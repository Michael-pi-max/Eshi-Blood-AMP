import 'package:eshiblood/src/admin/screens/dashboard_screen.dart';
import 'package:eshiblood/src/auth/widgets/horizontal_divider.dart';
import 'package:eshiblood/src/role_management/bloc/role_bloc.dart';
import 'package:eshiblood/src/role_management/bloc/role_event.dart';
import 'package:eshiblood/src/role_management/bloc/role_state.dart';
import 'package:eshiblood/src/role_management/models/role_args.dart';
import 'package:eshiblood/src/role_management/models/role_model.dart';
import 'package:eshiblood/src/utilities/routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleDetails extends StatelessWidget {
  final RoleArgument args;
  static dynamic roleNameController = TextEditingController();

  RoleDetails({required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleBloc, RoleState>(
      builder: (context, state) {
        if (state is RoleLoading) {
          return CircularProgressIndicator();
        }
        return Scaffold(
          appBar: AppBar(
            title: args.edit == true
                ? Text("Edit Role Management")
                : args.create == true
                    ? Text("Create Role Management")
                    : Text("Detail Role Management"),
            backgroundColor: Color(0xffd32026),
          ),
          drawer: NavigationDrawerWidget(),
          body: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2,
                          color: Colors.black12,
                          offset: Offset(1, 1),
                          spreadRadius: 2)
                    ]),
                child: Column(
                  children: [
                    (args.edit)
                        ? Container(
                            padding: EdgeInsets.only(top: 25.0),
                            height: 40.0,
                            child: Text(
                              'Role ${args.edit ? 'Edit' : 'Details'} of ${args.role?.roleName}',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          )
                        : (args.create)
                            ? Container(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  controller: roleNameController,
                                  style: TextStyle(
                                    height: 1.2,
                                    fontSize: 20,
                                  ),
                                  cursorColor: Color(0xFFD32026),
                                  decoration: InputDecoration(
                                    hintText: "Role Name",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 20),
                                    labelText: "Role",
                                    labelStyle: TextStyle(
                                        color: Colors.redAccent, fontSize: 14),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFD32026), width: 2),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFD32026), width: 2),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.only(top: 25.0),
                                height: 40.0,
                                child: Text(
                                  'Role ${args.edit ? 'Edit' : 'Details'} of ${args.role?.roleName}',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                    SizedBox(
                      height: 20,
                    ),
                    HorizontalDivider(
                      height: 1,
                      label: "Privileges:  ",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    PreviligeBuilder(
                      args: args,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PreviligeBuilder extends StatefulWidget {
  final RoleArgument args;

  PreviligeBuilder({required this.args});

  @override
  _PreviligeBuilderState createState() => _PreviligeBuilderState();
}

class _PreviligeBuilderState extends State<PreviligeBuilder> {
  Map<String, dynamic> result = {"roleName": '', "privileges": []};
  Map<String, dynamic> mainResult = {"roleName": '', "privileges": []};
  Map<String, dynamic> forCreate = {
    "roleName": '',
    "privileges": [
      {"title": "user", "permissions": []},
      {"title": "role", "permissions": []},
      {"title": "request", "permissions": []},
      {"title": "donationCenter", "permissions": []},
      {"title": "appointment", "permissions": []},
    ]
  };

  @override
  Widget build(BuildContext context) {
    mainResult["roleName"] = (widget.args.create)
        ? forCreate["roleName"] = "newRole"
        : widget.args.role?.roleName;

    mainResult["privileges"] = (widget.args.edit)
        ? widget.args.role?.privileges
            .map((privilege) => {
                  "title": privilege["title"],
                  "permissions": privilege["permissions"]
                })
            .toList()
        : (widget.args.create)
            ? forCreate
            : widget.args.role?.privileges
                .map((privilege) => {
                      "title": privilege["title"],
                      "permissions": privilege["permissions"]
                    })
                .toList();

    result = widget.args.edit
        ? {
            "appointment": mainResult["privileges"][4]["permissions"],
            "request": mainResult["privileges"][2]["permissions"],
            "donationcenter": mainResult["privileges"][3]["permissions"],
            "role": mainResult["privileges"][1]["permissions"],
            "user": mainResult["privileges"][0]["permissions"]
          }
        : widget.args.create
            ? {
                "appointment": forCreate["privileges"][4]["permissions"],
                "request": forCreate["privileges"][2]["permissions"],
                "donationcenter": forCreate["privileges"][3]["permissions"],
                "role": forCreate["privileges"][1]["permissions"],
                "user": forCreate["privileges"][0]["permissions"]
              }
            : {
                "appointment": mainResult["privileges"][4]["permissions"],
                "request": mainResult["privileges"][2]["permissions"],
                "donationcenter": mainResult["privileges"][3]["permissions"],
                "role": mainResult["privileges"][1]["permissions"],
                "user": mainResult["privileges"][0]["permissions"]
              };

    dynamic changeResultState = (title, permission) {
      setState(() {
        if (result[title].contains(permission)) {
          result[title].remove(permission);
        } else {
          result[title].add(permission);
        }
      });
    };
    return Column(
      children: [
        checkBoxBuild('Appointment', changeResultState),
        paddedHorizontalLine(),
        checkBoxBuild('Request', changeResultState),
        paddedHorizontalLine(),
        checkBoxBuild('DonationCenter', changeResultState),
        paddedHorizontalLine(),
        checkBoxBuild('Role', changeResultState),
        paddedHorizontalLine(),
        checkBoxBuild('User', changeResultState),
        paddedHorizontalLine(),
        (widget.args.edit)
            ? BlocBuilder<RoleBloc, RoleState>(
                builder: (context, roleState) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          print("clicked");
                          BlocProvider.of<RoleBloc>(context).add(RoleUpdate(
                              Role(
                                  id: widget.args.role?.id,
                                  roleName: '${widget.args.role?.roleName}',
                                  privileges: mainResult["privileges"])));
                          Navigator.pushNamed(
                            context,
                            RouteGenerator.roleManage,
                          );
                        },
                        child: Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                            child: Text(
                              "Submit role",
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : (widget.args.create)
                ? BlocBuilder<RoleBloc, RoleState>(
                    builder: (context, roleState) {
                      // print(RoleDetails.roleNameController.text);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              print("clicked");
                              BlocProvider.of<RoleBloc>(context).add(RoleCreate(
                                  Role(
                                      roleName:
                                          '${RoleDetails.roleNameController.text}',
                                      privileges: forCreate["privileges"])));
                              Navigator.pushNamed(
                                context,
                                RouteGenerator.roleManage,
                              );
                            },
                            child: Container(
                              width: 300,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Center(
                                child: Text(
                                  "Create role",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Container()
      ],
    );
  }

  Widget checkBoxBuild(String title, dynamic handleResultChange) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '${title}',
          textAlign: TextAlign.start,
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      activeColor: widget.args.edit
                          ? Colors.blueAccent
                          : widget.args.create
                              ? Colors.blueAccent
                              : Colors.grey,
                      value: result[title.replaceAll(' ', '').toLowerCase()]
                          .contains("create"),
                      onChanged: (bool? value) => widget.args.edit
                          ? handleResultChange(
                              title.replaceAll(' ', '').toLowerCase(), "create")
                          : widget.args.create
                              ? handleResultChange(
                                  title.replaceAll(' ', '').toLowerCase(),
                                  "create")
                              : null,
                    ),
                    Text('CREATE')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        activeColor: widget.args.edit
                            ? Colors.blueAccent
                            : widget.args.create
                                ? Colors.blueAccent
                                : Colors.grey,
                        value: result[title.replaceAll(' ', '').toLowerCase()]
                            .contains("read"),
                        onChanged: (bool? value) => widget.args.edit
                            ? handleResultChange(
                                title.replaceAll(' ', '').toLowerCase(), "read")
                            : widget.args.create
                                ? handleResultChange(
                                    title.replaceAll(' ', '').toLowerCase(),
                                    "read")
                                : null),
                    Text('READ')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        activeColor: widget.args.edit
                            ? Colors.blueAccent
                            : widget.args.create
                                ? Colors.blueAccent
                                : Colors.grey,
                        value: result[title.replaceAll(' ', '').toLowerCase()]
                            .contains("update"),
                        onChanged: (bool? value) => widget.args.edit
                            ? handleResultChange(
                                title.replaceAll(' ', '').toLowerCase(),
                                "update")
                            : widget.args.create
                                ? handleResultChange(
                                    title.replaceAll(' ', '').toLowerCase(),
                                    "update")
                                : null),
                    Text('UPDATE')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        activeColor: widget.args.edit
                            ? Colors.blueAccent
                            : widget.args.create
                                ? Colors.blueAccent
                                : Colors.grey,
                        value: result[title.replaceAll(' ', '').toLowerCase()]
                            .contains("delete"),
                        onChanged: (bool? value) => widget.args.edit
                            ? handleResultChange(
                                title.replaceAll(' ', '').toLowerCase(),
                                "delete")
                            : widget.args.create
                                ? handleResultChange(
                                    title.replaceAll(' ', '').toLowerCase(),
                                    "delete")
                                : null),
                    Text('DELETE')
                  ],
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class paddedHorizontalLine extends StatelessWidget {
  const paddedHorizontalLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Divider(
          height: 1,
          color: Color(0xffd32026),
          indent: 40,
          endIndent: 40,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
