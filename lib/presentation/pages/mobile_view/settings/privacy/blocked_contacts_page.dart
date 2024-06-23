import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlockedContactsPage extends StatelessWidget {
  const BlockedContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Blocked contacts"),
        actions: [
          PopupMenuButton(
            onSelected: (value) {},
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: TextWidgetCommon(
                  text: "Select",
                ),
              ),
            ],
          )
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        itemBuilder: (context, index) {
          return commonListTile(
            leading: CircleAvatar(
              radius: 25.sp,
              child: Icon(
                Icons.person,
                color: iconGreyColor,
              ),
            ),
            onTap: () {},
            title: "+91 6730283903",
            isSmallTitle: false,
            context: context,
          );
        },
        separatorBuilder: (context, index) => kHeight10,
        itemCount: 15,
      ),
    );
  }
}
