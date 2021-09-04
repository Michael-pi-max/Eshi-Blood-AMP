import 'package:eshiblood/src/appointment/bloc/blocs.dart';
import 'package:eshiblood/src/appointment/models/models.dart';
import 'package:eshiblood/src/utilities/routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AppointmentList extends StatelessWidget {
  static const String routeName = "appointmentList";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text('Points'),
      ),
      body: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentOperationFailure) {
            return Text('Could not do appointment operation');
          }

          if (state is AppointmentOperationSuccess) {
            final appointments = state.appointments;

            return SafeArea(
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
                              Text('Total',
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
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "${appointments.length}",
                                        style: TextStyle(
                                            fontSize: 44,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFD32026))),
                                    TextSpan(
                                        text: 'Appointments',
                                        style: TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 200.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: pointBrain.points.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _pointTile(context, index);
                          },
                        )),
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
                                    child: Text('Pending Appointments',
                                        style: TextStyle(
                                            color: Color(0xFFD32026)))),
                                Tab(
                                    child: Text('Redeem',
                                        style: TextStyle(
                                            color: Color(0xFFD32026)))),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10.0),
                                    child: appointments.length > 0
                                        ? ListView.builder(
                                            itemCount: appointments.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return _rewardTile(
                                                  context, index, appointments);
                                            },
                                          )
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("No Appointments"),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      RouteGenerator
                                                          .appointmentAdd,
                                                      arguments:
                                                          AppointmentArgument(
                                                              edit: false),
                                                    );
                                                  },
                                                  child: Text(
                                                      'Create Appointment'),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10.0),
                                      child: ListView.builder(
                                        itemCount: rewardBrain.redeems.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _redeemTile(context, index);
                                        },
                                      )),
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
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _redeemTile(context, index) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${rewardBrain.redeems[index].giftName}',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text('${rewardBrain.redeems[index].description}',
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                    SizedBox(height: 6),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xFFD32026),
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: LinearPercentIndicator(
                          width: 100.0,
                          lineHeight: 8.0,
                          percent: 0.5,
                          progressColor: Color(0xFFD32026),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
        Divider(
          height: 2,
          color: Colors.grey[200],
        )
      ],
    );
  }

  Widget _rewardTile(context, index, appointments) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${appointments[index].appointmentDescription}',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                        'Donor - ${appointments[index].userId["firstName"]} ${appointments[index].userId["lastName"]}',
                        style: TextStyle(
                          fontSize: 14,
                        )),
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
                    InkWell(
                      onTap: () => Navigator.of(context).pushNamed(
                        RouteGenerator.appointmentAdd,
                        arguments: AppointmentArgument(
                            edit: true, appointment: appointments[index]),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xFFD32026),
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text('Edit'),
                      ),
                    )
                  ],
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
                                BlocProvider.of<AppointmentBloc>(context).add(
                                  AppointmentUpdate(
                                    Appointment(
                                        id: appointments[index].id,
                                        userId: appointments[index].userId,
                                        startDate:
                                            appointments[index].startDate,
                                        endDate: appointments[index].endDate,
                                        appointmentDescription:
                                            appointments[index]
                                                .appointmentDescription,
                                        weight: appointments[index].weight,
                                        donationCenter: appointments[index]
                                            .donationCenter["name"],
                                        healthCondition:
                                            appointments[index].healthCondition,
                                        tattoo: appointments[index].tattoo,
                                        pregnant: appointments[index].pregnant,
                                        status: "donated"),
                                  ),
                                );
                                Navigator.pop(context, 'Donated');
                                print("YES");
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
                    InkWell(
                      child: CircleAvatar(
                        radius: 15,
                        child: Icon(
                          Icons.cancel_outlined,
                        ),
                      ),
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('AlertDialog Title'),
                          content: const Text('AlertDialog description'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
        Divider(
          height: 2,
          color: Colors.grey[200],
        )
      ],
    );
  }

  Widget _pointTile(context, index) {
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
                  Text('${pointBrain.points[index].title}',
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
                      child: Text('${pointBrain.points[index].point}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          )),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Spacer(),
                  Text('${pointBrain.points[index].dueDate}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      )),
                ],
              ),
            ],
          ),
        ));
  }
}

