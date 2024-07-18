import 'dart:developer';
import 'dart:io';

import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CommonDBFunctions {
  static Future<String> saveUserFileToDataBaseStorage({
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
}
List<T> filterPermissions<T>(Map<T, bool> permissions) {
  return permissions.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();
}

List<String> enumListToStringList<T>(List<T> enumList) {
  return enumList.map((e) => e.toString().split('.').last).toList();
}

List<T> stringListToEnumList<T>(List<String> stringList, List<T> enumValues) {
  return stringList.map((e) {
    return enumValues.firstWhere((enumValue) => enumValue.toString().split('.').last == e);
  }).toList();
}
