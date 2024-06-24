import 'package:chatbox/data/data_sources/contact_data/contact_data.dart';
import 'package:chatbox/data/data_sources/user_data/user_data.dart';
import 'package:chatbox/data/models/user_model/user_model.dart';
import 'package:chatbox/data/repositories/auth_repo/authentication_repo_impl.dart';
import 'package:chatbox/data/repositories/contact_repository/contact_repo_impl.dart';
import 'package:chatbox/data/repositories/user_repository/user_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

final getItInstance = GetIt.instance;
void initializeServiceLocator() {
  // getItInstance.registerSingleton(() => FirebaseAuth.instance);
  // getItInstance.registerSingleton(() => FirebaseStorage.instance);
  // getItInstance.registerSingleton(() => FirebaseFirestore.instance);

  // getItInstance.registerLazySingleton(
  //   () => ContactData(),
  // );
  // getItInstance.registerLazySingleton(
  //   () => AuthenticationRepoImpl(firebaseAuth: getItInstance<FirebaseAuth>()),
  // );
  // getItInstance.registerLazySingleton(
  //   () => ContactRepoImpl(
  //     contactData: getItInstance<ContactData>(),
  //     firebaseFirestore: getItInstance<FirebaseFirestore>(),
  //   ),
  // );
  // getItInstance.registerLazySingleton(
  //   () => UserData(
  //     firestore: getItInstance<FirebaseFirestore>(),
  //     firebaseStorage: getItInstance<FirebaseStorage>(),
  //     firebaseAuth: getItInstance<FirebaseAuth>(),
  //   ),
  // );
  // getItInstance.registerLazySingleton(
  //   () => UserRepositoryImpl(
  //     userData: getItInstance<UserData>(),
  //   ),
  // );
  getItInstance.registerFactory(() => UserModel());
}