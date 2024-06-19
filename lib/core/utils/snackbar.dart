import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';

void commonSnackBarWidget({
  required BuildContext context,
  required String contentText,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      content: TextWidgetCommon(
        text: contentText,
        textColor: Theme.of(context).colorScheme.onTertiary,
      ),
    ),
  );
}
