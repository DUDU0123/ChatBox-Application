import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextButtonsCommon extends StatelessWidget {
  const TextButtonsCommon({
    super.key,
    required this.buttonName,
  });
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {},
          child: TextWidgetCommon(
            text: "Cancel",
            textColor: Theme.of(context).primaryColor,
            fontSize: 16.sp,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: TextWidgetCommon(
            text: buttonName,
            textColor: Theme.of(context).primaryColor,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
