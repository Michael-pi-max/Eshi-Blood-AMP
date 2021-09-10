import 'package:eshiblood/src/appointment/bloc/appointment_bloc.dart';
import 'package:eshiblood/src/appointment/bloc/appointment_event.dart';
import 'package:eshiblood/src/appointment/bloc/blocs.dart';
import 'package:eshiblood/src/appointment/models/models.dart';
import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/auth_event.dart';
import 'package:eshiblood/src/auth/bloc/auth_state.dart';
import 'package:eshiblood/src/auth/bloc/login_bloc.dart';
import 'package:eshiblood/src/auth/bloc/login_event.dart';
import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:eshiblood/src/donation_center/screens/create_donation_center.dart';
import 'package:eshiblood/src/request/bloc/request_bloc.dart';
import 'package:eshiblood/src/request/bloc/request_event.dart';
import 'package:eshiblood/src/request/bloc/request_state.dart';
import 'package:eshiblood/src/request/screen/create_request.dart';
import 'package:eshiblood/src/role_management/models/role_args.dart';
import 'package:eshiblood/src/role_management/screens/role_manage.dart';
import 'package:eshiblood/src/user/screens/profile_screen.dart';
import 'package:eshiblood/src/userList/screens/users_screen.dart';
import 'package:eshiblood/src/utilities/constants.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<RequestBloc>(context).add(RequestsLoad());
    BlocProvider.of<AppointmentBloc>(context).add(AppointmentLoad());
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: Color(0xFFD32026),
        title: Text('Dashboard'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                padding: EdgeInsets.all(15.0),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Today\'s Appointments',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BlocBuilder<AppointmentBloc, AppointmentState>(
                          builder: (context, state) {
                            return (state is AppointmentOperationSuccess)
                                ? RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '${state.appointments.length} ',
                                          style: TextStyle(
                                            fontSize: 44,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFD32026),
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'People',
                                          style: TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BlocBuilder<RequestBloc, RequestState>(
                builder: (context, requestState) {
                  return BlocBuilder<AppointmentBloc, AppointmentState>(
                    builder: (context, appointmentState) {
                      return Container(
                        height: 200.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _pointTile(
                              context,
                              title: 'Appointments',
                              amount: (appointmentState
                                      is AppointmentOperationSuccess)
                                  ? '${appointmentState.appointments.length}'
                                  : '~',
                            ),
                            _pointTile(
                              context,
                              title: 'Requests',
                              amount: (requestState is RequestsLoadSuccess)
                                  ? '${requestState.requests.length}'
                                  : '~',
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              DefaultTabController(
                length: 2,
                child: Container(
                  height: 500,
                  child: Column(
                    children: <Widget>[
                      TabBar(
                        indicatorColor: Color(0xFFD32026),
                        tabs: <Widget>[
                          Tab(
                              child: Text('Appointments',
                                  style: TextStyle(color: Color(0xFFD32026)))),
                          Tab(
                              child: Text('Requests',
                                  style: TextStyle(color: Color(0xFFD32026)))),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            BlocBuilder<AppointmentBloc, AppointmentState>(
                              builder: (context, state) {
                                return Container(
                                  child: (state is AppointmentOperationSuccess)
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10.0),
                                          child: state.appointments.length > 0
                                              ? RefreshIndicator(
                                                  onRefresh: () async {
                                                    print(state.appointments);
                                                    BlocProvider.of<
                                                                AppointmentBloc>(
                                                            context)
                                                        .add(AppointmentLoad());
                                                    print(state.appointments);
                                                  },
                                                  child: ListView.builder(
                                                    itemCount: state
                                                        .appointments.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return appointmentTile(
                                                          context,
                                                          index,
                                                          state.appointments);
                                                    },
                                                  ),
                                                )
                                              : Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text("No Appointments"),
                                                    ],
                                                  ),
                                                ))
                                      : Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                );
                              },
                            ),
                            BlocBuilder<RequestBloc, RequestState>(
                              builder: (context, state) {
                                return Container(
                                  child: (state is RequestsLoadSuccess)
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10.0),
                                          child: (state.requests.length > 0)
                                              ? RefreshIndicator(
                                                  onRefresh: () async {
                                                    BlocProvider.of<
                                                                RequestBloc>(
                                                            context)
                                                        .add(RequestsLoad());
                                                  },
                                                  child: ListView.builder(
                                                    itemCount:
                                                        state.requests.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return requestTile(
                                                          context,
                                                          index,
                                                          state
                                                              .requests[index]);
                                                    },
                                                  ),
                                                )
                                              : Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text("No Request"),
                                                      RoundButton(
                                                        color:
                                                            Color(0xFFD32026),
                                                        textColor: Colors.white,
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                            RouteGenerator
                                                                .requestCreate,
                                                            arguments:
                                                                RequestArgument(
                                                                    edit:
                                                                        false),
                                                          );
                                                        },
                                                        text: 'Create Request',
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                      : Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appointmentTile(context, index, appointments) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${appointments[index].appointmentDescription}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    SizedBox(
                      height: 4.0,
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    appointments[index].acceptorId == null
                        ? Text(
                            'Status - ${appointments[index].acceptorId.firstName} ${appointments[index].acceptorId.lastName}',
                            style: TextStyle(fontSize: 15, color: Colors.grey))
                        : Text('Pending',
                            style: TextStyle(fontSize: 15, color: Colors.red)),
                    SizedBox(height: 6),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    child: CircleAvatar(
                      radius: 15,
                      child: Icon(Icons.check),
                    ),
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Appointment Donated?'),
                        content: const Text(
                            'If the donor donates with this appointment please accept it!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              BlocProvider.of<AppointmentBloc>(context)
                                  .add(AppointmentUpdate(
                                Appointment(
                                  id: appointments[index].id,
                                  userId: appointments[index].userId['_id'],
                                  startDate: appointments[index].startDate,
                                  endDate: appointments[index].endDate,
                                  appointmentDescription: appointments[index]
                                      .appointmentDescription,
                                  weight: appointments[index].weight,
                                  donationCenter:
                                      appointments[index].donationCenter['_id'],
                                  healthCondition:
                                      appointments[index].healthCondition,
                                  tattoo: appointments[index].tattoo,
                                  pregnant: appointments[index].pregnant,
                                  status: "donated",
                                ),
                              ));
                              Navigator.of(context)
                                  .pushNamed(RouteGenerator.dashboardScreen);
                              print(appointments[index]);
                            },
                            child: const Text('Donated'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 2,
          color: Colors.grey[200],
        )
      ],
    );
  }

  Widget requestTile(context, index, request) {
    // if (request.totaldonations == request.unitsNeeded) {
    //   BlocProvider.of<RequestBloc>(context).add(RequestDelete(request));
    // }
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteGenerator.requestDetail,
              arguments: request,
            );
          },
          child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${request.bloodType}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xFFD32026),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${request.status}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text('${request.reason}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFD32026)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: request.totalDonations <= request.unitsNeeded
                                ? LinearPercentIndicator(
                                    width: 100.0,
                                    lineHeight: 8.0,
                                    percent: request.totalDonations /
                                        request.unitsNeeded,
                                    progressColor: Color(0xFFD32026),
                                  )
                                : Icon(Icons.check),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          RichText(
                            text: TextSpan(
                              text: '${request.totalDonations} / ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${request.unitsNeeded}',
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pushNamed(
                                RouteGenerator.requestCreate,
                                arguments: RequestArgument(
                                    request: request, edit: true)),
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<RequestBloc>(context)
                                  .add(RequestDelete(request));
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  RouteGenerator.dashboardScreen,
                                  (route) => false);
                            },
                            icon: Icon(Icons.delete),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              )),
        ),
        Divider(
          height: 2,
          color: Colors.grey[200],
        )
      ],
    );
  }

  Widget _pointTile(context, {amount, title}) {
    return Container(
        margin: EdgeInsets.all(10.0),
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFEEEEEE),
              spreadRadius: 4,
              blurRadius: 5,
              offset: Offset(2, 5),
            )
          ],
          border: Border.all(
            width: 0.5,
            color: Color(0xFFEEEEEE),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0,
                      )),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Color(0xFFD32026),
                          width: 0.8,
                        )),
                    width: 40.0,
                    height: 40.0,
                    child: Center(
                      child: Text(amount,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class NavigationDrawerWidget extends StatelessWidget {
  final Padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        if (authState is AuthenticationAuthenticated) {
          return Drawer(
            child: Material(
              color: Color(0xFFD32026),
              child: ListView(
                padding: Padding,
                children: [
                  buildHeader(
                    image:
                        "${Constants.imageBaseUrl}images/users/${authState.user?.image}",
                    name: "${authState.user?.firstName}",
                    phoneNumber: "${authState.user?.phoneNumber}",
                    onClicked: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Dashboard',
                    icon: Icons.desktop_mac,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  Divider(
                    color: Colors.white70,
                    height: 4,
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Users list',
                    icon: Icons.people,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  Divider(
                    color: Colors.white70,
                    height: 4,
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Create Donation Center',
                    icon: Icons.add_business_outlined,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: Colors.white70,
                    height: 4,
                  ),
                  buildMenuItem(
                    text: 'Create Request',
                    icon: Icons.article_outlined,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const SizedBox(height: 24),
                  Divider(
                    color: Colors.white70,
                    height: 4,
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                      text: 'Role Management',
                      icon: Icons.people,
                      onClicked: () => selectedItem(context, 4)),
                  Divider(
                    color: Colors.white70,
                    height: 4,
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                      text: 'Logout',
                      icon: Icons.logout,
                      onClicked: () {
                        print('Logout Clicked From Dashboard Screen');
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoggedOut());
                        BlocProvider.of<LoginBloc>(context)
                            .add(LoginLoggedOut());
                        Navigator.of(context)
                            .popAndPushNamed(RouteGenerator.loginScreen);
                      }),
                ],
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Widget buildHeader({
    required String image,
    required String name,
    required String phoneNumber,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 31,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                      radius: 30, backgroundImage: NetworkImage(image))),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phoneNumber,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              // Spacer(),
              // CircleAvatar(
              //   radius: 24,
              //   backgroundColor: Color.fromRGBO(30, 60, 168, 1),
              //   child: Icon(Icons.add_comment_outlined, color: Colors.white),
              // )
            ],
          ),
        ),
      );

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UsersScreen(),
        ));
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreateDonationCenter(),
          ),
        );
        break;
      case 3:
        Navigator.of(context).pushNamed(RouteGenerator.requestCreate,
            arguments: RequestArgument(edit: false));
        break;

      case 4:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RoleManage()));
        break;
    }
  }
}
