import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                onSelect: (selectedCountry) {
                  context.read<AuthenticationBloc>().add(
                        CountrySelectedEvent(
                          selectedCountry: selectedCountry,
                        ),
                      );
                },
              );
            },
            child: countrySelectedShowWidget(),
          ),
          Expanded(
            child: TextFieldCommon(
              style: fieldStyle(context: context),
              keyboardType: TextInputType.number,
              hintText: "Phone number",
              enabled: true,
              textAlign: TextAlign.start,
              controller: phoneNumberController,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  
}
