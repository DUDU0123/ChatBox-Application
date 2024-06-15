import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<Widget> appBarIconsHome({required bool isSearchIconNeeded,required ThemeData theme}) {
    return [
      CommonIconButtonWidget(
        theme: theme,
        height: 30,
        width: 30,
        iconImage: "assets/camera.svg",
        onPressed: () {},
      ),
      isSearchIconNeeded
          ? CommonIconButtonWidget(
            theme: theme,
              height: 22,
              width: 22,
              iconImage: "assets/search.svg",
              onPressed: () {},
            )
          : zeroMeasureWidget,
      IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.more_vert,
          size: 30.sp,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    ];
  }

