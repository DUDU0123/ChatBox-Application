import 'dart:developer';

import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/group/group_pages/group_permissions_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/select_contacts/selected_contacts_show_widget.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_gradient_tile_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/select_user_widgets.dart/floating_done_navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupDetailsAddPage extends StatefulWidget {
  const GroupDetailsAddPage({
    super.key,
    required this.selectedGroupMembers,
  });
  final List<ContactModel> selectedGroupMembers;

  @override
  State<GroupDetailsAddPage> createState() => _GroupDetailsAddPageState();
}

class _GroupDetailsAddPageState extends State<GroupDetailsAddPage> {
  TextEditingController groupNameController = TextEditingController();

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "New group"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth(context: context),
              // color: Colors.amberAccent,
              child: Row(
                children: [
                  Container(
                    height: 85.h,width: 85.w,
                    decoration: BoxDecoration(
                      color: kRed,
                     shape: BoxShape.circle,
                     image: DecorationImage(image: AssetImage(appLogo), fit: BoxFit.cover,)
                    ),
                  ),
                  nullImageReplaceWidget(containerRadius: 50, context: context),
                  kWidth15,
                  Expanded(
                    child: TextFieldCommon(
                      controller: groupNameController,
                      textAlign: TextAlign.start,
                      border: const UnderlineInputBorder(),
                      maxLines: 1,
                      hintText: "Enter group name",
                      labelText: "New group",
                    ),
                  ),
                ],
              ),
            ),
            kHeight30,
            CommonGradientTileWidget(
              onTap: () {
                log("Nav");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GroupPermissionsPage(),
                  ),
                );
              },
              rootContext: context,
              isSmallTitle: false,
              title: "Group Permissions",
              trailing: Icon(
                Icons.settings,
                color: kWhite,
              ),
            ),
            kHeight30,
            const TextWidgetCommon(text: "Members"),
            kHeight10,
            const SelectedContactShowWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingDoneNavigateButton(
        pageType: PageTypeEnum.groupDetailsAddPage,
        icon: Icons.done,
        groupName: groupNameController.text,
      ),
    );
  }
}
