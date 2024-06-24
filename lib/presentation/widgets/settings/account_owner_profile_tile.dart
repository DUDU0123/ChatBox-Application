import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/presentation/widgets/settings/account_owner_profile_page.dart';
import 'package:chatbox/presentation/widgets/settings/user_profile_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          userProfileImageContainerWidget(
            context: context,
            containerRadius: 68,
          ),
          kWidth10,
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is CurrentUserErrorState) {
                return Center(
                  child: Text(state.message),
                );
              }
              if (state is CurrentUserLoadedState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth(context: context) / 1.8,
                      child: TextWidgetCommon(
                        overflow: TextOverflow.ellipsis,
                        text: state.currentUserData.userName ?? "",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth(context: context) / 1.8,
                      child: TextWidgetCommon(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textColor: iconGreyColor,
                        text: state.currentUserData.userAbout ?? "",
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                );
              }
              return zeroMeasureWidget;
            },
          ),
        ],
      ),
    );
  }

  
}
