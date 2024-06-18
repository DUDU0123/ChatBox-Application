import 'package:chatbox/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CommonDivider extends StatelessWidget {
  const CommonDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1,
      color: iconGreyColor.withOpacity(0.2),
      endIndent: 10,
      indent: 10,
    );
  }
}