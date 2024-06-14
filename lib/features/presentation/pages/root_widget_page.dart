import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/config/theme/theme_manager.dart';
import 'package:chatbox/features/presentation/pages/main_page/main_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chatbox_welcome/chatbox_welcome_page.dart';
import 'package:chatbox/features/presentation/pages/web_view/chatbox_web_auth/chatbox_web_authentication_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RootWidgetPage extends StatelessWidget {
  const RootWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeManager()..init(),
      child: ScreenUtilInit(builder: (context, child) {
        final themeManager = Provider.of<ThemeManager>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const MainPage(
            mobileScreenLayout: ChatboxWelcomePage(),
            webScreenLayout: ChatboxWebAuthenticationPage(),
          ),
        );
      }),
    );
  }
}
