import 'dart:developer';
import 'package:chatbox/core/utils/snackbar.dart';
import 'package:chatbox/domain/repositories/authentication_repo/authentication_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const userAuthStatusKey = "is_user_signedIn";

class AuthenticationRepoImpl extends AuthenticationRepo {
  static FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void createAccountInChatBoxUsingPhoneNumber({
    required BuildContext context,
    required String phoneNumber,
  }) {
    try {
      auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.pushNamed(context, "verify_number",
              arguments: verificationId);
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
      FirebaseAuth auth = FirebaseAuth.instance;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );
      Future<UserCredential> value = auth.signInWithCredential(credential);
      // Set user authentication status in SharedPreferences
      setUserAuthStatus(isSignedIn: true);
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
      await auth.signOut();
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
  
  
}
