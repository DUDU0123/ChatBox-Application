import 'package:chatbox/config/theme/theme_manager.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/widgets/chat/attachment_list_container_vertical.dart';
import 'package:chatbox/features/presentation/widgets/chat/chatbar_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat/message_page_date_show_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatelessWidget {
  ChatRoomPage({super.key, required this.userName, required this.isGroup, required this.chatModel,});
  final String userName;
  final ChatModel chatModel;
  final bool isGroup;
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CommonAppBar(
          
          userStatus: "Online",
          appBarTitle: userName,
          pageType: isGroup
              ? PageTypeEnum.groupMessageInsidePage
              : PageTypeEnum.oneToOneChatInsidePage,
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth(context: context),
            height: screenHeight(context: context),
            child: Image.asset(
                fit: BoxFit.cover,
                Provider.of<ThemeManager>(context).isDark
                    ? 
                    bgImage
                    // bgImageDark
                    :
                     bgImage
                // bgImageLight,
                ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => index % 3 == 0
                      ? const Center(
                          child: MessagePageDateShowWidget(
                            date: "10 June, 2024",
                          ),
                        )
                      : kHeight2,
                  itemCount: 10,
                  itemBuilder: (context, index) => Align(
                    alignment: index % 3 == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      width: screenWidth(context: context) / 1.6,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      padding: EdgeInsets.only(
                          left: 10.w, right: 10.w, top: 5.h, bottom: 5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.sp),
                        gradient: LinearGradient(
                          colors: [
                            lightLinearGradientColorOne,
                            lightLinearGradientColorTwo,
                          ],
                        ),
                      ),
                      child: TextWidgetCommon(
                        fontSize: 16.sp,
                        maxLines: null,
                        text: "Hello, Good Morning jvbjdbvjabdkjvbavbjabdj",
                        textColor: kWhite,
                      ),
                    ),
                  ),
                ),
              ),
              
              ChatBarWidget(
                isImojiButtonClicked: false,
                messageController: messageController,
              ),
            ],
          ),
          Positioned(
            bottom: 60.h,
            right: screenWidth(context: context) / 3.3,
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.isAttachmentListOpened ?? false,
                  replacement: zeroMeasureWidget,
                  child: const AttachmentListContainerVertical(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
