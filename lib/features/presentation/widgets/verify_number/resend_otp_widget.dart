import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';

class ResendOtpWidget extends StatelessWidget {
  const ResendOtpWidget({
    super.key, this.onTap,
  });
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidgetCommon(
          text: "Didn't recieve any code?",
          textColor: iconGreyColor,
        ),
        GestureDetector(
          onTap: onTap,
          child: TextWidgetCommon(
            text: "Resend",
            textColor: buttonSmallTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
