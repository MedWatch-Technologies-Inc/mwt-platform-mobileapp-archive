import 'package:flutter/cupertino.dart';
import 'package:health_gauge/screens/Mail/message_detail.dart';

///for object purpose
// class ReplyMailData {
//   final InboxData data;
//   final String userEmail;
//   final int userId;
//   final Function sendMail;
//   final String screenFrom;
//   ReplyMailData(
//       {this.data, this.userEmail, this.userId, this.sendMail, this.screenFrom});
// }

// class MailDetailModel{
//
// }

class MailDetailBlocClassModel extends ChangeNotifier{
  // final state;
  final ReplyMailData replyMailData;

  List<bool> isOpened = [];

  bool showButton = false;
  // int _length;

  MailDetailBlocClassModel(this.replyMailData);

  void updateIsOpened(int index, bool val){
    isOpened[index] = val;
    notifyListeners();
  }

  void updateShowButton(bool val){
    showButton = val;
    notifyListeners();
  }
}