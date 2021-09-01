import 'package:eshiblood/src/auth/bloc/form_submission_status.dart';
import 'package:eshiblood/src/auth/models/user_model.dart';

class LoginState {
  final String phoneNumber;
  bool get isPhoneNumberValid => phoneNumber.startsWith('09');
  final String password;
  bool get isPasswordValid => password.length >= 4;
  final User? user;
  final FormSubmissionStatus formStatus;

  LoginState({
    this.phoneNumber = '',
    this.password = '',
    this.user,
    FormSubmissionStatus this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
    String? phoneNumber,
    String? password,
    User? user,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      user: user ?? this.user,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
