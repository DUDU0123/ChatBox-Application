import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/presentation/widgets/chat/message_icon_widgets.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageHoldContainer extends StatelessWidget {
  MessageHoldContainer({
    super.key,
    required this.isReadedMessage,
    required this.messageType,
  });

  final bool? isReadedMessage;
  final MessageType messageType;

  bool isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        isLongPressed = true;
      },
      onTap: () {
        isLongPressed = false;
      },
      child: Container(
        width: screenWidth(context: context),
        color: isLongPressed
            ? const Color.fromARGB(106, 33, 149, 243)
            : kTransparent,
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            10.h
                        ),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: screenWidth(context: context) / 1.6,
                            child: TextWidgetCommon(
                              fontSize: 16.sp,
                              maxLines: null,
                              text:
                                  "Hello, Good Morning jvbjdbvjabdkjvbavbjabdj",
                              textColor: kWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                messageBottomStatusIcons(
                  isReadedMessage: isReadedMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
