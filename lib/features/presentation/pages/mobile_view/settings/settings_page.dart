import 'package:chatbox/core/constants/app_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/enums/enums.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/divider_common.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/settings/account_owner_profile_tile.dart';
import 'package:chatbox/features/presentation/widgets/settings/common_blue_gradient_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Settings",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AccountOwnerProfileTile(),
            kHeight10,
            CommonDivider(),
            kHeight20,
            Expanded(
              child: GridView.builder(
                itemCount: settingsButtonsList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.8,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final settings = settingsButtonsList[index];
                  return CommonBlueGradientContainerWidget(
                    icon: settings.icon,
                    pageType: PageTypeEnum.settingsPage,
                    subTitle: settings.subtitle,
                    title: settings.title,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}