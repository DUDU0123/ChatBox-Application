import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/status_model/status_model.dart';
import 'package:chatbox/features/data/models/status_model/uploaded_status_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/bloc/status/status_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
class FileShowPage extends StatefulWidget {
  const FileShowPage(
      {super.key,
      this.fileToShow,
      required this.fileType,
      required this.statusModel});
  final File? fileToShow;
  final FileType fileType;
  final StatusModel? statusModel;

  @override
  State<FileShowPage> createState() => _FileShowPageState();
}

class _FileShowPageState extends State<FileShowPage> {
  TextEditingController fileCaptionController = TextEditingController();

  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();
    log('File to show: ${widget.fileToShow}');
    log('File type: ${widget.fileType}');

    if (widget.fileToShow != null) {
      log('Not null');
      if (widget.fileType == FileType.video) {
        log('Initializing video player');
        videoPlayerController = VideoPlayerController.file(widget.fileToShow!)
          ..initialize().then((_) {
            log('Video player initialized');
          }).catchError((error) {
            log('Error initializing video player: $error');
          });
        videoPlayerController?.addListener(_videoPlayerListener);
      } else {
        log('File type is not video');
      }
    } else {
      log('No file to show');
    }
  }

  @override
  void dispose() {
    videoPlayerController?.removeListener(_videoPlayerListener);
    videoPlayerController?.dispose();
    fileCaptionController.dispose();
    super.dispose();
  }

  void _videoPlayerListener() {
    if (videoPlayerController == null) {
      return;
    }
    if (videoPlayerController?.value.position ==
        videoPlayerController?.value.duration) {
      context.read<MessageBloc>().add(VideoMessageCompleteEvent());
    } else if (videoPlayerController!.value.isPlaying) {
      context.read<MessageBloc>().add(VideoMessagePlayEvent());
    } else {
      context.read<MessageBloc>().add(VideoMessagePauseEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkScaffoldColor,
      body: Stack(
        children: [
          widget.fileToShow != null
              ? widget.fileType == FileType.image
                  ? Center(
                      child: Image.file(
                        widget.fileToShow!,
                        fit: BoxFit.contain,
                      ),
                    )
                  : widget.fileType == FileType.video
                      ? videoPlayerController != null
                          ? VideoPlayer(
                              videoPlayerController!,
                            )
                          : commonErrorWidget(message: "No video selected")
                      : zeroMeasureWidget
              : zeroMeasureWidget,
          videoPlayerController != null
              ? Align(
                  alignment: Alignment.center,
                  child: BlocBuilder<MessageBloc, MessageState>(
                    builder: (context, state) {
                      if (state is MessageLoadingState) {
                        return commonAnimationWidget(
                            context: context, isTextNeeded: false);
                      }
                      IconData icon;
                      if (videoPlayerController?.value.position ==
                          videoPlayerController?.value.duration) {
                        icon = Icons.play_arrow;
                      } else {
                        icon = videoPlayerController!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow;
                      }

                      return GestureDetector(
                        onTap: () {
                          if (videoPlayerController!.value.isPlaying) {
                            videoPlayerController?.pause();
                            context
                                .read<MessageBloc>()
                                .add(VideoMessagePauseEvent());
                          } else {
                            videoPlayerController?.play();
                            context
                                .read<MessageBloc>()
                                .add(VideoMessagePlayEvent());
                          }
                        },
                        child: CircleAvatar(
                          radius: 30.sp,
                          backgroundColor: iconGreyColor.withOpacity(0.5),
                          child: Icon(
                            icon,
                            size: 30.sp,
                            color: kBlack,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : zeroMeasureWidget,
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: darkScaffoldColor,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, bottom: 15.h, top: 20.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.sp),
                          border: Border.all(
                            color: iconGreyColor,
                          ),
                        ),
                        child: TextFieldCommon(
                          maxLines: 20,
                          border: InputBorder.none,
                          cursorColor: buttonSmallTextColor,
                          controller: fileCaptionController,
                          textAlign: TextAlign.center,
                          hintText: "Add caption",
                          style: TextStyle(color: kWhite),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (widget.fileToShow != null) {
                          StatusModel statusModel = await newStatusUploadMethod(
                            fileToShow: widget.fileToShow!,
                            currentStatusModel: widget.statusModel,
                            fileCaption: fileCaptionController.text,
                            statusDuration: videoPlayerController != null
                                ? videoPlayerController!.value.duration
                                    .toString()
                                : "10",
                            statusType: widget.fileType == FileType.video
                                ? StatusType.video
                                : StatusType.image,
                          );
                          context.read<StatusBloc>().add(StatusUploadEvent(
                                statusModel: statusModel,
                              ));
                        }
                        Navigator.pop(context);
                        context.read<StatusBloc>().add(const FileResetEvent());
                      },
                      icon: SvgPicture.asset(
                        sendIcon,
                        width: 30.w,
                        height: 30.h,
                        colorFilter: ColorFilter.mode(
                          buttonSmallTextColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
Future<StatusModel> newStatusUploadMethod({
  required File? fileToShow,
  required String fileCaption,
  required String statusDuration,
  required StatusType statusType,
  StatusModel? currentStatusModel,
  final List<UploadedStatusModel>? currentStatusList,
}) async {
  final statusContentUrl =
      await CommonDBFunctions.saveUserFileToDataBaseStorage(
    ref: "users_statuses/${firebaseAuth.currentUser?.uid}",
    file: fileToShow!,
  );

  UploadedStatusModel uploadedStatusModel = UploadedStatusModel(
    uploadedStatusId: DateTime.now().millisecondsSinceEpoch.toString(),
    statusCaption: fileCaption,
    statusUploadedTime: DateTime.now().toString(),
    isViewedStatus: false,
    statusDuration: statusDuration,
    statusType: statusType,
    statusContent: statusContentUrl,
  );

  List<UploadedStatusModel> uploadedStatusList =
      currentStatusModel?.statusList ?? [];
  uploadedStatusList.add(uploadedStatusModel);

  // Create or update StatusModel
  StatusModel statusModel = StatusModel(
    statusUploaderId: firebaseAuth.currentUser?.uid ?? '',
    statusList: uploadedStatusList,
  );

  // If currentStatusModel is not null, copy its other fields (if any)
  if (currentStatusModel != null) {
    statusModel = currentStatusModel.copyWith(
      statusList: uploadedStatusList,
    );
  }
  return statusModel;
}
