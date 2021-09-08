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

}
