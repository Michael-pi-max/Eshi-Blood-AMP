import 'package:dio/dio.dart';
import 'package:eshiblood/src/auth/models/user_model.dart';
import 'package:eshiblood/src/auth/repository/secure_storage.dart';
import 'package:eshiblood/src/utilities/constants.dart';

class AuthProvider {
  AuthProvider();

  Future<dynamic> signup(User user) async {
    try {
      print("Fetching Start SignUp Data Provider...");
      String filename = user.image.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          user.image.path,
          filename: filename,
        ),
        "firstName": user.firstName,
        "lastName": user.lastName,
        "dateOfBirth": user.dateOfBirth,
        "email": user.email,
        "password": user.password,
        "phoneNumber": user.phoneNumber,
        "bloodType": user.bloodType,
        "gender": user.gender
      });

      var response = await Dio().post(
        'http://10.0.2.2:8000/api/v1/users/signup',
        data: formData,
        options: Options(
          headers: {
            "accept": "/",
            // For latter use commented
            // "Authorization" : "Bearer nsnadidasnkdw"
            "Content-Type": "multipart/form-data"
          },
        ),
      );
      if (response.statusCode == 201) {
        print("-------------------> Done");
        var user = User.fromJson(response.data["user"]);
        Map<String, dynamic> result = {
          "token": response.data["token"],
          "user": user
        };
        return result;
      }
    } catch (e) {
      print("Fetching Failed SignUp Data Provider...");
      return null;
    }
  }

  Future<dynamic> login(String phone, String password) async {
    try {
      print("Fetching Start Login Data Provider...");

      var response = await Dio().post('http://10.0.2.2:8000/api/v1/users/login',
          data: {'phoneNumber': phone, 'password': password});
      if (response.statusCode == 201) {
        var user = User.fromJson((response.data["user"]));
        print(user.appointed);
        print(user.totalDonations);
        Map<String, dynamic> result = {
          "token": response.data["token"],
          "user": user
        };

        return result;
      }
    } catch (e) {
      print("Fetching Failed Login Data Provider...");
      return null;
    }

    // Future<dynamic> getUser() async{
    //   try{
    //     print('Fetching Start Get User Data Provider...');
    //     var response =
    //   }
    // }
  }
}
