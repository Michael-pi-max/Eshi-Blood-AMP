import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:eshiblood/src/auth/repository/secure_storage.dart';
import 'package:eshiblood/src/request/model/request.dart';
import 'package:eshiblood/src/utilities/constants.dart';

import 'package:http/http.dart' as http;

class RequestDataProvider {
  Future<Request> createRequest(Request request) async {
    final token = await SecureStorage().getToken();

    print("from create request");
    final response = await dio.post(
      "http://10.0.2.2:8000/api/v1/requests",
      data: {
        "bloodType": request.bloodType,
        "reason": request.reason,
        "unitsNeeded": request.unitsNeeded,
      },
      options: Options(
        headers: <String, String>{
          "accept": "/",
          // For latter use commented
          "Authorization": "Bearer ${token}"
        },
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Request.fromJson(response.data["request"]);
    } else {
      // print(response.statusMessage);
      throw Exception("Failed to Load Request");
    }
  }

  Future<List<Request>> getRequests() async {
    final token = await SecureStorage().getToken();

    final response = await dio.get(
      "${Constants.emuBaseUrl}/requests",
      options: Options(headers: <String, String>{
        "accept": "/",
        // For latter use commented
        "Authorization": "Bearer ${token}"
      }, validateStatus: (status) => status! < 500),
    );
    print(
        "==================================================================================================");
    if (response.statusCode == 200) {
      final requests = response.data["result"]["docs"] as List;
      print(requests);
      print(
          "end==================================================================================================");
      return requests.map((request) => Request.fromJson(request)).toList();
    } else {
      throw Exception("Failed To Load Requests");
    }
  }

  Future<Request> getRequest(String id) async {
    final token = await SecureStorage().getToken();

    final response = await dio.get(
      "${Constants.emuBaseUrl}/requests/$id",
      options: Options(
        headers: <String, String>{
          "accept": "/",
          // For latter use commented
          "Authorization": "Bearer ${token}"
        },
      ),
    );

    if (response.statusCode == 200) {
      return Request.fromJson(response.data["request"]);
    } else {
      throw Exception("Failed to Update Request******");
    }
  }

  Future<void> deleteRequest(String id) async {
    final token = await SecureStorage().getToken();

    print("delete");
    final response = await dio.delete(
      "${Constants.emuBaseUrl}/requests/${id}",
      options: Options(
        headers: <String, String>{
          "accept": "/",
          // For latter use commented
          "Authorization": "Bearer ${token}"
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to delete Request");
    }
  }

  Future<Request> updateRequest(Request request) async {
    final token = await SecureStorage().getToken();

    final response =
        await dio.patch("${Constants.emuBaseUrl}/requests/${request.id}",
            options: Options(
              headers: <String, String>{
                "accept": "/",
                // For latter use commented
                "Authorization": "Bearer ${token}"
              },
            ),
            data: jsonEncode(<String, dynamic>{
              "bloodType": request.bloodType,
              "reason": request.reason,
              "unitsNeeded": request.unitsNeeded,
              "status": request.status
            }));
    print("from update");
    if (response.statusCode == 200) {
      return Request.fromJson(response.data["request"]);
    } else {
      throw Exception("Failed to Update Request******");
    }
  }

  Future<Request> acceptRequest(String id) async {
    final token = await SecureStorage().getToken();

    final response = await dio.patch(
      "${Constants.emuBaseUrl}/requests/accept/${id}",
      options: Options(
        headers: <String, String>{
          "accept": "/",
          // For latter use commented
          "Authorization": "Bearer ${token}",
        },
      ),
    );

    print("from request accept");
    if (response.statusCode == 200) {
      return Request.fromJson(response.data["request"]);
    } else {
      throw Exception("Failed to Update Request******");
    }
  }
}
