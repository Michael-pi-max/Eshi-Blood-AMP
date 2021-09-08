import 'dart:io';

import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:eshiblood/src/donation_center/bloc/donation_center_bloc.dart';
import 'package:eshiblood/src/donation_center/bloc/form_donation_center_bloc.dart';
import 'package:eshiblood/src/donation_center/models/addressEnum.dart';
import 'package:eshiblood/src/donation_center/repository/donation_center_repository.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateDonationCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Donation Center"),
      ),
      body: BlocBuilder<DonationCenterBloc, DonationCenterState>(
        builder: (context, donationCenterState) {
          return BlocBuilder<FormDonationCenterBloc, FormDonationCenterState>(
            builder: (context, formState) {
              var formBloc = BlocProvider.of<FormDonationCenterBloc>(context);
              return ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    // width: 350,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(fontSize: 24),
                            ),
                            Container(
                              height: 50,
                              width: 250,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(25)),
                              child: TextField(
                                onChanged: (name) {
                                  formBloc.add(NameChange(name));
                                  // print(name);
                                },
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            child: HorizontalDivider(
                              label: "Address",
                              height: 1,
                            )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Row(
                            //   children: [

                            //   ],
                            // ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.black12,
                                      offset: Offset(1, 1),
                                      spreadRadius: 1)
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("State"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    AddressDropDownMenu(
                                      currentDropDownItem: stateAddr,
                                      dropDownItems: stateList,
                                      fieldName: "state",
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 2,
                                          color: Colors.black12,
                                          offset: Offset(1, 1),
                                          spreadRadius: 1)
                                    ],
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("Wereda"),
                                        SizedBox(),
                                        AddressDropDownMenu(
                                          currentDropDownItem: weredaAddr,
                                          dropDownItems: weredaMap[stateAddr]!,
                                          fieldName: "wereda",
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 2,
                                            color: Colors.black12,
                                            offset: Offset(1, 1),
                                            spreadRadius: 1)
                                      ],
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text("City"),
                                          SizedBox(),
                                          AddressDropDownMenu(
                                            currentDropDownItem: cityAddr,
                                            dropDownItems: cityMap[stateAddr]!,
                                            fieldName: "city",
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: HorizontalDivider(
                            label: "Time Slot",
                            height: 1,
                          ),
                        ),
                        TimeSlotPicker(),
                        SizedBox(
                          height: 40,
                        ),
                        CreateDonationButton()
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class CreateDonationButton extends StatelessWidget {
  const CreateDonationButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormDonationCenterBloc, FormDonationCenterState>(
      builder: (context, state) {
        var formBloc = BlocProvider.of<FormDonationCenterBloc>(context);
        return Center(
          child: RoundButton(
            color: Color(0xFFD32026),
            text: 'Create',
            width: double.infinity,
            textColor: Colors.white,
            onPressed: () {
              print(state.formValid());
              if (state.formValid()) {
                // var donationCenterRepo =
                //     RepositoryProvider.of<DonationCenterRepository>(context);
                // donationCenterRepo
                //     .createDonationCenter(state.toDonationCenter());
                BlocProvider.of<DonationCenterBloc>(context)
                    .add(DonationCenterCreate(state.toDonationCenter()));
                Navigator.of(context).pushNamed(RouteGenerator.dashboardScreen);
              }
            },
          ),
        );
      },
    );
  }
}

class TimeSlotPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormDonationCenterBloc, FormDonationCenterState>(
      builder: (context, state) {
        var formBloc = BlocProvider.of<FormDonationCenterBloc>(context);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DatePicker("startDate"),
            DatePicker("endDate"),
          ],
        );
      },
    );
  }
}

