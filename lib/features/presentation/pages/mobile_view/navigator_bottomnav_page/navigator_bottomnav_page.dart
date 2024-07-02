import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/utils/get_appbar_title.dart';
import 'package:chatbox/features/presentation/bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/calls/call_home_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/chat_home_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/group/group_home_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/navigator_bottomnav_page/bottom_navbar.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/status/status_home_page.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/appbar_title_home.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/appbar_icons_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigatorBottomnavPage extends StatelessWidget {
  NavigatorBottomnavPage({super.key});
  final pages = [
    const ChatHomePage(),
    const GroupHomePage(),
    const StatusHomePage(),
    const CallHomePage(),
  ];
  PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final bottomNavBloc = BlocProvider.of<BottomNavBloc>(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            BlocBuilder<BottomNavBloc, BottomNavState>(
              builder: (context, state) {
                return SliverAppBar(
                  expandedHeight: 0,
                  surfaceTintColor: kTransparent,
                  floating: state.currentIndex == 0 ,
                  pinned: state.currentIndex != 0 ,
                  snap: state.currentIndex == 0,
                  automaticallyImplyLeading: false,
                  title: AppBarTitleHome(
                    appBarTitle: getAppBarTitle(currentIndex: state.currentIndex),
                  ),
                  actions: appBarIconsHome(
                    context: context,
                    currentIndex: state.currentIndex,
                    theme: Theme.of(context),
                    isSearchIconNeeded:state.currentIndex==2,
                  ),
                );
              },
            ),
          ];
        },
        body: BlocBuilder<BottomNavBloc, BottomNavState>(
          builder: (context, state) {
            return PageView(

              onPageChanged: (index) {
                bottomNavBloc.add(
                  BottomNavIconClickedEvent(
                    currentIndex: index,
                  ),
                );
              },
              controller: pageController,
              children: pages,
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        pageController: pageController,
      ),
    );
  }
}
