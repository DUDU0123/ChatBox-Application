import 'dart:io';
import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/data/models/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserData{
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  // method to get all users
  Future<List<UserModel>> getAllUsersFromDataBase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> allUsersQureySnapShot =
          await firestore.collection(usersCollection).get();
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
  Future<UserModel> getOneUserDataFromDataBase({required String userId}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection(usersCollection).doc(userId).get();
      if (documentSnapshot.exists) {
        return UserModel.fromJson(map: documentSnapshot.data()!);
      } else {
        return UserModel();
      }
    } catch (e) {
      throw Exception("Error while fetching user data: $e");
    }
  }

  Future<void> saveUserDataToDB(
      {required UserModel userData,File? profileImage}) async {
    try {
      if (profileImage != null) {
        final userProfileImage = await saveUserFileToDataBaseStorage(
            ref: "profile_images/${userData.id}", file: profileImage);
        userData = userData.copyWith(userProfileImage: userProfileImage);
      }
      await firestore.collection(usersCollection).doc(userData.id).set(userData.toJson());
    } catch (e) {
      throw Exception("Error while saving user data: $e");
    }
  }

  
  Future<void> updateUserInDB({required UserModel userData, required File? profileImage}) async {
    try {
      if (profileImage != null) {
        final userProfileImage = await saveUserFileToDataBaseStorage(
            ref: "profile_images/${userData.id}", file: profileImage);
        userData = userData.copyWith(userProfileImage: userProfileImage);
      }
      await firestore.collection(usersCollection).doc(userData.id).update(userData.toJson());
    } catch (e) {
      throw Exception("Error while updating user data: $e");
    }
  }
  
  Future<void> deleteUserInDB({required String userId}) async {
    try {
     await firestore.collection(usersCollection).doc(userId).delete();
    } catch (e) {
      throw Exception("Error while deleting user data: $e");
    }
  }

  Future<String> saveUserFileToDataBaseStorage({
    required String ref,
    required File file,
  }) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}