class DatePicker extends StatelessWidget {
  String dateBorder;
  DateTime dateValue = DateTime.now();
  DatePicker(this.dateBorder) {
    if (dateBorder == "startDate") {
      this.dateValue = DateTime.now();
    } else {
      this.dateValue = DateTime.now().add(Duration(days: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormDonationCenterBloc, FormDonationCenterState>(
      builder: (context, state) {
        var formBloc = BlocProvider.of<FormDonationCenterBloc>(context);
        return GestureDetector(
          onTap: () async {
            var date = await showDatePicker(
              context: context,
              initialDate: () {
                if (dateBorder == "endDate") {
                  if (state.endDate.compareTo(state.startDate) <= 0) {
                    dateValue = state.startDate.add(Duration(days: 1));
                    return dateValue;
                  }
                  dateValue = state.endDate;
                  return dateValue;
                }
                dateValue = state.startDate;
                return dateValue;
              }(),
              firstDate: state.startDate,
              lastDate: DateTime(2031),
            );

            if (this.dateBorder == "startDate") {
              this.dateValue = date ?? state.startDate;
              formBloc.add(startDateChange(dateValue));
            } else {
              this.dateValue = date ?? state.endDate;
              formBloc.add(endDateChange(this.dateValue));
            }
          },
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 4,
                      color: Colors.black12,
                      offset: Offset(2, 2),
                      spreadRadius: 1)
                ]),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 24,
                  ),
                  Text(this.dateBorder),
                  () {
                    if (dateBorder == "startDate") {
                      return Text(state.startDate
                          .toString()
                          .split(" ")[0]
                          .replaceAll("-", "/"));
                    } else {
                      if (state.endDate.compareTo(state.startDate) <= 0) {
                        // print(state.endDate);
                        dateValue = state.startDate.add(Duration(days: 1));
                        state.endDate = dateValue;
                        // formBloc.add(endDateChange(dateValue));// 1

                      } else {
                        dateValue = state.endDate;
                      }
                      formBloc.add(endDateChange(dateValue));

                      return Text(dateValue
                          .toString()
                          .split(" ")[0]
                          .replaceAll("-", "/"));
                    }
                  }()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AddressDropDownMenu extends StatelessWidget {
  String currentDropDownItem;
  List dropDownItems;
  String fieldName;
  String currValue = "Addis Ababa";

  AddressDropDownMenu(
      {required this.currentDropDownItem,
      required this.dropDownItems,
      required this.fieldName}) {
    if (fieldName == "state") {
      currValue = this.currentDropDownItem;

      // currValue = state.state;
    }
    if (fieldName == "wereda") {
      currValue = this.currentDropDownItem;
      // currValue = state.wereda;
    } else {
      // city
      currValue = this.currentDropDownItem;
      // currValue = state.city;
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormDonationCenterBloc, FormDonationCenterState>(
      builder: (context, state) {
        var formBloc = BlocProvider.of<FormDonationCenterBloc>(context);

        return DropdownButton(value: () {
          if (fieldName == "state") {
            currValue = state.state;
            return currValue;
          } else if (fieldName == "wereda") {
            currValue = () {
              if (weredaMap[state.state]!.contains(state.wereda)) {
                return state.wereda;
              } else {
                formBloc.add(WeredaChange(weredaMap[state.state]![0]));
                return weredaMap[state.state]![0];
              }
            }();
            return currValue;
          } else {
            currValue = () {
              if (cityMap[state.state]!.contains(state.city)) {
                return state.city;
              } else {
                formBloc.add(CityChange(cityMap[state.state]![0]));
                return cityMap[state.state]![0];
              }
            }();
            return currValue;
          }
        }(), onChanged: (newValue) {
          currValue = newValue.toString();
          print("ONCHANGED");
          print(currValue);
          if (fieldName == "state") {
            formBloc.add(StateChange(newValue.toString()));
          }
          if (fieldName == "wereda") {
            formBloc.add(WeredaChange(newValue.toString()));
          }
          if (fieldName == "city") {
            formBloc.add(CityChange(newValue.toString()));
          }
          // print(state.state);
        }, items: () {
          if (fieldName == "state") {
            return stateList.map(
              (addr) {
                return DropdownMenuItem(
                  child: Text(addr),
                  value: addr,
                  onTap: () {
                    print("OnTAP state");
                  },
                );
              },
            ).toList();
          } else if (fieldName == "wereda") {
            return weredaMap[state.state]!.map(
              (addr) {
                return DropdownMenuItem(
                  child: Text(addr),
                  value: addr,
                  onTap: () {
                    print("OnTAP wereda");
                  },
                );
              },
            ).toList();
          } else if (fieldName == "city") {
            return cityMap[state.state]!.map(
              (addr) {
                return DropdownMenuItem(
                  child: Text(addr),
                  value: addr,
                  onTap: () {
                    print("OnTAP city");
                  },
                );
              },
            ).toList();
          }
        }());
      },
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  final String? label;
  final double? height;

  HorizontalDivider({this.label, this.height});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 15.0),
          child: Divider(
            color: Color(0xffd32026),
            height: height ?? 1,
          ),
        ),
      ),
      Text(
        label ?? '',
        style: TextStyle(color: Color(0xffd32026)),
      ),
      Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 15.0, right: 10.0),
          child: Divider(
            color: Color(0xffd32026),
            height: height ?? 1,
          ),
        ),
      )
    ]);
  }
}
