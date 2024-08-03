import 'dart:developer';

import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/features/data/models/broadcast_model/broadcast_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

const broadcastCollection = 'broadcast';

class BroadCastMethods {
  // method for creating a broadcast
  static Future<bool> createBroadCast({
    required BroadCastModel brocastModel,
  }) async {
    try {
      final currentUserId = firebaseAuth.currentUser?.uid;
      final broadcastDocRef = await fireStore
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
  // method for sending message in broadcast
}


