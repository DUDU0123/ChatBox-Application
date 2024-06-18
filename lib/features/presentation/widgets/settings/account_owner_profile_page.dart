import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/enums/enums.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/features/presentation/widgets/settings/account_owner_profile_details_grid_view.dart';
import 'package:chatbox/features/presentation/widgets/settings/settings_profile_image_avatar_widget.dart';
import 'package:flutter/material.dart';

class AccountOwnerProfilePage extends StatelessWidget {
  AccountOwnerProfilePage({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SettingsProfileImageAvatarWidget(),
          // next
          kHeight60,
          Expanded(
            child: AccountOwnerProfileDetailsGridView(
              nameController: nameController,
              aboutController: aboutController,
            ),
          )
        ],
      ),
    );
  }
}