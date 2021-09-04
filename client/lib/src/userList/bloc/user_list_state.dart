class UserListState {}

class UserListStateInitial extends UserListState {}

class UserListStateLoading extends UserListState {}

class UserListStateLoaded extends UserListState {
  final List<dynamic> users;

  UserListStateLoaded({required this.users});
}

class UserListStateError extends UserListState {
  final String error;

  UserListStateError({required this.error});
}

class UpdateUserRole extends UserListState {
  
}
