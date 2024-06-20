import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:chatbox/data/data_sources/user_data/user_data.dart';
import 'package:chatbox/data/models/user_model/user_model.dart';
import 'package:chatbox/domain/repositories/user_repo/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final UserData userData;
  UserRepositoryImpl({
    required this.userData,
  });
  // method to get all users
  @override
  Future<List<UserModel>> getAllUsersFromDB() async {
      return userData.getAllUsersFromDataBase();
  }

  // method to get one user by id
  @override
  Future<UserModel> getOneUserDataFromDB({required String userId}) async {
    return userData.getOneUserDataFromDataBase(userId: userId);
  }

  @override
  Future<void> saveUserDataToDataBase(
      {required UserModel userModel,File? profileImage}) async {
    userData.saveUserDataToDB(userData: userModel);
  }

  
  @override
  Future<void> updateUserInDataBase({required UserModel userModel, required File? profileImage}) async {
    userData.updateUserInDB(userData: userModel, profileImage: profileImage);
  }
  
  @override
  Future<void> deleteUserInDataBase({required String userId}) async {
    deleteUserInDataBase(userId: userId);
  }

  @override
  Future<String> saveUserFileToDBStorage({
    required String ref,
    required File file,
  }) async {
    return userData.saveUserFileToDataBaseStorage(ref: ref, file: file);
  }
}