class PointBrain {
  List<PointModel> points = [
    PointModel(
      title: 'Invitation',
      dueDate: 'Permanent',
      point: '+2',
    ),
    PointModel(
      title: 'Invitation',
      dueDate: 'Permanent',
      point: '+2',
    ),
    PointModel(
      title: 'Invitation',
      dueDate: 'Permanent',
      point: '+2',
    ),
    PointModel(
      title: 'Invitation',
      dueDate: 'Permanent',
      point: '+2',
    ),
  ];
}

PointBrain pointBrain = PointBrain();

class PointModel {
  String title;
  String point;
  Image? backgroundImage;
  String dueDate;

  PointModel(
      {required this.title,
      required this.point,
      this.backgroundImage,
      required this.dueDate});
}

class RewardBrain {
  List<RewardModel> rewards = [
    RewardModel(
      giftName: '1GB internet package',
      description: 'Earn a total of 500 points',
    ),
    RewardModel(
      giftName: '1GB internet package',
      description: 'Earn a total of 500 points',
    ),
    RewardModel(
      giftName: '1GB internet package',
      description: 'Earn a total of 500 points',
    ),
    RewardModel(
      giftName: '1GB internet package',
      description: 'Earn a total of 500 points',
    ),
    RewardModel(
      giftName: '1GB internet package',
      description: 'Earn a total of 500 points',
    ),
    RewardModel(
      giftName: '1GB internet package',
      description: 'Earn a total of 500 points',
    ),
  ];

  List<RewardModel> redeems = [
    RewardModel(
      giftName: '10% off ahoon stoodio',
      description: 'Earn a total of 250 points',
    ),
    RewardModel(
      giftName: '50% off Eshi Digital Marketing',
      description: 'Earn a total of 200 points',
    ),
    RewardModel(
      giftName: '1GB internet package',
      description: 'Earn a total of 500 points',
    ),
    RewardModel(
      giftName: '1GB internet package',
      description: 'Earn a total of 500 points',
    ),
    RewardModel(
      giftName: '1GB internet package',
      description: 'Earn a total of 500 points',
    ),
    RewardModel(
      giftName: '1GB internet package',
      description: 'Earn a total of 500 points',
    ),
  ];
}

RewardBrain rewardBrain = RewardBrain();

class RewardModel {
  String description;
  String giftName;
  // CircularPercentIndicator indicator;

  RewardModel({
    required this.description,
    required this.giftName,
  });
}

class NavigationDrawerWidget extends StatelessWidget {
  final Padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color(0xFFD32026),
        child: ListView(
          padding: Padding,
          children: [
            // buildHeader(
            //   image: "image",
            //   name: "Michael",
            //   phoneNumber: "0966303009",
            //   onClicked: () => Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (context) => ProfileScreen(),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 8),
            // buildMenuItem(
            //   text: 'People',
            //   icon: Icons.people,
            //   onClicked: () => selectedItem(context, 0),
            // ),
            const SizedBox(height: 16),
            // buildMenuItem(
            //   text: 'People',
            //   icon: Icons.people,
            //   onClicked: () => selectedItem(context, 1),
            // ),
            const SizedBox(height: 16),
            buildMenuItem(text: 'People', icon: Icons.people),
            const SizedBox(height: 16),
            buildMenuItem(text: 'People', icon: Icons.people),
            const SizedBox(height: 24),
            Divider(
              color: Colors.white70,
              height: 4,
            ),
            const SizedBox(height: 24),
            buildMenuItem(text: 'People', icon: Icons.people),
            const SizedBox(height: 24),
            buildMenuItem(text: 'People', icon: Icons.people),
          ],
        ),
      ),
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
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(image)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phoneNumber,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
              CircleAvatar(
                radius: 24,
                backgroundColor: Color.fromRGBO(30, 60, 168, 1),
                child: Icon(Icons.add_comment_outlined, color: Colors.white),
              )
            ],
          ),
        ),
      );

  // void selectedItem(BuildContext context, int index) {
  //   Navigator.of(context).pop();
  //   switch (index) {
  //     case 0:
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => DashboardScreen(),
  //         ),
  //       );
  //       break;
  //     case 1:
  //       Navigator.of(context).push(MaterialPageRoute(
  //         builder: (context) => UsersScreen(),
  //       ));
  //       break;
  //   }
  // }
}
