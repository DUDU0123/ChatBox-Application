import 'package:chatbox/core/constants/app_constants.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/invite_app_function.dart';
import 'package:chatbox/presentation/pages/mobile_view/settings/account_settings.dart';
import 'package:chatbox/presentation/pages/mobile_view/settings/chat_settings.dart';
import 'package:chatbox/presentation/pages/mobile_view/settings/help_settings.dart';
import 'package:chatbox/presentation/pages/mobile_view/settings/notification_settings.dart';
import 'package:chatbox/presentation/pages/mobile_view/settings/privacy_settings.dart';
import 'package:chatbox/presentation/pages/mobile_view/settings/storage_settings.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/presentation/widgets/common_widgets/divider_common.dart';
import 'package:chatbox/presentation/widgets/settings/account_owner_profile_tile.dart';
import 'package:chatbox/presentation/widgets/settings/common_blue_gradient_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Settings",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AccountOwnerProfileTile(),
            kHeight10,
            const CommonDivider(),
            kHeight20,
            Expanded(
              child: GridView.builder(
                itemCount: settingsButtonsList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.8,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final settings = settingsButtonsList[index];
                  return GestureDetector(
                    onTap: () async {
                      switch (settings.pageType) {
                        case PageTypeEnum.accountSetting:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountSettings(),
                            ),
                          );
                          break;
                        case PageTypeEnum.privacySetting:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacySettings(),
                            ),
                          );
                          break;
                        case PageTypeEnum.chatSetting:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatSettings(),
                            ),
                          );
                          break;
                        case PageTypeEnum.notificationsSetting:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationSettings(),
                            ),
                          );
                          break;
                        case PageTypeEnum.storageSetting:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StorageSettings(),
                            ),
                          );
                          break;
                        case PageTypeEnum.helpSetting:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSettings(),
                            ),
                          );
                          break;
                        case PageTypeEnum.inviteButton:
                          await inviteToChatBoxApp();
                          break;
                        default:
                      }
                    },
                    child: CommonBlueGradientContainerWidget(
                      icon: settings.icon,
                      pageType: PageTypeEnum.settingsPage,
                      subTitle: settings.subtitle,
                      title: settings.title,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
