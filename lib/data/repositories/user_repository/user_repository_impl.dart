import 'dart:io';

import 'package:chatbox/data/models/user_model/user_model.dart';
import 'package:chatbox/domain/repositories/user_repo/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserRepositoryImpl extends UserRepository{
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  // method to get all users
  @override
  Future<List<UserModel>> getAllUsersFromDB() async {
    try {
      QuerySnapshot<Map<String, dynamic>> allUsersQureySnapShot =
          await firestore.collection('users').get();
      return allUsersQureySnapShot.docs
          .map(
            (doc) => UserModel.fromJson(
              map: doc.data(),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception("Error while fetching all users: $e");
    }
  }

  // method to get one user by id
  @override
  Future<UserModel> getOneUserDataFromDB({required String userId}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection('users').doc(userId).get();
      if (documentSnapshot.exists) {
        return UserModel.fromJson(map: documentSnapshot.data()!);
      } else {
        return UserModel();
      }
    } catch (e) {
      throw Exception("Error while fetching user data: $e");
    }
  }

  @override
  Future<void> saveUserDataToDataBase(
      {required UserModel userData,File? profileImage}) async {
    try {
      if (profileImage != null) {
        final userProfileImage = await saveUserFileToDBStorage(
            ref: "profile_images/${userData.id}", file: profileImage);
        userData = userData.copyWith(userProfileImage: userProfileImage);
      }
      await firestore.collection('users').doc(userData.id).set(userData.toJson());
    } catch (e) {
      throw Exception("Error while saving user data: $e");
    }
  }

  
  @override
  Future<void> updateUserInDataBase({required UserModel userData, required File? profileImage}) async {
    try {
      if (profileImage != null) {
        final userProfileImage = await saveUserFileToDBStorage(
            ref: "profile_images/${userData.id}", file: profileImage);
        userData = userData.copyWith(userProfileImage: userProfileImage);
      }
      await firestore.collection('users').doc(userData.id).update(userData.toJson());
    } catch (e) {
      throw Exception("Error while updating user data: $e");
    }
  }
  
  @override
  Future<void> deleteUserInDataBase({required String userId}) async {
    try {
     await firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception("Error while deleting user data: $e");
    }
  }

  @override
  Future<String> saveUserFileToDBStorage({
    required String ref,
    required File file,
  }) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}