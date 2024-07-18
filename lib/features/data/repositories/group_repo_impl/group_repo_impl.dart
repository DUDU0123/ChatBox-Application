import 'package:chatbox/features/data/data_sources/group_data/group_data.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/domain/repositories/group_repo/group_repository.dart';

class GroupRepoImpl extends GroupRepository {
  final GroupData groupData;
  GroupRepoImpl({
    required this.groupData,
  });
  
  @override
  Future<String?> createGroup({required GroupModel newGroupData}) async {
   return await groupData.createNewGroup(newGroupData: newGroupData);
  }

  @override
  List<GroupModel> getAllGroups() {
    return [];
  }

  @override
  deleteGroup({required String groupID}) {}

  

  @override
  updateGroupData({required GroupModel updatedGroupData}) {}
}
