import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:eshiblood/src/request/bloc/request_bloc.dart';
import 'package:eshiblood/src/request/bloc/request_event.dart';
import 'package:eshiblood/src/request/model/request.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateRequestScaffold extends StatefulWidget {
  final RequestArgument? args;

  CreateRequestScaffold(Type requestArgument, {this.args});
  @override
  _CreateRequestState createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequestScaffold> {
  int amountNeeded = 0;
  String? bloodType = "";
  String reason = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      bloodType = widget.args!.edit ? widget.args!.request!.bloodType : '';
      amountNeeded = widget.args!.edit ? widget.args!.request!.unitsNeeded : 0;
      reason = widget.args!.edit ? widget.args!.request!.reason : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffD32026),
        title:
            Text('${widget.args!.edit ? "Edit Request" : "Add New Request"}'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              AmountNeeded(
                currentValue: amountNeeded,
                increment: () {
                  setState(() {
                    amountNeeded += 1;
                  });
                },
                decrement: () {
                  setState(() {
                    if (amountNeeded == 0) {
                      amountNeeded = 0;
                    } else {
                      amountNeeded -= 1;
                    }
                  });
                },
              ),
              BloodTypeRadio(
                bloodType: bloodType,
                handleBloodTypeChange: (String? bloodTypeState) {
                  setState(
                    () {
                      print(bloodType);
                      bloodType = bloodTypeState;
                    },
                  );
                },
              ),
              ReasonWidget(
                handleReasonChange: (String reasonState) {
                  setState(
                    () {
                      reason = reasonState;
                    },
                  );
                },
              ),
              RoundButton(
                color: Color(0xFFD32026),
                text: "Create Request",
                textColor: Colors.white,
                onPressed: () {
                  if (amountNeeded != 0 && bloodType != "" && reason != "") {
                    // BlocProvider.of<RequestBloc>(context).add(
                    //   RequestCreate(
                    //     Request(
                    //       unitsNeeded: amountNeeded,
                    //       reason: reason,
                    //       bloodType: bloodType,
                    //     ),
                    //   ),
                    // );
                    final RequestEvent event = widget.args!.edit
                        ? RequestUpdate(
                            Request(
                              id: widget.args!.request!.id,
                              status: 'pending',
                              bloodType: this.bloodType,
                              reason: this.reason,
                              unitsNeeded: this.amountNeeded,
                            ),
                          )
                        : RequestCreate(
                            Request(
                              bloodType: this.bloodType,
                              reason: this.reason,
                              unitsNeeded: this.amountNeeded,
                            ),
                          );
                    BlocProvider.of<RequestBloc>(context).add(event);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteGenerator.dashboardScreen, (route) => false);
                  }
                },
                borderCurve: 14,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReasonWidget extends StatelessWidget {
  Function(String) handleReasonChange;

  ReasonWidget({required this.handleReasonChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
            ),
            Text(
              "Reason",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
              ),
            ],
          ),
          child: TextField(
            onChanged: (value) {
              handleReasonChange(value);
            },
            maxLines: 10,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter Reason for desktop",
              contentPadding: EdgeInsets.all(10),
            ),
          ),
        )
      ],
    );
  }
}

class AmountNeeded extends StatelessWidget {
  int currentValue;
  VoidCallback increment;
  VoidCallback decrement;

  AmountNeeded({
    required this.currentValue,
    required this.increment,
    required this.decrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Amount Needed"),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.red),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, blurRadius: 4, offset: Offset(0, 0))
              ]),
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                  padding: EdgeInsets.only(bottom: 15, right: 25),
                  onPressed: decrement,
                  icon: Icon(Icons.minimize)),
              Text(
                '$currentValue',
                style: TextStyle(fontSize: 24),
              ),
              IconButton(
                  padding: EdgeInsets.only(left: 25),
                  onPressed: increment,
                  icon: Icon(Icons.add)),
            ],
          ),
        )
      ],
    );
  }
}

class BloodTypeRadio extends StatelessWidget {
  String? bloodType;
  Function(String?) handleBloodTypeChange;

  BloodTypeRadio({
    required this.bloodType,
    required this.handleBloodTypeChange,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        width: 350,
        // height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            // border: Border.all(color: Colors.red),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 2, offset: Offset(0, 0))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // SizedBox(width: 20,),
            Text("Blood Type"),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio(
                      groupValue: bloodType,
                      onChanged: (String? value) {
                        handleBloodTypeChange(value);
                      },
                      value: "A+",
                    ),
                    Text("A+")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      groupValue: bloodType,
                      onChanged: (String? value) {
                        print(value);
                        handleBloodTypeChange(value);
                      },
                      value: "B+",
                    ),
                    Text("B+")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      groupValue: bloodType,
                      onChanged: (String? value) {
                        handleBloodTypeChange(value);
                      },
                      value: "AB+",
                    ),
                    Text("AB+")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      groupValue: bloodType,
                      onChanged: (String? value) {
                        handleBloodTypeChange(value);
                      },
                      value: "O+",
                    ),
                    Text("O+")
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio(
                      groupValue: bloodType,
                      onChanged: (String? value) {
                        handleBloodTypeChange(value);
                      },
                      value: "A-",
                    ),
                    Text("A-")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      groupValue: bloodType,
                      onChanged: (String? value) {
                        handleBloodTypeChange(value);
                      },
                      value: "B-",
                    ),
                    Text("B-")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      groupValue: bloodType,
                      onChanged: (String? value) {
                        handleBloodTypeChange(value);
                      },
                      value: "AB-",
                    ),
                    Text("AB-")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      groupValue: bloodType,
                      onChanged: (String? value) {
                        handleBloodTypeChange(value);
                      },
                      value: "O-",
                    ),
                    Text("O-")
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
