import 'package:chatbox/config/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String themeType({required BuildContext context,}){
    final themeManager = Provider.of<ThemeManager>(context);
    if (themeManager.isSystemThemeMode) {
      return "System Default";
    }else if(themeManager.isDark){
      return "Dark";
    }else{
      return "Light";
    }
  }
