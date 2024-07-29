part of 'status_bloc.dart';

class StatusState extends Equatable {
   StatusState({
    this.statusList,
    this.pickedStatus,
    this.message,
  });
  final Stream<List<StatusModel>>? statusList;
  File? pickedStatus;
  
  final String? message;
  StatusState copyWith({
    Stream<List<StatusModel>>? statusList, String? message,File? pickedStatus
  }) {
    return StatusState(
      statusList: statusList ?? this.statusList,
      message: message ?? this.message,pickedStatus: pickedStatus?? this.pickedStatus
    );
  }

  @override
  List<Object> get props => [statusList??[],message??'', pickedStatus??File('')];
}

class StatusInitial extends StatusState {}
class StatusLoadingState extends StatusState{}
class StatusErrorState extends StatusState {
  final String message;
   StatusErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message,];
}
