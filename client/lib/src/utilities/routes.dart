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
  static const String homeScreen = "/homeScreen";
  static const String dashboardScreen = "/dashboardScreen";
  static const String userListScreen = "/userListScreen";
  static const String donationHistoryScreen = "/donationHistoryScreen";
  static const String donorCardScreen = "/donorCardScreen";
  static const String profileScreen = "/profileScreen";
  static const String donationCenterCreate = "/donationCenterCreate";
  static const String requestCreate = "/requestCreate";
  static const String requestDetail = "/requestDetail";
  static const String roleManagement = "/roleManagement";
  static const String setting = "/setting";
  static const String requestList = "/requestList";
  static const String roleDetails = "/roleDetails";
  static const String appointmentAdd = 'appointmentAdd';
  static const String appointmentDetail = 'appointmentDetail';
  static const String appointmentList = "appointmentList";
  static const String roleManage = "/roleManage";
  static const String userDetails = "/userdetails";
  static const String editUserDetails = "/editUserDetails";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcomeScreen:
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case registrationScreen:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
      case eligibilityNoticeScreen:
        return MaterialPageRoute(builder: (_) => EligibilityNoticeScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case dashboardScreen:
        return MaterialPageRoute(builder: (_) => DashboardScreen());

      case donationHistoryScreen:
        return MaterialPageRoute(builder: (_) => DonationHistoryScreen());
      case donorCardScreen:
        return MaterialPageRoute(builder: (_) => DonationCardScreen());
      case profileScreen:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case appointmentAdd:
        AppointmentArgument args = settings.arguments as AppointmentArgument;
        return MaterialPageRoute(
            builder: (_) => AddAppointment(
                  args: args,
                ));
      case appointmentDetail:
        Appointment appointment = settings.arguments as Appointment;
        return MaterialPageRoute(
            builder: (_) => AppointmentCurrent(
                  appointment: appointment,
                ));
      case donationCenterCreate:
        return MaterialPageRoute(builder: (_) => CreateDonationCenter());
      case requestCreate:
        RequestArgument args = settings.arguments as RequestArgument;

        return MaterialPageRoute(
          builder: (_) => CreateRequestScaffold(RequestArgument, args: args),
        );
      case requestDetail:
        return MaterialPageRoute(
          builder: (_) => RequestDetail(
            request: settings.arguments as Request,
          ),
        );

      case requestList:
        return MaterialPageRoute(builder: (_) => RequestListScreen());
      case setting:
        return MaterialPageRoute(builder: (_) => SettingScreen());
      case roleDetails:
        RoleArgument args = settings.arguments as RoleArgument;
        return MaterialPageRoute(
            builder: (_) => RoleDetails(
                  args: args,
                ));
      case roleManage:
        return MaterialPageRoute(builder: (_) => RoleManage());

      case userDetails:
        UserArguments args = settings.arguments as UserArguments;
        return MaterialPageRoute(
            builder: (_) => UserDetails(
                  args: args,
                ));
      case userListScreen:
        return MaterialPageRoute(builder: (_) => UsersScreen());
      case editUserDetails:
        return MaterialPageRoute(builder: (_) => EditUserDetails());
      default:
        throw FormatException("Route was not found");
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
