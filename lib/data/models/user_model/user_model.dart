import 'package:chatbox/domain/entities/user_entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.userName,
    super.userEmailId,
    super.phoneNumber,
    super.userAbout,
    super.userProfileImage,
    super.userNetworkStatus,
    super.createdAt,
    super.tfaPin,
    super.isBlockedUser,
  });

  factory UserModel.fromJson({required Map<String, dynamic> map}) {
    return UserModel(
        id: map['id'],
        userName: map['username'],
        userEmailId: map['user_email'],
        phoneNumber: map['phone_number'],
        userAbout: map['user_about'],
        userProfileImage: map['user_profile_image'],
        userNetworkStatus: map['user_network_status'],
        createdAt: map['created_at'],
        tfaPin: map['tfa_pin'],
        isBlockedUser: map['is_blocked_user']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': userName,
      'user_email': userEmailId,
      'phone_number': phoneNumber,
      'user_about': userAbout,
      'user_profile_image': userProfileImage,
      'user_network_status': userNetworkStatus,
      'created_at': createdAt,
      'tfa_pin': tfaPin,
      'is_blocked_user': isBlockedUser,
    };
  }
}
