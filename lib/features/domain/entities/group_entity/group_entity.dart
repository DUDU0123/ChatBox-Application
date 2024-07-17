import 'package:equatable/equatable.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';

class GroupEntity extends Equatable {
  final String? groupID;
  final String? groupProfileImage;
  final String? groupName;
  final List<UserModel>? groupMembers;
  final List<UserModel>? groupAdmins;
  final String? groupDescription;
  final List<MembersGroupPermission>? membersPermissions;
  final List<AdminsGroupPermission>? adminsPermissions;
  const GroupEntity({
    this.groupID,
    this.groupProfileImage,
    this.groupName,
    this.groupMembers,
    this.groupAdmins,
    this.groupDescription,
    this.membersPermissions,
    this.adminsPermissions,
  });

  @override
  List<Object?> get props {
    return [
      groupID,
      groupProfileImage,
      groupName,
      groupMembers,
      groupAdmins,
      groupDescription,
      membersPermissions,
      adminsPermissions,
    ];
  }
}
