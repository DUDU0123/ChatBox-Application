import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/chat/message_icon_widgets.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageHoldContainer extends StatelessWidget {
  const MessageHoldContainer({
    super.key,
    required this.isReadedMessage,
  });

  final bool? isReadedMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.sp),
                    bottomRight: Radius.circular(10.sp),
                    topRight: Radius.circular(10.sp),
                    topLeft: Radius.circular(1.sp)),
                gradient: LinearGradient(
                  colors: [
                    lightLinearGradientColorOne,
                    lightLinearGradientColorTwo,
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: screenWidth(context: context) / 1.6,
                        child: const TextWidgetCommon(
                          maxLines: null,
                          text:
                              "Hello, Good Morning jvbjdbvjabdkjvbavbjabdj",
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
    );
  }
}
