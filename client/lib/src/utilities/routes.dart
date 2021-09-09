import 'package:eshiblood/src/admin/screens/dashboard_screen.dart';

import 'package:eshiblood/src/appointment/models/models.dart';
import 'package:eshiblood/src/appointment/screens/appointment_add.dart';
import 'package:eshiblood/src/appointment/screens/appointment_current.dart';
import 'package:eshiblood/src/auth/screens/eligibility_screen.dart';
import 'package:eshiblood/src/auth/screens/login_screen.dart';
import 'package:eshiblood/src/auth/screens/registration_screen.dart';
import 'package:eshiblood/src/donation_center/screens/create_donation_center.dart';
import 'package:eshiblood/src/request/screen/request_list_screen.dart';
import 'package:eshiblood/src/auth/screens/welcome_screen.dart';
import 'package:eshiblood/src/request/model/request.dart';
import 'package:eshiblood/src/request/screen/create_request.dart';
import 'package:eshiblood/src/request/screen/request_detail.dart';
import 'package:eshiblood/src/role_management/models/role_args.dart';
import 'package:eshiblood/src/role_management/screens/role_details.dart';
import 'package:eshiblood/src/role_management/screens/role_manage.dart';
import 'package:eshiblood/src/user/screens/donation_card_screen.dart';
import 'package:eshiblood/src/user/screens/donation_history_screen.dart';
import 'package:eshiblood/src/user/screens/home_screen.dart';
import 'package:eshiblood/src/user/screens/profile_screen.dart';
import 'package:eshiblood/src/user/screens/profile_screen_edit.dart';
import 'package:eshiblood/src/user/screens/setting_screen.dart';
import 'package:eshiblood/src/userList/models/user_args.dart';
import 'package:eshiblood/src/userList/screens/user_detail.dart';
import 'package:eshiblood/src/userList/screens/users_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String welcomeScreen = "/";
  static const String loginScreen = "/login";
  static const String registrationScreen = "/registration";
  static const String eligibilityNoticeScreen = "/eligibilityNotice";


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcomeScreen:
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
     
    }
  }
}

class RequestArgument {
  final Request? request;
  final bool edit;
  RequestArgument({this.request, required this.edit});
}

class AppointmentArgument {
  final Appointment? appointment;
  final bool edit;
  AppointmentArgument({this.appointment, required this.edit});
}
