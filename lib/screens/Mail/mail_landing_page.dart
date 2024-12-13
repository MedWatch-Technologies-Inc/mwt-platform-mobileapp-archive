// import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/RepositoryDB/email_data.dart';
import 'package:health_gauge/data_generator.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';
import 'package:health_gauge/screens/Mail/draft_listing.dart';
import 'package:health_gauge/screens/inbox/inbox_bloc.dart';
import 'package:health_gauge/screens/inbox/inbox_events.dart';
import 'package:health_gauge/screens/inbox/inbox_states.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/drawer_items.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_floating_action_button.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Contacts/contacts_screen.dart';
import 'compose_mail.dart';
import 'listing.dart';
import 'message_detail.dart';
import 'outbox_listing.dart';
import 'search_result.dart';

/// Added by: Akhil
/// Added on: June/04/2020
/// This is the landing page for the email feature
class MailLandingPage extends StatefulWidget {
  final int userId; //user Id from dashboard
  final String userEmail; // user id from dashboard
  MailLandingPage(this.userId, this.userEmail);

  @override
  _MailLandingPageState createState() => _MailLandingPageState();
}

/// Added by: Akhil
/// Added on: June/04/2020
/// This class maintains state for mail landing page
class _MailLandingPageState extends State<MailLandingPage> {
  bool? isSearchOpen; //to check if search box is open or not
  String? currentScreen; //to maintain current screen value
  InboxBloc? inboxBloc; //bloc declaration
  List<InboxData> emailList =
  <InboxData>[]; //list to temporarily store database and api data
  SharedPreferences? sharedPreferences;
  final dbHelper = DatabaseHelper.instance; //Database initialzation
  int messageType =
  1; //To maintain which type of message to be shown at main screen
  late ScrollController _controller;
  late TextEditingController _searchController; //controller for text feild
  int startCount = 1; //start count for pagination
  int endCount = 20; //page size
  InboxData lastLocalMail = InboxData();
  bool isFirst =
  true; //to maintain api must only be hit only one time after state is created
  EmailData? emailData; // local database function repository
  DataGenerator dataGenerator = DataGenerator();
  List<int> mailAddFeature = [
    1,
    2,
    3
  ]; //this list stored the 1>inbox, 2>sent, 3>trash
  int? currentfeatureIndex;
  String value = StringLocalization.kInbox;

  // to store no of mails for each mail type.
  int noOfInboxMail = 0;
  int noOfSentMail = 0;
  int noOfTrashMail = 0;
  int noOfDraftMail = 0;
  int noOfOutboxMail = 0;
  final draftsRepo = EmailData();
  List<InboxData> draftMailList = [];
  List<InboxData> outBoxMailList = [];
  bool isDoingSomething = false;

  // draftId
  int? gDraftId;

  /// Added by: Akhil
  /// Added on: June/04/2020
  ///method for deleting message from the list
  ///@param- index : index of item to be deleted , messageId : messageId of item to be deleted
  void removeItemFromList(int index, int messageId) async {
    print("--------------${emailList[index].messageID}------------------");
    print(emailList[index].messageType);
    if (emailList[index].messageType == 1 ||
        emailList[index].messageType == 2) {
      emailList[index].messageType = 3;
      emailList[index].isSync = 0;
      Map<String, dynamic> data = emailList[index]
          .toJsonToInsertInDb(emailList[index].isViewed ?? false ? 1 : 0, 1);
      dbHelper.updateMessageTypeForEmail(data, messageId);
      inboxBloc?.add(DeleteMessageEvent(
          messageId: messageId,
          lastInboxMessageId: data["LastInboxMessageID"]));
      setState(() {
        emailList.removeAt(index);
        print('Email List Size : ${emailList.length}');
      });
    } else {
      isDoingSomething = true;
      inboxBloc?.add(MultipleTrashMessageDeleteEvent(
          messageIds: [emailList[index].lastInboxMessageID!]));
      dbHelper.deleteEmailRowFromMessageId(messageId);
      setState(() {
        emailList.removeAt(index);
      });
    }
  }

  /// Added by: Akhil
  /// Added on: Aug/19/2020
  /// Method to call send api and save message to outbox if internet is unavailable.
  /// @param inboxData : data of mail to be sent.
  void sendMail(InboxData inboxData, [draftId]) async {
    // can add draftId
    // print(inboxData.messageSubject);
    // print(inboxData.msgResponseTypeID);
    print("coming here from contact list");
    //print(emailList);

    if (draftId != null) {
      gDraftId = draftId;
      print(gDraftId);
    }

    bool isInternetAvailable = await Constants.isInternetAvailable();
    print('---------------------');
    if (isInternetAvailable) {
      if (inboxData.msgResponseTypeID == 0) {
        inboxBloc?.add(SendMessageEvent(
          messageFrom: widget.userEmail,
          messageBody: inboxData.messageBody,
          messageCc: inboxData.messageCc,
          messageTo: inboxData.messageTo,
          messageSubject: inboxData.messageSubject,
          userFile: inboxData.userFile ?? '',
          fileExtension: inboxData.fileExtension ?? '',
          requestType: inboxData.requestType,
        ));
      } else {
        inboxBloc?.add(SendResponseMessageEvent(
          messageFrom: widget.userEmail,
          messageBody: inboxData.messageBody,
          messageCc: inboxData.messageCc,
          messageTo: inboxData.messageTo,
          messageSubject: inboxData.messageSubject,
          userFile: inboxData.userFile ?? '',
          fileExtension: inboxData.fileExtension ?? '',
          messageId: inboxData.messageID,
          messageResponseTypeId: inboxData.msgResponseTypeID ?? -1,
          parentGUIID: inboxData.parentGUIID,
        ));
      }
    } else {
      InboxData data = InboxData(
          messageFrom: widget.userEmail,
          messageBody: inboxData.messageBody,
          messageCc: inboxData.messageCc,
          messageTo: inboxData.messageTo,
          messageSubject: inboxData.messageSubject,
          userFile: inboxData.userFile,
          fileExtension: inboxData.fileExtension,
          messageID: inboxData.messageID,
          // createdDateTime: DateTime.now().toString(),
          createdDateTime: '/Date(${DateTime.now().millisecondsSinceEpoch})',
          isSync: 0,
          userId: widget.userId,
          messageType: 5,
          requestType: "api",
          msgResponseTypeID: inboxData.msgResponseTypeID);
      await emailData?.insertOutbox(data);
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text('Message saved to Outbox'),
      // ));

      CustomSnackBar.buildSnackbar(
          context,
          StringLocalization.of(context)
              .getText(StringLocalization.emailSavedInOutbox),
          3);
    }
  }

