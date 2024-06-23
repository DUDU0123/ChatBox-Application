import 'package:chatbox/core/constants/database_name_constants.dart';
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
    super.userGroupIdList,
  });

  factory UserModel.fromJson({required Map<String, dynamic> map}) {
    return UserModel(
      id: map[userDbId],
      userName: map[userDbName] ?? 'No Username',
      userEmailId: map[userDbEmail] ?? '',
      phoneNumber: map[userDbPhoneNumber] ?? '',
      userAbout: map[userDbAbout] ?? '',
      userProfileImage: map[userDbProfileImage] ?? '',
      userNetworkStatus: map[userDbNetworkStatus] ?? '',
      createdAt: map[userDbCreatedAt] ?? '',
      tfaPin: map[userDbTFAPin] ?? '',
      isBlockedUser: map[userDbBlockedStatus] ?? false,
      userGroupIdList: map[userDbGroupIdList]??[]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      userDbId: id,
      userDbName: userName,
      userDbEmail: userEmailId,
      userDbPhoneNumber: phoneNumber,
      userDbAbout: userAbout,
      userDbProfileImage: userProfileImage,
      userDbNetworkStatus: userNetworkStatus,
      userDbCreatedAt: createdAt,
      userDbTFAPin: tfaPin,
      userDbBlockedStatus: isBlockedUser,
      userDbGroupIdList: userGroupIdList,
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
    List<String>? userGroupIdList,

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
      userGroupIdList: userGroupIdList??this.userGroupIdList
    );
  }
}
