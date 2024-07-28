part of 'status_bloc.dart';

class StatusState extends Equatable {
  const StatusState({
    this.statusList,
    this.message,
  });
  final Stream<List<StatusModel>>? statusList;
  final String? message;
  StatusState copyWith({
    Stream<List<StatusModel>>? statusList, String? message,
  }) {
    return StatusState(
      statusList: statusList ?? this.statusList,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [statusList??[],message??''];
}

class StatusInitial extends StatusState {}
class StatusLoadingState extends StatusState{}
class StatusErrorState extends StatusState {
  final String message;
  const StatusErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message,];
}
