import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneNumberRecieveField extends StatelessWidget {
  PhoneNumberRecieveField({
    super.key,
    required this.phoneNumberController,
  });

  final TextEditingController phoneNumberController;
  Country selectedCountry = Country(
    phoneCode: "+91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
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
           GestureDetector(
                onTap: () {
                  showCountryPicker(
                    countryListTheme: CountryListThemeData(
                      backgroundColor: theme.colorScheme.onTertiary,
                      bottomSheetHeight: screenHeight(context: context) / 2,
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    context: context,
                    onSelect: (country) {
                      selectedCountry = country;
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: TextWidgetCommon(
                    text: selectedCountry.flagEmoji + selectedCountry.phoneCode,
                    fontWeight: FontWeight.w500,
                    fontSize: theme.textTheme.labelSmall?.fontSize,
                    textColor: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
          Expanded(
            child: TextFieldCommon(
              style: fieldStyle(context: context),
              keyboardType: TextInputType.number,
              hintText: "Phone number",
              enabled: true,
              textAlign: TextAlign.start,
              controller: phoneNumberController,
              border: InputBorder.none
            ),
          ),
        ],
      ),
    );
  }
}
