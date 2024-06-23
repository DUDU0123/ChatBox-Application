import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/presentation/widgets/settings/account_owner_profile_page.dart';
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
          CircleAvatar(
            radius: 34.sp,
          ),
          kWidth10,
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is CurrentUserErrorState) {
                return Center(child: Text(state.message),);
              }
              if (state is CurrentUserLoadedState) {
                return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidgetCommon(
                    text: state.currentUserData.userName?? "Username",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  TextWidgetCommon(
                    text: state.currentUserData.userAbout??"",
                    fontSize: 15.sp,
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
