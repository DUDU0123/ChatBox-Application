import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chatbox/core/constants/app_constants.dart';
import 'package:chatbox/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:chatbox/presentation/pages/mobile_view/splash_screen/splash_screen.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:chatbox/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/data/models/user_model/user_model.dart';
import 'package:chatbox/domain/repositories/authentication_repo/authentication_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserData {
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  final FirebaseAuth firebaseAuth;
  final AuthenticationRepo authenticationRepo;
  UserData({
    required this.firestore,
    required this.firebaseStorage,
    required this.firebaseAuth,
    required this.authenticationRepo,
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
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while fetching all user: $e");
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
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while fetching user data: $e");
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
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while saving user data: $e");
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
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while updating user data: $e");
    } catch (e, stackTrace) {
      log('Error while updating user data: $e', stackTrace: stackTrace);
      throw Exception("Error while updating user data: $e");
    }
  }

  // Method to delete user in DB
  Future<void> deleteUserInFireStoreDB({required String userId}) async {
    try {
      await firestore.collection(usersCollection).doc(userId).delete();
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while deleting user data: $e");
    } catch (e, stackTrace) {
      log('Error while deleting user data: $e', stackTrace: stackTrace);
      throw Exception("Error while deleting user data: $e");
    }
  }

  // Future<void> deleteUserFilesInDB({required String fullPathToFile}) async {
  //   log(name: "FilePath", fullPathToFile);
  //   try {
  //     Reference fileReference = firebaseStorage.ref(fullPathToFile);
  //     final FullMetadata metaDataInLocation = await fileReference.getMetadata();
  //     if (metaDataInLocation.size! > 0) {
  //       await fileReference.delete();
  //     } else {
  //       return;
  //     }
  //     // await fileReference.delete();
  //   } on FirebaseAuthException catch (e) {
  //     log(
  //       'Firebase Auth exception: $e',
  //     );
  //     throw Exception("Error while deleting user data: $e");
  //   } catch (e) {
  //     log(
  //       'Error while deleting user file: $e',
  //     );
  //     throw Exception("Error while deleting user data: $e");
  //   }
  // }
  Future<void> deleteUserFilesInDB({required String fullPathToFile}) async {
  log(name: "FilePath", fullPathToFile);
  try {
    Reference fileReference = firebaseStorage.ref(fullPathToFile);

    // Check if the file exists by attempting to get its metadata
    await fileReference.getMetadata();

    // If the file exists, proceed to delete it
    await fileReference.delete();
    log('File deleted successfully');
  } on FirebaseException catch (e) {
    if (e.code == 'object-not-found') {
      log('File does not exist at path: $fullPathToFile');
      return;
    } else {
      log('Firebase exception: $e');
      throw Exception("Error while deleting user data: $e");
    }
  } catch (e) {
    log('Error while deleting user file: $e');
    throw Exception("Error while deleting user data: $e");
  }
}


  Future<void> deleteUserAuthInDB({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      if (firebaseAuth.currentUser != null) {
        await firebaseAuth.currentUser?.delete();
        await authenticationRepo.setUserAuthStatus(isSignedIn: false);
      } else {
        return;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        log('The user must reauthenticate before this operation can be executed.');
        await reAuthenticateUser(
          phoneNumber: phoneNumber,
          context: context,
        );
        await firebaseAuth.currentUser?.delete();
        await authenticationRepo.setUserAuthStatus(isSignedIn: false);
      }
    } catch (e) {
      log(
        'Error while deleting user from auth: $e',
      );
      throw Exception("Error while deleting user from auth: $e");
    }
  }

  Future<void> reAuthenticateUser({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    User? user = firebaseAuth.currentUser;

    try {
      PhoneAuthCredential credential = await getPhoneAuthCredential(
        context: context,
        phoneNumber: phoneNumber,
      );
      log("User reauthicate 203 file: userdata: ${credential.verificationId}");
      await user?.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      log('Reauthentication error: $e');
      throw Exception('Reauthentication error: $e');
    } catch (e) {
      log('No user is currently signed in');
      throw Exception('No user is currently signed in');
    }
  }

  Future<PhoneAuthCredential> getPhoneAuthCredential({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    TextEditingController smsController = TextEditingController();
    Completer<PhoneAuthCredential> completer = Completer();

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        completer.complete(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        completer.completeError(e);
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Prompt the user to enter the OTP
        // String smsCode;
        showDialog(
          context: context,
          builder: (context) => alertDialog(
            context: context,
            title: "Delete account confirmation",
            content: TextFieldCommon(
              controller: smsController,
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: smsController.text,
              );
              completer.complete(credential);
            },
            actionButtonName: "Submit",
          ),
        ); // Implement this function to get the OTP from the user
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return completer.future;
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
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while saving file to storage: $e");
    } catch (e, stackTrace) {
      log('Error while saving file to storage: $e', stackTrace: stackTrace);
      throw Exception("Error while saving file to storage: $e");
    }
  }

  // Method to save current user profile image to DB
  Future<void> saveUserProfileImageToDatabase({
    required File? profileImage,
    required UserModel currentUser,
  }) async {
    try {
      if (currentUser != null && profileImage != null) {
        final userProfileImage = await saveUserFileToDataBaseStorage(
            ref: "$usersProfileImageFolder${currentUser.id}",
            file: profileImage);
        await firestore.collection(usersCollection).doc(currentUser.id).update({
          'profileImage': userProfileImage,
        });
      } else {
        log('Current user or profile image is null');
      }
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while saving profile image to database: $e");
    } catch (e, stackTrace) {
      log('Error while saving profile image to database: $e',
          stackTrace: stackTrace);
      throw Exception("Error while saving profile image to database: $e");
    }
  }
}
