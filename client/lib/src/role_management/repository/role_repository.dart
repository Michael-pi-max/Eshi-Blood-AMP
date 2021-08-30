import 'package:eshiblood/src/role_management/data_provider/role_data_provider.dart';
import 'package:eshiblood/src/role_management/models/role_model.dart';

class RoleRepository {
  final RoleDataProvider dataProvider;

  RoleRepository({required this.dataProvider});

  Future<Role> createRole(Role role) async {
    print("------> from role repository");
    return await dataProvider.createRole(role);
  }

  Future<void> updateRole(Role role) async {
    print("------> from role repository-update");
    return await dataProvider.updateRole(role);
  }

  Future<List<Role>> getRoles() async {
    print("------> from role repository= get all");
    return await dataProvider.getroles();
  }

  Future<void> deleteRole(String id) async {
    print("------> from role repository= delete");
    await dataProvider.deleteRole(id);
  }
}
