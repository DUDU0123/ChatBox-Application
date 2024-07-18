import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
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
    super.groupCreatedAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> map) {
    return GroupModel(
      groupID: map[dbGroupId],
      groupName: map[dbGroupName] ?? "ChatBoxGroup",
      groupDescription: map[dbGroupDescription],
      groupProfileImage: map[dbGroupProfileImage],
      groupAdmins: List<String>.from(map[dbGroupAdminsList] ?? []),
      groupMembers: List<String>.from(map[dbGroupMembersList] ?? []),
      adminsPermissions: stringListToEnumList(
        List<String>.from(map[dbGroupAdminsPermissionList] ?? []),
        AdminsGroupPermission.values,
      ),
      membersPermissions: stringListToEnumList(
        List<String>.from(map[dbGroupMembersPermissionList] ?? []),
        MembersGroupPermission.values,
      ),
      groupCreatedAt: map[dbGroupCreatedAt],
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
      dbGroupAdminsPermissionList: enumListToStringList(adminsPermissions!),
      dbGroupMembersPermissionList: enumListToStringList(membersPermissions!),
      dbGroupCreatedAt: groupCreatedAt,
    };
  }

  GroupModel copyWith({
    String? groupID,
    String? groupName,
    String? groupProfileImage,
    List<String>? groupMembers,
    List<String>? groupAdmins,
    String? groupDescription,
    List<MembersGroupPermission>? membersPermissions,
    List<AdminsGroupPermission>? adminsPermissions,
    String? groupCreatedAt,
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
      groupCreatedAt: groupCreatedAt ?? this.groupCreatedAt,
    );
  }
}
