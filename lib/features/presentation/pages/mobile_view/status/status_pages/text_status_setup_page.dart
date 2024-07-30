import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/status_methods.dart';
import 'package:chatbox/features/data/models/status_model/status_model.dart';
import 'package:chatbox/features/presentation/bloc/status/status_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:chatbox/features/presentation/widgets/status/status_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStatusSetupPage extends StatefulWidget {
  const TextStatusSetupPage({
    super.key,
    required this.currentStatusModel,
  });
  final StatusModel? currentStatusModel;

  @override
  State<TextStatusSetupPage> createState() => _TextStatusSetupPageState();
}

class _TextStatusSetupPageState extends State<TextStatusSetupPage> {
  TextEditingController textStatusController = TextEditingController();

  List<Color> availableColors = [
    darkGreyColor,
    darkSwitchColor,
    darkScaffoldColor,
    darkLinearGradientColorTwo,
    kBlack,
    Colors.yellow,
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<StatusBloc, StatusState>(
            builder: (context, state) {
              if (state is StatusErrorState) {
                return Text(state.errorMessage);
              }
              return Container(
                color: state.pickedColorOfStatus,
              );
            },
          ),
          Align(
            alignment: Alignment.center,
            child: TextFieldCommon(
              hintText: "Write something...",
              keyboardType: TextInputType.text,
              maxLines: 30,
              style: TextStyle(fontSize: 28.sp),
              border: InputBorder.none,
              cursorColor: buttonSmallTextColor,
              controller: textStatusController,
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: 40.h,
            right: 30.w,
            child: IconButton(
              onPressed: () {
                context.read<StatusBloc>().add(
                      PickTextStatusBgColor(
                        availableColors: availableColors,
                      ),
                    );
              },
              icon: Icon(
                Icons.color_lens,
                size: 38.sp,
                color: kWhite,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: BlocBuilder<StatusBloc, StatusState>(
        builder: (context, state) {
          return FloatingActionButton(
            backgroundColor: kWhite.withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            onPressed: () async {
              if (textStatusController.text.isNotEmpty) {
                final statusModel = await StatusMethods.newStatusUploadMethod(
                  textStatusBgColor: state.pickedColorOfStatus,
                  statusType: StatusType.text,
                  currentStatusModel: widget.currentStatusModel,
                  statusTextContent: textStatusController.text,
                );
                if (mounted) {
                  context.read<StatusBloc>().add(StatusUploadEvent(statusModel: statusModel));
                }
              }
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: sendIconWidget(),
          );
        },
      ),
    );
  }
}
