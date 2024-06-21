import 'package:chatbox/config/theme/theme_manager.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/presentation/widgets/chat/chatbar_widget.dart';
import 'package:chatbox/presentation/widgets/chat/message_hold_container.dart';
import 'package:chatbox/presentation/widgets/chat/message_page_date_show_widget.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MessagingPage extends StatelessWidget {
  MessagingPage({
    super.key,
    required this.isGroup,
    this.isReadedMessage,
    required this.userName,
  });

  final bool isGroup;
  final String userName;
  final bool? isReadedMessage;
  TextEditingController messageController = TextEditingController();
  bool isVisible = false;
  bool isImojiButtonClicked = false;
  // final bool? isGone;
  @override
  Widget build(BuildContext context) {
    
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CommonAppBar(
          userStatus: "",
          appBarTitle: userName,
          pageType: isGroup
              ? PageTypeEnum.groupMessageInsidePage
              : PageTypeEnum.oneToOneChatInsidePage,
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth(context: context),height: screenHeight(context: context),
            child: Image.asset(
              fit: BoxFit.cover,
              Provider.of<ThemeManager>(context).isDark
                    ? bgImageDark
                    : bgImageLight,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) =>index%5==0?  Padding(
                    padding:  EdgeInsets.all(10.sp),
                    child:  const Column(
                      children: [
                        MessagePageDateShowWidget(date: "10 June, 2024"),
                      ],
                    ),
                  ):zeroMeasureWidget,
                  itemCount: 17,
                  padding: EdgeInsets.only(
                    top: 10.h,
                    bottom: 10.h,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      child: MessageHoldContainer(
                        isReadedMessage: isReadedMessage,
                      ),
                    );
                  },
                ),
              ),
              ChatBarWidget(
                isImojiButtonClicked: isImojiButtonClicked,
                messageController: messageController,
              ),
            ],
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: MessagePageDateShowWidget(date: "10 July, 2022"),
          ),
        ],
      ),
    );
    // Scaffold(
    // appBar: PreferredSize(
    //   preferredSize: const Size.fromHeight(60),
    //   child: CommonAppBar(
    //     appBarTitle: userName,
    //     pageType: isGroup
    //         ? PageTypeEnum.groupMessageInsidePage
    //         : PageTypeEnum.oneToOneChatInsidePage,
    //   ),
    // ),
    //   body: Container(
    //     // height: screenHeight(context: context),
    //     width: screenWidth(context: context),
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         image: AssetImage(
              // Provider.of<ThemeManager>(context).isDark
              //     ? bgImageDark
              //     : bgImageLight,
    //         ),
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     child: Stack(
    //       children: [
    //         SafeArea(
    // child: ListView.separated(
    //   separatorBuilder: (context, index) => kHeight5,
    //   itemCount: 17,
    //   padding: EdgeInsets.only(
    //     top: 10.h,
    //     bottom: 10.h,
    //   ),
    //   itemBuilder: (context, index) {
    //     return MessageHoldContainer(isReadedMessage: isReadedMessage);
    //   },
    // ),
    //         ),
    // Positioned(
    //   bottom: 0.h,
    //   child: ChatBarWidget(
    //     isImojiButtonClicked: isImojiButtonClicked,
    //     messageController: messageController,
    //   ),
    // ),
    //         Align(
    //           alignment: Alignment.topCenter,
    //           child: Container(
    //             margin: EdgeInsets.only(top: 3.h),
    //             padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
    //             decoration: BoxDecoration(
    //               color: iconGreyColor.withAlpha(150),
    //               borderRadius: BorderRadius.circular(5.sp),
    //             ),
    //             child: const Text("MM/dd/YYYY"),
    //           ),
    //         ),

    //         Positioned(
    //           right: screenWidth(context: context) / 3.5,
    //           bottom: 0,
    //           child: Visibility(
    //             visible: false,
    //             replacement: zeroMeasureWidget,
    //             child: Container(
    //                 height: screenHeight(context: context) / 3.h,
    //                 width: 50.w,
    //                 decoration: BoxDecoration(
    //                   color: theme.colorScheme.onTertiary,
    //                   borderRadius: BorderRadius.circular(15.sp),
    //                 ),
    //                 child: ClipRRect(
    //                   borderRadius: BorderRadius.circular(15.sp),
    //                   child: ListView.separated(
    //                     padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
    //                     itemCount: attachmentIcons.length,
    //                     itemBuilder: (context, index) {
    //                       return Container(
    //                         decoration: BoxDecoration(
    //                           shape: BoxShape.circle,
    //                           gradient: LinearGradient(
    //                             colors: [
    //                               attachmentIcons[index].colorOne,
    //                               attachmentIcons[index].colorTwo,
    //                             ],
    //                           ),
    //                         ),
    //                         child: IconButton(
    //                           onPressed: () {},
    //                           icon: SvgPicture.asset(
    //                             attachmentIcons[index].icon,
    //                            height: 24.h,width: 24.h,
    //                             colorFilter: ColorFilter.mode(
    //                               kBlack,
    //                               BlendMode.srcIn,
    //                             ),
    //                           ),
    //                         ),
    //                       );
    //                     },
    //                     separatorBuilder: (context, index) => kHeight5,
    //                   ),
    //                 )),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    //   // bottomNavigationBar: Padding(
    //   //   padding: EdgeInsets.only(
    //   //       bottom:
    //   //           isKeyboardOpen ? MediaQuery.of(context).viewInsets.bottom : 0),
    //   //   child: ChatBarWidget(
    //   //     messageController: messageController,
    //   //   ),
    //   // ),
    // );
  }
}