  /// Added by: Akhil
  /// Added on: June/04/2020
  /// method to delete multiple messages simultaneously
  /// @param removeList : list of items to be removed
  void deleteMultipleMessage(List<InboxData> removeList) async {
    List<int> messageIds = [];
    // setState(() async {
    if (removeList[0].messageType == 1 || removeList[0].messageType == 2) {
      for (var mail in removeList) {
        emailList.remove(mail);
        // made change from messageId to lastInboxmessageID for deleting purpose
        messageIds.add(mail.lastInboxMessageID!);
        mail.messageType = 3;
        mail.isSync = 0;
        await dbHelper.updateMessageTypeForEmail(
            mail.toJsonToInsertInDb(mail.isViewed ?? false ? 1 : 0,
                mail.isDeleted ?? false ? 1 : 0),
            mail.messageID!);
      }
      inboxBloc?.add(MultipleMessageDeleteEvent(messageIds: messageIds));
    } else {
      for (var mail in removeList) {
        emailList.remove(mail);
        messageIds.add(mail.messageID!);
        mail.messageType = 0;
        await dbHelper.updateMessageTypeForEmail(
            mail.toJsonToInsertInDb(mail.isViewed ?? false ? 1 : 0,
                mail.isDeleted ?? false ? 1 : 0),
            mail.messageID!);
        await dbHelper.deleteEmailRowFromMessageId(mail.messageID!);
      }
      inboxBloc?.add(MultipleTrashMessageDeleteEvent(messageIds: messageIds));
    }
    // });
    setState(() {});
  }

