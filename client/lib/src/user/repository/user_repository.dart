import 'package:eshiblood/src/user/data_provider/user_data_provider.dart';

class UserProfileRepository {
  final UserProfileProvider userProfileProvider;

  UserProfileRepository({required this.userProfileProvider});
  Future<void> updateProfile(String phoneNumber) async {
    print("------------> Repository Update Profile");
    return await userProfileProvider.updateProfile(phoneNumber);
  }

  Future<void> deleteUser(String id) async {
    return await userProfileProvider.deleteUser(id);
  }
}
