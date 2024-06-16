import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldCommon extends StatelessWidget {
  const TextFieldCommon({
    super.key,
    this.border,
    this.suffixIcon,
    this.hintText,
    required this.controller,
    required this.textAlign, this.enabled, this.keyboardType, this.style, this.prefix, this.fillColor, this.focusNode,
  });
  final InputBorder? border;
  final TextStyle? style;
  final Widget? suffixIcon;
  final String? hintText;
  final TextEditingController controller;
  final TextAlign textAlign;
  final bool? enabled;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final Color? fillColor;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return TextField(
      focusNode: focusNode,
      cursorColor: theme.primaryColor,
      style: style,
      keyboardType: keyboardType,
      controller: controller,
      enabled: enabled,
      textAlign: textAlign,
      decoration: InputDecoration(
        prefix: prefix,
       // filled: true,
        fillColor: fillColor??kTransparent,
        border: border,
        disabledBorder: border,
        enabledBorder: border,
        focusedBorder: border,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: theme.textTheme.labelSmall?.copyWith(
          color: kGrey,
          fontSize: 18.sp,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
