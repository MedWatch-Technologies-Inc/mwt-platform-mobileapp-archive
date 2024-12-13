//import 'dart:html';
//import 'dart:io';
//import 'dart:ui';

import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/screens/chat/attachments/image_picker.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_bloc.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_event.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_state.dart';
import 'package:health_gauge/screens/chat/models/access_group_chat_history_model.dart';
import 'package:health_gauge/screens/chat/models/chat_item_model.dart';
import 'package:health_gauge/screens/chat/models/chat_model.dart';
import 'package:health_gauge/screens/chat/models/group_chat_conversation_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

import 'group_participants_page.dart';

// class GroupChatPageDetails extends StatelessWidget {
//   final String groupName;
//   final String userName;
//   GroupChatPageDetails({this.groupName, this.userName});
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (context) => ChatBloc(),
//         child: GroupChatPage(groupName: groupName, senderUserName: userName));
//   }
// }

// class GroupChatPageDetails extends StatelessWidget {
//   final String groupMaskedName;
//   // final int pageIndex;
//   // final int pageSize;
//   final String userName;
//   GroupChatPageDetails({
//     this.groupMaskedName,
//     this.userName,
//     // this.pageIndex,this.pageSize
//   });
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (context) => ChatBloc(),
//         child: GroupChatPage(
//           groupMaskedName: groupMaskedName, senderUserName: userName,
//           // pageIndex: pageIndex,pageSize: pageSize,
//         ));
//   }
// }

class GroupChatPage extends StatefulWidget {
  //final HubConnection hubConnection;
  // final UserData chatUser;
  final String? senderUserName;
  final String? groupMaskedName;
  // final int pageIndex;
  // final int pageSize;
  final String? groupNameReal;
  // final ChatUserData chatUserData;

  GroupChatPage(
      {
      //this.hubConnection,
      // this.chatUserData,
      // this.chatUser,
      this.groupMaskedName,
      this.senderUserName,
      // this.pageIndex,
      // this.pageSize,
      this.groupNameReal});

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  String? senderMsg;
  List<dynamic>? typeOfData;
  File? _image;
  String tempMsg = '';
  int pageIndex = 1;
  int pageSize = 10;
  final _scrollController = ScrollController();
  final _controller = TextEditingController();

  ChatModel? currentChat;
  String currentUser = '1';
  String pairId = '2';
  List<ChatItemModel> chatItems = [];
  List<GroupChatMessageData> chatList = [];
  List<ChatModel> chatModels = [];
  String? profileImgPath;

  late ChatBloc chatBloc;
  final picker = ImagePicker();
  GroupChatConversationModel groupChatConversationModel =
      GroupChatConversationModel();
  Queue messages = Queue<String>();

  // KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  int? _keyboardVisibilitySubscriberId;
  bool _keyboardState = false;

  bool isShowSticker = false;

  bool isInternetAvailable = false;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);

    chatBloc.add(ChatGroupHistoryEvent(groupName: widget.groupMaskedName));

    //profileImgPath = chatModels[widget.index].profile_picture;
    // print("connection state:  ${widget.hubConnection.state}");
