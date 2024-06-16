import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarChatHome extends StatelessWidget {
   SearchBarChatHome({
    super.key,
  });
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 20.w, right: 10.w),
        margin: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
          bottom: 30.h
        ),
        height: 50.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(100.sp),
        ),
        width: screenWidth(context: context),
        child: Center(
          child: TextFieldCommon(
            keyboardType: TextInputType.name,
            hintText: "Search chat...",
            style: fieldStyle(context: context).copyWith(
              fontWeight: FontWeight.normal
            ),
            controller: searchController,
            textAlign: TextAlign.start,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: kTransparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
