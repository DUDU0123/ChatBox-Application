import 'package:chatbox/config/theme/theme_manager.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/emoji_select.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ChatBarWidget extends StatefulWidget {
   ChatBarWidget({
    super.key,
    required this.messageController, required this.isImojiButtonClicked,
  });
  final TextEditingController messageController;
  bool isImojiButtonClicked;

  @override
  State<ChatBarWidget> createState() => _ChatBarWidgetState();
}

class _ChatBarWidgetState extends State<ChatBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
      decoration: BoxDecoration(
        color: kTransparent,
        image: DecorationImage(
            image: AssetImage(Provider.of<ThemeManager>(context).isDark
                ? bgImageDark
                : bgImageLight),
            fit: BoxFit.cover),
      ),
      width: screenWidth(context: context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 0.w, right: 5.w),
                  width: screenWidth(context: context) / 1.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.sp),
                    color: const Color.fromARGB(255, 39, 52, 78),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                         setState(() {
                            widget.isImojiButtonClicked = !widget.isImojiButtonClicked;
                         });
                        },
                        icon: SvgPicture.asset(
                          width: 25.w,
                          height: 25.h,
                          colorFilter:
                              ColorFilter.mode(iconGreyColor, BlendMode.srcIn),
                          smileIcon,
                        ),
                      ),
                      Expanded(
                        child: TextFieldCommon(
                          style: fieldStyle(context: context).copyWith(
                            fontWeight: FontWeight.w400,
                            color: kWhite,
                          ),
                          hintText: "Type message...",
                          maxLines: 5,
                          
                          controller: widget.messageController,
                          textAlign: TextAlign.start,
                          border: InputBorder.none,
                          cursorColor: buttonSmallTextColor,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              
                            },
                            icon: Icon(
                              Icons.attach_file,
                              color: iconGreyColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              width: 25.w,
                              height: 25.h,
                              colorFilter:
                                  ColorFilter.mode(iconGreyColor, BlendMode.srcIn),
                              cameraIcon,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                kWidth2,
                Expanded(
                  child: Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: buttonSmallTextColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: IconButton(
                      onPressed: () {
                        // voice record functionationality if user try to record voice
            
                        // send message functionality if user try to send message
                      },
                      icon: SvgPicture.asset(
                          width: 24.w,
                          height: 24.h,
                          colorFilter: ColorFilter.mode(kBlack, BlendMode.srcIn),
                          // messageController.text.isEmpty
                          // ?
                          microphoneFilled
                          // : sendIcon,
                          ),
                    )),
                  ),
                )
              ],
            ),
          ),
          widget.isImojiButtonClicked? emojiSelect(textEditingController: widget.messageController):zeroMeasureWidget,
        ],
      ),
    );
  }
}
