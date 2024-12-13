import 'package:flutter/material.dart';
import 'package:health_gauge/screens/chat/models/access_group_chat_history_model.dart';

class GroupChatConversationModel with ChangeNotifier{
  List<GroupChatMessageData> messageList = [];
  bool isLoading = false;
  bool isErrorState = false;

  List<String> messages = [];

  void addChatConversation(GroupChatMessageData data){
    messageList.add(data);
    notifyListeners();
  }

  void addConversationList(List<GroupChatMessageData> data){
    messageList.addAll(data);
    notifyListeners();
  }

  void addConversationInFront(List<GroupChatMessageData> data){
    messageList = [...data, ...messageList];
    notifyListeners();
  }

  void clearMessageList(){
    messageList = [];
    notifyListeners();
  }

  void removeChatAt(int index) {
    messageList.removeAt(index);
    notifyListeners();
  }

  void changeIsLoading(bool v){
    isLoading = v;
    notifyListeners();
  }
  void changeIsError(bool e){
    isErrorState = e;
    notifyListeners();
  }

  void addMessages(String m){
    messages.add(m);
    notifyListeners();
  }

  void clearMessages(){
    messages = [];
    notifyListeners();
  }
}