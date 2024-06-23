import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Account",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
        child: Column(
          children: [
            commonListTile(
              onTap: () {},
              title: "Two step verification",
              leading: SvgPicture.asset(
                tfaPin,
                width: 25.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
              ),
              isSmallTitle: false,
              context: context,
            ),
            kHeight5,
            commonListTile(
              onTap: () {},
              title: "Change number",
              leading: SvgPicture.asset(
                changeNumberIcon,
                width: 20.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
              ),
              isSmallTitle: false,
              context: context,
            ),
            kHeight5,
            commonListTile(
              onTap: () {},
              title: "Delete account",
              leading: SvgPicture.asset(
                deleteIcon,
                width: 20.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
              ),
              isSmallTitle: false,
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
