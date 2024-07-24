import 'dart:io';

import 'package:chatbox/features/data/models/group_model/group_model.dart';

abstract class GroupRepository {
  Future<bool?> createGroup({required GroupModel newGroupData,required File? groupImageFile});
  Stream<List<GroupModel>>? getAllGroups();
  Future<bool> updateGroupData({required GroupModel updatedGroupData,});
  Future<String> deleteAGroupOnlyForCurrentUser({required String groupID,});
}
