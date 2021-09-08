import 'package:eshiblood/src/appointment/screens/appointment_add.dart';
import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/auth_state.dart';
import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:eshiblood/src/utilities/constants.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DonationCardScreen extends StatelessWidget {
  const DonationCardScreen({Key? key, this.onFlip}) : super(key: key);
  final VoidCallback? onFlip;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: (state is AuthenticationAuthenticated)
                  ? Container(
                      decoration: BoxDecoration(
                        color: Color(0xffD32026),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 25),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                      '${Constants.imageBaseUrl}/images/users/${state.user!.image}'),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "${state.user?.firstName} ${state.user?.lastName}",
                                style: TextStyle(
                                    fontSize: 28, color: Colors.white),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "EB - ${state.user?.id?.substring(14)}",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Container(
                                          color: Colors.white,
                                          width: 50,
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                                '${state.user!.totalDonations}'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Units",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Container(
                                          color: Colors.white,
                                          width: 50,
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                                '${state.user!.totalDonations * 3}'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Lives Saved",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.white,
                                indent: 50,
                                endIndent: 50,
                                thickness: 1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Container(
                                          color: Colors.white,
                                          width: 50,
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                                '${(state.user!.appointed) ? '✅' : '❌'}'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Appointed",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Container(
                                          color: Colors.white,
                                          width: 50,
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                                '${state.user!.bloodType}'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Blood Type",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: QrImage(
                                  backgroundColor: Colors.white,
                                  data: state.user!.id ?? 'Eshi Blood User',
                                  size: 170,
                                  version: QrVersions.auto,
                                ),
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
                                            text:
                                                "Can't appoint with your current Role.",
                                            textColor: Color(0xFFD32026),
                                            onPressed: () {},
                                            borderCurve: 10.0,
                                            width: double.infinity,
                                          ),
                              ),
                            ],
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
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
}

// class DonationCard extends StatelessWidget {
//   final VoidCallback? onFlip;

//   const DonationCard({
//     Key? key,
//     this.onFlip,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }
