import 'package:equatable/equatable.dart';
import 'package:chatbox/features/data/models/status_model/uploaded_status_model.dart';

class StatusEntity extends Equatable {
  final String? statusId;
  final String? statusUploaderId;
  final String? statusUploaderName;
  final List<UploadedStatusModel>? statusList;
  const StatusEntity({
    this.statusId,
    this.statusUploaderId,
    this.statusUploaderName,
    this.statusList,
  });

  @override
  List<Object?> get props => [
        statusId,
        statusUploaderName,
        statusList,
        statusUploaderId,
      ];
}
