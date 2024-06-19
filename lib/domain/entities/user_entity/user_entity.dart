import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {

  final String? id;
  final String? userName;
  final String? phoneNumber;
  final String? userEmailId;
  final String? userAbout;
  final String? userProfileImage;
  final String? userNetworkStatus;
  final DateTime? createdAt;
  final int? tfaPin;
  final bool? isBlockedUser;
  const UserEntity({
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
