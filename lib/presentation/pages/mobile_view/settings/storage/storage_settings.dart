import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/presentation/pages/mobile_view/settings/storage/manage_storage_page.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:chatbox/presentation/widgets/common_widgets/divider_common.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/presentation/widgets/settings/common_check_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StorageSettings extends StatelessWidget {
  const StorageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Storage",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageStoragePage(),
                  ),
                );
              },
              leading: Icon(
                Icons.folder_outlined,
                color: iconGreyColor,
                size: 30.sp,
              ),
              title: "Manage storage",
              isSmallTitle: false,
              context: context,
              subtitle: "Default tone",
            ),
            const CommonDivider(),
            kHeight10,
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: TextWidgetCommon(
                textAlign: TextAlign.start,
                text: "Media auto-download",
                textColor: iconGreyColor,
                fontSize: 20.sp,
              ),
            ),
            kHeight10,
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: TextWidgetCommon(
                textAlign: TextAlign.start,
                text:
                    "Choose which media will be automatically downloaded from the messages you recieve",
                textColor: iconGreyColor,
              ),
            ),
            kHeight10,
            commonCheckTile(
              context: context,
              title: "Photos",
              boxValue: true,
              onChanged: (value) {},
            ),
            commonCheckTile(
              context: context,
              title: "Audio",
              boxValue: false,
              onChanged: (value) {},
            ),
            commonCheckTile(
              context: context,
              title: "Video",
              boxValue: true,
              onChanged: (value) {},
            ),
            commonCheckTile(
              context: context,
              title: "Documents",
              boxValue: false,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
