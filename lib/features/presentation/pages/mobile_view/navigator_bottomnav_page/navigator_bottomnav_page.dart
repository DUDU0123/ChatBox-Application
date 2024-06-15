import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavigatorBottomnavPage extends StatelessWidget {
  NavigatorBottomnavPage({super.key});

  final colorfilterOne = ColorFilter.mode(kWhite, BlendMode.srcIn);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: BottomNavigationBar(
          enableFeedback: false,
          currentIndex: 2,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(color: kWhite),
          unselectedItemColor: kWhite,
          selectedItemColor: kWhite,
          selectedFontSize: 16.sp,
          unselectedFontSize: 16.sp,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          items: const [
          const  BottomNavigationBarItem(
              icon: BottomIconWidget(
                iconName: "assets/chat.png",
                scale: 21,
              ),
              label: "Chats",
            ),
            const  BottomNavigationBarItem(
              icon: BottomIconWidget(
                iconName: "assets/groups.png",
                scale: 21,
              ),
              label: "Groups",
            ),
            const  BottomNavigationBarItem(
              icon: BottomIconWidget(
                iconName: "assets/status.png",
                scale: 21,
              ),
              label: "Status",
            ),
            const  BottomNavigationBarItem(
              icon: BottomIconWidget(
                iconName: "assets/call.png",
                scale: 21,
              ),
              label: "Calls",
            ),
            
          ],
        ),
      ),
    );
  }
}

class BottomIconWidget extends StatelessWidget {
  const BottomIconWidget({
    super.key,
    required this.scale, required this.iconName,
  });
  final double scale;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 35.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color.fromARGB(92, 3, 72, 193),
      ),
      child: Image.asset(
        iconName,
        scale: scale.sp,
        color: kWhite,
      ),
    );
  }
}
