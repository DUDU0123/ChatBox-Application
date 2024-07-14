import 'dart:developer';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class LocationPickPage extends StatelessWidget {
  const LocationPickPage({super.key, required this.chatModel});
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Pick Location"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<MessageBloc, MessageState>(builder: (contex, state) {
            if (state is MessageErrorState) {
              return commonErrorWidget(message: state.message);
            }
            if (state is CurrentLocationState) {
              log("Current Location: ${state.currentLocation}");
              log("Current Location: ${state.latitude}, ${state.longitude}");
              String locationUrl =
                  'https://www.google.com/maps/search/?api=1&query=${state.latitude},${state.longitude}';
              context.read<MessageBloc>().add(
                    LocationMessageSendEvent(
                      chatModel: chatModel,
                      location: locationUrl,
                    ),
                  );
              return SizedBox(
                width: screenWidth(context: context),
                height: screenHeight(context: context) / 2,
                // child: GoogleMap(
                //   initialCameraPosition:  CameraPosition(
                //     target:state.currentLocation,
                //     zoom: 20,
                //   ),
                //   myLocationEnabled: true,
                //   myLocationButtonEnabled: true,
                //   onMapCreated: (GoogleMapController controller) {
                //     // Additional configuration if needed
                //   },
                // ),
              );
            }
            return zeroMeasureWidget;
          }),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: buttonSmallTextColor.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp))),
              onPressed: () {
                context.read<MessageBloc>().add(LocationPickEvent());
              },
              child: TextWidgetCommon(
                text: "Send your current location",
                fontSize: 18.sp,
                textColor: kWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
