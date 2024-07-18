part of 'group_bloc.dart';


class GroupState extends Equatable {
  final Stream<List<GroupModel>>? groupList;
  final File? groupPickedImageFile;
  final Map<MembersGroupPermission, bool> memberPermissions;
  final Map<AdminsGroupPermission, bool> adminPermissions;

  const GroupState({
    this.groupList,
    this.groupPickedImageFile,
    this.memberPermissions = const {
      MembersGroupPermission.editGroupSettings: false,
      MembersGroupPermission.sendMessages: false,
      MembersGroupPermission.addMembers: false,
    },
    this.adminPermissions = const {
      AdminsGroupPermission.viewMembers: false,
      AdminsGroupPermission.approveMembers: false,
      AdminsGroupPermission.editGroupSettings: false,
      AdminsGroupPermission.sendMessages: false,
      AdminsGroupPermission.addMembers: false,
    },
  });

  GroupState copyWith({
    Stream<List<GroupModel>>? groupList,
    File? groupPickedImageFile,
    Map<MembersGroupPermission, bool>? memberPermissions,
    Map<AdminsGroupPermission, bool>? adminPermissions,
  }) {
    return GroupState(
      groupList: groupList ?? this.groupList,
      groupPickedImageFile: groupPickedImageFile ?? this.groupPickedImageFile,
      memberPermissions: memberPermissions ?? this.memberPermissions,
      adminPermissions: adminPermissions ?? this.adminPermissions,
    );
  }

  @override
  List<Object> get props => [groupList ?? [], groupPickedImageFile ?? '', memberPermissions, adminPermissions];
}


final class GroupInitial extends GroupState {}

class GroupLoadingState extends GroupState {
  @override
  List<Object> get props => [];
}

class GroupErrorState extends GroupState {
  final String message;
  const GroupErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [
        message,
      ];
}
