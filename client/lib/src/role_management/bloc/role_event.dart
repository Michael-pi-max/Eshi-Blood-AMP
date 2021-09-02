import 'package:equatable/equatable.dart';
import 'package:eshiblood/src/role_management/models/role_model.dart';

abstract class RoleEvent extends Equatable {
  const RoleEvent();
}

class RoleLoad extends RoleEvent {
  const RoleLoad();

  @override
  List<Object> get props => [];
}

class RoleCreate extends RoleEvent {
  final Role role;

  const RoleCreate(this.role);

  @override
  List<Object> get props => [Role];

  @override
  String toString() => 'Role Created {Role: $role}';
}

class RoleUpdate extends RoleEvent {
  final Role role;

  const RoleUpdate(this.role);

  @override
  List<Object> get props => [Role];

  @override
  String toString() => 'Role Updated {Role: $role}';
}

class RoleDelete extends RoleEvent {
  final Role role;

  const RoleDelete(this.role);

  @override
  List<Object> get props => [Role];

  @override
  toString() => 'Role Deleted {Role: $role}';
}

class RadioButtonSelected extends RoleEvent {
  final Role role;

  RadioButtonSelected({required this.role});

  @override
  List<Object?> get props => [Role];
}

class SubmissionButton extends RoleEvent {
  final Role role;
  SubmissionButton({required this.role});

  @override
  // TODO: implement props
  List<Object?> get props => [Role];
}
