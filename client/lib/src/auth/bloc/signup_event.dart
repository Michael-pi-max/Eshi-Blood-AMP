abstract class SignUpEvent {}

class SignUpFirstNameChanged extends SignUpEvent {
  final String firstName;

  SignUpFirstNameChanged({required this.firstName});
}

class SignUpLastNameChanged extends SignUpEvent {
  final String lastName;

  SignUpLastNameChanged({required this.lastName});
}

class SignUpPhoneNumberChanged extends SignUpEvent {
  final String phoneNumber;

  SignUpPhoneNumberChanged({required this.phoneNumber});
}

class SignUpEmailChanged extends SignUpEvent {
  final String email;

  SignUpEmailChanged({required this.email});
}

class SignUpPasswordChanged extends SignUpEvent {
  final String password;

  SignUpPasswordChanged({required this.password});
}

class SignUpProfileChanged extends SignUpEvent {
  final dynamic profile;

  SignUpProfileChanged({required this.profile});
}

class SignUpDateOfBirthChanged extends SignUpEvent {
  final String dateOfBirth;

  SignUpDateOfBirthChanged({required this.dateOfBirth});
}

class SignUpGenderChanged extends SignUpEvent {
  final String gender;

  SignUpGenderChanged({required this.gender});
}

class Reset extends SignUpEvent{
  
}

class SignUpBloodTypeChanged extends SignUpEvent {
  final String bloodType;

  SignUpBloodTypeChanged({required this.bloodType});
}

class SignUpSubmitted extends SignUpEvent {}
