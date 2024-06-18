import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/presentation/widgets/settings/account_owner_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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


