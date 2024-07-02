import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextButtonsCommon extends StatelessWidget {
  const TextButtonsCommon({
    super.key,
    required this.buttonName, this.onPressed,
  });
  final String buttonName;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: TextWidgetCommon(
            text: "Cancel",
            textColor: buttonSmallTextColor,
            fontSize: 16.sp,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: TextWidgetCommon(
            text: buttonName,
            textColor: buttonSmallTextColor,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
