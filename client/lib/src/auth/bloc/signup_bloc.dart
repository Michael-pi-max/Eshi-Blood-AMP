import 'dart:io';

import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/auth_event.dart';
import 'package:eshiblood/src/auth/bloc/form_submission_status.dart';
import 'package:eshiblood/src/auth/bloc/signup_event.dart';
import 'package:eshiblood/src/auth/bloc/signup_state.dart';
import 'package:eshiblood/src/auth/models/user_model.dart';
import 'package:eshiblood/src/auth/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepo;
  final AuthenticationBloc authenticationBloc;
  SignUpBloc({required this.authRepo, required this.authenticationBloc})
      : super(SignUpState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpFirstNameChanged) {
      yield state.copyWith(firstName: event.firstName);
    } else if (event is SignUpLastNameChanged) {
      yield state.copyWith(lastName: event.lastName);
    } else if (event is SignUpPhoneNumberChanged) {
      yield state.copyWith(phoneNumber: event.phoneNumber);
    } else if (event is SignUpEmailChanged) {
      yield state.copyWith(email: event.email);
    } else if (event is SignUpPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is SignUpDateOfBirthChanged) {
      yield state.copyWith(dateOfBirth: event.dateOfBirth);
    } else if (event is SignUpGenderChanged) {
      yield state.copyWith(gender: event.gender);
    } else if (event is SignUpBloodTypeChanged) {
      yield state.copyWith(bloodType: event.bloodType);
    } else if (event is Reset) {
      yield state.copyWith(
          firstName: '',
          lastName: '',
          phoneNumber: '',
          email: '',
          password: '',
          dateOfBirth: '',
          profile: null,
          gender: 'Male',
          bloodType: 'A+');
      yield state.copyWith(formStatus: InitialFormStatus());
    } else if (event is SignUpProfileChanged) {
      yield state.copyWith(profile: event.profile);
    } else if (event is SignUpSubmitted) {
      User user = User(
        firstName: state.firstName,
        lastName: state.lastName,
        phoneNumber: state.phoneNumber,
        email: state.email,
        password: state.password,
        image: File(state.profile.path),
        dateOfBirth: state.dateOfBirth,
        gender: state.gender,
        bloodType: state.bloodType,
      );

      yield state.copyWith(formStatus: FormSubmitting());

      try {
        var userCredential =
            await authRepo.signup(user) as Map<String, dynamic>;
        User newUser = userCredential["user"] as User;

        authenticationBloc.add(
          LoggedIn(
              phoneNumber: state.phoneNumber,
              role: newUser.role["roleName"],
              token: userCredential["token"],
              id: newUser.id,
              user: newUser),
        );

        yield state.copyWith(formStatus: SubmissionSuccess());
        yield state.copyWith(user: newUser);
      } catch (e) {
        yield state.copyWith(
          formStatus:
              SubmissionFailed('Submission Failed Error From SignUp Bloc...'),
        );
        yield state.copyWith(formStatus: InitialFormStatus());
        return;
      }
    }
  }
}
