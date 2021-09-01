import 'package:eshiblood/src/auth/bloc/form_submission_status.dart';
import 'package:eshiblood/src/auth/models/user_model.dart';

class SignUpState {
  final String firstName;
  bool get isFirstNameValid => firstName.length >= 3;
  final String lastName;
  bool get isLastNameValid => lastName.length >= 3;
  final String phoneNumber;
  bool get isPhoneNumberValid => phoneNumber.startsWith('09');
  final String email;
  bool get isEmailValid => email.contains('@');
  final String password;
  bool get isPasswordValid => password.length >= 4;
  final String dateOfBirth;
  bool get isValidDateOfBirth => dateOfBirth.isNotEmpty;
  final String gender;
  final String bloodType;
  final dynamic profile;
  bool get isValidProfile => profile != null;
  final User? user;
  final FormSubmissionStatus formStatus;
  final dynamic role;

  SignUpState({
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.email = '',
    this.password = '',
    this.dateOfBirth = '',
    this.gender = 'male',
    this.bloodType = 'A+',
    this.profile = null,
    this.role = 'user',
    this.user,
    this.formStatus = const InitialFormStatus(),
  });

  SignUpState copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? password,
    String? dateOfBirth,
    String? gender,
    String? bloodType,
    dynamic profile,
    User? user,
    FormSubmissionStatus? formStatus,
  }) {
    return SignUpState(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        password: password ?? this.password,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        bloodType: bloodType ?? this.bloodType,
        profile: profile ?? this.profile,
        formStatus: formStatus ?? this.formStatus,
        user: user ?? this.user);
  }
}
