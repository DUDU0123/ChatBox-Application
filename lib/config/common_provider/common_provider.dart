import 'package:flutter/material.dart';

class CommonProvider extends ChangeNotifier {
  bool isExpanded = false;
  bool isEmptyList = false;
  Set<String> expandedMessages = {};
  void changeIsEmpty(){
    isEmptyList = !isEmptyList;
    notifyListeners();
  }
  void changeExpanded() {
    isExpanded = !isExpanded;
    notifyListeners();
  }
  void toggleExpand({required String messageID}){
    if (expandedMessages.contains(messageID)) {
      expandedMessages.remove(messageID);
    }else{
      expandedMessages.add(messageID);
    }
    notifyListeners();
  }
  bool isExpandedMessage(String messageId) {
    return expandedMessages.contains(messageId);
  }
  void restartApp() {
    notifyListeners();
  }
}