import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/presentation/widgets/common_widgets/app_icon_hold_widget.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_button_container.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberVerifyPage extends StatelessWidget {
  NumberVerifyPage({super.key});
  TextEditingController numberVerifyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const AppIconHoldWidget(),
            kHeight25,
            TextWidgetCommon(
              textAlign: TextAlign.center,
              text: "To verify, enter the otp send to the given number",
              fontSize: 20.sp,
              textColor: theme.textTheme.titleMedium?.color,
              fontWeight: theme.textTheme.titleMedium?.fontWeight,
            ),
            kHeight20,
            SizedBox(
              height: 50.h,
              child: TextFieldCommon(
                maxLines: 1,
                keyboardType: TextInputType.number,
                style: fieldStyle(context: context),
                hintText: "Enter otp",
                textAlign: TextAlign.center,
                controller: numberVerifyController,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.sp),
                  borderSide: BorderSide(
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
            kHeight15,
            CommonButtonContainer(
              onTap: () {
                Navigator.pushNamed(context, "bottomNav_Navigator");
              },
              horizontalMarginOfButton: 30,
              text: "Next",
            ),
          ],
        ),
      ),
    );
  }
}
