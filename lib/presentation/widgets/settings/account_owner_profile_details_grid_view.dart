import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/presentation/widgets/settings/common_blue_gradient_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountOwnerProfileDetailsGridView extends StatelessWidget {
  const AccountOwnerProfileDetailsGridView({
    super.key,
    required this.nameController,
    required this.aboutController,
  });

  final TextEditingController nameController;
  final TextEditingController aboutController;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      crossAxisCount: 1,
      childAspectRatio: 4.5,
      mainAxisSpacing: 10.h,
      children: [
        CommonBlueGradientContainerWidget(
          controller: nameController,
          title: "Name",
          subTitle: "User Name",
          icon: contact,
          pageType: PageTypeEnum.settingEditProfilePage,
        ),
        CommonBlueGradientContainerWidget(
          controller: aboutController,
          title: "About",
          subTitle: "User Name",
          icon: info,
          pageType: PageTypeEnum.settingEditProfilePage,
        ),
       const CommonBlueGradientContainerWidget(
          title: "Phone number",
          subTitle: "User Name",
          icon: call,
          pageType: PageTypeEnum.none,
        ),
      ],
    );
  }
}
