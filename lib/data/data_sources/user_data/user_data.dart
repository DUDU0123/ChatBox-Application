import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/data/models/user_model/user_model.dart';

class UserData {
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  final FirebaseAuth firebaseAuth;
  UserData({
    required this.firestore,
    required this.firebaseStorage,
    required this.firebaseAuth,
  });

  // Method to get all users
  Future<List<UserModel>> getAllUsersFromDataBase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> allUsersQuerySnapshot =
          await firestore.collection(usersCollection).get();
      return allUsersQuerySnapshot.docs
          .map(
            (doc) => UserModel.fromJson(
              map: doc.data(),
            ),
          )
          .toList();
    } catch (e, stackTrace) {
      log('Error while fetching all users: $e', stackTrace: stackTrace);
      throw Exception("Error while fetching all users: $e");
    }
  }

  // Method to get one user by ID
  Future<UserModel?> getOneUserDataFromDataBase(
      {required String userId}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection(usersCollection).doc(userId).get();
      if (documentSnapshot.exists) {
        return UserModel.fromJson(map: documentSnapshot.data()!);
      } else {
        log('User not found with ID: $userId');
        return null;
      }
    } catch (e, stackTrace) {
      log('Error while fetching user data: $e', stackTrace: stackTrace);
      throw Exception("Error while fetching user data: $e");
    }
  }

  // Method to save user data to DB
  Future<void> saveUserDataToDB(
      {required UserModel userData, File? profileImage}) async {
    try {
      if (profileImage != null) {
        final userProfileImage = await saveUserFileToDataBaseStorage(
            ref: "profile_images/${userData.id}", file: profileImage);
        userData = userData.copyWith(userProfileImage: userProfileImage);
      }
      await firestore
          .collection(usersCollection)
          .doc(userData.id)
          .set(userData.toJson());
    } catch (e, stackTrace) {
      log('Error while saving user data: $e', stackTrace: stackTrace);
      throw Exception("Error while saving user data: $e");
    }
  }

  // Method to update user in DB
  Future<void> updateUserInDB(
      {required UserModel userData, File? profileImage}) async {
    try {
      if (profileImage != null) {
        final userProfileImage = await saveUserFileToDataBaseStorage(
            ref: "profile_images/${userData.id}", file: profileImage);
        userData = userData.copyWith(userProfileImage: userProfileImage);
      }
      log("User data updating...");
      
      await firestore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser?.uid)
          .update(userData.toJson());
      log("User data updated");
    } catch (e, stackTrace) {
      log('Error while updating user data: $e', stackTrace: stackTrace);
      throw Exception("Error while updating user data: $e");
    }
  }

  // Method to delete user in DB
  Future<void> deleteUserInDB({required String userId}) async {
    try {
      await firestore.collection(usersCollection).doc(userId).delete();
    } catch (e, stackTrace) {
      log('Error while deleting user data: $e', stackTrace: stackTrace);
      throw Exception("Error while deleting user data: $e");
    }
  }

  // Method to save user file to database storage
  Future<String> saveUserFileToDataBaseStorage({
    required String ref,
    required File file,
  }) async {
    try {
      UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e, stackTrace) {
      log('Error while saving file to storage: $e', stackTrace: stackTrace);
      throw Exception("Error while saving file to storage: $e");
    }
  }

  // Method to save current user profile image to DB
  Future<void> saveUserProfileImageToDatabase(
      {required File? profileImage}) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null && profileImage != null) {
        final userProfileImage = await saveUserFileToDataBaseStorage(
            ref: "profile_images/${currentUser.uid}", file: profileImage);
        await firestore
            .collection(usersCollection)
            .doc(currentUser.uid)
            .update({
          'profileImage': userProfileImage,
        });
      } else {
        log('Current user or profile image is null');
      }
    } catch (e, stackTrace) {
      log('Error while saving profile image to database: $e',
          stackTrace: stackTrace);
      throw Exception("Error while saving profile image to database: $e");
    }
  }
}
