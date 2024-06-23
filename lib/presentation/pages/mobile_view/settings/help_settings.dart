import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:chatbox/presentation/widgets/common_widgets/divider_common.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpSettings extends StatelessWidget {
  const HelpSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Help",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidgetCommon(
              textAlign: TextAlign.start,
              text: "Contact Us",
              textColor: Theme.of(context).colorScheme.onPrimary,
              fontSize: 25.sp,
            ),
            TextWidgetCommon(
              textAlign: TextAlign.start,
              text: "We would like to know your thoughts about\nthis app.",
              textColor: iconGreyColor,
            ),
            kHeight10,
            linkText(
              text: "Contact Us",
              onTap: () {},
            ),
            const CommonDivider(),
            kHeight15,
            linkText(
              text: "Help Center",
              onTap: () {},
            ),
            kHeight15,
            linkText(
              text: "Terms and privacy policy",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector linkText({required String text, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: TextWidgetCommon(
        textAlign: TextAlign.start,
        text: text,
        textColor: buttonSmallTextColor,
        fontSize: 18.sp,
      ),
    );
  }

  Widget commonCheckTile({
    required BuildContext context,
    required String title,
    bool? boxValue,
    required void Function(bool?)? onChanged,
  }) {
    return commonListTile(
      onTap: () {},
      title: title,
      isSmallTitle: false,
      context: context,
      leading: Checkbox(
        checkColor: kWhite,
        activeColor: buttonSmallTextColor,
        fillColor: WidgetStateProperty.all(boxValue != null
            ? boxValue
                ? buttonSmallTextColor
                : kTransparent
            : kTransparent),
        value: boxValue,
        onChanged: (value) {},
      ),
    );
  }
}
