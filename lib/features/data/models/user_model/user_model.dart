import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/features/domain/entities/user_entity/user_entity.dart';

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
    super.isDisabled,
    super.lastActiveTime,
  });

  factory UserModel.fromJson({required Map<String, dynamic> map}) {
    return UserModel(
      id: map[userDbId],
      userName: map[userDbName] ?? 'chatbox user',
      userEmailId: map[userDbEmail] ?? '',
      phoneNumber: map[userDbPhoneNumber] ?? '',
      userAbout: map[userDbAbout] ?? 'chatbox about',
      userProfileImage: map[userDbProfileImage],
      userNetworkStatus: map[userDbNetworkStatus] ?? false,
      createdAt: map[userDbCreatedAt] ?? '',
      tfaPin: map[userDbTFAPin] ?? '',
      isBlockedUser: map[userDbBlockedStatus] ?? false,
      userGroupIdList: map[userDbGroupIdList]??[],
      isDisabled: map[isUserDisabled]??false,
      lastActiveTime: map[userDbLastActiveTime]??'00:00',
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
      isUserDisabled: isDisabled,
      userDbLastActiveTime: lastActiveTime,
    };
  }
  

  UserModel copyWith({
    String? id,
    String? userName,
    String? userEmailId,
    String? phoneNumber,
    String? userAbout,
    String? userProfileImage,
    bool? userNetworkStatus,
    String? createdAt,
    String? tfaPin,
    bool? isBlockedUser,
    List<dynamic>? userGroupIdList,
    bool? isDisabled,
    String? lastActiveTime,

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
      userGroupIdList: userGroupIdList??this.userGroupIdList,
      isDisabled: isDisabled??this.isDisabled,
      lastActiveTime: lastActiveTime??this.lastActiveTime,
    );
  }

  
}
