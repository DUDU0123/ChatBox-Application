import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/settings/user_details/account_owner_profile_details_grid_view.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/settings/user_details/settings_profile_image_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is LoadCurrentUserData) {
            return commonAnimationWidget(
              context: context,
              isTextNeeded: false,
              lottie: settingsLottie,
            );
          }
          if (state is CurrentUserLoadedState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SettingsProfileImageAvatarWidget(
                  userProfileImage: state.currentUserData.userProfileImage,
                ),
                // next
                kHeight60,
                Expanded(
                  child: AccountOwnerProfileDetailsGridView(
                    nameController: nameController,
                    aboutController: aboutController,
                  ),
                ),
              ],
            );
          }
          return zeroMeasureWidget;
        },
      ),
    );
  }
}
