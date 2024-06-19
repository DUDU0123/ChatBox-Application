import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthenticationRepo {
  void createAccountInChatBoxUsingPhoneNumber({
    required BuildContext context,
    required String phoneNumber,
  });
  Future<UserCredential> verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String otpCode,
    required Function onSuccess,
  });
  void signOutUser({required userId});
  Future<void> setUserAuthStatus({required bool isSignedIn});
  Future<bool> getUserAthStatus();
}
