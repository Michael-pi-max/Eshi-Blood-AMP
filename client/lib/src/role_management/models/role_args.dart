import 'package:eshiblood/src/role_management/models/role_model.dart';

class RoleArgument {
  final Role? role;
  final bool edit;
  final bool create;
  RoleArgument({this.role, this.edit = false, this.create = false});
}
