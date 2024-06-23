import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationSettings extends StatelessWidget {
  const NotificationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Notifications",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            commonListTile(
              onTap: () {},
              title: "Show notifications",
              isSmallTitle: false,
              context: context,
              leading: Checkbox(
                value: true,
                onChanged: (value) {},
              ),
            ),
            kHeight20,
            commonListTile(
              onTap: () {},
              title: "Notification tone",
              isSmallTitle: false,
              context: context,
              subtitle: "Default tone",
            ),
            kHeight10,
            commonListTile(
              onTap: () {},
              title: "Ringtone",
              isSmallTitle: false,
              context: context,
              subtitle: "Default tone",
            ),
          ],
        ),
      ),
    );
  }
}
