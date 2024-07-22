import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget infoPageListTileWidget({
  required BuildContext context,
  required bool isGroup,
  IconData? icon,
  UserModel? receiverData,
  required bool isFirstTile,
}) {
  return commonListTile(
    onTap: () {},
    title: isFirstTile
        ? !isGroup
            ? "Block ${receiverData?.userName ?? ''}"
            : "Exit group"
        : !isGroup
            ? "Report ${receiverData?.userName ?? ''}"
            : "Report group",
    isSmallTitle: false,
    context: context,
    color: kRed,
    leading: Icon(
      isFirstTile
          ? !isGroup
              ? Icons.block
              : Icons.logout
          : Icons.report_outlined,
      color: kRed,
      size: 28.sp,
    ),
  );
}
