import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_listtile_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: ,
        title: TextFieldCommon(
          keyboardType: TextInputType.name,
          hintText: "Search chat...",
          style: fieldStyle(context: context)
              .copyWith(fontWeight: FontWeight.normal),
          controller: searchController,
          textAlign: TextAlign.start,
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: kTransparent,
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ChatListTileWidget(userName: "User", isGroup: false);
        },
        separatorBuilder: (context, index) => kHeight5,
        itemCount: 10,
      ),
    );
  }
}