  /// Added by: Akhil
  /// Added on: June/04/2020
  ///method to view detail of mail from listing
  ///@param messageID : messageID of email , subject : subject of mail , data : data of mail whose detail is to be seen.
  void openMail(int messageId, String subject, InboxData data) {
    print(data.messageID);
    if (!(data.isViewed ?? true)) {
      data.isViewed = true;
      dbHelper.updateMessageTypeForEmail(
          data.toJsonToInsertInDb(1, data.isDeleted ?? false ? 1 : 0),
          data.messageID!);
      inboxBloc?.add(MarkReadEvent(id: data.lastInboxMessageID));
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MailDetail(
          data: data,
          userEmail: widget.userEmail,
          userId: widget.userId,
          sendMail: sendMail,
          screenFrom: currentScreen!,
        ),
      ),
    ).then((value) {
      if (value != null && value) {
        print("value : $value");
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content:
        //   Text('Email deleted successfully',textAlign: TextAlign.center, style: TextStyle(color:Colors.green,),),
        // ));
        int? index;
        for (int i = 0; i < emailList.length; i++) {
          if (emailList[i].messageID == messageId) {
            index = i;
            break;
          }
        }
        if (index != null) removeItemFromList(index, messageId);
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //     StringLocalization.of(context)
        //         .getText(StringLocalization.emailDeletedSuccessfully),
        //     style: TextStyle(color: Colors.green),
        //     textAlign: TextAlign.center,
        //   ),
        // ));
        CustomSnackBar.buildSnackbar(
            context,
            StringLocalization.of(context)
                .getText(StringLocalization.emailDeletedSuccessfully),
            3);
      }
    });
  }

  /// Added by: Akhil
  /// Added on: June/04/2020
  ///method to restore mail from trash
  ///@param data : data of mail which is to be restored , index : index of mail in emailList which is to be restored.
  void restoreMail(InboxData data, int index) {
    data.messageFrom == widget.userEmail
        ? data.messageType = 2
        : data.messageType = 1;
    data.isSync = 0;
    dbHelper.updateMessageTypeForEmail(
        data.toJsonToInsertInDb(data.isViewed ?? false ? 1 : 0, 0),
        data.messageID!);
    setState(() {
      emailList.removeAt(index);
    });
    inboxBloc?.add(
        MessageRestoreEvent(messageId: data.messageID, userId: widget.userId));
  }

  /// Added by: Akhil
  /// Added on: June/04/2020
  ///method to delete drafts
  ///@param id : primary key of local database , index: index of draft mail to be deleted
  void deleteDrafts(int id, int index) {
    inboxBloc?.add(DeleteDrafts(id: id));
    emailList.removeAt(index);
  }

  /// Added by: Akhil
  /// Added on: June/04/2020
  ///method to open drafts
  ///@param index : index of draft in emailList whose detail is to be seen.
  void openDrafts(int index) {
    print(emailList[index].id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposeMail(
          // can add parameter draftID draftID: emailList[index].id,
            subject: emailList[index].messageSubject,
            to: emailList[index].messageTo,
            body: emailList[index].messageBody,
            cc: emailList[index].messageCc,
            data: emailList[index],
            userEmail: widget.userEmail,
            userId: widget.userId,
            // added line sendMail : sendMail
            sendMail: sendMail,
            // change
            draftId: emailList[index].id),
      ),
    ).then((value) => inboxBloc?.add(GetDraftsList(
      userId: widget.userId,
    )));
    print("-----------after navigator ---------------");
  }

  /// Added by: Akhil
  /// Added on: June/04/2020
  ///method to delete outbox mail
  ///@param id : primary key of local database, index: index of mail in emailList which is to be deleted.
  void deleteOutbox(int id, int index) {
    inboxBloc?.add(DeleteDrafts(id: id));
    print("hello deleteOutbox");
    emailList.removeAt(index);
  }

  /// Added by: Akhil
  /// Added on: June/04/2020
  ///method to openOutbox
  ///@param index : index of outbox mail in emailList whose detail is to be seen.
  void openOutbox(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MailDetail(
              data: emailList[index],
              userId: widget.userId,
              userEmail: widget.userEmail,
              screenFrom: currentScreen!,
            ))).then((value) {
      if (value != null && value) {
        deleteOutbox(emailList[index].id!, index);
      }
    });
  }

  /// Added by: Akhil
  /// Added on: Aug/28/2020
  ///method to mark messages as read
  void markAsRead() async {
    bool isInternetAvailable = await Constants.isInternetAvailable();
    if (isInternetAvailable) {
      setState(() {
        if (emailList.length > 0) {
          emailList.forEach((item) {
            dbHelper.updateMarkAsRead(item.isViewedSync!);
            item.isViewed = true;
            item.isViewedSync = 0;
          });
        }
        inboxBloc?.add(MarkAsReadAllListEvent(
            userID: widget.userId, messageTypeid: currentfeatureIndex!));
      });
    } else {
      setState(() {
        if (emailList.length > 0) {
          emailList.forEach((item) {
            item.isViewed = true;
            item.isViewedSync = 0;
          });
        }
      });
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text('Mails marked as read'),
      // ));

      CustomSnackBar.buildSnackbar(context, 'Mails marked as read', 3);
    }
  }

  /// Added by: Akhil
  /// Added on: Aug/20/2020
  /// this dialog Ask user before Deleting the all messages
  Widget dialog() => Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 0,
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? HexColor.fromHex("#111B1A")
        : AppColor.backgroundColor,
    child: Container(
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex("#111B1A")
              : AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                  : HexColor.fromHex("#DDE3E3").withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(-5, -5),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#000000").withOpacity(0.75)
                  : HexColor.fromHex("#384341").withOpacity(0.9),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(5, 5),
            ),
          ]),
      padding: EdgeInsets.only(
        top: 33,
        left: 26,
      ),
      height: 128,
      width: 309,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
            child: Body1AutoText(
              text: StringLocalization.of(context)
                  .getText(StringLocalization.areYouReadyToEmptyYourTrash),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                  : HexColor.fromHex("#384341"),
              maxLine: 1,
              minFontSize: 8,
            ),
            // child: FittedTitleText(
            //   text: 'Are you ready to empty the trash?',
            //   fontSize: 16,
            //   fontWeight: FontWeight.w600,
            //   color: Theme.of(context).brightness == Brightness.dark
            //       ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
            //       : HexColor.fromHex("#384341"),
            //   // maxLine: 1,
            // ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end,
              //mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  key: Key('trashDialgoOk'),
                  child: SizedBox(
                    height: 25,
                    child: Body1AutoText(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.ok),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: HexColor.fromHex("#00AFAA"),
                      maxLine: 1,
                      minFontSize: 8,
                    ),
                    // child: FittedTitleText(
                    //   text: StringLocalization.of(context)
                    //       .getText(StringLocalization.ok),
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.bold,
                    //   color: HexColor.fromHex("#00AFAA"),
                    //   // maxLine: 1,
                    // ),
                  ),
                  onPressed: () async {
                    bool isInternetAvailable =
                    await Constants.isInternetAvailable();
                    emailList.removeRange(0, emailList.length);
                    await dbHelper.updateMessageTypeForAllEmail(
                        3); //set Email messageType 0
                    if (isInternetAvailable) {
                      print("going for api hit");
                      inboxBloc
                          ?.add(EmptyTrashListEvent(userID: widget.userId));
                    } else {
                      // Scaffold.of(context).showSnackBar(SnackBar(
                      //   content:
                      //       Text('Message deleted from Trash Successfully'),
                      // ));

                      CustomSnackBar.buildSnackbar(
                          context,
                          StringLocalization.of(context).getText(
                              StringLocalization
                                  .messageDeletedFromTrashSuccessfully),
                          3);
                      setState(() {});
                    }
                    if (context != null) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                ),
                TextButton(
                  key: Key('trashDialogCancel'),
                  child: SizedBox(
                    height: 25,
                    child: Body1AutoText(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.cancel),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: HexColor.fromHex("#00AFAA"),
                      minFontSize: 8,
                      maxLine: 1,
                    ),
                    // child: FittedTitleText(
                    //   text: "Cancel",
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.bold,
                    //   color: HexColor.fromHex("#00AFAA"),
                    //   // maxLine: 1
                    // ),
                  ),
                  onPressed: () async {
                    if (context != null) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                ),
                //SizedBox(width: 42,),

              ])
        ],
      ),
    ),
  );

  /// Added by: Akhil
  /// Added on: June/04/2020
  /// in this function we are initializing all the variables and objects that are needed in widgets
  @override
  void initState() {
    dbHelper.database;
    super.initState();
    isSearchOpen = false; //set text field visibility to false
    currentfeatureIndex = 1; //set the current page index i.e Inbox
    currentScreen =
        StringLocalization.kInbox; //set current screen vale to inbox
    _controller = ScrollController();
    _searchController = TextEditingController();
    emailData = EmailData();
  }

  /// Added by: Akhil
  /// Added on: June/04/2020
  /// Lifecycle method of stateful widget
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //to call api for first time after state is created

    if (isFirst) {
      inboxBloc = BlocProvider.of<InboxBloc>(context);
      currentScreen = StringLocalization.kInbox;
      inboxBloc?.add(GetListEvent(
          userID: widget.userId,
          pageSize: 20,
          pageNumber: 1,
          messageTypeid: messageType));
      isFirst = false;
    }
  }

  /// Added by: Akhil
  /// Added on: June/04/2020
  /// this method is also lifecycle method of stateful widget
  @override
  void dispose() {
    super.dispose();
    inboxBloc?.add(DisposeEvent());
  }

  Widget emptyContainer() {
    String text = '';
    if (currentScreen == StringLocalization.kSent) {
      text = StringLocalization.of(context)
          .getText(StringLocalization.sentIsEmpty);
    } else if (currentScreen == StringLocalization.kDrafts) {
      text = StringLocalization.of(context)
          .getText(StringLocalization.draftIsEmpty);
    } else if (currentScreen == StringLocalization.kInbox) {
      text = StringLocalization.of(context)
          .getText(StringLocalization.inboxIsEmpty);
    } else if (currentScreen == StringLocalization.kTrash) {
      text = StringLocalization.of(context)
          .getText(StringLocalization.trashIsEmpty);
    } else if (currentScreen == StringLocalization.kOutBox) {
      text = StringLocalization.of(context)
          .getText(StringLocalization.outboxIsEmpty);
    }
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          text,
        ),
      ),
    );
  }

  /// Added by: Akhil
  /// Added on: June/04/2020
  /// this method is responsible for building UI
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.5)
                  : HexColor.fromHex("#384341").withOpacity(0.2),
              offset: Offset(0, 2.0),
              blurRadius: 4.0,
            )
          ]),
          child: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            //set value for title of appbar
            leading: IconButton(
              key: Key('mailBackButton'),
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Image.asset(
                "asset/dark_leftArrow.png",
                width: 13,
                height: 22,
              )
                  : Image.asset(
                "asset/leftArrow.png",
                width: 13,
                height: 22,
              ),
            ),
            title: Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    key: Key('contactIcon'),
                    padding: EdgeInsets.only(right: 10),
                    icon: Theme.of(context).brightness == Brightness.dark
                        ? Image.asset(
                      "asset/dark_contacts.png",
                      width: 33,
                      height: 33,
                    )
                        : Image.asset(
                      "asset/contacts.png",
                      width: 33,
                      height: 33,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Contacts(
                            userId: widget.userId,
                            // sendMail: sendMail,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Body1AutoText(
                      text: StringLocalization.of(context)
                          .getText(currentScreen!),
                      color: HexColor.fromHex("62CBC9"),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      align: TextAlign.center,
                    ),
                    // child: FittedTitleText(
                    //   text: StringLocalization.of(context)
                    //       .getText(currentScreen),
                    //   color: HexColor.fromHex("62CBC9"),
                    //   fontSize: 18,
                    //   fontWeight: FontWeight.bold,
                    //   align: TextAlign.center,
                    // ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              ///Added by Akhil
              ///Added on Aug/20/2020
              ///hit api for markAsReadByMessageID or emptyTrashMessage
//          currentfeatureIndex == mailAddFeature[0]
//              ? IconButton(
//                  icon: Icon(Icons.markunread_mailbox),
//                  onPressed: () {
//                    //   markAsRead();
//                  },
//                )
//              :

              //toggle between isSearchOpen
              isSearchOpen ?? false
                  ? IconButton(
                key: Key('closeSearch'),
                // padding: EdgeInsets.only(right: 15),
                icon: Theme.of(context).brightness == Brightness.dark
                    ? Image.asset(
                  "asset/dark_close.png",
                  width: 33,
                  height: 33,
                )
                    : Image.asset(
                  "asset/close.png",
                  width: 33,
                  height: 33,
                ),
                onPressed: () {
                  setState(() {
                    isSearchOpen = false;
                  });
                },
              )
                  : IconButton(
                key: Key('openSearch'),
                //padding: EdgeInsets.only(right: 15),
                icon: Theme.of(context).brightness == Brightness.dark
                    ? Image.asset(
                  "asset/dark_search.png",
                  width: 33,
                  height: 33,
                )
                    : Image.asset(
                  "asset/search.png",
                  width: 33,
                  height: 33,
                ),
                onPressed: () {
                  setState(() {
                    isSearchOpen = true;
                  });
                },
              ),
              Builder(builder: (BuildContext context) {
                return IconButton(
                  key: Key('openSideDrawer'),
                  padding: EdgeInsets.only(right: 15),
                  icon: Theme.of(context).brightness == Brightness.dark
                      ? Image.asset(
                    "asset/dark_dots.png",
                    width: 33,
                    height: 28,
                  )
                      : Image.asset(
                    'asset/dots.png',
                    width: 33,
                    height: 28,
                  ),
                  onPressed: () {
                    updateMailListNumbers();
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              })
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await checkValue();
          return;
        },
        child: Center(
          child: Column(
            children: <Widget>[
              //check to show search text field
              isSearchOpen ?? false ? searchTextField() : Container(),
              // currentfeatureIndex == mailAddFeature[2] && emailList.length > 0
              //     ? deleteContainer()
              //     : Container(),
              //listener to chexk change in state of bloc
              BlocListener(
                bloc: inboxBloc,
                listener: (BuildContext context, InboxState state) {
                  //check to show snackbar if send message is successful and dialog box is unsuccessful
                  print('Listener is starting : $state');
                  if (state is DatabaseLoadedState) {
                    if (state.list.isNotEmpty) {
                      emailList = state.list;
                      setState(() {});
                    }
                  }
                  if (state is SendMessageSuccessState) {
                    print(state);
                    print('Inside sendmessagesuccessState');

                    if (gDraftId != null) {
                      print(gDraftId);
                      int? lIndex;
                      // find InboxData in emailList where inboxdata id== gDraftId
                      for (int i = 0; i < emailList.length; i++) {
                        if (emailList[i].id == gDraftId) {
                          lIndex = i;
                          break;
                        }
                      }
                      dbHelper.deleteEmailRow(gDraftId!);
                      emailList.removeAt(lIndex!);
                      gDraftId = null;
                    }
                    // print(state.draftId);
                    // we can now remove from emailList the the inboxdata corresponding to draftId
                    if (state.sendMessageModel.result ?? false) {
                      // Scaffold.of(context).showSnackBar(SnackBar(
                      //   content: Text(StringLocalization.of(context).getText(
                      //       StringLocalization.messageSentSuccessfully)),
                      // ));

                      CustomSnackBar.buildSnackbar(
                          context,
                          StringLocalization.of(context).getText(
                              StringLocalization.messageSentSuccessfully),
                          3);
                      if (currentScreen == StringLocalization.kSent) {
                        inboxBloc?.add(
                          GetListEvent(
                              userID: widget.userId,
                              pageSize: 20,
                              pageNumber: 1,
                              messageTypeid: 2),
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AlertDialog(
                          title: Text(StringLocalization.of(context)
                              .getText(StringLocalization.messageNotSent)),
                          actions: <Widget>[
                            TextButton(
                              child: Text(StringLocalization.of(context)
                                  .getText(StringLocalization.ok)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    }
                  } else if (state is MessageDetailSuccessState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MailDetail(
                          data: state.messageDetailModel.data,
                          screenFrom: currentScreen!,
                        ),
                      ),
                    );
                  }
                  //check to show snackbar if send message is successful and dialog box is unsuccessful
                  else if (state is TrashAllMessageSuccessState) {
                    if (state.trashAllMessageModel.result ?? false) {
                      dbHelper.deleteMailByMessageType(0);
                      // Scaffold.of(context).showSnackBar(
                      //   SnackBar(
                      //       content: Text('All Messages Deleted Sucessfully')),
                      // );
                      CustomSnackBar.buildSnackbar(
                          context, 'All Messages Deleted Sucessfully', 3);
                      setState(() {});
                      setState(() {});
                    } else
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AlertDialog(
                          title: Text('something went wrong'),
                          actions: <Widget>[
                            TextButton(
                              child: Text(StringLocalization.of(context)
                                  .getText(StringLocalization.ok)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                  }
                  //check to show snackbar if send message is successful and dialog box is unsuccessful
                  else if (state is SendResponseMessageSuccessState) {
                    if (state.sendResponseMessageModel.result ?? false) {
                      CustomSnackBar.buildSnackbar(
                          context,
                          StringLocalization.of(context).getText(
                              StringLocalization.messageSentSuccessfully),
                          3);
                      inboxBloc?.add(GetListEvent(
                          userID: widget.userId,
                          pageSize: 20,
                          pageNumber: 1,
                          messageTypeid: messageType));
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AlertDialog(
                          title: Text(StringLocalization.of(context)
                              .getText(StringLocalization.messageNotSent)),
                          actions: <Widget>[
                            TextButton(
                              child: Text(StringLocalization.of(context)
                                  .getText(StringLocalization.ok)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    }
                    // state.sendResponseMessageModel.result
                    //     ?
                    //     // Scaffold.of(context).showSnackBar(SnackBar(
                    //     //     content: Text(StringLocalization.of(context)
                    //     //         .getText(StringLocalization
                    //     //             .messageSentSuccessfully)),
                    //     //   ))
                    //     CustomSnackBar.buildSnackbar(
                    //         context,
                    //         StringLocalization.of(context).getText(
                    //             StringLocalization.messageSentSuccessfully),
                    //         3)
                    //     : showDialog(
                    //         context: context,
                    //         barrierDismissible: true,
                    //         builder: (context) => AlertDialog(
                    //               title: Text(StringLocalization.of(context)
                    //                   .getText(
                    //                       StringLocalization.messageNotSent)),
                    //               actions: <Widget>[
                    //                 TextButton(
                    //                   child: Text(StringLocalization.of(context)
                    //                       .getText(StringLocalization.ok)),
                    //                   onPressed: () {
                    //                     Navigator.pop(context);
                    //                   },
                    //                 )
                    //               ],
                    //             ));
                  } else if (state is MarkAsReadAllMessageSuccessState) {
                    state.markAsReadAllMessageModel.result ?? false
                        ?
                    //  Scaffold.of(context).showSnackBar(SnackBar(
                    //     content: Text("All mails are marked as read"),
                    //   ))
                    CustomSnackBar.buildSnackbar(
                        context, "All mails are marked as read", 3)
                        : showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AlertDialog(
                          title: Text("All mails are already read"),
                          actions: <Widget>[
                            TextButton(
                              child: Text(StringLocalization.of(context)
                                  .getText(StringLocalization.ok)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ));
                  } else if (state is LoadedSearchState) {
                    noOfInboxMail =
                    state.searchResponse.totalInboxMessageCount!;
                    noOfSentMail =
                    state.searchResponse.totalSendboxMessageCount!;
                    noOfTrashMail =
                    state.searchResponse.totalTrashMessageCount!;
                    setState(() {});
                  } else if (state is SearchApiErrorState) {
                    isDoingSomething = false;
                  }
                },
                child: Container(),
              ),

              Expanded(
                child: Center(
                  //bloc builder to build ui according to states
                  child: BlocBuilder<InboxBloc, InboxState>(
                    builder: (context, state) {
                      //if database is loaded show data form database and add data to local list
                      //also update database from api
                      if (state is DatabaseLoadedState) {
                        print(state);
                        emailList = state.list;
                        emailList.sort(
                                (a, b) => b.messageID!.compareTo(a.messageID!));

                        print(widget.userEmail);
                        return emailList.length > 0
                            ? Column(
                          children: [
                            currentfeatureIndex == mailAddFeature[2] &&
                                emailList.length > 0
                                ? deleteContainer()
                                : Container(),
                            Expanded(
                              child: Listing(
                                data: emailList,
                                delete: removeItemFromList,
                                open: openMail,
                                restore: restoreMail,
                                userEmail: widget.userEmail,
                                controller: _controller,
                                deleteMultiple: deleteMultipleMessage,
                              ),
                            ),
                          ],
                        )
                            : Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).brightness ==
                              Brightness.dark
                              ? AppColor.darkBackgroundColor
                              : AppColor.backgroundColor,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      // }else if(state is SendMessageSuccessState){
                      //   return Text("Message is sent successfully");
                      // }
                      //check for initial state
                      else if (state is InitialSearchState) {
                        print(state);
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColor.darkBackgroundColor
                              : AppColor.backgroundColor,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state is NoInternetState) {
                        return emptyContainer();
                      }
                      //check if drafts are loaded and populate list from data from database
                      else if (state is LoadedDraftsState) {
                        print(state);
                        emailList = state.response;
                        emailList.sort((a, b) => b.id!.compareTo(a.id!));

                        return emailList.length > 0
                            ? DraftListing(
                          data: emailList,
                          delete: deleteDrafts,
                          open: openDrafts,
                        )
                            : emptyContainer();
                      }
                      //check if state is deleted draft state then show data from local list
                      else if (state is DraftsDeleteState) {
                        return emailList.length > 0
                            ? DraftListing(
                          data: emailList,
                          delete: deleteDrafts,
                          open: openDrafts,
                        )
                            : emptyContainer();
                      } else if (state is MultipleMessageDeleteSucessState) {
                        return emailList.length > 0
                            ? Column(children: [
                          currentfeatureIndex == mailAddFeature[2] &&
                              emailList.length > 0
                              ? deleteContainer()
                              : Container(),
                          Expanded(
                            child: Listing(
                              data: emailList,
                              delete: removeItemFromList,
                              open: openMail,
                              restore: restoreMail,
                              userEmail: widget.userEmail,
                              controller: _controller,
                              deleteMultiple: deleteMultipleMessage,
                            ),
                          )
                        ])
                            : emptyContainer();
                      } else if (state
                      is MultipleTrashMessageDeleteSucessState) {
                        return emailList.length > 0
                            ? Column(
                          children: [
                            currentfeatureIndex == mailAddFeature[2] &&
                                emailList.length > 0
                                ? deleteContainer()
                                : Container(),
                            Expanded(
                              child: Listing(
                                data: emailList,
                                delete: removeItemFromList,
                                open: openMail,
                                restore: restoreMail,
                                userEmail: widget.userEmail,
                                controller: _controller,
                                deleteMultiple: deleteMultipleMessage,
                              ),
                            ),
                          ],
                        )
                            : emptyContainer();
                      }
                      // if data is returned from api and update the data base accordingly
                      else if (state is LoadedSearchState) {
                        print(state);
                        updateMailListNumbers();
                        print(
                            "======================= net data ==================");
                        if (state.searchResponse.data!.first.messageType ==
                            messageType &&
                            !isDoingSomething) {
                          if (emailList.length > 0) {
                            lastLocalMail = emailList.first;
                            // List of messages [1,2,4]
                            state.searchResponse.data!.forEach((message) {
                              // ????
                              int flagMsgId = 0;
                              int flagParentId = 0;
                              for (int i = 0; i < emailList.length; i++) {
                                if (emailList[i].messageID ==
                                    message.messageID) {
                                  flagMsgId = 1;
                                  break;
                                }
                              }

                              if (flagMsgId == 0) {
                                for (int i = 0; i < emailList.length; i++) {
                                  if (emailList[i].parentGUIID ==
                                      message.parentGUIID) {
                                    flagParentId = 1;
                                    message.userId = widget.userId;
                                    message.isSync = 1;
                                    message.messageType = messageType;
                                    emailList[i] = message;
                                    int isRead =
                                    message.isViewed ?? false ? 1 : 0;
                                    int isRemoved =
                                    message.isDeleted ?? false ? 1 : 0;
                                    dbHelper.updateEmailData(
                                        message.toJsonToInsertInDb(
                                            isRead, isRemoved),
                                        message.parentGUIID!);
                                    break;
                                  }
                                }
                                if (flagParentId == 0) {
                                  message.userId = widget.userId;
                                  message.isSync = 1;
                                  message.messageType = messageType;
                                  int isRead =
                                  message.isViewed ?? false ? 1 : 0;
                                  int isRemoved =
                                  message.isDeleted ?? false ? 1 : 0;
                                  dbHelper.insertEmailData(message
                                      .toJsonToInsertInDb(isRead, isRemoved));
                                  emailList.insert(0, message);
                                }
                              }
//                            if ((emailList.where((email) => email.messageID == message.messageID)).length == 0) {
//                              if ((emailList.where((email) => email.parentGUIID == message.parentGUIID)).length == 0) {
//                                                            message.userId = widget.userId;
//                                                            message.isSync = 1;
//                                                            message.messageType = messageType;
//                                                            int isRead = message.isViewed ? 1 : 0;
//                                                            int isRemoved = message.isDeleted ? 1 : 0;
//                                                            dbHelper.insertEmailData(message
//                                                                .toJsonToInsertInDb(isRead, isRemoved));
//                                                            emailList.insert(0, message);
//                                                          }
//                                                          else {
//                                                              message.userId = widget.userId;
//                                                              message.isSync = 1;
//                                                              message.messageType = messageType;
//                                                              int isRead = message.isViewed ? 1 : 0;
//                                                              int isRemoved = message.isDeleted ? 1 : 0;
//                                                              dbHelper.updateEmailData(message.toJsonToInsertInDb(isRead, isRemoved), message.parentGUIID);
//                                                          }
//                            }
                            });
                            emailList.sort(
                                    (a, b) => b.messageID!.compareTo(a.messageID!));
                          } else {
                            print("in line no-------------insert data--------");
                            // emailList = state.searchResponse.data;
                            lastLocalMail = state.searchResponse.data!.last;
                            state.searchResponse.data!.forEach((f) {
                              f.userId = widget.userId;
                              f.isSync = 1;
                              f.messageType = messageType;
                              int isRead = f.isViewed ?? false ? 1 : 0;
                              int isRemoved = f.isDeleted ?? false ? 1 : 0;
                              emailList.add(f);
                              dbHelper.insertEmailData(
                                  f.toJsonToInsertInDb(isRead, isRemoved));
                            });
                          }
                          if (state.searchResponse.totalMessageCount! >
                              emailList.length) {
                            print(
                                "--------------call again getListEvent due to pageination---------");
                            inboxBloc?.add(
                              GetListEvent(
                                userID: widget.userId,
                                pageSize: endCount + 20,
                                pageNumber: 1,
                                messageTypeid: messageType,
                              ),
                            );
                          }
                          endCount = endCount + 20;
                          startCount = startCount + 20;
                        }
                        return emailList.isNotEmpty
                            ? Column(
                          children: <Widget>[
                            currentfeatureIndex == mailAddFeature[2] &&
                                emailList.isNotEmpty
                                ? deleteContainer()
                                : Container(),
                            Expanded(
                              child: Listing(
                                data: emailList,
                                delete: removeItemFromList,
                                open: openMail,
                                restore: restoreMail,
                                userEmail: widget.userEmail,
                                controller: _controller,
                                deleteMultiple: deleteMultipleMessage,
                              ),
                            ),
                          ],
                        )
                            : emptyContainer();
                      }
                      //check if state is deleted message state then show data from local list
                      else if (state is MessageDeletedSuccessState) {
                        print(
                            "-----------------------here--------------------");
                        dbHelper.updateSyncForEmail(state.messageId);
                        return emailList.length > 0
                            ? Column(
                          children: [
                            currentfeatureIndex == mailAddFeature[2] &&
                                emailList.length > 0
                                ? deleteContainer()
                                : Container(),
                            Expanded(
                              child: Listing(
                                data: emailList,
                                delete: removeItemFromList,
                                open: openMail,
                                restore: restoreMail,
                                userEmail: widget.userEmail,
                                controller: _controller,
                                deleteMultiple: deleteMultipleMessage,
                              ),
                            )
                          ],
                        )
                            : emptyContainer();
                      } else if (state is LoadingSearchState &&
                          emailList.isEmpty) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColor.darkBackgroundColor
                              : AppColor.backgroundColor,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state is SearchErrorState) {
                        return emailList.isNotEmpty
                            ? Column(
                          children: <Widget>[
                            currentfeatureIndex == mailAddFeature[2] &&
                                emailList.isNotEmpty
                                ? deleteContainer()
                                : Container(),
                            Expanded(
                              child: Listing(
                                data: emailList,
                                delete: removeItemFromList,
                                open: openMail,
                                restore: restoreMail,
                                userEmail: widget.userEmail,
                                controller: _controller,
                                deleteMultiple: deleteMultipleMessage,
                              ),
                            ),
                          ],
                        )
                            : emptyContainer();
                      }
                      //check if state is message read state then show data from local list
                      else if (state is MessageReadSuccessState) {
                        return emailList.isNotEmpty
                            ? Column(
                          children: [
                            currentfeatureIndex == mailAddFeature[2] &&
                                emailList.isNotEmpty
                                ? deleteContainer()
                                : Container(),
                            Expanded(
                              child: Listing(
                                data: emailList,
                                delete: removeItemFromList,
                                open: openMail,
                                restore: restoreMail,
                                userEmail: widget.userEmail,
                                controller: _controller,
                                deleteMultiple: deleteMultipleMessage,
                              ),
                            ),
                          ],
                        )
                            : emptyContainer();
                      } else if (state is MessageRestoreSuccessState) {
                        dbHelper.updateSyncForEmail(state.messageId);
                        return emailList.isNotEmpty
                            ? Column(
                          children: [
                            currentfeatureIndex == mailAddFeature[2] &&
                                emailList.isNotEmpty
                                ? deleteContainer()
                                : Container(),
                            Expanded(
                              child: Listing(
                                data: emailList,
                                delete: removeItemFromList,
                                open: openMail,
                                restore: restoreMail,
                                userEmail: widget.userEmail,
                                controller: _controller,
                                deleteMultiple: deleteMultipleMessage,
                              ),
                            ),
                          ],
                        )
                            : emptyContainer();
                      }
                      //check if state is Loaded outbox then show data from local list by populating data from database
                      else if (state is LoadedOutboxState) {
                        emailList = state.response;
                        emailList.sort((a, b) => b.id!.compareTo(a.id!));
                        return emailList.isNotEmpty
                            ? OutboxListing(
                            data: emailList,
                            delete: deleteOutbox,
                            open: openOutbox)
                            : emptyContainer();
                      } else {
                        if (messageType == 4) {
                          return emailList.isNotEmpty
                              ? DraftListing(
                            data: emailList,
                            delete: deleteDrafts,
                            open: openDrafts,
                          )
                              : emptyContainer();
                        }
                        return emailList.isNotEmpty
                            ? Column(
                          children: [
                            currentfeatureIndex == mailAddFeature[2] &&
                                emailList.isNotEmpty
                                ? deleteContainer()
                                : Container(),
                            Expanded(
                              child: Listing(
                                data: emailList,
                                delete: removeItemFromList,
                                // changes in open when send mail from draft
                                open: messageType == 4
                                    ? openDrafts
                                    : openMail,
                                restore: restoreMail,
                                userEmail: widget.userEmail,
                                controller: _controller,
                                deleteMultiple: deleteMultipleMessage,
                              ),
                            ),
                          ],
                        )
                            : emptyContainer();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //this button pushes compose mail screen
      floatingActionButton: CustomFloatingActionButton(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComposeMail(
                userEmail: widget.userEmail,
                userId: widget.userId,
                sendMail: sendMail,
              ),
            ),
          ).then((value) {
            if (currentScreen == StringLocalization.kDrafts)
              inboxBloc?.add(GetDraftsList(userId: widget.userId));
          });
        },
      ),
      drawerScrimColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex("#7F8D8C").withOpacity(0.6)
          : HexColor.fromHex("#384341").withOpacity(0.6),
      endDrawer: Container(
          width: 220.w,
          child: Drawer(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : AppColor.backgroundColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  healthGauge(),
                  GestureDetector(
                      key: Key(StringLocalization.kInbox),
                      onTap: () {
                        value = StringLocalization.kInbox;
                        checkValue();
                        Navigator.pop(context);
                      },
                      child: DrawerItems(
                          title: StringLocalization.kInbox,
                          iconPath: "asset/inbox_icon.png",
                          num: noOfInboxMail,
                          selectedItem: currentScreen!)),
                  GestureDetector(
                      key: Key(StringLocalization.kSent),
                      onTap: () {
                        value = StringLocalization.kSent;
                        checkValue();
                        Navigator.pop(context);
                      },
                      child: DrawerItems(
                          title: StringLocalization.kSent,
                          iconPath: "asset/sent.png",
                          num: noOfSentMail,
                          selectedItem: currentScreen!)),
                  GestureDetector(
                      key: Key(StringLocalization.kDrafts),
                      onTap: () {
                        value = StringLocalization.kDrafts;
                        checkValue();
                        Navigator.pop(context);
                      },
                      child: DrawerItems(
                          title: StringLocalization.kDrafts,
                          iconPath: "asset/draft.png",
                          num: noOfDraftMail,
                          selectedItem: currentScreen!)),
                  GestureDetector(
                      key: Key(StringLocalization.kTrash),
                      onTap: () {
                        value = StringLocalization.kTrash;
                        checkValue();
                        Navigator.pop(context);
                      },
                      child: DrawerItems(
                          title: StringLocalization.kTrash,
                          iconPath: "asset/trash.png",
                          num: noOfTrashMail,
                          selectedItem: currentScreen!)),
                  GestureDetector(
                      key: Key(StringLocalization.kOutBox),
                      onTap: () {
                        value = StringLocalization.kOutBox;
                        checkValue();
                        Navigator.pop(context);
                      },
                      child: DrawerItems(
                          title: StringLocalization.kOutBox,
                          iconPath: "asset/outbox_icon.png",
                          num: noOfOutboxMail,
                          selectedItem: currentScreen!)),
                ],
              ),
            ),
          )),
      endDrawerEnableOpenDragGesture: false,
    );
  }

  ///Added by: Shahzad
  ///Added on: 19th Feb 2021
  /// this function is use to update the number of list for each mail type.
  updateMailListNumbers() async {
    // if(emailList != null && emailList.isNotEmpty) {
    //   noOfInboxMail = emailList[0].totalInboxMessageCount;
    //   noOfTrashMail = emailList[0].totalTrashMessageCount;
    //   noOfSentMail = emailList[0].totalSendboxMessageCount;
    // }
    await getLocalMailList();
  }

  checkValue() {
    print('value is $value');
    //call message list Api if selected value is inbox
    if (value == StringLocalization.kInbox) {
      messageType = 1;
      startCount = 1;
      endCount = 20;
      currentfeatureIndex = messageType;

      emailList.clear();
      //if (emailList.length > 0) emailList.removeRange(0, emailList.length);
      inboxBloc?.add(
        GetListEvent(
            userID: widget.userId,
            pageSize: 20,
            pageNumber: 1,
            messageTypeid: 1),
      );
    }
    //call message list Api if selected value is sent
    else if (value == StringLocalization.kSent) {
      messageType = 2;
      startCount = 1;
      endCount = 20;
      currentfeatureIndex = 0;

      emailList.clear();
      //if (emailList.length > 0) emailList.removeRange(0, emailList.length);
      inboxBloc?.add(GetListEvent(
          userID: widget.userId,
          pageSize: 20,
          pageNumber: 1,
          messageTypeid: 2));
    }
    //call message list Api if selected value is trash
    else if (value == StringLocalization.kTrash) {
      messageType = 3;
      startCount = 1;
      endCount = 20;
      currentfeatureIndex = messageType;

      emailList.clear();
      //if (emailList.length > 0) emailList.removeRange(0, emailList.length);
      inboxBloc?.add(GetListEvent(
          userID: widget.userId,
          pageSize: 20,
          pageNumber: 1,
          messageTypeid: 3));
    }
    //get drafts list
    else if (value == StringLocalization.kDrafts) {
      print("GET Draft List");
      currentfeatureIndex = 0;
      messageType = 4;

      emailList.clear();
      //if (emailList.length > 0) emailList.removeRange(0, emailList.length);
      inboxBloc?.add(GetDraftsList(
        userId: widget.userId,
      ));
    }
    // get outBox list
    else if (value == StringLocalization.kOutBox) {
      currentfeatureIndex = 0;
      messageType = 5;

      emailList.clear();
      //if (emailList.length > 0) emailList.removeRange(0, emailList.length);
      inboxBloc?.add(GetOutBoxList(
        userId: widget.userId,
      ));
    }
    //set current screen value to selected value
    setState(() {
      currentScreen = value;
    });
  }

  Widget healthGauge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 58.h, left: 26.w),
          child: Body1AutoText(
            text: stringLocalization.getText(StringLocalization.dashBoardName),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: HexColor.fromHex("#62CBC9"),
            maxLine: 1,
            minFontSize: 10,
          ),
        ),
        Container(
          height: 1,
          margin: EdgeInsets.only(top: 10.h, right: 7.w),
          color: HexColor.fromHex("#BDC7C5"),
        )
      ],
    );
  }

//  Widget drawerItems(
//      {String iconPath, String title, int num, String selectedScreen}) {
//    return Container(
//      height: 47,
//      margin: EdgeInsets.only(right: 7, top: 5),
//      decoration: BoxDecoration(
//        //color: Theme.of(context).brightness == Brightness.dark ? selectedScreen == title ? HexColor.fromHex("#9F2DBC").withOpacity(0.15) : AppColor.darkBackgroundColor : selectedScreen == title ? HexColor.fromHex("#FFDFDE").withOpacity(0.6) : AppColor.backgroundColor,
//          borderRadius: BorderRadius.only(
//              topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
//          gradient: LinearGradient(
//              begin: Alignment.topCenter,
//              end: Alignment.bottomCenter,
//              colors: [
//                Theme.of(context).brightness == Brightness.dark
//                    ? selectedScreen == title
//                    ? HexColor.fromHex("#9F2DBC").withOpacity(0.15)
//                    : AppColor.darkBackgroundColor
//                    : selectedScreen == title
//                    ? HexColor.fromHex("#FFDFDE").withOpacity(0.6)
//                    : AppColor.backgroundColor,
//                Theme.of(context).brightness == Brightness.dark
//                    ? selectedScreen == title
//                    ? HexColor.fromHex("#CC0A00").withOpacity(0.15)
//                    : AppColor.darkBackgroundColor
//                    : selectedScreen == title
//                    ? HexColor.fromHex("#FFDFDE").withOpacity(0.6)
//                    : AppColor.backgroundColor,
//              ])),
//      child: Container(
//        decoration: selectedScreen == title
//            ? ConcaveDecoration(
//            shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.only(
//                  topRight: Radius.circular(30),
//                  bottomRight: Radius.circular(30)),
//            ),
//            depression: 7,
//            colors: [
//              Theme.of(context).brightness == Brightness.dark
//                  ? Colors.black
//                  : HexColor.fromHex("#D1D9E6"),
//              Theme.of(context).brightness == Brightness.dark
//                  ? HexColor.fromHex("#E7EBF2").withOpacity(0.30)
//                  : Colors.white
//            ])
//            : BoxDecoration(
//            color: Theme.of(context).brightness == Brightness.dark
//                ? AppColor.darkBackgroundColor
//                : AppColor.backgroundColor),
//        child: Center(
//          child: ListTile(
//            leading: Padding(
//              padding: EdgeInsets.only(
//                  left: title == StringLocalization.kOutBox ? 6.0 : 0),
//              child: Image.asset(
//                iconPath,
//                height: title == StringLocalization.kOutBox ? 23 : 33,
//                width: title == StringLocalization.kOutBox ? 24 : 33,
//              ),
//            ),
//            title: Text(
//              StringLocalization.of(context).getText(title),
//              style: TextStyle(
//                  fontSize: 14,
//                  fontWeight: FontWeight.bold,
//                  color: Theme.of(context).brightness == Brightness.dark
//                      ? Colors.white.withOpacity(0.87)
//                      : HexColor.fromHex("#384341")),
//              overflow: TextOverflow.ellipsis,
//              maxLines: 2,
//            ),
//            trailing: Text(
//              num != 0 ? num.toString() : "",
//              style: TextStyle(
//                  fontSize: 12,
//                  color: Theme.of(context).brightness == Brightness.dark
//                      ? Colors.white.withOpacity(0.60)
//                      : HexColor.fromHex("#5D6A68")),
//            ),
//          ),
//        ),
//      ),
//    );
//  }

  //search textfield when clicking submitted this pushes the search result screen with query
  Widget searchTextField() {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      padding: EdgeInsets.only(top: 16, left: 13, right: 13),
      child: Container(
        height: 56,
        decoration: ConcaveDecoration(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            depression: 7,
            colors: [
              Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#000000").withOpacity(0.8)
                  : HexColor.fromHex("#D1D9E6"),
              Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                  : Colors.white,
            ]),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: TextField(
            key: Key('searchTextField'),
            controller: _searchController,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                    : HexColor.fromHex("#384341")),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: StringLocalization.of(context)
                  .getText(StringLocalization.kSearchMailHint),
              hintStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex("#FFFFFF").withOpacity(0.38)
                    : HexColor.fromHex("#7F8D8C"),
              ),
            ),
            onSubmitted: (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchResults(
                    query: value,
                    list: emailList,
                    // screen: StringLocalization.of(context)
                    //     .getText(currentScreen),
                    screen: currentScreen!,
                    userId: widget.userId,
                    userEmail: widget.userEmail,
                  ),
                ),
              );
              _searchController.clear();
              setState(() {
                isSearchOpen = false;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget deleteContainer() {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      padding: EdgeInsets.only(top: 17, left: 21, right: 21),
      child: GestureDetector(
        key: Key('openTrashDialog'),
        child: Row(
          children: [
            Image.asset(
              "asset/trash.png",
              height: 33,
              width: 33,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              StringLocalization.of(context)
                  .getText(StringLocalization.emptyTrashNow),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: HexColor.fromHex("#00AFAA"),
              ),
            ),
          ],
        ),
        onTap: () {
          showDialog(
              context: context,
              useRootNavigator: true,
              builder: (context) => dialog());
        },
      ),
    );
  }

  //widget for popupmenu tile which takes icon title and value oh current selected item for menu
  Widget popUpMenuTile(
      {IconData? iconData, String? title, int? count, String? selected}) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Icon(iconData),
              title: Text(StringLocalization.of(context).getText(title ?? '')),
            ),
            selected == title
                ? Container(
                color: IconTheme.of(context).color, height: 1, child: Row())
                : Container()
          ],
        ));
  }

  ///Added by: Shahzad
  ///Added on: 19th Feb 2021
  /// this function is use to store the draft and outbox list
  getLocalMailList() async {
    List<InboxData> inboxList = await dbHelper.getEmailList(1, widget.userId);
    List<InboxData> sentList = await dbHelper.getEmailList(2, widget.userId);
    List<InboxData> trashList = await dbHelper.getEmailList(3, widget.userId);

    draftMailList = await draftsRepo.viewDrafts(widget.userId);
    outBoxMailList = await draftsRepo.viewOutBox(widget.userId);
    noOfTrashMail = 0;
    noOfSentMail = 0;
    noOfDraftMail = 0;
    noOfInboxMail = 0;
    noOfOutboxMail = 0;

    if (draftMailList != null && draftMailList.isNotEmpty) {
      noOfDraftMail = draftMailList.length;
    }
    if (outBoxMailList != null && outBoxMailList.isNotEmpty) {
      noOfOutboxMail = outBoxMailList.length;
    }
    if (inboxList != null && inboxList.isNotEmpty) {
      noOfInboxMail = inboxList.length;
    }
    if (sentList != null && sentList.isNotEmpty) {
      noOfSentMail = sentList.length;
    }
    if (trashList != null && trashList.isNotEmpty) {
      noOfTrashMail = trashList.length;
    }
//     setState(() {
//     });
  }
}
