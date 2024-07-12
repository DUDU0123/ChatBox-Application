import 'dart:developer';
import 'dart:io';

import 'package:chatbox/core/constants/app_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/video_photo_from_camera_source_method.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/location_pick/location_pick_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/select_contacts/select_contact_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AttachmentListContainerVertical extends StatelessWidget {
  const AttachmentListContainerVertical({super.key, required this.chatModel});
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: screenHeight(context: context) / 3.h,
      width: 50.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiary,
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.sp),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
          itemCount: attachmentIcons.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    attachmentIcons[index].colorOne,
                    attachmentIcons[index].colorTwo,
                  ],
                ),
              ),
              child: IconButton(
                onPressed: () async {
                  context.read<MessageBloc>().add(AttachmentIconClickedEvent());
                  switch (attachmentIcons[index].mediaType) {
                    case MediaType.camera:
                      await videoOrPhotoTakeFromCameraSourceMethod(
                        context: context,
                        chatModel: chatModel,
                      );
                      break;
                    case MediaType.gallery:
                      context.read<MessageBloc>().add(
                            PhotoMessageSendEvent(
                                chatModel: chatModel,
                                imageSource: ImageSource.gallery),
                          );
                      break;
                    case MediaType.document:
                      context.read<MessageBloc>().add(
                            OpenDeviceFileAndSaveToDbEvent(
                              messageType: MessageType.document,
                              chatModel: chatModel,
                            ),
                          );
                      break;
                    case MediaType.contact:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return SelectContactPage(
                            chatModel: chatModel,
                          );
                        }),
                      );
                      break;
                    case MediaType.location:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationPickPage(chatModel: chatModel,),
                        ),
                      );
                      context.read<MessageBloc>().add(LocationPickEvent());
                      break;
                    case MediaType.audio:
                      context.read<MessageBloc>().add(
                            OpenDeviceFileAndSaveToDbEvent(
                              messageType: MessageType.audio,
                              chatModel: chatModel,
                            ),
                          );
                      break;
                    default:
                  }
                },
                icon: SvgPicture.asset(
                  attachmentIcons[index].icon,
                  height: 24.h,
                  width: 24.h,
                  colorFilter: ColorFilter.mode(
                    kBlack,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => kHeight5,
        ),
      ),
    );
  }
}

