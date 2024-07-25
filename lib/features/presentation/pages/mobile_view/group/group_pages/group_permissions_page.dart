import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/presentation/bloc/group/group_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_gradient_tile_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class GroupPermissionsPage extends StatelessWidget {
  const GroupPermissionsPage({super.key, this.pageType = PageTypeEnum.groupDetailsAddPage, this.groupModel,});

  final PageTypeEnum? pageType;
  final GroupModel? groupModel;

  @override
  Widget build(BuildContext context) {
    if (pageType == PageTypeEnum.groupInfoPage && groupModel != null) {
      context.read<GroupBloc>().add(LoadGroupPermissionsEvent(groupModel: groupModel!, pageTypeEnum: pageType!));
    } else {
      context.read<GroupBloc>().add(LoadGroupPermissionsEvent(groupModel: const GroupModel(), pageTypeEnum: pageType!));
    }
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Group Permission"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallGreyMediumBoldTextWidget(
                  text: "Members can:",
                ),
                kHeight10,
                CommonGradientTileWidget(
                  trailing: Switch(
                    value:
                    //  pageType==PageTypeEnum.groupInfoPage?:
                     state.memberPermissions[
                            MembersGroupPermission.editGroupSettings] 
                            ??false,
                    onChanged: (value) {
                      context.read<GroupBloc>().add(UpdateMemberPermissionEvent(
                         groupModel: groupModel,
                        pageTypeEnum: pageType??PageTypeEnum.groupDetailsAddPage,
                            permission:
                                MembersGroupPermission.editGroupSettings,
                            isEnabled: value,
                          ));
                    },
                  ),
                  isSwitchTile: true,
                  rootContext: context,
                  isSmallTitle: false,
                  title: "Edit group settings",
                ),
                kHeight10,
                CommonGradientTileWidget(
                  trailing: Switch(
                    value: state.memberPermissions[
                            MembersGroupPermission.sendMessages] 
                            ??false,
                    onChanged: (value) {
                      context.read<GroupBloc>().add(UpdateMemberPermissionEvent(
                         groupModel: groupModel,
                        pageTypeEnum: pageType??PageTypeEnum.groupDetailsAddPage,
                            permission: MembersGroupPermission.sendMessages,
                            isEnabled: value,
                          ));
                    },
                  ),
                  rootContext: context,
                  isSmallTitle: false,
                  title: "Send messages",
                ),
                kHeight10,
                CommonGradientTileWidget(
                  trailing: Switch(
                    value: state.memberPermissions[
                            MembersGroupPermission.addMembers] ??
                        false,
                    onChanged: (value) {
                      context.read<GroupBloc>().add(UpdateMemberPermissionEvent(
                        groupModel: groupModel,
                        pageTypeEnum: pageType??PageTypeEnum.groupDetailsAddPage,
                            permission: MembersGroupPermission.addMembers,
                            isEnabled: value,
                          ));
                    },
                  ),
                  rootContext: context,
                  isSmallTitle: false,
                  title: "Add members",
                ),
                kHeight20,
                smallGreyMediumBoldTextWidget(
                  text: "Only Admins can:",
                ),
                kHeight10,
                CommonGradientTileWidget(
                  trailing: Switch(
                    value: state.adminPermissions[
                            AdminsGroupPermission.approveMembers] ??
                        false,
                    onChanged: (value) {
                      context.read<GroupBloc>().add(UpdateAdminPermissionEvent(
                         groupModel: groupModel,
                        pageTypeEnum: pageType??PageTypeEnum.groupDetailsAddPage,
                            permission: AdminsGroupPermission.approveMembers,
                            isEnabled: value,
                          ));
                    },
                  ),
                  rootContext: context,
                  isSmallTitle: false,
                  title: "Approve members",
                ),
                kHeight10,
                CommonGradientTileWidget(
                  trailing: Switch(
                    value: state.adminPermissions[
                            AdminsGroupPermission.viewMembers] ??
                        false,
                    onChanged: (value) {
                      context.read<GroupBloc>().add(UpdateAdminPermissionEvent(
                         groupModel: groupModel,
                        pageTypeEnum: pageType??PageTypeEnum.groupDetailsAddPage,
                            permission: AdminsGroupPermission.viewMembers,
                            isEnabled: value,
                          ));
                    },
                  ),
                  rootContext: context,
                  isSmallTitle: false,
                  title: "View members",
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}