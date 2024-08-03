import 'dart:developer';

import 'package:chatbox/features/data/models/broadcast_model/broadcast_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/core/utils/broadcast_methods.dart';

class BroadcastData {
  final FirebaseAuth firebaseAuthentication;
  final FirebaseFirestore firebaseFireStore;
  BroadcastData({
    required this.firebaseAuthentication,
    required this.firebaseFireStore,
  });
  Future<bool> createBroadCast({
    required BroadCastModel brocastModel,
  }) async {
    try {
      final currentUserId = firebaseAuthentication.currentUser?.uid;
      final broadcastDocRef = await firebaseFireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(broadcastCollection)
          .add(brocastModel.toJson());
      final broadCastId = broadcastDocRef.id;
      final updatedBroadcastModel = brocastModel.copyWith(
        broadCastId: broadCastId,
      );
      await fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(broadcastCollection)
          .doc(broadCastId)
          .update(updatedBroadcastModel.toJson());
      log("Brodcast creared");
      return true;
    } on FirebaseException catch (e) {
      log(e.message.toString());
      return true;
    } catch (e) {
      log(e.toString());
      return true;
    }
  }

  Stream<List<BroadCastModel>>? getAllBroadCast() {
    try {
      final currentUserId = firebaseAuthentication.currentUser?.uid;
      return fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(broadcastCollection)
          .snapshots()
          .map((broadCastSnapShot) {
        return broadCastSnapShot.docs
            .map(
              (broadCastDoc) => BroadCastModel.fromJson(
                broadCastDoc.data(),
              ),
            )
            .toList();
      });
    } on FirebaseException catch (e) {
      log(e.message.toString());
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
