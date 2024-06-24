import 'package:chatbox/presentation/widgets/settings/user_profile_container_widget.dart';
import 'package:flutter/material.dart';

class SettingsProfileImageAvatarWidget extends StatelessWidget {
  const SettingsProfileImageAvatarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return userProfileImageContainerWidget(
      context: context,
      containerRadius: 160,
    );
  }
}
