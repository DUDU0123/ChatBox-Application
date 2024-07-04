import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/features/presentation/bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:chatbox/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chatbox/features/presentation/widgets/bottom_nav/bottom_nav_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.pageController,
  });
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    const selectedIconColor = Color.fromARGB(92, 3, 72, 193);
    final bottomNavBloc = BlocProvider.of<BottomNavBloc>(context);
    final theme = ThemeConstants.theme(context: context);
    return BlocBuilder<BottomNavBloc, BottomNavState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.currentIndex,
          onTap: (currentIndex) {
            pageController.jumpToPage(currentIndex);
            if (currentIndex==0) {
              context.read<ChatBloc>().add(GetAllChatsEvent());
            }
            bottomNavBloc.add(
              BottomNavIconClickedEvent(
                currentIndex: currentIndex,
              ),
            );
          },
          // type: BottomNavigationBarType.fixed,
          // showSelectedLabels: true,
          // showUnselectedLabels: true,
          // selectedIconTheme: IconThemeData(color: kWhite),
          // unselectedItemColor: theme.textTheme.titleMedium?.color,
          // selectedItemColor: theme.textTheme.titleMedium?.color,
          // selectedFontSize: 16.sp,
          // unselectedFontSize: 16.sp,
          // selectedLabelStyle: TextStyle(
          //   fontWeight: FontWeight.bold,
          //   color: theme.textTheme.titleMedium?.color,
          // ),
          // unselectedLabelStyle: const TextStyle(
          //   fontWeight: FontWeight.bold,
          // ),
          backgroundColor: theme.scaffoldBackgroundColor,
          items: [
            BottomNavigationBarItem(
              icon: BottomIconWidget(
                iconColor: state.currentIndex == 0
                    ? theme.iconTheme.color
                    : theme.colorScheme.onPrimary,
                color:
                    state.currentIndex == 0 ? selectedIconColor : kTransparent,
                iconName: "assets/chat.png",
                scale: 21,
              ),
              label: "Chats",
            ),
            BottomNavigationBarItem(
              icon: BottomIconWidget(
                iconColor: state.currentIndex == 1
                    ? theme.iconTheme.color
                    : theme.colorScheme.onPrimary,
                color:
                    state.currentIndex == 1 ? selectedIconColor : kTransparent,
                iconName: "assets/groups.png",
                scale: 15.sp,
              ),
              label: "Groups",
            ),
            BottomNavigationBarItem(
              icon: BottomIconWidget(
                iconColor: state.currentIndex == 2
                    ? theme.iconTheme.color
                    : theme.colorScheme.onPrimary,
                color:
                    state.currentIndex == 2 ? selectedIconColor : kTransparent,
                iconName: "assets/status.png",
                scale: 21,
              ),
              label: "Status",
            ),
            BottomNavigationBarItem(
              icon: BottomIconWidget(
                iconColor: state.currentIndex == 3
                    ? theme.iconTheme.color
                    : theme.colorScheme.onPrimary,
                color:
                    state.currentIndex == 3 ? selectedIconColor : kTransparent,
                iconName: "assets/call.png",
                scale: 21,
              ),
              label: "Calls",
            ),
          ],
        );
      },
    );
  }
}
