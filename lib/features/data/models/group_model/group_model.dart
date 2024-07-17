import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/domain/entities/group_entity/group_entity.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    super.groupID,
    super.groupName,
    super.groupProfileImage,
    super.groupMembers,
    super.groupAdmins,
    super.groupDescription,
    super.membersPermissions,
    super.adminsPermissions,
  });
  factory GroupModel.fromJson(Map<String, dynamic> map) {
    return GroupModel(
      groupID: map[dbGroupId],
      groupName: map[dbGroupName],
      groupDescription: map[dbGroupDescription],
      groupProfileImage: map[dbGroupProfileImage],
      groupAdmins: map[dbGroupAdminsList],
      groupMembers: map[dbGroupMembersList],
      adminsPermissions: map[dbGroupAdminsPermissionList],
      membersPermissions: map[dbGroupMembersPermissionList],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      dbGroupId: groupID,
      dbGroupName: groupName,
      dbGroupDescription: groupDescription,
      dbGroupProfileImage: groupProfileImage,
      dbGroupAdminsList: groupAdmins,
      dbGroupMembersList: groupMembers,
      dbGroupAdminsPermissionList: adminsPermissions,
      dbGroupMembersPermissionList: membersPermissions,
    };
  }

  GroupModel copyWith({
    String? groupID,
    String? groupName,
    String? groupProfileImage,
    List<UserModel>? groupMembers,
    List<UserModel>? groupAdmins,
    String? groupDescription,
    List<MembersGroupPermission>? membersPermissions,
    List<AdminsGroupPermission>? adminsPermissions,
  }) {
    return GroupModel(
      groupID: groupID ?? this.groupID,
      groupName: groupName ?? this.groupName,
      groupProfileImage: groupProfileImage ?? this.groupProfileImage,
      groupMembers: groupMembers ?? this.groupMembers,
      groupAdmins: groupAdmins ?? this.groupAdmins,
      groupDescription: groupDescription ?? this.groupDescription,
      membersPermissions: membersPermissions ?? this.membersPermissions,
      adminsPermissions: adminsPermissions ?? this.adminsPermissions,
    );
  }
}
