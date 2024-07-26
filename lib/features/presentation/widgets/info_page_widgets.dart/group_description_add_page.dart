import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupDescriptionAddPage extends StatelessWidget {
  GroupDescriptionAddPage({super.key});
  TextEditingController groupDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidgetCommon(
          text: "Add Description",
          textColor: Theme.of(context).colorScheme.onPrimary,
          fontSize: 20.sp,
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          width: screenWidth(context: context),
          height: screenHeight(context: context) / 2.8,
          child: TextFieldCommon(
            hintText: "Enter description",
            maxLines: 20,
            controller: groupDescriptionController,
            textAlign: TextAlign.start,
            border: UnderlineInputBorder(borderSide: BorderSide(color: buttonSmallTextColor)),
          )),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: lightLinearGradientColorTwo,
        onPressed: () {},
        label: TextWidgetCommon(
          text: "Save",
          textColor: kWhite,
        ),
      ),
    );
  }
}
