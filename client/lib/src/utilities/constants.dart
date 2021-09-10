import 'package:dio/dio.dart';
import 'package:eshiblood/src/auth/repository/secure_storage.dart';

class Constants {
  static final String url = "http://127.0.0.1:8000";
  static final String baseUrl = "http://127.0.0.1:8000/api/v1";
  static final String emuBaseUrl = "http://10.0.2.2:8000/api/v1";
  static final String imageBaseUrl = "http://10.0.2.2:8000/";
}

BaseOptions options = new BaseOptions(
    connectTimeout: 10 * 1000, // 60 seconds
    receiveTimeout: 10 * 1000 // 60 seconds,

    );
final dio = Dio(options);
