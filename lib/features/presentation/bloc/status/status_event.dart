part of 'status_bloc.dart';

sealed class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object> get props => [];
}
class StatusLoadEvent extends StatusEvent{

}
class StatusUploadEvent extends StatusEvent {
  final StatusModel statusModel;
  final StatusType statusType;
  const StatusUploadEvent({
    required this.statusModel,
    required this.statusType,
  });
  @override
  List<Object> get props => [statusModel,statusType,];
}
class StatusShareEvent extends StatusEvent{}
class StatusDeleteEvent extends StatusEvent {
  final String statusId;
  const StatusDeleteEvent({
    required this.statusId,
  });
  @override
  List<Object> get props => [statusId,];
}
class PickStatusEvent extends StatusEvent {
  final StatusType statusType;
  const PickStatusEvent({
    required this.statusType,
  });
  @override
  List<Object> get props => [statusType,];
}
