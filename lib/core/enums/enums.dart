enum PageTypeEnum {
  chatHome,
  chatStatus,
  chatGroup,
  chatCalls,
  settingsPage,
  groupMessageInsidePage,
  oneToOneChatInsidePage,
  broadCastMessageInsidePage,
  groupSettingsPage,
  broadCastSettingsPage,
  settingEditProfilePage,
  accountSetting,
  privacySetting,
  chatSetting,
  notificationsSetting,
  storageSetting,
  helpSetting,
  inviteButton,
  none,
}

enum FieldTypeSettings {
  name,
  about,
}

enum MessageStatus {
  sent,
  delivered,
  read,
  notDelivered,
  none,
}

enum MessageType {
  text,
  photo,
  audio,
  video,
  document,
  location,
  contact,
  none,
}

extension Converter on String{
  MessageType toEnum (){
    switch (this) {
      case 'text':
        return MessageType.text;
      case 'audio':
        return MessageType.audio;
      case 'video':
        return MessageType.video;
      case 'photo':
        return MessageType.photo;
      case 'document':
        return MessageType.document;
      case 'location':
        return MessageType.location;
      case 'contact':
        return MessageType.contact;
      default:
        return MessageType.text;
    }
  }
}