import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CommonAppBar extends StatelessWidget {
  const CommonAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextWidgetCommon(text: "UserName"),
      actions: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            videoCall,
            width: 30.w,
            height: 30.h,
            colorFilter: ColorFilter.mode(
              kWhite,
              BlendMode.srcIn,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            call,
            width: 30.w,
            height: 23.h,
            colorFilter: ColorFilter.mode(
              kWhite,
              BlendMode.srcIn,
            ),
          ),
        ),
        PopupMenuButton(
          onSelected: (value) {},
          itemBuilder: (context) {
            return [
              const PopupMenuItem(child: Text("data")),
              const PopupMenuItem(child: Text("data")),
              const PopupMenuItem(child: Text("data")),
              const PopupMenuItem(child: Text("data")),
            ];
          },
        )
      ],
    );
  }
}