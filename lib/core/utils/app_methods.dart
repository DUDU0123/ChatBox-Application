import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppMethods{
  static Widget emojiSelect({required TextEditingController textEditingController}){
    return EmojiPicker(
      
    onEmojiSelected: (category, emoji) {
      
    },
    onBackspacePressed: () {
        // Do something when the user taps the backspace button (optional)
        // Set it to null to hide the Backspace-Button
    },
    textEditingController: textEditingController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
    config: Config(

        height: 256,
        checkPlatformCompatibility: true,
        swapCategoryAndBottomBar:  false,
        skinToneConfig: const SkinToneConfig(),
        categoryViewConfig: const CategoryViewConfig(),
        bottomActionBarConfig: const BottomActionBarConfig(),
        searchViewConfig: const SearchViewConfig(),
    ),
);
  }
}