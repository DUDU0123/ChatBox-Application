import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';

class ResendOtpWidget extends StatelessWidget {
  const ResendOtpWidget({
    super.key,
  });

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
          onTap: () {},
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
