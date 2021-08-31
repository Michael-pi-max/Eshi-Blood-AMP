import 'package:eshiblood/src/auth/models/user_model.dart';
import 'package:eshiblood/src/userList/data_provider/user_list_provider.dart';

class UserListRepository {
  final UserListProvider userListProvider;

  UserListRepository({required this.userListProvider});

  Future<List<User>> getUserList() async {
    print('--------------------> Repository UserList');
    return await userListProvider.getUserList();
  }

  Future<void> updateUser(String id, String roleId) async {
    print('--------------------> Repository UpdateUser');
    return await userListProvider.updateUser(id, roleId);
  }
}
