// import 'dart:convert;
import 'dart:convert';

import 'package:eshiblood/src/appointment/models/models.dart';
import 'package:dio/dio.dart';
import 'package:eshiblood/src/auth/repository/secure_storage.dart';
import 'package:eshiblood/src/utilities/constants.dart';

class AppointmentDataProvider {
  static final String _baseUrl = '${Constants.emuBaseUrl}/appointments';

  AppointmentDataProvider();

  Future<Appointment?> create(Appointment appointment) async {
    final token = await SecureStorage().getToken();

    print("creating Appointment start ...");
    final response = await dio.post(
      '$_baseUrl/',
      data: {
        "userId": appointment.userId,
        "startDate": appointment.startDate,
        "endDate": appointment.endDate,
        "appointmentDescription": appointment.appointmentDescription,
        "weight": appointment.weight,
        "donationCenter": appointment.donationCenter,
        "healthCondition": appointment.healthCondition,
        "tattoo": appointment.tattoo,
        "pregnant": appointment.pregnant
      },
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

    print(response);
    if (response.statusCode == 201) {
      return Appointment.fromJson(
          jsonDecode(jsonEncode(response.data['appointment'])));
    } else {
      print("creating Appointment error ...");
      throw Exception("Could not create appointment");
    }
  }

  Future<Appointment> fetchOne(dynamic id) async {
    final token = await SecureStorage().getToken();

    print("fetching Appointment start ... $_baseUrl/$id");

    final response = await dio.get(
      '$_baseUrl/$id',
      options: Options(
        validateStatus: (status) {
          return status! < 500;
        },
        headers: {
          "accept": "/",
          // For latter use commented
          "Authorization": "Bearer ${token}",
          "Content-Type": "application/json"
        },
      ),
    );
    print(response.data["appointment"]);
    if (response.statusCode == 200) {
      return Appointment.fromJson(
          jsonDecode(jsonEncode(response.data["appointment"])));
    } else {
      throw Exception("fetching appointment by code failed");
    }
  }

  Future<List<Appointment>> fetchAll() async {
    final token = await SecureStorage().getToken();

    print("fetching Appointments start ...");
    final response = await dio.get(
      '$_baseUrl/',
      options: Options(
        headers: {
          "accept": "/",
          // For latter use commented
          "Authorization": "Bearer ${token}",
          "Content-Type": "application/json"
        },
      ),
    );
    print(response.data["result"]["docs"]);
    if (response.statusCode == 200) {
      final appointments =
          jsonDecode(jsonEncode(response.data["result"]["docs"]))
              as List<dynamic>;
      print(appointments.length);
      return appointments.map((a) => Appointment.fromJson(a)).toList();
    } else {
      throw Exception("fetching appointments by code failed");
    }
  }

  Future<List<Appointment>> fetchAllHistory() async {
    final token = await SecureStorage().getToken();

    print("fetching Appointments start ...");
    final response = await dio.get(
      '$_baseUrl/user/history',
      queryParameters: {"status": "donated"},
      options: Options(
        headers: {
          "accept": "/",
          // For latter use commented
          "Authorization": "Bearer ${token}",
          "Content-Type": "application/json"
        },
      ),
    );
    print(response.data["appointments"]["docs"]);
    if (response.statusCode == 200) {
      final appointments =
          jsonDecode(jsonEncode(response.data["appointments"]["docs"]))
              as List<dynamic>;
      print(appointments.length);
      return appointments.map((a) => Appointment.fromJson(a)).toList();
    } else {
      throw Exception("fetching appointments by code failed");
    }
  }

  Future<List<Appointment>> fetchAllPending() async {
    final token = await SecureStorage().getToken();

    print("fetching Pending Appointments start ...");
    final response = await dio.get(
      '$_baseUrl/',
      options: Options(
        headers: {
          "accept": "/",
          // For latter use commented
          "Authorization": "Bearer ${token}",
          "Content-Type": "application/json"
        },
      ),
    );
    if (response.statusCode == 200) {
      final appointments =
          jsonDecode(jsonEncode(response.data["result"]["docs"]))
              as List<dynamic>;
      print(appointments.length);
      return appointments.map((a) => Appointment.fromJson(a)).toList();
    } else {
      throw Exception("fetching appointments by code failed");
    }
  }

  Future<Appointment> update(dynamic id, Appointment appointment) async {
    final token = await SecureStorage().getToken();

    print("updating Appointment start ...");
    final response = await dio.patch('$_baseUrl/$id',
        data: {
          "userId": appointment.userId,
          "acceptorId": appointment.acceptorId,
          "startDate": appointment.startDate,
          "endDate": appointment.endDate,
          "status": appointment.status,
          "appointmentDescription": appointment.appointmentDescription,
          "weight": appointment.weight,
          "donationCenter": appointment.donationCenter,
          "healthCondition": appointment.healthCondition,
          "tattoo": appointment.tattoo,
          "pregnant": appointment.pregnant,
        },
        options: Options(
          headers: {
            "accept": "/",
            // For latter use commented
            "Authorization": "Bearer ${token}",
            "Content-Type": "application/json"
          },
        ));
    if (response.statusCode == 200) {
      print(response.data);
      return Appointment.fromJson(
          jsonDecode(jsonEncode(response.data["appointment"])));
    } else {
      print("updating Appointment ended ...");
      throw Exception("Could not update appointment");
    }
  }

  Future<void> delete(dynamic id) async {
    final token = await SecureStorage().getToken();

    print("deleting appointment start...");
    final response = await dio.delete('$_baseUrl/$id',
        options: Options(
          headers: {
            "accept": "/",
            // For latter use commented
            "Authorization": "Bearer ${token}",
            "Content-Type": "application/json"
          },
        ));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete appointment");
    }
  }
}
