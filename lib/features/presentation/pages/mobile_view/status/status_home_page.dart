import 'dart:developer';
import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/core/utils/snackbar.dart';
import 'package:chatbox/features/data/models/status_model/status_model.dart';
import 'package:chatbox/features/presentation/bloc/status/status_bloc.dart';
import 'package:chatbox/features/presentation/widgets/status/status_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class StatusHomePage extends StatefulWidget {
  const StatusHomePage({super.key});

  @override
  State<StatusHomePage> createState() => _StatusHomePageState();
}

class _StatusHomePageState extends State<StatusHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StatusBloc, StatusState>(
        listener: (context, state) {
          if (state is StatusErrorState) {
            commonSnackBarWidget(
              context: context,
              contentText: state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is StatusLoadingState) {
            return commonAnimationWidget(context: context, isTextNeeded: false);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              StreamBuilder<StatusModel?>(
                stream: CommonDBFunctions.getCurrentUserStatus(),
                builder: (context, snapshot) {
                  return statusTileWidget(
                    isCurrentUser: true,
                    statusModel: snapshot.data,
                    context: context,
                  );
                }
              ),
              kHeight15,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: smallGreyMediumBoldTextWidget(text: "Recent updates"),
              ),
              kHeight15,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: smallGreyMediumBoldTextWidget(text: "Viewed updates"),
              ),
              Expanded(
                child: StreamBuilder<List<StatusModel>?>(
                    stream: state.statusList,
                    builder: (context, snapshot) {
                      log(snapshot.data.toString());
                      if (snapshot.data == null || snapshot.hasError) {
                        return commonErrorWidget(
                            message:
                                "No data ${snapshot.error} ${snapshot.stackTrace}");
                      }
                      if (snapshot.data!.isEmpty) {
                        return emptyShowWidget(
                            context: context, text: "No status");
                      }
                      return ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final status = snapshot.data![index];
                          return statusTileWidget(
                            isCurrentUser: false,
                            context: context,
                            statusModel: status,
                          );
                        },
                      );
                    }),
              )
            ],
          );
        },
      ),
    );
  }
}
