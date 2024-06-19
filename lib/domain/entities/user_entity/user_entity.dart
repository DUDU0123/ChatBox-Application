import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  String? id;
  String? userName;
  String? phoneNumber;
  String? userEmailId;
  String? userAbout;
  String? userProfileImage;
  String? userNetworkStatus;
  String? createdAt;
  String? tfaPin;
  bool? isBlockedUser;
  UserEntity({
    this.id,
    this.userName,
    this.phoneNumber,
    this.userEmailId,
    this.userAbout,
    this.userProfileImage,
    this.userNetworkStatus,
    this.createdAt,
    this.tfaPin,
    this.isBlockedUser,
  });

  @override
  List<Object?> get props {
    return [
      id,
      userName,
      phoneNumber,
      userEmailId,
      userAbout,
      userProfileImage,
      userNetworkStatus,
      createdAt,
      tfaPin,
      isBlockedUser,
    ];
  }
}