//    _keyboardState = _keyboardVisibility.isKeyboardVisible;
//   _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
//      onChange: (bool visible) {
//        setState(() {
//          _keyboardState = visible;
//          isShowSticker = false;
//
//        });
//      },
//    );
    // widget.hubConnection.invoke("SendChat", args: [int.parse(globalUser.userId), globalUser.userName, "", "akhilgupta"]);
    //currentChat = ChatModel.list.elementAt(widget.index);
    isShowSticker = false;
    // updateMsgList();
    // currentUser = globalUser.userName;
    // addStatusListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // chatBloc.add(GetAccessHistoryTwoUsers(
    //     fromUserId: widget.fromUserId, toUserId: widget.toUserId));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addStatusListener() {
    try {
      // ChatConnectionGlobal().connectionStatus.listen((event) {
      //   if (event == ChatConnectionState.CONNECTED) {
      //     groupChatConversationModel.messages.forEach((message) async {
      //       await ChatConnectionGlobal().hubConnection.invoke("SendChat",
      //           args: [
      //             int.parse(globalUser.userId),
      //             widget.senderUserName,
      //             message,
      //             widget.groupName
      //           ]);
      //       var mod = GroupChatMessageData(
      //         message: temp_msg,
      //         dateSent: '${DateTime.now()}',
      //         fromUsername: widget.senderUserName,
      //         toUsername: null,
      //         isSent: 1,
      //       );
      //       dbHelper.insertChatDetail(mod.toJsonToInsertInDb());
      //       groupChatConversationModel.addChatConversation(mod);
      //       _scrollController
      //           .jumpTo(_scrollController.position.maxScrollExtent + 100.0);
      //     });
      //     groupChatConversationModel.clearMessages();
      //   }
      // });
    } on Exception catch (_) {}
  }

  //to get the text message
  Future<void> sendTxtMsg() async {
    print('msg: $tempMsg');
    isInternetAvailable = await Constants.isInternetAvailable();
    if (isInternetAvailable) {
      // if (ChatConnectionGlobal().hubConnection.state ==
      //     HubConnectionState.connected) {
      try {
        //todo api
        chatBloc.add(SendGroupMessageEvent(
          maskedGroupName: widget.groupMaskedName,
          message: tempMsg,
          senderUserName: widget.senderUserName,
        ));
      } on Exception catch (e) {
        print('error while sending chat msg $e');
      }
      //todo database fetch msg
      var mod = GroupChatMessageData(
        message: tempMsg,
        dateSent: '${DateTime.now()}',
        fromUsername: widget.senderUserName,
        isSent: 1,
      );
//
      groupChatConversationModel.addChatConversation(mod);
      _scrollController
          .jumpTo(_scrollController.position.maxScrollExtent + 100.0);
      _controller.text = '';
    } else {
      //when offline
      messages.add(tempMsg);
      groupChatConversationModel.addMessages(tempMsg);
      var mod = GroupChatMessageData(
        message: tempMsg,
        dateSent: '${DateTime.now()}',
        fromUsername: widget.senderUserName,
        isSent: 0,
      );
      print(mod);
//
      groupChatConversationModel.addChatConversation(mod);
      _scrollController
          .jumpTo(_scrollController.position.maxScrollExtent + 100.0);
      _controller.text = '';
    }

//    widget.hubConnection.on("sendchat", (message) {
//      print(message);
//      if(message[0] == int.parse(globalUser.userId)){
//        chatItems.insert(0, ChatItemModel(
//            senderId: "2",
//            message: message[4],
//            type: "String"
//        ),);
//      }
//    });
//    ChatItemModel temp = new ChatItemModel(type: "string",message: temp_msg, senderId: "1" );
//    chatItems.add(temp);
//     setState(() {
//       print(chatItems.length);
    _controller.clear();
//       if (temp_msg != "") sender_msg = temp_msg;
//       chatItems.insert(
//         0,
//         ChatItemModel(senderId: "1", message: sender_msg, type: "String"),
//       );
//       print(chatItems.length);
//     });
//     print('txtMsg: $sender_msg');
  }

  //to get the img message/file
