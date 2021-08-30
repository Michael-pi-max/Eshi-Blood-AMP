import 'package:dio/dio.dart';
import 'package:eshiblood/src/auth/repository/secure_storage.dart';
import 'package:eshiblood/src/role_management/models/role_model.dart';
import 'package:eshiblood/src/utilities/constants.dart';

class RoleDataProvider {
  final dio = Dio();

  Future<Role> createRole(Role role) async {
    print("Fetching Start Role data provider...\nCreate Role");
    final token = await SecureStorage().getToken();
    final response = await dio.post(
      '${Constants.emuBaseUrl}/roles',
      data: {
        "roleName": role.roleName,
        "privileges": role.privileges,
      },
      options: Options(headers: <String, String>{
        "accept": "/",
        // For latter use commented
        "Authorization": "Bearer ${token}",
        'Content-Type': 'application/json; charset=UTF-8'
      }, validateStatus: (status) => status! < 500),
    );
    // print("After Awaiting In Role data provider...");
    if (response.statusCode == 201) {
      return Role.fromJson(response.data['role']);
    } else {
      throw Exception('Failed to create role');
    }
  }

  Future<List<Role>> getroles() async {
    print("Fetching Start Role data provider...\nGet Roles");
    // print(await SecureStorage().getToken());
    final token = await SecureStorage().getToken();
    final response = await dio.get(
      "${Constants.emuBaseUrl}/roles",
      options: Options(headers: <String, String>{
        "accept": "/",
        // For latter use commented
        "Authorization": "Bearer ${token}",
      }, validateStatus: (status) => status! < 500),
    );
    // print(response.data);
    if (response.statusCode == 200) {
      // print("------------------> Done");
      final roles = response.data['result']['docs'] as List;
      // print("------------------> Returning roles");
      return roles.map((role) => Role.fromJson(role)).toList();
    } else {
      throw Exception('Failed to load roless');
    }
  }

  Future<void> deleteRole(String id) async {
    final token = await SecureStorage().getToken();
    final response = await dio.delete(
      '${Constants.emuBaseUrl}/roles/$id',
      options: Options(
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer ${token}",
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete role...');
    }
  }

  Future<void> updateRole(Role role) async {
    print('Fetching Start Role data provider...\nUpdate role');
    print("from roledata provider");
    final token = await SecureStorage().getToken();
    final response = await dio.patch(
      '${Constants.emuBaseUrl}/roles/${role.id}',
      data: {
        "id": role.id,
        "roleName": role.roleName,
        "privileges": role.privileges,
      },
      options: Options(headers: <String, String>{
        "accept": "/",
        // For latter use commented
        "Authorization": "Bearer ${token}",
        'Content-Type': 'application/json; charset=UTF-8'
      }, validateStatus: (status) => status! < 500),
    );
    print("After Await");
    if (response.statusCode != 200) {
      throw Exception('Failed to update role...');
    }
  }
}
