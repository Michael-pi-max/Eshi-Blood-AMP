abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class SubmissionSuccess extends FormSubmissionStatus {}

// Used for finding out the user is an admin
// class SubmissionAdminSuccess extends FormSubmissionStatus {}

class SubmissionFailed extends FormSubmissionStatus {
  final String errorMessage;

  SubmissionFailed(this.errorMessage);
}
