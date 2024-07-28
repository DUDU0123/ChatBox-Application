import 'dart:developer';

import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/features/data/models/status_model/status_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StatusData {
  final FirebaseFirestore firebaseFireStore;
  final FirebaseAuth fireBaseAuth;
  final FirebaseStorage fireBaseStorage;
  StatusData({
    required this.firebaseFireStore,
    required this.fireBaseAuth,
    required this.fireBaseStorage,
  });

  final currentUser = firebaseAuth.currentUser?.uid;

  // method to upload a status
  Future<bool> uploadStatus({required StatusModel statusModel}) async {
    try {
      if (currentUser == null) {
        log("No current user found.");
        return false;
      }
      final statusDocumentReference = await firebaseFireStore
          .collection(usersCollection)
          .doc(currentUser)
          .collection(statusCollection)
          .add(
            statusModel.toJson(),
          );
      final statusDocId = statusDocumentReference.id;
      final updatedStatusModel = statusModel.copyWith(
        statusId: statusDocId,
      );
      await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(currentUser)
          .collection(statusCollection)
          .doc(statusDocId)
          .update(
            updatedStatusModel.toJson(),
          );
      return true;
    } on FirebaseException catch (e) {
      log("Firebase Auth exception on upload status: ${e.message}");
      return false;
    } catch (e, stackTrace) {
      log("Error while uploading status: $e", stackTrace: stackTrace);
      return false;
    }
  }

  // method to get/read all status
  Stream<List<StatusModel>>? getAllStatus() {
    try {
      if (currentUser == null) {
        log("No current user found.");
      }
      return firebaseFireStore
          .collection(usersCollection)
          .doc(currentUser)
          .collection(statusCollection)
          .snapshots()
          .map((statusSnapShot) {
        return statusSnapShot.docs
            .map(
              (statusDoc) => StatusModel.fromJson(
                map: statusDoc.data(),
              ),
            )
            .toList();
      });
    } on FirebaseException catch (e) {
      log("Firebase Auth exception on upload status: ${e.message}");
      return null;
    } catch (e, stackTrace) {
      log("Error while uploading status: $e", stackTrace: stackTrace);
      return null;
    }
  }

  // method to share a status
  shareStatus() {}
  // method to delete a status
  Future<bool> deleteStatus({
    required String statusId,
  }) async {
    try {
      if (currentUser == null) {
        log("No current user found.");
        return false;
      }
      await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(currentUser)
          .collection(statusCollection)
          .doc(statusId)
          .delete();
      return true;
    } on FirebaseException catch (e) {
      log("Firebase Auth exception on deleting status: ${e.message}");
      return false;
    } catch (e, stackTrace) {
      log("Error while deleting status: $e", stackTrace: stackTrace);
      return false;
    }
  }
}
