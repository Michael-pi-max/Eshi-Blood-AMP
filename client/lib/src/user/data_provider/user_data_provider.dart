import 'package:dio/dio.dart';
import 'package:eshiblood/src/auth/repository/secure_storage.dart';
import 'package:eshiblood/src/utilities/constants.dart';

class UserProfileProvider {
  UserProfileProvider();
  Future<void> updateProfile(String phoneNumber) async {
    try {
      print(await SecureStorage().getToken());
      print('Fetching Start User update data provider...');

      var token = await SecureStorage().getToken();
      var id = await SecureStorage().getId();

      var response = await Dio().patch('${Constants.emuBaseUrl}/users/${id}',
          data: {"phoneNumber": phoneNumber},
          options: Options(headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          }, validateStatus: (status) => status! < 500));

      if (response.statusCode == 200) {
        print('-------------------> Done');
      } else {
        throw Exception('Fetching Failed User list data provider...');
      }
    } catch (e) {
      throw Exception('Fetching Failed User list data provider...');
    }
  }

  Future<void> deleteUser(String id) async {
    // final id = await SecureStorage().getId();
    final token = await SecureStorage().getToken();
    final response = await Dio().delete('${Constants.emuBaseUrl}/users/$id',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer ${token}",
          },
        ));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete role...');
    }
  }
}
