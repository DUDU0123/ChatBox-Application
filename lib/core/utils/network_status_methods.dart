import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'dart:developer';

class NetworkStatusMethods {
  static updateUserNetworkStatusInApp({required bool isOnline}) async {
    await fireStore
        .collection(usersCollection)
        .doc(firebaseAuth.currentUser?.uid)
        .update({
      userDbLastActiveTime: DateTime.now().millisecondsSinceEpoch.toString(),
      userDbNetworkStatus: isOnline,
    });
  }

  static Future<bool> checkNetworkStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  static void initialize() {
    // Initial status check
    checkNetworkStatus().then((isConnected) {
      updateUserNetworkStatusInApp(isOnline: isConnected);
    });

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      bool isConnected = result != ConnectivityResult.none;
      updateUserNetworkStatusInApp(isOnline: isConnected);
    });

    // Listen for app lifecycle changes
    SystemChannels.lifecycle.setMessageHandler((message) async {
      log(message.toString());
      if (message.toString().contains("resume")) {
        if (await checkNetworkStatus()) {
          updateUserNetworkStatusInApp(isOnline: true);
        }
      } else if (message.toString().contains("pause")) {
        updateUserNetworkStatusInApp(isOnline: false);
      }
      return Future.value(message);
    });
  }
}
