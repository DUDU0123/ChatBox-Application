import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class SettingsProfileImageAvatarWidget extends StatelessWidget {
  const SettingsProfileImageAvatarWidget({
    super.key,
    required this.userProfileImage,
  });
  final String? userProfileImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       userProfileImage!=null? Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoViewSection(
              userProfileImage: userProfileImage!,
            ),
          ),
        ): null;
      },
      child: userProfileImageContainerWidget(
        context: context,
        containerRadius: 160,
      ),
    );
  }
}

class PhotoViewSection extends StatelessWidget {
  const PhotoViewSection({super.key, required this.userProfileImage});

  final String userProfileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(
        color: kWhite
      ),
        backgroundColor: kBlack,
      ),
      body: PhotoView(
        loadingBuilder: (context, event) {
          return commonAnimationWidget(context: context, lottie: settingsLottie, isTextNeeded: false,);
        },
        imageProvider: NetworkImage(userProfileImage),
      ),
    );
  }
}
