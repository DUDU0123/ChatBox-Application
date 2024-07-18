part of 'group_bloc.dart';

sealed class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class CreateGroupEvent extends GroupEvent {
  final GroupModel newGroupData;
  final File? groupProfileImage;
  const CreateGroupEvent({
    required this.newGroupData,
    this.groupProfileImage,
  });
  @override
  List<Object> get props => [
        newGroupData,groupProfileImage??File('')
      ];
}

class GetAllGroupsEvent extends GroupEvent {
  @override
  List<Object> get props => [];
}

class UpdateGroupEvent extends GroupEvent {
  final GroupModel updatedGroupData;
  const UpdateGroupEvent({
    required this.updatedGroupData,
  });
  @override
  List<Object> get props => [
        updatedGroupData,
      ];
}

class DeleteGroupEvent extends GroupEvent {
  final String groupID;
  const DeleteGroupEvent({
    required this.groupID,
  });
  @override
  List<Object> get props => [groupID];
}
class GroupImagePickEvent extends GroupEvent {
  final File? pickedFile;
  const GroupImagePickEvent({
    this.pickedFile,
  });
  @override
  List<Object> get props => [pickedFile??''];
}
class ResetPickedFileEvent extends GroupEvent{}

class UpdateMemberPermissionEvent extends GroupEvent {
  final MembersGroupPermission permission;
  final bool isEnabled;

  const UpdateMemberPermissionEvent({
    required this.permission,
    required this.isEnabled,
  });

  @override
  List<Object> get props => [permission, isEnabled];
}

class UpdateAdminPermissionEvent extends GroupEvent {
  final AdminsGroupPermission permission;
  final bool isEnabled;

 const UpdateAdminPermissionEvent({
    required this.permission,
    required this.isEnabled,
  });

  @override
  List<Object> get props => [permission, isEnabled];
}
