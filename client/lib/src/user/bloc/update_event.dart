abstract class UpdateEvent {}

class UpdatePhoneNumberChanged extends UpdateEvent {
  final String phoneNumber;
  UpdatePhoneNumberChanged({required this.phoneNumber});
}

class UpdateSubmitted extends UpdateEvent {}

class UpdateOut extends UpdateEvent {}

class DeleteButtonClicked extends UpdateEvent {
  final String? id;

  DeleteButtonClicked(this.id);
}
