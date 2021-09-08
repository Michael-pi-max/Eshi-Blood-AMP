import 'package:eshiblood/src/appointment/bloc/appointment_bloc.dart';
import 'package:eshiblood/src/appointment/bloc/appointment_event.dart';
import 'package:eshiblood/src/appointment/bloc/appointment_state.dart';
import 'package:eshiblood/src/appointment/screens/appointment_add.dart';
import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/auth_state.dart';
import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DonationHistoryScreen extends StatelessWidget {
  final VoidCallback? onFlip;

  const DonationHistoryScreen({Key? key, this.onFlip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now().add(const Duration(days: 90));
    DateTime hdate = DateTime.now().subtract(const Duration(days: 30));

    BlocProvider.of<AppointmentBloc>(context).add(AppointmentLoadHistory());
    return Scaffold(
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return (state is AuthenticationAuthenticated)
              ? SafeArea(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Donation History",
                                style: TextStyle(
                                  color: Color(0xFFD32026),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              BlocBuilder<AuthenticationBloc,
                                  AuthenticationState>(
                                builder: (context, state) {
                                  return (state is AuthenticationAuthenticated)
                                      ? Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Color(0xFFD32026),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey,
                                                        blurRadius: 10,
                                                        spreadRadius: 2,
                                                      ),
                                                    ]),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '${state.user?.totalDonations}',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFFD32026),
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text('Donations'),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Color(0xFFD32026),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 8,
                                                      spreadRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                                child: state
                                                        .user
                                                        ?.role["privileges"][4]
                                                            ["permissions"]
                                                        .contains("create")
                                                    ? DateTime.fromMillisecondsSinceEpoch(int.parse(state.user!.lastDonation ?? '1623501622005'))
                                                                    .add(const Duration(
                                                                        days:
                                                                            90))
                                                                    .difference(
                                                                        DateTime
                                                                            .now())
                                                                    .inDays >
                                                                0 &&
                                                            DateTime.fromMillisecondsSinceEpoch(
                                                                        int.parse(state.user!.lastDonation ?? '1623501622005'))
                                                                    .add(const Duration(days: 90))
                                                                    .difference(DateTime.now())
                                                                    .inDays <
                                                                90
                                                        ? Text(
                                                            '${DateTime.fromMillisecondsSinceEpoch(int.parse(state.user!.lastDonation ?? '1623501622005')).add(const Duration(days: 90)).difference(DateTime.now()).inDays} days left to donate.',
                                                            // 'a${state.user!.lastDonation}')
                                                          )
                                                        : Text(
                                                            'You can donate',
                                                          )
                                                    : Text(
                                                        "You can't donate",
                                                      ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container();
                                },
                              ),
                              BlocBuilder<AppointmentBloc, AppointmentState>(
                                builder: (context, state) {
                                  return (state is AppointmentOperationSuccess)
                                      ? Expanded(
                                          child: state.appointments.length > 0
                                              ? RefreshIndicator(
                                                  onRefresh: () async {
                                                    BlocProvider.of<
                                                                AppointmentBloc>(
                                                            context)
                                                        .add(
                                                            AppointmentLoadHistory());
                                                  },
                                                  child: ListView.builder(
                                                    itemCount: state
                                                        .appointments.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    16.0),
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              title: Text(
                                                                  '${DateFormat('EEE, MMM d, ' 'yyyy').format(DateTime.parse(state.appointments[index].updatedAt))}'),
                                                              subtitle: Text(
                                                                  '${state.appointments[index].donationCenter["name"]}'),
                                                              trailing: Text(
                                                                  '${state.appointments[index].weight} kg'),
                                                            ),
                                                            Divider(
                                                              color: Color(
                                                                  0xFFD32026),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Center(
                                                  child: Text(
                                                      "No dornation history yet!")))
                                      : Center(
                                          child: CircularProgressIndicator());
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: (state.user?.appointed)
                                    ? RoundButton(
                                        color: Colors.white,
                                        text: 'Manage Appointment',
                                        textColor: Color(0xFFd32026),
                                        onPressed: () {},
                                        borderCurve: 10.0,
                                        width: double.infinity,
                                      )
                                    : state
                                            .user
                                            ?.role["privileges"][4]
                                                ["permissions"]
                                            .contains("create")
                                        ? DateTime.fromMillisecondsSinceEpoch(
                                                            int.parse(state
                                                                    .user!
                                                                    .lastDonation ??
                                                                '1623501622005'))
                                                        .add(const Duration(
                                                            days: 90))
                                                        .difference(
                                                            DateTime.now())
                                                        .inDays >
                                                    0 &&
                                                DateTime.fromMillisecondsSinceEpoch(
                                                            int.parse(state.user!.lastDonation ?? '1623501622005'))
                                                        .add(const Duration(days: 90))
                                                        .difference(DateTime.now())
                                                        .inDays <
                                                    90
                                            ? RoundButton(
                                                color: Colors.white,
                                                text:
                                                    '${DateTime.fromMillisecondsSinceEpoch(int.parse(state.user!.lastDonation ?? '1623501622005')).add(const Duration(days: 90)).difference(DateTime.now()).inDays} days left to donate.',
                                                textColor: Colors.grey,
                                                onPressed: () {},
                                                borderCurve: 10.0,
                                                width: double.infinity,
                                              )
                                            : RoundButton(
                                                color: Colors.white,
                                                text: 'Schedule Appointment',
                                                textColor: Color(0xFFD32026),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddAppointment(
                                                        args:
                                                            AppointmentArgument(
                                                                edit: false),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                borderCurve: 10.0,
                                                width: double.infinity,
                                              )
                                        : RoundButton(
                                            color: Colors.white,
                                            text: "Can't appoint with your current profile!",
                                            textColor: Color(0xFFD32026),
                                            onPressed: () {},
                                            borderCurve: 10.0,
                                            width: double.infinity,
                                          ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Tooltip(
                            message: "Swipe to see donation history",
                            child: IconButton(
                              onPressed: () => onFlip,
                              icon: Icon(
                                Icons.switch_right,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
