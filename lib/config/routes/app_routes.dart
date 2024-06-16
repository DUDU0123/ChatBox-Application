import 'package:chatbox/config/routes/app_routes_name.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/chat_home_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/create_account/create_account_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/number_verify/number_verify_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';

import 'package:chatbox/features/presentation/pages/mobile_view/chatbox_welcome/chatbox_welcome_page.dart';

class AppPages {
  static List<RouteEntity> routes() {
    return [
      RouteEntity(
          path: AppRoutesName.welcomePage, page: const ChatboxWelcomePage()),
      RouteEntity(
          path: AppRoutesName.createAccountPage, page: CreateAccountPage()),
      RouteEntity(
          path: AppRoutesName.verifyNumberPage, page: NumberVerifyPage()),
      RouteEntity(path: AppRoutesName.chatHomePage, page: ChatHomePage()),
    ];
  }

  static MaterialPageRoute generateRouteSettings(RouteSettings settings) {
    if (settings.name != null) {
      var result = routes().where((route) => route.path == settings.name);
      if (result.first.path == AppRoutesName.welcomePage) {
        return MaterialPageRoute(
            builder: (_) => const ChatboxWelcomePage(), settings: settings);
      }
    }
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: TextWidgetCommon(text: "Nothing to Show"),
        ),
      ),
    );
  }
}

class RouteEntity {
  String path;
  Widget page;

  RouteEntity({
    required this.path,
    required this.page,
  });
}
