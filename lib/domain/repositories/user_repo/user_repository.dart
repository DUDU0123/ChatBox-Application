import 'dart:io';

import 'package:chatbox/data/models/user_model/user_model.dart';

abstract class UserRepository {
  Future<void> saveUserDataToDataBase({
    required UserModel userModel,
    File? profileImage,
  });
  Future<void> updateUserInDataBase({
    required UserModel userModel,
    File? profileImage,
  });
  Future<List<UserModel>> getAllUsersFromDB();
  Future<UserModel?> getOneUserDataFromDB({required String userId});
  Future<void> deleteUserInDataBase({required String userId});
  Future<String> saveUserFileToDBStorage({
    required String ref,
    required File file,
  });
  Future<void> saveUserProfileImageToDatabase({
    required File? profileImage,
    required UserModel currentUser,
  });
  // Future<void> saveUserProfileImageUrl(String url);
  // Future<String?> getUserProfileImageUrl();
  // void userChangeNumber();
  // void userDeleteAccount();
  // void blockUser();
  // void reportUser();
}
