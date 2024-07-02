import 'package:chatbox/features/presentation/pages/mobile_view/splash_screen/splash_screen.dart';
import 'package:chatbox/features/presentation/pages/web_view/chatbox_web_auth/chatbox_web_authentication_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    // required this.mobileScreenLayout,
    // required this.webScreenLayout,
  });
  // final Widget mobileScreenLayout;
  // final Widget webScreenLayout;

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder(
    //   builder: (context, constraints) {
    //     // if (constraints.maxWidth > 900) {
    //     //   // web view
    //     //   return webScreenLayout;
    //     // }
    //     // // mobile view
    //     // return mobileScreenLayout;
    //     // if (kIsWeb) {
    //     //   // web view
    //     //   return ChatboxWebAuthenticationPage();
    //     // }
    //     // // mobile view
    //     // return ChatboxWelcomePage();
    //   },
    // );
    if (kIsWeb) {
      // web view
      return const ChatboxWebAuthenticationPage();
    }
    // mobile view
    return const SplashScreen();
  }
}
