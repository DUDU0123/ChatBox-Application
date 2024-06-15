import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryCodeSelectField extends StatelessWidget {
  const CountryCodeSelectField({
    super.key,
    required this.countryCodeController,
  });

  final TextEditingController countryCodeController;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return Container(
      color: kTransparent,
      width: screenWidth(context: context),
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 50.w),
      child: Row(
        children: [
          Expanded(
            child: TextFieldCommon(
              enabled: false,
              textAlign: TextAlign.center,
              controller: countryCodeController,
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primaryColor,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_drop_down_sharp,
                ),
              ),
              hintText: "India",
            ),
          ),
        ],
      ),
    );
  }
}
