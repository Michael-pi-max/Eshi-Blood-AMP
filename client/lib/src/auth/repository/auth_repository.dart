import 'package:eshiblood/src/auth/data_provider/auth_data_provider.dart';
import 'package:eshiblood/src/auth/models/user_model.dart';

class AuthRepository {
  final AuthProvider authProvider;

  AuthRepository({required this.authProvider});
  Future<dynamic> signup(User user) async {
    print("------------> Repository SignUp");
    return await authProvider.signup(user);
  }

  Future<dynamic> login(String phone, String password) async {
    print('------------> Repository Login');
    return await authProvider.login(phone, password);
  }
}
