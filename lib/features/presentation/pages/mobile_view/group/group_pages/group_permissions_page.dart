import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_gradient_tile_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/select_user_widgets.dart/floating_done_navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupPermissionsPage extends StatelessWidget {
  const GroupPermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Group Permission"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            smallGreyMediumBoldTextWidget(
              text: "Members can:",
            ),
            kHeight10,
            CommonGradientTileWidget(
              trailing:  Switch(value: true, onChanged: (value) {
                
              },),
              isSwitchTile: true,
              rootContext: context,
              isSmallTitle: false,
              title: "Edit group settings",
            ),
            kHeight10,
            CommonGradientTileWidget(
              trailing:  Switch(value: true, onChanged: (value) {
                
              },),
              rootContext: context,
              isSmallTitle: false,
              title: "Send messages",
            ),
            kHeight10,
            CommonGradientTileWidget(
              trailing:  Switch(value: true, onChanged: (value) {
                
              },),
              rootContext: context,
              isSmallTitle: false,
              title: "Add members",
            ),
            kHeight20,
            smallGreyMediumBoldTextWidget(
              text: "Only Admins can:",
            ),
            kHeight10,
            CommonGradientTileWidget(
              trailing:  Switch(value: false, onChanged: (value) {
                
              },),
              rootContext: context,
              isSmallTitle: false,
              title: "Approve members",
            ),
            kHeight10,
            CommonGradientTileWidget(
              trailing:  Switch(value: true, onChanged: (value) {
                
              },),
              rootContext: context,
              isSmallTitle: false,
              title: "View members",
            ),
          ],
        ),
      ),
    );
  }
}
