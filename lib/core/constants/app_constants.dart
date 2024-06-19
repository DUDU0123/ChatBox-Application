import 'package:chatbox/core/constants/colors.dart';
import 'package:flutter/material.dart';

class AttachmentModel {
  final Color colorOne;
  final Color colorTwo;
  final String icon;
  AttachmentModel({
    required this.colorOne,
    required this.colorTwo,
    required this.icon,
  });
}


class SettingsHomeButtonModel {
  final String title;
  final String subtitle;
  final String icon;
  SettingsHomeButtonModel({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

List<SettingsHomeButtonModel> settingsButtonsList = [
  SettingsHomeButtonModel(title: "Account", subtitle: "Delete account", icon: keyIcon),
  SettingsHomeButtonModel(title: "Privacy", subtitle: "Profile photo", icon: privacyIcon),
  SettingsHomeButtonModel(title: "Chats", subtitle: "Theme, wallpaper", icon: chatsIcon),
  SettingsHomeButtonModel(title: "Notifications", subtitle: "Message, call tones", icon: notificationIcon),
  SettingsHomeButtonModel(title: "Storage", subtitle: "Manage storage", icon: storageIcon),
  SettingsHomeButtonModel(title: "Help", subtitle: "Help center, contact us", icon: helpIcon),
  SettingsHomeButtonModel(title: "Invite a friend", subtitle: "", icon: inviteIcon),
];

List<AttachmentModel> attachmentIcons = [
  AttachmentModel(
    colorOne: documentColorOne,
    colorTwo: documentColorTwo,
    icon: document,
  ),
  AttachmentModel(
    colorOne: cameraColorOne,
    colorTwo: cameraColorTwo,
    icon: cameraIcon,
  ),
  AttachmentModel(
    colorOne: galleryColorOne,
    colorTwo: galleryColorTwo,
    icon: gallery,
  ),
  AttachmentModel(
    colorOne: audioColorOne,
    colorTwo: audioColorTwo,
    icon: headphone,
  ),
  AttachmentModel(
    colorOne: locationColorOne,
    colorTwo: locationColorTwo,
    icon: location,
  ),
  AttachmentModel(
    colorOne: contactColorOne,
    colorTwo: contactColorTwo,
    icon: contact,
  ),
];
