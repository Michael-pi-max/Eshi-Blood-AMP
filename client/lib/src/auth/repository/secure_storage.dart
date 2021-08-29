import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static SecureStorage? _instance;

  factory SecureStorage() =>
      _instance ??= SecureStorage._(FlutterSecureStorage());

  SecureStorage._(this._storage);

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'TOKEN';
  static const _phoneNumberKey = 'PHONENUMBER';
  static const _role = 'ROLE';
  static const _id = 'ID';

  Future<void> persistPhoneRoleAndToken(
      String phoneNumber, String role, String token, String id) async {
    await _storage.write(key: _phoneNumberKey, value: phoneNumber);
    await _storage.write(key: _role, value: role);
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _id, value: id);
  }

  Future<bool> hasId() async {
    var value = await _storage.read(key: _id);
    return value != null;
  }

  Future<bool> hasToken() async {
    var value = await _storage.read(key: _tokenKey);
    return value != null;
  }

  Future<bool> hasPhoneNumber() async {
    var value = await _storage.read(key: _phoneNumberKey);
    return value != null;
  }

  Future<bool> hasRole() async {
    var value = await _storage.read(key: _role);
    return value != null;
  }

  Future<void> deleteToken() async {
    return await _storage.delete(key: _tokenKey);
  }

  Future<void> deleteId() async {
    return await _storage.delete(key: _id);
  }

  Future<void> deletePhoneNumber() async {
    return await _storage.delete(key: _phoneNumberKey);
  }

  Future<void> deleteRole() async {
    return await _storage.delete(key: _role);
  }

  Future<String?> getId() async {
    return await _storage.read(key: _id);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<String?> getPhoneNumber() async {
    return await _storage.read(key: _phoneNumberKey);
  }

  Future<String?> getRole() async {
    return _storage.read(key: _role);
  }

  Future<void> deleteAll() async {
    return await _storage.deleteAll();
  }

  @override
  String toString() {
    return _tokenKey;
  }
}
