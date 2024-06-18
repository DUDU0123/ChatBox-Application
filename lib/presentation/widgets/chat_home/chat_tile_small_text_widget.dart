import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTileSmallTextWidget extends StatelessWidget {
  const ChatTileSmallTextWidget({
    super.key,
    required this.smallText,
  });
  final String smallText;

  @override
  Widget build(BuildContext context) {
    return TextWidgetCommon(
      text: smallText,
      textColor: buttonSmallTextColor,
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
    );
  }
}
