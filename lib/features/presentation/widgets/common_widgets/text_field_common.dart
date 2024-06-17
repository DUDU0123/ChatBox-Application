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
    required this.textAlign,
    this.enabled,
    this.keyboardType,
    this.style,
    this.prefix,
    this.fillColor,
    this.focusNode,
    this.maxLines,
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
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return TextField(
      maxLines: maxLines,
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
        fillColor: fillColor ?? kTransparent,
        border: border,
        disabledBorder: border,
        enabledBorder: border,
        focusedBorder: border,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: theme.textTheme.labelSmall?.copyWith(
          color: iconGreyColor,
          fontSize: 17.sp,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
