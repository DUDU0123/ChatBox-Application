import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/enums/enums.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/settings/common_blue_gradient_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountOwnerProfileTile extends StatelessWidget {
  const AccountOwnerProfileTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountOwnerProfilePage(),
            ));
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 34.sp,
          ),
          kWidth10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidgetCommon(
                text: "Username",
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
              TextWidgetCommon(
                text: "Believe in yourself",
                fontSize: 15.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AccountOwnerProfilePage extends StatelessWidget {
  const AccountOwnerProfilePage({super.key});

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
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                child: SvgPicture.asset(contact),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        darkLinearGradientColorTwo,
                        darkLinearGradientColorOne,
                      ])),
                  child: Center(
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        cameraIcon,
                        height: 30.h,
                        width: 30.w,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // next
          kHeight20,
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              crossAxisCount: 1,
              childAspectRatio: 4.5,
              mainAxisSpacing: 10.h,
              children: [
                CommonBlueGradientContainerWidget(
                  title: "Name",
                  subTitle: "User Name",
                  icon: contact,
                  pageType: PageTypeEnum.settingEditProfilePage,
                ),
                CommonBlueGradientContainerWidget(
                  title: "About",
                  subTitle: "User Name",
                  icon: contact,
                  pageType: PageTypeEnum.settingEditProfilePage,
                ),
                CommonBlueGradientContainerWidget(
                  title: "Phone number",
                  subTitle: "User Name",
                  icon: contact,
                  pageType: PageTypeEnum.settingEditProfilePage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
