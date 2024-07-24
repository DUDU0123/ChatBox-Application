import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/domain/repositories/group_repo/group_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:flutter/material.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository groupRepository;
  GroupBloc({
    required this.groupRepository,
  }) : super(GroupInitial()) {
    on<GetAllGroupsEvent>(getAllGroupsEvent);
    on<CreateGroupEvent>(createGroupEvent);
    on<UpdateGroupEvent>(updateGroupEvent);
    on<DeleteGroupEvent>(deleteGroupEvent);
    on<GroupImagePickEvent>(groupImagePickEvent);
    on<ResetPickedFileEvent>(resetPickedFileEvent);
    on<UpdateMemberPermissionEvent>(updateMemberPermissionEvent);
    on<UpdateAdminPermissionEvent>(updateAdminPermissionEvent);
  }

  FutureOr<void> getAllGroupsEvent(
      GetAllGroupsEvent event, Emitter<GroupState> emit) {
    emit(GroupLoadingState());
    try {
      Stream<List<GroupModel>>? groupList = groupRepository.getAllGroups();
      emit(GroupState(groupList: groupList));
    } catch (e) {
      log("Get all groups Bloc error: ${e.toString()}");
      emit(GroupErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> createGroupEvent(
      CreateGroupEvent event, Emitter<GroupState> emit) async {
    emit(GroupLoadingState());
    try {
      final File? groupImageFile = event.groupProfileImage;
      final value = await groupRepository.createGroup(
        groupImageFile: groupImageFile,
        newGroupData: event.newGroupData,
      );
      Navigator.pop(event.context);
      log(name: "Create", value.toString());
      emit(state.copyWith(groupList: state.groupList, isLoading: value,));
    } catch (e) {
      log("Create group Bloc error: ${e.toString()}");
      emit(GroupErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> updateGroupEvent(
      UpdateGroupEvent event, Emitter<GroupState> emit) async {
    try {
      final value = await groupRepository.updateGroupData(
        updatedGroupData: event.updatedGroupData,
      );
      log("Edit: $value");
      emit(state.copyWith(groupList: state.groupList));
    } catch (e) {
      log("Update group Bloc error: ${e.toString()}");
      emit(GroupErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> deleteGroupEvent(
      DeleteGroupEvent event, Emitter<GroupState> emit) async {
    try {
      final value = await groupRepository.deleteAGroupOnlyForCurrentUser(
        groupID: event.groupID,
      );
      log("Delete: $value");
      emit(state.copyWith(groupList: state.groupList));
    } catch (e) {
      log("Delete group Bloc error: ${e.toString()}");
      emit(GroupErrorState(message: e.toString()));
    }
  }

  FutureOr<void> updateMemberPermissionEvent(
      UpdateMemberPermissionEvent event, Emitter<GroupState> emit) {
    final updatedPermissions =
        Map<MembersGroupPermission, bool>.from(state.memberPermissions)
          ..[event.permission] = event.isEnabled;
    emit(state.copyWith(memberPermissions: updatedPermissions));
  }

  FutureOr<void> updateAdminPermissionEvent(
      UpdateAdminPermissionEvent event, Emitter<GroupState> emit) {
    final updatedPermissions =
        Map<AdminsGroupPermission, bool>.from(state.adminPermissions)
          ..[event.permission] = event.isEnabled;
    emit(state.copyWith(adminPermissions: updatedPermissions));
  }

  FutureOr<void> groupImagePickEvent(
      GroupImagePickEvent event, Emitter<GroupState> emit) async {
    try {
      emit(state.copyWith(
          groupList: state.groupList, groupPickedImageFile: event.pickedFile));
    } catch (e) {
      log(" group image pick Bloc error: ${e.toString()}");
      emit(GroupErrorState(message: e.toString()));
    }
  }

  FutureOr<void> resetPickedFileEvent(
      ResetPickedFileEvent event, Emitter<GroupState> emit) {
    try {
      emit(state.copyWith(
          groupList: state.groupList, groupPickedImageFile: null));
    } catch (e) {
      emit(GroupErrorState(message: e.toString()));
    }
  }
}
