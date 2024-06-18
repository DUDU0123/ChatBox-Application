import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/app_icon_hold_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_button_container.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/phone_number_recieve_field.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({super.key});
  TextEditingController regionController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight(context: context),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppIconHoldWidget(),
                kHeight25,
                TextWidgetCommon(
                  text: "Enter phone number",
                  fontSize: 20.sp,
                  textColor: theme.textTheme.titleMedium?.color,
                  fontWeight: theme.textTheme.titleMedium?.fontWeight,
                ),
               kHeight10,
                PhoneNumberRecieveField(
                  phoneNumberController: phoneNumberController,
                ),
                kHeight15,
                CommonButtonContainer(
                  onTap: () {
                    Navigator.pushNamed(context, "verify_number");
                  },
                  horizontalMarginOfButton: 30,
                  text: "Next",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
