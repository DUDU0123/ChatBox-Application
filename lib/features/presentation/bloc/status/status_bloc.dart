import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/chat_asset_send_methods.dart';
import 'package:chatbox/core/utils/image_picker_method.dart';
import 'package:equatable/equatable.dart';

import 'package:chatbox/features/data/models/status_model/status_model.dart';
import 'package:chatbox/features/domain/repositories/status_repo/status_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/common_widgets/file_show_page.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final StatusRepository statusRepository;
  StatusBloc({
    required this.statusRepository,
  }) : super(StatusInitial()) {
    on<StatusLoadEvent>(statusLoadEvent);
    on<StatusUploadEvent>(statusUploadEvent);
    on<StatusShareEvent>(statusShareEvent);
    on<StatusDeleteEvent>(statusDeleteEvent);
    on<PickStatusEvent>(pickStatusEvent);
    on<FileResetEvent>(fileResetEvent);
  }

  FutureOr<void> statusLoadEvent(
      StatusLoadEvent event, Emitter<StatusState> emit) {
    emit(StatusLoadingState());
    try {
      final Stream<List<StatusModel>>? statusList =
          statusRepository.getAllStatusFromDB();
      emit(StatusState(
        statusList: statusList,
      ));
    } catch (e) {
      log("Error on get all status bloc: ${e.toString()}");
      emit(StatusErrorState(message: e.toString()));
    }
  }

  FutureOr<void> statusUploadEvent(
      StatusUploadEvent event, Emitter<StatusState> emit) async {
    try {
      final bool isUploaded = await statusRepository.uploadStatusToDB(
          statusModel: event.statusModel);
      emit(StatusState(
        statusList: state.statusList,
        message: isUploaded ? "Status sent" : "Unable to sent",
      ));
    } catch (e) {
      log("Error on upload status bloc: ${e.toString()}");
      emit(StatusErrorState(message: e.toString()));
    }
  }

  FutureOr<void> statusShareEvent(
      StatusShareEvent event, Emitter<StatusState> emit) {
    try {} catch (e) {
      log("Error on share status bloc: ${e.toString()}");
      emit(StatusErrorState(message: e.toString()));
    }
  }

  FutureOr<void> statusDeleteEvent(
      StatusDeleteEvent event, Emitter<StatusState> emit) async {
    try {
      final bool isDeleted =
          await statusRepository.deleteStatusFromDB(statusId: event.statusId);
      emit(StatusState(
        statusList: state.statusList,
        message: isDeleted ? "Status sent" : "Unable to sent",
      ));
    } catch (e) {
      log("Error on delete status bloc: ${e.toString()}");
      emit(StatusErrorState(message: e.toString()));
    }
  }

  FutureOr<void> pickStatusEvent(
      PickStatusEvent event, Emitter<StatusState> emit) async {
    try {
      final file = await pickAsset(assetSelected: event.statusType);
      log("File $file");
      if (event.statusType == StatusType.image) {
        Navigator.push(
          event.context,
          MaterialPageRoute(
            builder: (context) => FileShowPage(
              statusModel: event.statusModel,
              fileType: FileType.image,
              fileToShow: file,
            ),
          ),
        );
      } else {
        Navigator.push(
          event.context,
          MaterialPageRoute(
            builder: (context) => FileShowPage(
              statusModel: event.statusModel,
              fileType: FileType.video,
              fileToShow: context.watch<StatusBloc>().state.pickedStatus,
            ),
          ),
        );
      }
      emit(state.copyWith(pickedStatus: file));
    } catch (e) {
      log("Error on pick status bloc: ${e.toString()}");
      emit(StatusErrorState(message: e.toString()));
    }
  }

  FutureOr<void> fileResetEvent(
      FileResetEvent event, Emitter<StatusState> emit) {
    emit(state.copyWith(pickedStatus: null));
  }
}
