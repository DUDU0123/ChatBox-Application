import 'dart:async';
import 'dart:developer';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class AssetLoadedPage extends StatefulWidget {
  AssetLoadedPage({super.key});

  @override
  State<AssetLoadedPage> createState() => _AssetLoadedPageState();
}

class _AssetLoadedPageState extends State<AssetLoadedPage> {
  TextEditingController assetSubtitleController = TextEditingController();

  VideoPlayerController? videoPlayerController;
  @override
  void dispose() {
    assetSubtitleController.dispose();
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: SingleChildScrollView(
        child: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            if (state is MessageLoadingState) {
              return Center(
                child: commonAnimationWidget(
                  context: context,
                  isTextNeeded: false,
                ),
              );
            }
            if (state is MessageErrorState) {
              return commonErrorWidget();
            }
            if (state is MessageState) {
            state.messageModel?.messageType==MessageType.video?  VideoPlayerController.networkUrl(
                Uri.parse(
                  state.messageModel != null
                      ? state.messageModel!.message != null
                          ? state.messageModel!.message!
                          : ''
                      : '',
                ),
              ).initialize().then((_) {
                videoPlayerController?.play();
              }):null;
              if (state.messageModel == null) {
                return zeroMeasureWidget;
              }
              log("asset loaded");
              return Column(
                children: [
                  Container(
                    height: screenHeight(context: context) / 1.5,
                    width: screenWidth(context: context),
                    child: state.messageModel?.message != null
                        ? state.messageModel?.messageType == MessageType.video
                            ? videoPlayerController != null &&
                                    videoPlayerController!.value.isInitialized
                                ? VideoPlayer(videoPlayerController!)
                                : commonAnimationWidget(
                                    context: context,
                                    isTextNeeded: false,
                                  )
                            : Image.network(
                                state.messageModel!.message!,
                                fit: BoxFit.cover,
                              )
                        : zeroMeasureWidget,
                  ),
                  Padding(
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
                              controller: assetSubtitleController,
                              textAlign: TextAlign.center,
                              hintText: "Add description",
                              style: TextStyle(color: kWhite),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
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
                  )
                ],
              );
            }
            return Container(
              color: buttonSmallTextColor,
              width: screenWidth(context: context),
              height: 100,
            );
          },
        ),
      ),
    );
  }
}
