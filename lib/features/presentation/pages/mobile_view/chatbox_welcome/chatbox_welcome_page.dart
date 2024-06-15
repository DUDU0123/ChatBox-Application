import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/app_icon_hold_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_button_container.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';

class ChatboxWelcomePage extends StatelessWidget {
  const ChatboxWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppIconHoldWidget(),
            kHeight15,
            TextWidgetCommon(
              text: "Add an account",
              fontSize: theme.textTheme.titleMedium?.fontSize,
              textColor: theme.textTheme.titleMedium?.color,
              fontWeight: theme.textTheme.titleMedium?.fontWeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidgetCommon(
                  text: "Read our ",
                  fontSize: theme.textTheme.titleSmall?.fontSize,
                  textColor: theme.textTheme.titleSmall?.color,
                  fontWeight: theme.textTheme.titleSmall?.fontWeight,
                ),
                Text(
                  "Privacy Policy ",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: darkSmallTextColor,
                  ),
                ),
                TextWidgetCommon(
                  text: "and Get start the journey",
                  fontSize: theme.textTheme.titleSmall?.fontSize,
                  textColor: theme.textTheme.titleSmall?.color,
                  fontWeight: theme.textTheme.titleSmall?.fontWeight,
                ),
              ],
            ),
            kHeight20,
             CommonButtonContainer(
              onTap: () {
                Navigator.pushNamed(context, "create_account");
              },
              horizontalMarginOfButton: 30,
              text: "Get Started",
            ),
          ],
        ),
      ),
    );
  }
}
