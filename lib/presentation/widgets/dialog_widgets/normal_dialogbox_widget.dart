import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void normalDialogBoxWidget({
  required BuildContext context,
  required String title,
  required String subtitle,
  required void Function()? onPressed,
  required String actionButtonName,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).dialogTheme.titleTextStyle,
        ),
        actions: dialogBoxActionButtons(
          context: context,
          onPressed: onPressed,
          actionButtonName: actionButtonName,
        ),
        content: TextWidgetCommon(
          text: subtitle,
          fontSize: 16.sp,
        ),
      );
    },
  );
}

List<Widget> dialogBoxActionButtons(
    {required BuildContext context,
    required void Function()? onPressed,
    required String actionButtonName}) {
  return [
    TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: TextWidgetCommon(
        text: "Cancel",
        textColor: buttonSmallTextColor,
      ),
    ),
    TextButton(
      onPressed: onPressed,
      child: TextWidgetCommon(
        text: actionButtonName,
        textColor: buttonSmallTextColor,
      ),
    ),
  ];
}
