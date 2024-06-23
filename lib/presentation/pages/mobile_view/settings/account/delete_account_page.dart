import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_button_container.dart';
import 'package:chatbox/presentation/widgets/common_widgets/phone_number_recieve_field.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteAccountPage extends StatelessWidget {
  DeleteAccountPage({super.key});
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Delete this account",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextWidgetCommon(
                text:
                    "To delete your account, confirm your country code and enter your phone number.",
                fontSize: 16.sp,
              ),
              kHeight15,
              PhoneNumberRecieveField(
                phoneNumberController: phoneNumberController,
              ),
              kHeight15,
              CommonButtonContainer(
                horizontalMarginOfButton: 40,
                text: "Delete Number",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}


