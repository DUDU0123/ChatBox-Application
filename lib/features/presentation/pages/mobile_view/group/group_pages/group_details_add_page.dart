import 'dart:developer';
import 'dart:io';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/image_picker_method.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/core/utils/snackbar.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/presentation/bloc/group/group_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/group/group_pages/group_permissions_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/select_contacts/selected_contacts_show_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_gradient_tile_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/select_user_widgets.dart/floating_done_navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class GroupDetailsAddPage extends StatefulWidget {
  const GroupDetailsAddPage({
    super.key,
    required this.selectedGroupMembers,
  });
  final List<ContactModel> selectedGroupMembers;

  @override
  State<GroupDetailsAddPage> createState() => _GroupDetailsAddPageState();
}

class _GroupDetailsAddPageState extends State<GroupDetailsAddPage> {
  TextEditingController groupNameController = TextEditingController();
  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "New group"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth(context: context),
              // color: Colors.amberAccent,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      File? pickedImageFile =
                          await pickImage(imageSource: ImageSource.gallery);
                      if (mounted) {
                        context.read<GroupBloc>().add(
                            GroupImagePickEvent(pickedFile: pickedImageFile));
                      }
                    },
                    child: BlocBuilder<GroupBloc, GroupState>(
                      builder: (context, state) {
                        return Container(
                          alignment: Alignment.center,
                          height: 85.h,
                          width: 85.w,
                          decoration: BoxDecoration(
                            color: kRed,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: state.groupPickedImageFile != null
                                  ? state.groupPickedImageFile!.path
                                          .isNotEmpty
                                      ? FileImage(state.groupPickedImageFile!)
                                      : const AssetImage(appLogo)
                                  : const AssetImage(appLogo),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: kBlack,
                            size: 30.sp,
                          ),
                        );
                      },
                    ),
                  ),
                  kWidth15,
                  Expanded(
                    child: TextFieldCommon(
                      controller: groupNameController,
                      textAlign: TextAlign.start,
                      border: const UnderlineInputBorder(),
                      maxLines: 1,
                      hintText: "Enter group name",
                      labelText: "New group",
                    ),
                  ),
                ],
              ),
            ),
            kHeight30,
            CommonGradientTileWidget(
              onTap: () {
                log("Nav");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GroupPermissionsPage(),
                  ),
                );
              },
              rootContext: context,
              isSmallTitle: false,
              title: "Group Permissions",
              trailing: Icon(
                Icons.settings,
                color: kWhite,
              ),
            ),
            kHeight30,
            const TextWidgetCommon(text: "Members"),
            kHeight10,
            const SelectedContactShowWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingDoneNavigateButton(
        isGroup: true,
        selectedContactList: widget.selectedGroupMembers,
        pageType: PageTypeEnum.groupDetailsAddPage,
        icon: Icons.done,
        groupName: groupNameController.text,
        pickedGroupImageFile:
            context.watch<GroupBloc>().state.groupPickedImageFile,
      ),
    );
  }
}
