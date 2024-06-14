import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIconHoldWidget extends StatelessWidget {
  const AppIconHoldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.sp),
        boxShadow: const [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 1,
            spreadRadius: 1,
            color: Color.fromARGB(255, 5, 4, 11)
          ),
          BoxShadow(
            offset: Offset(0, -1),
            blurRadius: 1,
            spreadRadius: 1,
            color: Color.fromARGB(255, 5, 4, 11)
          )
        ]
      ),
      height: 150,width: 150,
      child: SvgPicture.asset(
        "assets/appIconSvg.svg",
        fit: BoxFit.cover,
      ),
    );
  }
}