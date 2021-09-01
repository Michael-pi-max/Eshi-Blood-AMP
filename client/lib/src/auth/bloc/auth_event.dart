import 'package:eshiblood/src/auth/models/user_model.dart';

abstract class AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final User? user;
  final String? phoneNumber;
  final dynamic role;
  final String? token;
  final String? id;

  LoggedIn({this.phoneNumber, this.role, this.token, this.id, this.user});
}

class LoggedOut extends AuthenticationEvent {}

class WelcomeScreenCompleted extends AuthenticationEvent {}
