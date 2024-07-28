import 'package:chatbox/features/data/data_sources/status_data/status_data.dart';
import 'package:chatbox/features/data/models/status_model/status_model.dart';
import 'package:chatbox/features/domain/repositories/status_repo/status_repository.dart';

class StatusRepositoryImpl extends StatusRepository {
  final StatusData statusData;
  StatusRepositoryImpl({
    required this.statusData,
  });
  @override
  Stream<List<StatusModel>>? getAllStatusFromDB() {
    return statusData.getAllStatus();
  }

  @override
  Future<bool> uploadStatusToDB({required StatusModel statusModel}) {
    return statusData.uploadStatus(statusModel: statusModel);
  }
  @override
  Future<bool> deleteStatusFromDB({required String statusId}) {
    return statusData.deleteStatus(statusId: statusId);
  }
}
