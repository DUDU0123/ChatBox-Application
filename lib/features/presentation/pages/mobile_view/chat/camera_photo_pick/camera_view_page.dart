import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/utils/image_picker_method.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/camera_photo_pick/asset_loaded_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({super.key});

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  CameraController cameraController =
      CameraController(cameras[0], ResolutionPreset.high);
  late Future<void> cameraValue;
  @override
  void initState() {
    cameraValue = cameraController.initialize();
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder(
                future: cameraValue,
                builder: (context, snapshot) {
                  return CameraPreview(cameraController);
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: kWhite,
                    size: 30.sp,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.flash_off,
                    color: kWhite,
                    size: 30.sp,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 10.w, right: 10.w, bottom: 20.h, top: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        // final file =
                        //     await pickImage(imageSource: ImageSource.gallery);
                        
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => AssetLoadedPage(),
                        //         settings: RouteSettings(arguments: file)));
                      },
                      icon: Icon(
                        Icons.photo_outlined,
                        color: kWhite,
                        size: 30.sp,
                      ),
                    ),
                    GestureDetector(
                      onLongPress: () {
                        log("Video record started");
                      },
                      onLongPressUp: () {
                        log("Video Taken");
                      },
                      onTap: () async {
                        log("Photo taken");
                      },
                      child: Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          // color: kWhite,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: kWhite,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.flip_camera_android,
                        color: kWhite,
                        size: 30.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: TextWidgetCommon(
                  text: "Hold for video, tap for photo",
                  fontSize: 9.sp,
                  textColor: kWhite,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
