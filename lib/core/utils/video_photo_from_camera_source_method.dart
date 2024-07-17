import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/camera_photo_pick/asset_loaded_page.dart';
import 'package:chatbox/features/presentation/widgets/chat/icon_container_widget_gradient_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

Future<dynamic> videoOrPhotoTakeFromCameraSourceMethod({
  required BuildContext context,
  required ChatModel? chatModel,
  required String? receiverContactName,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      
      backgroundColor: kBlack,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          iconContainerWidgetGradientColor(
            subtitle: "Take video",
            icon: Icons.video_call,
            onTap: () {
             chatModel!=null? context.read<MessageBloc>().add(
                    VideoMessageSendEvent(
                      receiverContactName: receiverContactName??"",
                      receiverID: chatModel.receiverID??"",
                      imageSource: ImageSource.camera,
                      chatModel: chatModel,
                    ),
                  ):null;
              Navigator.pop(context);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => AssetLoadedPage(),));
            },
          ),
          iconContainerWidgetGradientColor(
            subtitle: "Take photo",
            icon: Icons.camera,
            onTap: () {
            chatModel!=null?  context.read<MessageBloc>().add(
                    PhotoMessageSendEvent(
                      receiverContactName: receiverContactName??'',
                      receiverID: chatModel.receiverID??'',
                      imageSource: ImageSource.camera,
                      chatModel: chatModel,
                    ),
                  ):null;
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => AssetLoadedPage(),));
            },
          ),
        ],
      ),
    ),
  );
}