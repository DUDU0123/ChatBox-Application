import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneNumberRecieveField extends StatelessWidget {
  const PhoneNumberRecieveField({
    super.key,
    required this.phoneNumberController,
  });

  final TextEditingController phoneNumberController;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return Container(
      padding: EdgeInsets.only(left: 10.w),
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      width: screenWidth(context: context),
      height: 50.sp,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.primaryColor,
        ),
        color: kTransparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          TextWidgetCommon(
            text: "+91",
            fontWeight: FontWeight.w500,
            fontSize: theme.textTheme.labelSmall?.fontSize,
          ),
          Expanded(
            child: TextFieldCommon(
              style: fieldStyle(context: context),
              keyboardType: TextInputType.number,
              hintText: "Phone number",
              enabled: true,
              textAlign: TextAlign.start,
              controller: phoneNumberController,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kTransparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
