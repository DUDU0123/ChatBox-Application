import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
// function for sorting the contact list to find the chatbox users and to show them first to the list
void sortContactsToShowChatBoxUsersFirst({
  required List<ContactModel> contactList,
}) {
  return contactList.sort(
    (a, b) {
      if (a.isChatBoxUser! && !b.isChatBoxUser!) {
        return -1; // a comes before b
      } else if (!a.isChatBoxUser! && b.isChatBoxUser!) {
        return 1; // b comes before a
      } else {
        return 0; // a and b are equivalent
      }
    },
  );
}
