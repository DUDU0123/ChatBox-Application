import 'package:chatbox/features/presentation/bloc/bottomNavBloc/bottom_nav_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/calls/call_home_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/chat_home_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/group/group_home_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/navigator_bottomnav_page/bottom_navbar.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/status/status_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigatorBottomnavPage extends StatelessWidget {
  NavigatorBottomnavPage({super.key});
  final pages = [
    ChatHomePage(),
    const GroupHomePage(),
    const StatusHomePage(),
    const CallHomePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return pages[state.currentIndex];
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
