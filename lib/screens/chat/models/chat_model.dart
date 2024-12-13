import 'package:health_gauge/screens/chat/models/contact_model.dart';

class ChatModel {
  final bool? isTyping;
  final String? lastMessage;
  final String? lastMessageTime;
  final String? profile_picture;
  final ContactModel? contact;

  ChatModel(
      {this.isTyping,
      this.lastMessage,
      this.lastMessageTime,
      this.profile_picture,
      this.contact});
}
