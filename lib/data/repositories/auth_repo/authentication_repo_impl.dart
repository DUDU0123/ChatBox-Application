import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chatbox/core/constants/app_constants.dart';
import 'package:chatbox/core/utils/snackbar.dart';
import 'package:chatbox/domain/repositories/authentication_repo/authentication_repo.dart';

const userAuthStatusKey = "is_user_signedIn";

class AuthenticationRepoImpl extends AuthenticationRepo {
  final FirebaseAuth firebaseAuth;
  AuthenticationRepoImpl({
    required this.firebaseAuth,
  });
  @override
  Future<void> createAccountInChatBoxUsingPhoneNumber({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.pushNamed(
            context,
            "verify_number",
            arguments: AuthOtpModel(
              phoneNumber: phoneNumber,
              verifyId: verificationId,
              forceResendingToken: forceResendingToken,
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      commonSnackBarWidget(context: context, contentText: e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<UserCredential> verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String otpCode,
    required Function onSuccess,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );
      Future<UserCredential> value = firebaseAuth.signInWithCredential(credential);
      // Set user authentication status in SharedPreferences
      await setUserAuthStatus(isSignedIn: true);
      onSuccess();
      return value;
    } on FirebaseAuthException catch (e) {
      commonSnackBarWidget(
        context: context,
        contentText: e.message.toString(),
      );
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> signOutUser({required userId}) async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<bool> getUserAthStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(userAuthStatusKey) ?? false;
  }

  @override
  Future<void> setUserAuthStatus({required bool isSignedIn}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(userAuthStatusKey, isSignedIn);
  }

  @override
  Future<void> resentOtp({
    required BuildContext context,
    required String phoneNumber,
    required int? forceResendingToken,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        forceResendingToken:
            forceResendingToken, // Use the resending token here
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          forceResendingToken =
              forceResendingToken; // Update the resending token
          Navigator.pushNamed(
            context,
            "verify_number",
            arguments: AuthOtpModel(
              phoneNumber: phoneNumber,
              verifyId: verificationId,
              forceResendingToken: forceResendingToken,
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      commonSnackBarWidget(
        context: context,
        contentText: e.toString(),
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
