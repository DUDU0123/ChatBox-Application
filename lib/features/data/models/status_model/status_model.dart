import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/features/data/models/status_model/uploaded_status_model.dart';
import 'package:chatbox/features/domain/entities/status_entity/status_entity.dart';

class StatusModel extends StatusEntity {
  const StatusModel({
    super.statusId,
    super.statusUploaderName,
    super.statusList,
    super.statusUploaderId,
  });

  factory StatusModel.fromJson({required Map<String, dynamic> map}) {
    return StatusModel(
      statusId: map[dbStatusId],
      statusUploaderName: map[dbStatusUploaderName],
      statusUploaderId: map[dbStatusUploaderId],
      statusList: (map[dbStatusContentList] as List<dynamic>?)
          ?.map((item) =>
              UploadedStatusModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      dbStatusId: statusId,
      dbStatusUploaderName: statusUploaderName,
      dbStatusUploaderId: statusUploaderId,
      dbStatusContentList: statusList
          ?.map((uploadedStatusModel) => uploadedStatusModel.toJson())
          .toList(),
    };
  }

  StatusModel copyWith({
    String? statusId,
    String? statusUploaderName,
    String? statusUploaderId,
    List<UploadedStatusModel>? statusList,
  }) {
    return StatusModel(
      statusId: statusId ?? this.statusId,
      statusUploaderName: statusUploaderName ?? this.statusUploaderName,
      statusUploaderId: statusUploaderId ?? this.statusUploaderId,
      statusList: statusList ?? this.statusList,
    );
  }
}
