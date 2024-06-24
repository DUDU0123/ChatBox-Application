import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chatbox/core/utils/image_picker_method.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chatbox/data/models/user_model/user_model.dart';
import 'package:chatbox/domain/repositories/user_repo/user_repository.dart';
import 'package:image_picker/image_picker.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseAuth firebaseAuth;
  final UserRepository userRepository;
  UserBloc({
    required this.firebaseAuth,
    required this.userRepository,
  }) : super(UserInitial()) {
    on<GetCurrentUserData>(getCurrentUserData);
    on<EditCurrentUserData>(editCurrentUserData);
    on<PickProfileImageFromDevice>(pickProfileImageFromDevice);
  }

  Future<FutureOr<void>> getCurrentUserData(
      GetCurrentUserData event, Emitter<UserState> emit) async {
    try {
      UserModel? userModel = await userRepository.getOneUserDataFromDB(
          userId: firebaseAuth.currentUser!.uid);
      if (userModel != null) {
        emit(CurrentUserLoadedState(currentUserData: userModel));
      } else {
        log("User model is null error");
      }
    } catch (e) {
      emit(CurrentUserErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> editCurrentUserData(
      EditCurrentUserData event, Emitter<UserState> emit) async {
    try {
      UserModel? currentUser = await userRepository.getOneUserDataFromDB(
          userId: firebaseAuth.currentUser!.uid);

      if (currentUser != null) {
        UserModel updatedUser = currentUser.copyWith(
          userName: event.userModel.userName ?? currentUser.userName,
          userAbout: event.userModel.userAbout ?? currentUser.userAbout,
        );
        await userRepository.updateUserInDataBase(
          userModel: updatedUser,
          profileImage: event.userProfileImage,
        );
        emit(CurrentUserLoadedState(currentUserData: updatedUser));
      } else {
        emit(const CurrentUserErrorState(message: "User is null"));
      }
    } catch (e) {
      emit(CurrentUserErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> pickProfileImageFromDevice(
      PickProfileImageFromDevice event, Emitter<UserState> emit) async {
        emit(LoadCurrentUserData());
    try {
      final pickedImage = await pickImage(imageSource: event.imageSource);
      UserModel? currentUser = await userRepository.getOneUserDataFromDB(
          userId: firebaseAuth.currentUser!.uid);
      if (pickedImage != null && currentUser != null) {
        String userProfileImageData =
            await userRepository.saveUserFileToDBStorage(
          ref: "profile_images/${currentUser.id}",
          file: pickedImage,
        );
        UserModel updatedUser = currentUser.copyWith(
          userProfileImage: userProfileImageData,
        );
        emit(CurrentUserLoadedState(currentUserData: updatedUser));
      } else {
        log("Picked Image is null");
      }
    } catch (e) {
      emit(ImagePickErrorState(message: e.toString()));
    }
  }
}
