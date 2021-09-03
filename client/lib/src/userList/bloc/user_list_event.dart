abstract class UserEvent {}

class UserListEvent extends UserEvent {
  final List<dynamic> users;

  UserListEvent(this.users);
}

class UpdateUserEvent extends UserEvent {
  final String? userId;
  final String? roleId;

  UpdateUserEvent({required this.userId, required this.roleId});
}
