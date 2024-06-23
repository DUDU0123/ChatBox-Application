import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacySettings extends StatelessWidget {
  const PrivacySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Privacy",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            commonListTile(
              onTap: () {},
              title: "Last seen and online",
              subtitle: "Everyone",
              isSmallTitle: true,
              context: context,
            ),
            kHeight10,
            commonListTile(
              onTap: () {},
              title: "Profile photo",
              subtitle: "Everyone",
              isSmallTitle: true,
              context: context,
            ),
            kHeight10,
            commonListTile(
              onTap: () {},
              title: "About",
              subtitle: "Everyone",
              isSmallTitle: true,
              context: context,
            ),
            kHeight10,
            commonListTile(
              onTap: () {},
              title: "Status",
              subtitle: "Everyone",
              isSmallTitle: true,
              context: context,
            ),
            kHeight10,
            commonListTile(
              onTap: () {},
              title: "Read reciepts",
              subtitle:
                  "If turned off, you can’t know whether the message is seen or not.",
              isSmallTitle: false,
              context: context,
              isSwitchTile: true,
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
            
            kHeight10,
            commonListTile(
              onTap: () {},
              title: "Blocked contact",
              subtitle: "0",
              isSmallTitle: false,
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
