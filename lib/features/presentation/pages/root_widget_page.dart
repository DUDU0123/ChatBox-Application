import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/config/theme/theme_manager.dart';
import 'package:chatbox/features/presentation/bloc/bottomNavBloc/bottom_nav_bloc.dart';
import 'package:chatbox/features/presentation/pages/main_page/main_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chatbox_welcome/chatbox_welcome_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/create_account/create_account_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/navigator_bottomnav_page/navigator_bottomnav_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/number_verify/number_verify_page.dart';
import 'package:chatbox/features/presentation/pages/web_view/chatbox_web_auth/chatbox_web_authentication_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        return MultiBlocProvider(
          providers: AppBlocProviders.allBlocProviders,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            theme: ThemeConstants.lightTheme,
            darkTheme: ThemeConstants.darkTheme,
            // home: const MainPage(
            //   mobileScreenLayout: ChatboxWelcomePage(),
            //   webScreenLayout: ChatboxWebAuthenticationPage(),
            // ),
            initialRoute: "/",
            routes: {
              "/": (context) => const MainPage(
                    mobileScreenLayout: ChatboxWelcomePage(),
                    webScreenLayout: ChatboxWebAuthenticationPage(),
                  ),
              'welcome_page': (context) => const ChatboxWelcomePage(),
              "create_account": (context) => CreateAccountPage(),
              "verify_number": (context) => NumberVerifyPage(),
              "bottomNav_Navigator": (context) => NavigatorBottomnavPage(),
            },
          ),
        );
      }),
    );
  }
}
