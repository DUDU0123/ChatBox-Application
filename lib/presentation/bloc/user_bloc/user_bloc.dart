import 'dart:async';
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
  //  on<PickProfileImageFromDevice>(pickProfileImageFromDevice);
  }

  Future<FutureOr<void>> getCurrentUserData(
      GetCurrentUserData event, Emitter<UserState> emit) async {
    try {
      UserModel userModel = await userRepository.getOneUserDataFromDB(
          userId: firebaseAuth.currentUser!.uid);
      emit(CurrentUserLoadedState(currentUserData: userModel));
    } catch (e) {
      emit(CurrentUserErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> editCurrentUserData(
      EditCurrentUserData event, Emitter<UserState> emit) async {
    try {
      
      await userRepository.updateUserInDataBase(
        userModel: event.userModel,
        profileImage: event.userProfileImage,
      );

      emit(CurrentUserLoadedState(currentUserData: UserModel()));
    } catch (e) {
      emit(CurrentUserErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> pickProfileImageFromDevice(
      PickProfileImageFromDevice event, Emitter<UserState> emit) async {
        try {
          final pickedImage = await pickImage(imageSource: event.imageSource);
          
        } catch (e) {
          emit(ImagePickErrorState(message: e.toString()));
        }
      }
}
