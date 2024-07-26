import 'package:chatbox/config/common_provider/common_provider.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Widget readMoreButton({
  required BuildContext context,
  required CommonProvider commonProvider,
  double? fontSize,
  bool? isInMessageList = false,
  String? messageID,
}) {
  final isExpanded = commonProvider.isExpandedMessage(messageID??'');
  return GestureDetector(
    onTap: () {
      !isInMessageList
          ? Provider.of<CommonProvider>(context, listen: false).changeExpanded()
          : Provider.of<CommonProvider>(context, listen: false)
              .toggleExpand(messageID: messageID ?? '');
    },
    child: TextWidgetCommon(
      text:!isInMessageList!? !commonProvider.isExpanded ? "...read more" : "read less": !isExpanded ? "...read more" : "read less",
      textColor: buttonSmallTextColor,
      fontSize: fontSize?.sp ?? 16.sp,
    ),
  );
}
