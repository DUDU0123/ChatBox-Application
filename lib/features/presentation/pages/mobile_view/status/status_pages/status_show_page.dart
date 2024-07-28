import 'package:chatbox/features/data/models/status_model/status_model.dart';
import 'package:chatbox/features/presentation/widgets/status/build_status_item_widget.dart';
import 'package:chatbox/features/presentation/widgets/status/status_appbar.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StatusShowPage extends StatelessWidget {
  StatusShowPage({super.key, required this.statusModel});
  final StatusModel statusModel;
  final StoryController controller = StoryController();
  final ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StoryView(
            onComplete: () {
              Navigator.pop(context);
            },
            onVerticalSwipeComplete: (p0) {
              Navigator.pop(context);
            },
            onStoryShow: (s, i) {
              currentIndexNotifier.value = i;
            },
            storyItems: buildStatusItems(
                controller: controller, statusModel: statusModel, context: context,),
            controller: controller,
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<int>(
              valueListenable: currentIndexNotifier,
              builder: (context, currentIndex, _) {
                return statusAppBar(
                  userName: statusModel.statusUploaderName ?? '',
                  howHours:
                      statusModel.statusList![currentIndex].statusUploadedTime ??
                          '',
                  deleteMethod: () {},
                  shareMethod: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }


}