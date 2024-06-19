import 'package:chatbox/domain/entities/user_entity/user_entity.dart';

class UserModel extends UserEntity {
   UserModel({
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
      userName: map['username'] ?? '',
      userEmailId: map['user_email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      userAbout: map['user_about'] ?? '',
      userProfileImage: map['user_profile_image'] ?? '',
      userNetworkStatus: map['user_network_status'] ?? '',
      createdAt: map['created_at'] ?? '',
      tfaPin: map['tfa_pin'] ?? '',
      isBlockedUser: map['is_blocked_user'] ?? false,
    );
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

  UserModel copyWith({
    String? id,
    String? userName,
    String? userEmailId,
    String? phoneNumber,
    String? userAbout,
    String? userProfileImage,
    String? userNetworkStatus,
    String? createdAt,
    String? tfaPin,
    bool? isBlockedUser,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userEmailId: userEmailId ?? this.userEmailId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userAbout: userAbout ?? this.userAbout,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      userNetworkStatus: userNetworkStatus ?? this.userNetworkStatus,
      createdAt: createdAt ?? this.createdAt,
      tfaPin: tfaPin ?? this.tfaPin,
      isBlockedUser: isBlockedUser ?? this.isBlockedUser,
    );
  }
}
