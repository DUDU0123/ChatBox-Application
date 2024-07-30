import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/select_user_widgets.dart/select_user_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactSingleWidget extends StatelessWidget {
  const ContactSingleWidget({
    super.key,
    required this.contactNameorNumber,
    required this.contactModel,
    required this.isSelected, this.pageType,
  });
  final String contactNameorNumber;
  final ContactModel contactModel;
  final bool isSelected;
  final PageTypeEnum? pageType;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(contactModel.userContactNumber),
      onTap: () {
        context.read<ContactBloc>().add(SelectUserEvent(contact: contactModel));
      },
      leading: Stack(
        children: [
          selectedUserDataWidget(
            contactModel: contactModel,
          ),
          isSelected
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          darkLinearGradientColorOne,
                          darkLinearGradientColorTwo,
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.done,
                      color: kWhite,
                      size: 20.sp,
                    ),
                  ),
                )
              : zeroMeasureWidget
        ],
      ),
      title: TextWidgetCommon(
        text: contactNameorNumber,
      ),
    );
  }
}
