import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';

class RecieverProfilePart extends StatelessWidget {
  const RecieverProfilePart({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [

              ],
            ),
            Row(
              children: [

              ],
            ),
            Column(
              children: [
                TextWidgetCommon(text: "About"),
              ],
            ),
            ListTile(),
            
          ],
        ),
      ),
    );
  }
}