//import 'dart:html';
//import 'dart:io';
//import 'dart:ui';
import 'dart:collection';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/screens/chat/attachments/image_picker.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_bloc.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_event.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_state.dart';
import 'package:health_gauge/screens/chat/models/access_chatted_with_model.dart';
import 'package:health_gauge/screens/chat/models/access_history_with_two_user_model.dart';
import 'package:health_gauge/screens/chat/models/chat_conversation_model.dart';
import 'package:health_gauge/screens/chat/models/chat_item_model.dart';
import 'package:health_gauge/screens/chat/models/chat_model.dart';
import 'package:health_gauge/utils/chat_connection_global.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
//import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
// import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chat_api_repo.dart';


// class UserChatPageDetail extends StatelessWidget {
//   final HubConnection hubConnection;
//   final UserData chatUser;
//   final int fromUserId;
//   final int toUserId;
//   final ChatUserData chatUserData;
//   UserChatPageDetail(
//       {this.hubConnection,
//       this.chatUserData,
//       this.chatUser,
//       this.toUserId,
//       this.fromUserId});
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ChatBloc(),
//       child: UserChatPage(
//         hubConnection: this.hubConnection,
//         chatUser: this.chatUser,
//         fromUserId: this.fromUserId,
//         toUserId: this.toUserId,
//         chatUserData: this.chatUserData,
//       ),
//     );
//   }
// }

class UserChatPage extends StatefulWidget {
  final HubConnection? hubConnection;
  final UserData? chatUser;
  final int? fromUserId;
  final int? toUserId;
  final ChatUserData? chatUserData;

  UserChatPage(
      {this.hubConnection,
      this.chatUserData,
      this.chatUser,
      required this.toUserId,
      this.fromUserId});

  @override
  _UserChatPageState createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  String? senderMsg;
  List<dynamic>? typeOfData;
  File? _image;
  String tempMsg = '';
  final _scrollController = ScrollController();
  final _controller = TextEditingController();
  ChatAPI _chatAPI = ChatAPI();

  // added by me
  var iname = 'image';
  var fname = 'file';
  var icount = 0;
  var fcount = 0;

  ChatModel? currentChat;
  String? currentUser = '1';
  String pairId = '2';
  List<ChatItemModel>? chatItems = [];
  List<ChatMessageData>? chatList = [];
  List<ChatModel>? chatModels = [];
  String? profileImgPath;

  ChatBloc? chatBloc;
  final picker = ImagePicker();
  ChatConversationModel chatConversationModel = ChatConversationModel();
  Queue messages = Queue<String>();

  // KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  late int _keyboardVisibilitySubscriberId;
  late bool _keyboardState;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc!.add(GetAccessHistoryTwoUsers(
        fromUserId: widget.fromUserId, toUserId: widget.toUserId));

