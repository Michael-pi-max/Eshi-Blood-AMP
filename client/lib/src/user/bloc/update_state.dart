import 'package:eshiblood/src/auth/bloc/form_submission_status.dart';

class UpdateState {
  final String phoneNumber;
  bool get isPhoneNumberValid => phoneNumber.startsWith('09');

  final FormSubmissionStatus formStatus;

  UpdateState(
      {this.phoneNumber = '',
      FormSubmissionStatus this.formStatus = const InitialFormStatus()});

  UpdateState copyWith(
      {String? phoneNumber,
      String? password,
      FormSubmissionStatus? formStatus}) {
    return UpdateState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
