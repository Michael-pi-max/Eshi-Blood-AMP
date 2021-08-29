import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eshiblood/src/auth/repository/secure_storage.dart';
import 'package:eshiblood/src/donation_center/models/donation_center.dart';
import 'package:eshiblood/src/utilities/constants.dart';

class DonationCenterDataProvider {
  final dio = Dio();
  static final String _baseUrl = '${Constants.emuBaseUrl}';

  Future<DonationCenter> createDonationCenter(
      DonationCenter donationCenter) async {
    final token = await SecureStorage().getToken();

    final response = await dio.post("${_baseUrl}/donationcenters",
        data: jsonEncode(<String, dynamic>{
          "address": donationCenter.address,
          "name": donationCenter.name,
          "timeSlot": donationCenter.timeSlot,
        }),
        options: Options(
          headers: {
            "accept": "/",
            // For latter use commented
            "Authorization": "Bearer ${token}",
            "Content-Type": "application/json"
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    print("entry");
    print(response.data);
    print(response.statusCode);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("response*********");
      print(response.data);
      return DonationCenter.fromJson(response.data["donationCenter"]);
    } else {
      print(response.statusMessage);
      throw Exception("Failed to Load DonationCenter");
    }
  }

  Future<List<DonationCenter>> getDonationCenters() async {
    final token = await SecureStorage().getToken();

    // print("ggggggggeeeeeeeeeeeeeettttttttttttt");
    final response = await dio.get("${_baseUrl}/DonationCenters",
        options: Options(
          headers: {
            "accept": "/",
            // For latter use commented
            "Authorization": "Bearer ${token}",
            "Content-Type": "application/json"
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (response.statusCode == 200) {
      // print(response.data["result"]["docs"]);
      final donationCenters = response.data["result"]["docs"] as List;
      // print(donationCenters);
      print("DonationCenters ***********************");
      return donationCenters
          .map((donationCenter) => DonationCenter.fromJson(donationCenter))
          .toList();
    } else {
      throw Exception("Failed To Load DonationCenters");
    }
  }

  Future<DonationCenter> getDonationCenter(String id) async {
    final token = await SecureStorage().getToken();

    final response = await dio.get(
      "${_baseUrl}/DonationCenters/$id",
      options: Options(
        headers: {
          "accept": "/",
          // For latter use commented
          "Authorization": "Bearer ${token}",
          "Content-Type": "application/json"
        },
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    if (response.statusCode == 200) {
      // print(response.data["result"]["docs"]);
      final donationCenter = response.data["donationCenter"];
      // print(donationCenters);
      print("DonationCenter ************ $id  ***********");
      return DonationCenter.fromJson(donationCenter);
    } else {
      throw Exception("Failed To Load DonationCenters");
    }
  }

  Future<void> deleteDonationCenter(String id) async {
    final token = await SecureStorage().getToken();

    final response = await dio.delete(
      "${_baseUrl}/DonationCenters/$id",
      options: Options(
        headers: {
          "accept": "/",
          // For latter use commented
          "Authorization": "Bearer ${token}",
          "Content-Type": "application/json"
        },
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to delete DonationCenter");
    }
  }

  Future<DonationCenter> updateDonationCenter(
      DonationCenter donationCenter) async {
    final token = await SecureStorage().getToken();

    final response = await dio.patch(
      "${_baseUrl}/DonationCenters/${donationCenter.id}",
      data: jsonEncode(
        <String, dynamic>{
          "address": donationCenter.address,
          "name": donationCenter.name,
          "status": donationCenter.status,
          "timeSlot": donationCenter.timeSlot,
        },
      ),
      options: Options(
        headers: {
          "accept": "/",
          // For latter use commented
          "Authorization": "Bearer ${token}",
          "Content-Type": "application/json"
        },
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    if (response.statusCode == 200) {
      print("tried to access from json ************************");
      return DonationCenter.fromJson(response.data["donationCenter"]);
    } else {
      throw Exception("Failed to Update DonationCenter******");
    }
  }
}
