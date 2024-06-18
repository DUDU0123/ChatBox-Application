import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarTitleHome extends StatelessWidget {
  const AppBarTitleHome({
    super.key,
    required this.appBarTitle,
  });

  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return TextWidgetCommon(
      text: appBarTitle,
      fontWeight: FontWeight.bold,
      fontSize: 30.sp,
    );
  }
}