//function to get the img/file message
  void callBack(dynamic file) {
    setState(() {
      senderMsg = file;
    });
    var mimeStr = senderMsg is List
        ? lookupMimeType(senderMsg![0])!
        : lookupMimeType(senderMsg!)!;
    typeOfData = mimeStr.split('/');
    print('file type $typeOfData');
    print('image set: $senderMsg');
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ImagePickerPage(
                    func: callBack,
                    image: _image,
                  )));
    } else {}
  }

  String getDateInFormat(String date, String outputFormat) {
    return DateFormat(outputFormat).format(DateTime.parse(date));
    // "dd-MM-yyyy"
  }

  bool checkWithInWeek(String date) {
    var dt = DateTime.now();
    var Dt = DateTime(dt.year, dt.month, dt.day + 1);
    var last7Days = dt.subtract(Duration(days: 7));
    if (DateTime.parse(date).isBefore(Dt) &&
        DateTime.parse(date).isAfter(last7Days)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return ChangeNotifierProvider.value(
      value: groupChatConversationModel,
      child: Consumer<GroupChatConversationModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.5)
                          : HexColor.fromHex('#384341').withOpacity(0.2),
                      offset: Offset(0, 2.0),
                      blurRadius: 4.0,
                    )
                  ]),
                  child: AppBar(
                    elevation: 0,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                    leading: IconButton(
                      padding: EdgeInsets.only(left: 10),
                      onPressed: () {
                        chatList = [];
                        Navigator.of(context).pop();
                      },
                      icon: Theme.of(context).brightness == Brightness.dark
                          ? Image.asset(
                              'asset/dark_leftArrow.png',
                              width: 13,
                              height: 22,
                            )
                          : Image.asset(
                              'asset/leftArrow.png',
                              width: 13,
                              height: 22,
                            ),
                    ),
                    centerTitle: true,
                    title: Text(
                      widget.groupNameReal!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: HexColor.fromHex('62CBC9'),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Image.asset(
                          Theme.of(context).brightness == Brightness.dark
                              ? 'asset/dark_third_parties_icon.png'
                              : 'asset/third_parties_icon.png',
                          height: 32,
                          width: 32,
                        ),
                        onPressed: () {
                          Constants.navigatePush(
                              BlocProvider.value(
                                  value: chatBloc,
                                  child: GroupParticipantsPage(
                                      widget.groupMaskedName)),
                              context);
                        },
                      ),
                      IconButton(
                        icon: Theme.of(context).brightness == Brightness.dark
                            ? Image.asset(
                                'asset/attachment_dark.png',
                                width: 32,
                                height: 32,
                              )
                            : Image.asset(
                                'asset/attachment.png',
                                width: 32,
                                height: 32,
                              ),
                        onPressed: () {
                          // updateMsgList();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => FilePickerPage(
                          //               func: callBack,
                          //             )));
                        },
                      ),
                    ],
                  ),
                )),
            body: Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : AppColor.backgroundColor,
              child: Column(
                children: <Widget>[
                  BlocListener(
                    bloc: chatBloc,
                    listener: (context, state) {
                      if (state is GroupChatHistorySuccessState) {
                        // if (chatList != null && chatList.length == 0) {
                        //   return Container(
                        //     child: Center(
                        //       child: Text('No Result Found'),
                        //     ),
                        //   );
                        // }
                        chatList = state.dataModel.data;
                        // var day = DateTime.now();
                        // var tDay = DateTime(day.year, day.month, day.day + 1);
                        // var oneMonthBeforeDate =
                        //     DateTime(tDay.year, tDay.month - 1, tDay.day);
                        // chatList.removeWhere((element) =>
                        //     DateTime.parse(element.dateSent)
                        //         .isAfter(oneMonthBeforeDate));
                        // model.addConversationInFront(chatList);
                        model.clearMessageList();
                        model.addConversationList(chatList);
                        model.changeIsLoading(false);
                        model.changeIsError(false);
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent +
                                  100.0);
                        });
                      }
                      //Todo implement database chat import
                      if (state is DatabaseGroupChatHistoryLoadedState) {
                        chatList = state.dataModel.data;
                        model.changeIsLoading(false);
                        model.changeIsError(false);
                        model.addConversationList(chatList);
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent +
                                  100.0);
                        });
                      }
                      if (model.messageList.isEmpty) {
                        model.changeIsError(true);
                        model.changeIsLoading(false);
                      }
                      if (state is GroupChatHistoryErrorState) {
                        model.changeIsLoading(false);
                        if (model.messageList.isEmpty) {
                          model.changeIsError(true);
                          model.changeIsLoading(false);
                        }
                      }
                      if (state is GroupChatListIsLoadingState) {
                        model.changeIsLoading(true);
                        model.changeIsError(false);

                        // model.isErrorState(false);
                      }
                    },
                    child: Container(),
                  ),
                  // groupChatConversationModel.isLoading
                  model is GroupChatListIsLoadingState
                      ? Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      :
                      // groupChatConversationModel.isErrorState
                      (model is GroupChatHistoryNoDataState
                          ? Expanded(
                              child: Center(child: Text('Nothing to Show')),
                            )
                          : Container()),
                  Expanded(
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            groupChatConversationModel.messageList.length,
                        itemBuilder: (context, index) {
                          var direction = groupChatConversationModel
                                  .messageList[index].fromUsername ==
                              globalUser!.userName;
                          var tday = DateTime.now();
                          var date = DateTime.parse(groupChatConversationModel
                              .messageList[index].dateSent!);
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  margin: EdgeInsets.only(top: 5),
                                ),
                                Row(
                                  mainAxisAlignment: groupChatConversationModel
                                              .messageList[index]
                                              .fromUsername ==
                                          globalUser!.userName
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 12,
                                        ),
                                        margin: groupChatConversationModel
                                                    .messageList[index]
                                                    .fromUsername ==
                                                globalUser!.userName
                                            ? EdgeInsets.only(
                                                bottom: 6,
                                                top: 6,
                                                right: 12,
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2)
                                            : EdgeInsets.only(
                                                bottom: 6,
                                                top: 6,
                                                left: 12,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(
                                                direction ? 0 : 10),
                                            topLeft: Radius.circular(
                                              !direction ? 0 : 10,
                                            ),
                                            bottomLeft: Radius.circular(
                                              10,
                                            ),
                                          ),
                                          color: groupChatConversationModel
                                                      .messageList[index]
                                                      .fromUsername ==
                                                  globalUser!.userName
                                              ? AppColor.primaryColor
                                                  .withOpacity(0.5)
                                              : AppColor.graydark,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              groupChatConversationModel
                                                          .messageList[index]
                                                          .fromUsername ==
                                                      globalUser!.userName
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              groupChatConversationModel
                                                  .messageList[index]
                                                  .fromUsername!
                                                  .trim(),
                                              softWrap: true,
                                              maxLines: 1000,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              groupChatConversationModel
                                                  .messageList[index].message!
                                                  .trim(),
                                              softWrap: true,
                                              maxLines: 1000,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                groupChatConversationModel
                                            .messageList[index].fromUsername ==
                                        globalUser!.userName
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              groupChatConversationModel
                                                          .messageList[index]
                                                          .fromUsername ==
                                                      globalUser!.userName
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              checkWithInWeek(
                                                      groupChatConversationModel
                                                          .messageList[index]
                                                          .dateSent!)
                                                  ? date.year == tday.year &&
                                                          date.month ==
                                                              tday.month &&
                                                          date.day == tday.day
                                                      ? getDateInFormat(
                                                          groupChatConversationModel
                                                              .messageList[
                                                                  index]
                                                              .dateSent!,
                                                          'h:mm')
                                                      : getDateInFormat(
                                                          groupChatConversationModel
                                                              .messageList[
                                                                  index]
                                                              .dateSent!,
                                                          'EEE h:mm a')
                                                  : getDateInFormat(
                                                      groupChatConversationModel
                                                          .messageList[index]
                                                          .dateSent!,
                                                      'dd/MM, h:mm a'),
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              model.messageList[index].isSent ==
                                                      1
                                                  ? Icons.check
                                                  : Icons.access_time_rounded,
                                              size: 10,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              groupChatConversationModel
                                                          .messageList[index]
                                                          .fromUsername ==
                                                      globalUser!.userName
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              model.messageList[index].isSent ==
                                                      1
                                                  ? Icons.check
                                                  : Icons.access_time_rounded,
                                              size: 10,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              checkWithInWeek(
                                                      groupChatConversationModel
                                                          .messageList[index]
                                                          .dateSent!)
                                                  ? date.year == tday.year &&
                                                          date.month ==
                                                              tday.month &&
                                                          date.day == tday.day
                                                      ? getDateInFormat(
                                                          groupChatConversationModel
                                                              .messageList[
                                                                  index]
                                                              .dateSent!,
                                                          'h:mm')
                                                      : getDateInFormat(
                                                          groupChatConversationModel
                                                              .messageList[
                                                                  index]
                                                              .dateSent!,
                                                          'EEE h:mm a')
                                                  : getDateInFormat(
                                                      groupChatConversationModel
                                                          .messageList[index]
                                                          .dateSent!,
                                                      'dd/MM, h:mm a'),
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          );
                        }),
                  ),
                  _buildInput(),
//          ((!_keyboardState &&  isShowSticker) ? buildEmoji() : Container()),
                  SizedBox(
                    height: MediaQuery.of(context).viewPadding.bottom,
                  ),
                ],
              ),
            ),
            // bottomNavigationBar: _buildInput(),
          );
        },
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColor.graydark,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              maxLines: 3,
              minLines: 1,
              controller: _controller,
              style: TextStyle(color: AppColor.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Type something...',
                hintStyle: TextStyle(
                  color: AppColor.black,
                ),
              ),
              onChanged: (val) {
                tempMsg = val;
              },
            ),
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.camera_alt,
          //     color: AppColor.primaryColor,
          //   ),
          //   onPressed: getImage,
          // ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: AppColor.primaryColor,
            ),
            onPressed: () async {
              if (_controller.text.trim().isNotEmpty) {
                await sendTxtMsg();
                // model.changeIsError(false);
                _controller.text = '';
              } else {
                print('Empty Text');
              }
            },
          ),
        ],
      ),
    );
  }
}
