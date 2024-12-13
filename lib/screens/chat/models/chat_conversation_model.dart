import 'package:flutter/material.dart';
import 'package:health_gauge/screens/chat/models/access_history_with_two_user_model.dart';

class ChatConversationModel with ChangeNotifier {
  List<ChatMessageData> messageList = [];
  bool isLoading = false;
  bool isErrorState = false;

  List<String> messages = [];

  void addChatConversation(ChatMessageData data) {
    messageList.add(data);
    notifyListeners();
  }

  void addConversationList(List<ChatMessageData>? data) {
    messageList.addAll(data!);
    notifyListeners();
  }

  void addConversationInFront(List<ChatMessageData> data) {
    messageList = [...data, ...messageList];
    notifyListeners();
  }

  void clearMessageList() {
    messageList = [];
    notifyListeners();
  }

  void removeChatAt(int index) {
    messageList.removeAt(index);
    notifyListeners();
  }

  void changeIsLoading(bool v) {
    isLoading = v;
    notifyListeners();
  }

  void changeIsError(bool e) {
    isErrorState = e;
    notifyListeners();
  }

  void addMessages(String m) {
    messages.add(m);
    notifyListeners();
  }

  void clearMessages() {
    messages = [];
    notifyListeners();
  }
}