    currentUser = globalUser?.userName;
    addStatusListener();
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
      ChatConnectionGlobal().newMsg.listen((event) {
        print('msg::::::::newMsg ${event.toString()}');
        if (event[2] == int.parse(globalUser!.userId!) &&
            event[0] == widget.chatUserData!.userID) {
          var mod = ChatMessageData(
            message: event[4],
            dateSent: '${DateTime.now()}',
            fromUserId: widget.chatUserData!.userID,
            toUserId: int.parse(globalUser!.userId!),
            fromUsername: widget.chatUserData!.username,
            toUsername: globalUser!.userName,
            isSent: 1,
          );
          dbHelper.insertChatDetail(mod.toJsonToInsertInDb());
          chatConversationModel.addChatConversation(mod);
          _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent + 100.0);
        }
      });
      ChatConnectionGlobal().connectionStatus.listen((event) {
        print('ChatConnectionGlobal :: event :: ${event.toString()}');

        if (event == ChatConnectionState.CONNECTED) {
          chatConversationModel.messages.forEach((element) async {
            await ChatConnectionGlobal()
                .hubConnection!
                .invoke('SendChat', args: [
              int.parse(globalUser!.userId!),
              globalUser!.userName,
              element,
              "${widget.chatUserData?.firstName}${widget.chatUserData?.lastName}"
            ]);
            var mod = ChatMessageData(
              message: element,
              dateSent: '${DateTime.now()}',
              fromUserId: int.parse(globalUser!.userId!),
              toUserId: widget.chatUserData!.userID,
              fromUsername: globalUser!.userName,
              toUsername: widget.chatUserData!.username,
              isSent: 1,
            );
            dbHelper.insertChatDetail(mod.toJsonToInsertInDb());
            chatConversationModel.addChatConversation(mod);
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent + 100.0);
          });
          chatConversationModel.clearMessages();
        }
        if (event == ChatConnectionState.DISCONNECTED) {
          // ChatConnectionGlobal().connectToHub();
        }
      });
    } on Exception catch (_) {}
  }

  //to get the text message
  Future<void> sendTxtMsg() async {
    var temp_chat = _controller.text;
    _controller.text = '';
    print('msg: $tempMsg');
    var isInternetAvailable = await Constants.isInternetAvailable();
    if (isInternetAvailable) {
      if (ChatConnectionGlobal().hubConnection!.state ==
          HubConnectionState.connected) {
        try {
          print('chatData: ${widget.chatUserData!.userID}');
          print('chatData: ${widget.chatUserData!.username}');
          print('chatData: ${tempMsg.trim()}');
          print('chatData: ${globalUser!.userName}');

          await _chatAPI.postData(
              widget.chatUserData!.userID!,
              widget.chatUserData!.username.toString(),
              tempMsg.trim(),
              ChatConnectionGlobal().connectionId);

          // await ChatConnectionGlobal().hubConnection!.invoke('sendChat', args: [
          //   widget.chatUserData!.userID,
          //   widget.chatUserData!.username,
          //   tempMsg.trim(),
          //   globalUser!.userName
          // ]);
        } on Exception catch (e) {
          print('error while sending chat msg $e');
        }
        var mod = ChatMessageData(
          message: tempMsg,
          dateSent: '${DateTime.now()}',
          fromUserId: int.parse(globalUser!.userId!),
          toUserId: widget.chatUserData!.userID,
          fromUsername: globalUser!.userName,
          toUsername: widget.chatUserData!.username,
          isSent: 1,
        );
        dbHelper.insertChatDetail(mod.toJsonToInsertInDb());
        chatConversationModel.addChatConversation(mod);
        _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent + 100.0);
        _controller.text = '';
        print('msg::::::::ChatMessageData Send  ${mod.toJson().toString()}');
      } else if (ChatConnectionGlobal().hubConnection!.state ==
              HubConnectionState.connecting ||
          ChatConnectionGlobal().hubConnection!.state ==
              HubConnectionState.disconnected ||
          ChatConnectionGlobal().hubConnection!.state ==
              HubConnectionState.reconnecting) {
        messages.add(tempMsg);
        chatConversationModel.addMessages(tempMsg);
      }
    } else {
      messages.add(tempMsg);
      chatConversationModel.addMessages(tempMsg);
      var mod = ChatMessageData(
        message: tempMsg,
        dateSent: '${DateTime.now()}',
        fromUserId: int.parse(globalUser!.userId!),
        toUserId: widget.chatUserData!.userID,
        fromUsername: globalUser!.userName,
        toUsername: widget.chatUserData!.username,
        isSent: 0,
      );
      print(mod);
      // dbHelper.insertChatDetail(mod.toJsonToInsertInDb());
      chatConversationModel.addChatConversation(mod);
      _scrollController
          .jumpTo(_scrollController.position.maxScrollExtent + 100.0);
      _controller.text = '';
    }
    _controller.clear();
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
    return ChangeNotifierProvider.value(
      value: chatConversationModel,
      child: Consumer<ChatConversationModel>(
        builder: (context, model, child) {
          print('Messagesssssssssssssss');
          print(model.messages.length);
          print(model.messageList.length);
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
                    title: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: CircleAvatar(
                            child: Center(
                                child:  CachedNetworkImage(

                                  imageUrl:widget.chatUserData!
                                      .picture!,
                                  imageBuilder: (context,
                                      imageProvider) =>
                                      Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration:
                                        BoxDecoration(
                                          shape:
                                          BoxShape.circle,
                                          image: DecorationImage(
                                              image:
                                              imageProvider,
                                              fit:
                                              BoxFit.cover),
                                        ),
                                      ),
                                  placeholder:
                                      (context, url) =>
                                      Image.asset(
                                        'asset/m_profile_icon.png',
                                        color: Colors.white,
                                      ),
                                  errorWidget: (context,
                                      url, error) {
                                    return Image.asset(
                                      'asset/m_profile_icon.png',
                                      color: Colors.white,
                                    );
                                  },
                                  // errorWidget: (context, url,
                                  //         error) =>
                                  //     Image.asset('"asset/m_profile_icon.png"'),
                                )

                              // child: Text(
                              //   "${widget.chatUserData!.firstName![0].toUpperCase()}${widget.chatUserData!.lastName![0].toUpperCase()}",
                              //   style: TextStyle(
                              //       fontSize: 20,
                              //       fontWeight: FontWeight.bold,
                              //       color: Theme.of(context).brightness ==
                              //               Brightness.dark
                              //           ? Colors.black
                              //           : HexColor.fromHex('#EEF1F1')),
                              // ),
                            ),
                            radius: 21,
                            backgroundColor: HexColor.fromHex('#9F2DBC'),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            '${widget.chatUserData!.firstName} ${widget.chatUserData!.lastName}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: HexColor.fromHex('62CBC9'),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        StreamBuilder<ChatConnectionState>(

                          stream: ChatConnectionGlobal().onStatusChange.stream,
                          builder: (context,  snapshot) {
                            print('Online :: ${snapshot.data}');
                            return Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                  color: ChatConnectionGlobal().connectionId.isNotEmpty
                                      ? Colors.green
                                      : Colors.red,
                                  shape: BoxShape.circle),
                            );
                          }
                        ),
                      ],
                    ),
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
                      if (state is AccessHistoryWithTwoUserSuccessState) {
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
                      if (state is DatabaseChatHistoryLoadedState) {
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
                      if (state is ChatErrorState) {
                        model.changeIsLoading(false);
                        if (model.messageList.isEmpty) {
                          model.changeIsError(true);
                        }
                      }
                      if (state is ChatListIsLoadingState) {
                        model.changeIsLoading(true);
                      }
                    },
                    child: Container(),
                  ),
                  chatConversationModel.isLoading
                      ? Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      :
                      // chatConversationModel.isErrorState
                      (chatConversationModel.messageList.isEmpty
                          ? Expanded(
                              child: Center(child: Text('Nothing to Show')),
                            )
                          : Container()),
                  Expanded(
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: chatConversationModel.messageList.length,
                        itemBuilder: (context, index) {
                          var direction = chatConversationModel
                                  .messageList[index].fromUsername ==
                              currentUser;
                          var tday = DateTime.now();
                          var date = DateTime.parse(chatConversationModel
                              .messageList[index].dateSent);

                          print(
                              'mesg ::: ${chatConversationModel.messageList[index].toJson()}');
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
                                  child: Row(
                                    mainAxisAlignment: chatConversationModel
                                                .messageList[index]
                                                .fromUsername ==
                                            currentUser
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        model.messageList[index].isSent == 1
                                            ? Icons.check
                                            : Icons.access_time_rounded,
                                        size: 14,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        checkWithInWeek(chatConversationModel
                                                .messageList[index].dateSent)
                                            ? date.year == tday.year &&
                                                    date.month == tday.month &&
                                                    date.day == tday.day
                                                ? getDateInFormat(
                                                    chatConversationModel
                                                        .messageList[index]
                                                        .dateSent,
                                                    'h:mm')
                                                : getDateInFormat(
                                                    chatConversationModel
                                                        .messageList[index]
                                                        .dateSent,
                                                    'EEE h:mm a')
                                            : getDateInFormat(
                                                chatConversationModel
                                                    .messageList[index]
                                                    .dateSent,
                                                'dd/MM, h:mm a'),
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: chatConversationModel
                                              .messageList[index]
                                              .fromUsername ==
                                          currentUser
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 12,
                                          ),
                                          margin: EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 12,
                                          ),
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
                                            color: chatConversationModel
                                                        .messageList[index]
                                                        .fromUsername ==
                                                    currentUser
                                                ? AppColor.primaryColor
                                                    .withOpacity(0.5)
                                                : AppColor.graydark,
                                          ),
                                          child: Text(
                                            chatConversationModel
                                                        .messageList[index]
                                                        .message !=
                                                    null
                                                ? chatConversationModel
                                                    .messageList[index].message!
                                                    .trim()
                                                : '',
                                            softWrap: true,
                                            maxLines: 1000,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          )),
                                    ),
                                  ],
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
          IconButton(
            icon: Icon(
              Icons.send,
              color: AppColor.primaryColor,
            ),
            onPressed: () async {
              if (_controller.text.trim().isNotEmpty) {
                await sendTxtMsg();
                _controller.clear();

                // Future.delayed(Duration(seconds: 2));
              } else {
                print('Empty Text');
              }
            },
          ),
        ],
      ),
    );
  }

  bool _isFirstMessage(List<ChatItemModel>? chatItems, int index) {
    return (chatItems![index].senderId !=
            chatItems[index - 1 < 0 ? 0 : index - 1].senderId) ||
        index == 0;
  }

  bool _isLastMessage(List<ChatItemModel>? chatItems, int index) {
    var maxItem = chatItems!.length - 1;
    return (chatItems[index].senderId !=
            chatItems[index + 1 > maxItem ? maxItem : index + 1].senderId) ||
        index == maxItem;
  }

  Widget txtMsgWidget(int index) {
    print('*************************');
    print(chatItems![index].message);
    print('*************************');
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 12,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(
            _isFirstMessage(chatItems, index) ? 0 : 10,
          ),
          bottomLeft: Radius.circular(
            _isLastMessage(chatItems, index) ? 0 : 10,
          ),
        ),
        color: chatItems![index].senderId == currentUser
            ? AppColor.primaryColor
            : AppColor.graydark,
      ),
      child: Text('${chatItems![index].message}',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 16,
          )),
    );
  }
}
