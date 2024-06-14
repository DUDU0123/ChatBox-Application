import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonButtonContainer extends StatelessWidget {
   const CommonButtonContainer({
    super.key, required this.horizontalMarginOfButton, required this.text,
  });
  final double horizontalMarginOfButton;
  final String text;
  
  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMarginOfButton.sp),
      height: 50.h,
      width: screenWidth(context: context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.sp),
        gradient: LinearGradient(
          colors: [
            lightLinearGradientColorOne,
            lightLinearGradientColorTwo,
          ],
        ),
      ),
      child: Center(
        child: TextWidgetCommon(
          text: text,
          fontSize: theme.textTheme.labelSmall?.fontSize,
          textColor: theme.textTheme.labelSmall?.color,
          fontWeight: theme.textTheme.labelSmall?.fontWeight,
        ),
      ),
    );
  }
}
