import 'package:dio/dio.dart';
import 'package:eshiblood/src/appointment/models/appointment.dart';
import 'package:eshiblood/src/appointment/screens/appointment_list.dart';
import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/auth_event.dart';
import 'package:eshiblood/src/auth/bloc/auth_state.dart';
import 'package:eshiblood/src/auth/repository/secure_storage.dart';
import 'package:eshiblood/src/utilities/constants.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:intl/intl.dart';
import 'package:eshiblood/src/appointment/bloc/blocs.dart';
import 'package:eshiblood/src/appointment/widgets/custom_radio.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAppointment extends StatefulWidget {
  final AppointmentArgument args;
  AddAppointment({required this.args});

  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  DateTimeRange? dateRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 15)));

  String? getFrom() {
    if (dateRange == null) {
      setState(() {
        this._appointment["startDate"] =
            DateFormat("ymd").format(DateTime.now());
      });
      return DateFormat('EEE, MMM d, ' 'yy').format(DateTime.now());
    } else {
      this._appointment["startDate"] =
          DateFormat("ymd").format(dateRange!.start);

      return DateFormat('EEE, MMM d, ' 'yy').format(dateRange!.start);
    }
  }

  String? getUntil() {
    if (dateRange == null) {
      this._appointment["endDate"] =
          DateFormat("ymd").format(DateTime.now().add(Duration(days: 15)));
      return DateFormat('EEE, MMM d, ' 'yy').format(DateTime.now().add(
        Duration(days: 15),
      ));
    } else {
      this._appointment["endDate"] = DateFormat("ymd").format(dateRange!.end);
      return DateFormat('EEE, MMM d, ' 'yy').format(dateRange!.end);
    }
  }

  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _appointment = {
    "healthCondition": "yes",
    "weight": 45,
    "tattoo": "no",
    "donationCenter": "Bole Donation Center",
    "appointmentDescription": "Appointment due to shortage",
    "pregnant": "no"
  };

  onSubmit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      final AppointmentEvent event = widget.args.edit
          ? AppointmentUpdate(
              Appointment(
                id: widget.args.appointment?.id,
                userId: widget.args.appointment?.userId,
                status: "pending",
                startDate: this._appointment["startDate"],
                endDate: this._appointment["endDate"],
                appointmentDescription:
                    this._appointment["appointmentDescription"],
                weight: this._appointment["weight"],
                healthCondition: this._appointment["healthCondition"],
                tattoo: this._appointment["tattoo"],
                donationCenter: this._appointment["donationCenter"],
                pregnant: this._appointment["pregnant"],
              ),
            )
          : AppointmentCreate(
              Appointment(
                id: null,
                startDate: this._appointment["startDate"],
                endDate: this._appointment["endDate"],
                appointmentDescription:
                    this._appointment["appointmentDescription"],
                weight: this._appointment["weight"],
                healthCondition: this._appointment["healthCondition"],
                tattoo: this._appointment["tattoo"],
                donationCenter: this._appointment["donationCenter"],
                pregnant: this._appointment["pregnant"],
              ),
            );
      BlocProvider.of<AppointmentBloc>(context).add(event);
      // BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
      Navigator.of(context).pushNamed(RouteGenerator.homeScreen);
    }
  }

  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    setState(() => _currentStep < 5 ? _currentStep += 1 : onSubmit());
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.args.appointment);
    print(this._appointment);

    dynamic argsApt = widget.args.appointment;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        return (authState is AuthenticationAuthenticated)
            ? Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xFFD32026),
                  title: Text(
                      '${widget.args.edit ? "Edit Appointment" : "Add  Appointment"}'),
                ),
                body: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Expanded(
                            child: Theme(
                              data: ThemeData(
                                colorScheme: Theme.of(context)
                                    .colorScheme
                                    .copyWith(primary: Color(0xffd32026)),
                              ),
                              child: Stepper(
                                type: stepperType,
                                controlsBuilder: (BuildContext context,
                                    {VoidCallback? onStepContinue,
                                    VoidCallback? onStepCancel}) {
                                  return Row(
                                    children: <Widget>[
                                      _currentStep == 5
                                          ? TextButton(
                                              onPressed: onStepContinue,
                                              child: const Text('FINISH'),
                                            )
                                          : widget.args.edit
                                              ? TextButton(
                                                  onPressed: onStepContinue,
                                                  child: const Text('EDIT'),
                                                )
                                              : TextButton(
                                                  onPressed: onStepContinue,
                                                  child: const Text('CONTINUE'),
                                                ),
                                      SizedBox(width: 10),
                                      TextButton(
                                        onPressed: onStepCancel,
                                        child: const Text('CANCEL'),
                                      ),
                                    ],
                                  );
                                },
                                physics: ScrollPhysics(),
                                currentStep: _currentStep,
                                onStepTapped: (step) => tapped(step),
                                onStepContinue: continued,
                                onStepCancel: cancel,
                                steps: <Step>[
                                  Step(
                                    title: Text('Health Condition'),
                                    content: Column(
                                      children: <Widget>[
                                        Text(
                                          'Are you in good health condition?',
                                        ),
                                        CustomRadio(
                                          conditions: [
                                            RadioModel(
                                              isSelected: widget.args.edit
                                                  ? argsApt?.healthCondition ==
                                                          "yes"
                                                      ? true
                                                      : false
                                                  : this._appointment[
                                                          "healthCondition"] ==
                                                      "yes",
                                              buttonText: "Yes",
                                              onClicked: () {
                                                setState(() {
                                                  this._appointment[
                                                          "healthCondition"] =
                                                      "yes";
                                                });
                                              },
                                            ),
                                            RadioModel(
                                              isSelected: widget.args.edit
                                                  ? argsApt?.healthCondition ==
                                                          "no"
                                                      ? true
                                                      : false
                                                  : this._appointment[
                                                          "healthCondition"] ==
                                                      "no",
                                              buttonText: "No",
                                              onClicked: () {
                                                print(this._appointment);
                                                setState(() {
                                                  this._appointment[
                                                      "healthCondition"] = "no";
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 0
                                        ? StepState.complete
                                        : StepState.disabled,
                                  ),
                                  Step(
                                    title: Text('Weight'),
                                    content: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: DropdownSearch<dynamic>(
                                                label: "Weight",
                                                showSearchBox: true,
                                                items: [
                                                  for (var i = 45;
                                                      i < 150;
                                                      i += 1)
                                                    i.toString()
                                                ],
                                                selectedItem: widget.args.edit
                                                    ? argsApt?.weight
                                                    : this
                                                        ._appointment["weight"],
                                                onChanged: (value) {
                                                  setState(() {
                                                    this._appointment[
                                                        "weight"] = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Kg",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 1
                                        ? StepState.complete
                                        : StepState.disabled,
                                  ),
                                  Step(
                                    title: Text('Tattoo'),
                                    content: Column(
                                      children: <Widget>[
                                        Text(
                                          'Did you get tattoo within the last 12 months?',
                                        ),
                                        CustomRadio(
                                          conditions: [
                                            RadioModel(
                                              isSelected: widget.args.edit
                                                  ? argsApt?.tattoo == "yes"
                                                      ? true
                                                      : false
                                                  : this._appointment[
                                                          "tattoo"] ==
                                                      "yes",
                                              buttonText: "Yes",
                                              onClicked: () {
                                                print("tattoo yes");
                                                setState(() {
                                                  this._appointment["tattoo"] =
                                                      "yes";
                                                });
                                              },
                                            ),
                                            RadioModel(
                                              isSelected: widget.args.edit
                                                  ? argsApt?.tattoo == "no"
                                                      ? true
                                                      : false
                                                  : this._appointment[
                                                          "tattoo"] ==
                                                      "no",
                                              buttonText: "No",
                                              onClicked: () {
                                                setState(() {
                                                  this._appointment["tattoo"] =
                                                      "No";
                                                });
                                                print("tatoo no");
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 2
                                        ? StepState.complete
                                        : StepState.disabled,
                                  ),
                                  Step(
                                    title: Text('Donation Center'),
                                    content: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: DropdownSearch<dynamic>(
                                                validator: (dynamic item) {
                                                  if (item == null)
                                                    return "Required field";
                                                  else
                                                    return null;
                                                },
                                                dropdownSearchDecoration:
                                                    InputDecoration(
                                                  filled: true,
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xFFFFEBEE)),
                                                  ),
                                                ),
                                                showAsSuffixIcons: true,
                                                clearButtonBuilder: (_) =>
                                                    Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: const Icon(
                                                    Icons.clear,
                                                    size: 24,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                showClearButton: true,
                                                showSearchBox: true,
                                                label: "Donation Center",
                                                isFilteredOnline: true,
                                                onFind: (String? filter) async {
                                                  final token =
                                                      await SecureStorage()
                                                          .getToken();

                                                  var response = await Dio().get(
                                                      "${Constants.emuBaseUrl}/donationCenters",
                                                      // queryParameters: {"city": filter},
                                                      options: Options(
                                                        headers: {
                                                          "accept": "/",
                                                          // For latter use commented
                                                          "Authorization":
                                                              "Bearer ${token}",
                                                          "Content-Type":
                                                              "application/json"
                                                        },
                                                      )
                                                      // queryParameters: {"filter": filter},
                                                      );
                                                  if (response.statusCode ==
                                                      200) {
                                                    var models = response
                                                        .data["result"]["docs"];
                                                    var names = [];
                                                    for (var item in models) {
                                                      names.add(item["name"]);
                                                    }
                                                    this._appointment[
                                                            "donationCenter"] =
                                                        names.length > 0
                                                            ? names[0]
                                                            : "";

                                                    return names;
                                                  } else {
                                                    return [];
                                                  }
                                                },
                                                selectedItem: widget.args.edit
                                                    ? argsApt
                                                        .donationCenter["name"]
                                                    : this._appointment[
                                                        "donationCenter"],
                                                onChanged: (value) {
                                                  this._appointment[
                                                      "donationCenter"] = value;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 3
                                        ? StepState.complete
                                        : StepState.disabled,
                                  ),
                                  Step(
                                    title: Text('Date'),
                                    content: Column(
                                      children: <Widget>[
                                        Text(
                                            "Schedule your appointment with in the next 15 days (DD/MM/yyyy)\n"),
                                        Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  268,
                                              height: 50,
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                                  color: Colors.blueAccent),
                                              child: Center(
                                                child: Text(
                                                  getFrom()!,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                child: Center(
                                                  child: Text(" - "),
                                                ),
                                                width: 20),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  268,
                                              height: 50,
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                                  color: Color(0xFFD32026)),
                                              child: Center(
                                                child: Text(
                                                  getUntil()!,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              pickDateRange(context);
                                            },
                                            child: Text("Choose Date Range"),
                                          ),
                                        )
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 4
                                        ? StepState.complete
                                        : StepState.disabled,
                                  ),
                                  Step(
                                    title: Text('Pregnant'),
                                    content: Column(
                                      children: <Widget>[
                                        Text(
                                          'Are you pregnant?',
                                        ),
                                        CustomRadio(
                                          conditions: [
                                            RadioModel(
                                              isSelected: widget.args.edit
                                                  ? argsApt?.pregnant == "yes"
                                                      ? true
                                                      : false
                                                  : this._appointment[
                                                          "pregnant"] ==
                                                      "yes",
                                              buttonText: "Yes",
                                              onClicked: () {
                                                setState(() {
                                                  this._appointment[
                                                      "pregnant"] = "yes";
                                                });
                                              },
                                            ),
                                            RadioModel(
                                              isSelected: widget.args.edit
                                                  ? argsApt?.pregnant == "no"
                                                      ? true
                                                      : false
                                                  : this._appointment[
                                                          "pregnant"] ==
                                                      "no",
                                              buttonText: "No",
                                              onClicked: () {
                                                setState(() {
                                                  this._appointment[
                                                      "pregnant"] = "no";
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 5
                                        ? StepState.complete
                                        : StepState.disabled,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(
          Duration(days: 15),
        ));

    final DateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 15),
      ),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (DateRange == null) return;
    setState(() => dateRange = DateRange);
  }
}
