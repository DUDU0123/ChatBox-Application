import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppIconHoldWidget extends StatelessWidget {
  const AppIconHoldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.sp),
      ),
      height: 150,width: 150,
      child: Image.asset(
        appLogo,
        fit: BoxFit.cover,
      ),
    );
  }
}