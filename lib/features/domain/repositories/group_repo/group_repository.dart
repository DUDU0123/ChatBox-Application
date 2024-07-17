import 'package:chatbox/features/data/models/group_model/group_model.dart';

abstract class GroupRepository {
  createGroup({required GroupModel newGroupData,});
  List<GroupModel> getAllGroups();
  updateGroupData({required GroupModel updatedGroupData,});
  deleteGroup({required String groupID,});
}
