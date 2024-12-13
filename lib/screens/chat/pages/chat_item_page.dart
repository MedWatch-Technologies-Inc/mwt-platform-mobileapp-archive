//import 'dart:html';
//import 'dart:io';
//import 'dart:ui';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/screens/chat/attachments/file_picker.dart';
import 'package:health_gauge/screens/chat/attachments/image_picker.dart';
import 'package:health_gauge/screens/chat/attachments/video_viewer.dart';
import 'package:health_gauge/screens/chat/models/chat_item_model.dart';
import 'package:health_gauge/screens/chat/models/chat_model.dart';
import 'package:health_gauge/utils/chat_connection_global.dart';
// import 'package:emoji_picker/emoji_picker.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:mime/mime.dart';
//import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
// import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatItemPage extends StatefulWidget {
  final HubConnection? hubConnection;
  final UserData? chatUser;

  ChatItemPage({this.hubConnection, this.chatUser});

  @override
  _ChatItemPageState createState() => _ChatItemPageState();
}

class _ChatItemPageState extends State<ChatItemPage> {
  String? senderMsg;
  late List<dynamic> typeOfData;
  String tempMsg = '';

  final _controller = TextEditingController();

  // added by me
  String iName = 'image';
  String fName = 'file';
  int iCount = 0;
  int fCount = 0;

  ChatModel? currentChat;
  String currentUser = '1';
  String pairId = '2';
  List<ChatItemModel> chatItems = [];
  List<ChatModel> chatModels = [];
  String? profileImgPath;

  // KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  int? _keyboardVisibilitySubscriberId;
  bool? _keyboardState;

  bool? isShowSticker;

  @override
  void initState() {
    super.initState();
    // connectToHub();
    // ChatConnectionGlobal().connectToHub();
    print(widget.chatUser);
    //profileImgPath = chatModels[widget.index].profile_picture;
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
    updateMsgList();
  }

  // void connectToHub() async {
  //   try {
  //     print('connection state:  ${widget.hubConnection?.state}');
  //     if (ChatConnectionGlobal().hubConnection!.state ==
  //         HubConnectionState.disconnected) {
  //       ChatConnectionGlobal().connectionState =
  //           ChatConnectionState.DISCONNECTED;
  //       await Constants.chatConnectionEstablishing();
  //     }
  //   } on Exception catch (e) {
  //     await Constants.chatConnectionEstablishing();
  //   }
  // }

//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    chatItems = updateMsgList();
//    setState(() {});
//  }

  void updateMsgList() {
    print(widget.hubConnection?.state);
    widget.hubConnection?.on('sendchat', (message) {
      if (message?[0] == int.parse(globalUser!.userId!) &&
          message?[2] == widget.chatUser?.fKReceiverUserID) {
        chatItems.insert(
          0,
          ChatItemModel(senderId: '2', message: message![4], type: 'String'),
        );
      }
      setState(() {});
    });
  }

  //to get the text message
  Future<void> getTxtMsg() async {
    print('msg: $tempMsg');
    try {
      await widget.hubConnection?.invoke('sendchat', args: [
        int.parse(globalUser!.userId!),
        globalUser?.userName,
        tempMsg,
        "${widget.chatUser!.firstName}${widget.chatUser!.lastName}"
      ]);
    } on Exception catch (e) {
      print(e);
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
    setState(() {
      print(chatItems.length);
      _controller.clear();
      if (tempMsg != '') senderMsg = tempMsg;
      chatItems.insert(
        0,
        ChatItemModel(senderId: '1', message: senderMsg!, type: 'String'),
      );
      print(chatItems.length);
    });
    print('txtMsg: $senderMsg');
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

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              leading: IconButton(
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
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
                      child: CachedNetworkImage(
                        imageUrl: widget.chatUser!.picture.toString(),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => Image.asset(
                          'asset/m_profile_icon.png',
                          color: Colors.white,
                        ),
                      ),
                      // backgroundImage:
                      //     CachedNetworkImageProvider(widget.chatUser.picture),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(widget.chatUser!.firstName!,
                      style: TextStyle(
                          color: HexColor.fromHex('62CBC9'),
                          fontSize: 18,
                          fontWeight: FontWeight.bold))
                ],
              ),
              actions: <Widget>[
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FilePickerPage(
                                  func: callBack,
                                )));
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
            Expanded(
              child: ListView.builder(
                itemCount: chatItems.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    child: Row(
                        mainAxisAlignment:
                            chatItems[index].senderId == currentUser
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: <Widget>[
                          _isFirstMessage(chatItems, index) &&
                                  chatItems[index].senderId == pairId
                              ? Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          widget.chatUser!.picture!),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 30,
                                  height: 30,
                                ),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * .7,
                            ),
                            child: chatItems[index].type == 'String'
                                ? txtMsgWidget(index)
                                : chatItems[index].type == 'file'
                                    ? fileMsgWidget(index)
                                    : chatItems[index].type == 'video'
                                        ? VidMsgWidget(
                                            chatItems: chatItems,
                                            index: index,
                                            currentUser: currentUser,
                                          )
                                        : imgMsgWidget(index),
                            //                           : chatItems[index].type == "file" ?
//                           fileMsgWidget(index) : chatItems[index].type == "video" ?
//                            VidMsgWidget(chatItems:chatItems, index: index, currentUser:currentUser)
                          )
                        ]),
                  );
                },
              ),
            ),
//          if (currentChat.isTyping)
//            Padding(
//              padding: EdgeInsets.all(8.0),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Row(
//                    children: <Widget>[
//                      SpinKitThreeBounce(
//                        color: AppColor.white,
//                        size: 20.0,
//                      ),
//                    ],
//                  ),
//                  Text(
//                    "${currentChat.contact.name} is typing...",
//                    style: TextStyle(
//                      color: AppColor.graydark,
//                    ),
//                  )
//                ],
//              ),
//            ),
//            _buildInput(),
//          ((!_keyboardState &&  isShowSticker) ? buildEmoji() : Container()),
            SizedBox(
              height: MediaQuery.of(context).viewPadding.bottom,
            ),
          ],
        ),
      ),
      // bottomNavigationBar: _buildInput(),
    );
  }

  void _onEmojiSelected(Emoji emoji) {
    _controller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  void _onBackspacePressed() {
    _controller
      ..text = _controller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  Widget buildEmoji() {
    return EmojiPicker(
      onEmojiSelected: (Category? category, Emoji emoji) {
        _onEmojiSelected(emoji);
      },
      onBackspacePressed: _onBackspacePressed,
      config: const Config(
          columns: 7,
          emojiSizeMax: 32.0,
          verticalSpacing: 0,
          horizontalSpacing: 0,
          initCategory: Category.RECENT,
          bgColor: Color(0xFFF2F2F2),
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          iconColorSelected: Colors.blue,
          backspaceColor: Colors.blue,
          recentsLimit: 28,
          noRecents: Text(
            'No Recents',
            style: TextStyle(fontSize: 20, color: Colors.black26),
          ),
          categoryIcons: CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL),
    );
  }
  // Widget buildEmoji() {
  //   return EmojiPicker(
  //     rows: 3,
  //     columns: 7,
  //     buttonMode: ButtonMode.MATERIAL,
  //     recommendKeywords: ["racing", "horse"],
  //     numRecommended: 10,
  //     onEmojiSelected: (emoji, category) {
  //       print(emoji);
  //       setState(() {
  //         temp_msg += "${emoji.emoji}";
  //         print(temp_msg);
  //         _controller.text = temp_msg;
  //         _controller.selection = TextSelection.fromPosition(
  //             TextPosition(offset: _controller.text.length));
  //       });
  //     },
  //   );
  // }

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
//          IconButton(
//            icon: Icon(
//              Icons.tag_faces,
//              color: AppColor.primaryColor,
//            ),
//            onPressed: (){
//              setState(() {
//                FocusScopeNode currentFocus = FocusScope.of(context);
//                if (!currentFocus.hasPrimaryFocus) {
//                  currentFocus.unfocus();
//                }
//                isShowSticker = !isShowSticker;
//              });
//
//              },
//          ),
//           IconButton(
//             icon: Icon(
//               Icons.camera_alt,
//               color: AppColor.primaryColor,
//             ),
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (_) => ImagePickerPage(
//                             func: callBack,
//                           )));
//             },
//           ),
//          IconButton(
//            icon: Icon(
//              Icons.send,
//              color: AppColor.primaryColor,
//            ),
//            onPressed: () async {
//              await getTxtMsg();
//              print("sdasd");
//            },
//          ),
        ],
      ),
    );
  }

  bool _isFirstMessage(List<ChatItemModel> chatItems, int index) {
    return (chatItems[index].senderId !=
            chatItems[index - 1 < 0 ? 0 : index - 1].senderId) ||
        index == 0;
  }

  bool _isLastMessage(List<ChatItemModel> chatItems, int index) {
    var maxItem = chatItems.length - 1;
    return (chatItems[index].senderId !=
            chatItems[index + 1 > maxItem ? maxItem : index + 1].senderId) ||
        index == maxItem;
  }

  Widget txtMsgWidget(index) {
    print('*************************');
    print(chatItems[index].message);
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
        color: chatItems[index].senderId == currentUser
            ? AppColor.primaryColor
            : AppColor.graydark,
      ),
      child: Text('${chatItems[index].message}',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 16,
          )),
    );
  }

  Widget imgMsgWidget(int index) {
    return Container(
      width: 150,
      height: 250,
      child: GestureDetector(
        // adding new line by hm
        child: chatItems[index].senderId != currentUser
            ? IconButton(
                icon: Icon(
                  Icons.file_download,
                  size: 35,
                  color: AppColor.white,
                ),
                onPressed: () async {
                  print('Clicked');
                  final status = await Permission.storage.request();
                  if (status.isGranted) {
                    try {
                      // Saved with this method.
                      var imageId = await ImageDownloader.downloadImage(
                          chatItems[index].message);
                      if (imageId == null) {
                        return;
                      }

                      // Below is a method of obtaining saved image information.
                      var fileName = await ImageDownloader.findName(imageId);
                      var path = await ImageDownloader.findPath(imageId);
                      var size = await ImageDownloader.findByteSize(imageId);
                      var mimeType =
                          await ImageDownloader.findMimeType(imageId);
                      if (Platform.isAndroid) await ImageDownloader.open(path!);
                    } on PlatformException catch (error) {
                      print(error);
                    }

//              final externalDir = await getLibraryDirectory();
//              print(externalDir);
//              final id = await FlutterDownloader.enqueue(
//                url: chatItems[index].message,
//                savedDir: externalDir.path,
//                fileName: iname + "$icount.png",
//                showNotification: true,
//                openFileFromNotification: true,
//              );
//              print(id);
//              if(id != null && id.isNotEmpty){
//                new Future.delayed(const Duration(seconds: 5), () {
//                  FlutterDownloader.open(taskId: id);
//                });
//              }
//              icount++;
                  }
                },
              )
            : null,
        onTap: () async {
          await showDialog(
              context: context,
              builder: (_) => ImageDialog('${chatItems[index].message}'));
        },
      ),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(offset: Offset(0.0, 1.0), blurRadius: 2)],
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            // colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.8), BlendMode.color),
            image: NetworkImage(
              '${chatItems[index].message}',
            ),
            fit: BoxFit.cover,
          )),
    );
  }

  // added by me
  String checkType(name) {
    List<String> t = name.split('.');
    return t[t.length - 1];
  }

  Widget fileMsgWidget(int index) {
    var fileName = <String>[];
    fileName = (chatItems[index].message).split('/');
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
        boxShadow: [BoxShadow(offset: Offset(0.0, 1.0), blurRadius: 2)],
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
        color: chatItems[index].senderId == currentUser
            ? AppColor.primaryColor
            : AppColor.graydark,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.insert_drive_file,
              color: AppColor.red,
            ),
            onPressed: getTxtMsg,
          ),
          MaterialButton(
            onPressed: () async {
              var path = chatItems[index].message;
              openFile(path);
            },
            child: Text('${fileName[fileName.length - 1]}',
                style: TextStyle(
                  color: AppColor.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
          ),
          chatItems[index].senderId == currentUser
              ? Container()
              : IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: () async {
                    print('Clicked');
                    final status = await Permission.storage.request();
                    if (status.isGranted) {
                      try {
                        // Saved with this method.
                        var imageId = await ImageDownloader.downloadImage(
                            chatItems[index].message);
                        if (imageId == null) {
                          return;
                        }

                        // Below is a method of obtaining saved image information.
                        var fileName = await ImageDownloader.findName(imageId);
                        var path = await ImageDownloader.findPath(imageId);
                        var size = await ImageDownloader.findByteSize(imageId);
                        var mimeType =
                            await ImageDownloader.findMimeType(imageId);
                        if (Platform.isAndroid) {
                          await ImageDownloader.open(path!);
                        }
                      } on PlatformException catch (error) {
                        print(error);
                      }

//            onPressed: () async{
//              print("Clicked");
//              final status = await Permission.storage.request();
//
//              if (status.isGranted) {
//                final externalDir = await getExternalStorageDirectory();
//
//                final id = await FlutterDownloader.enqueue(
//                  url: chatItems[index].message,
//                  savedDir: externalDir.path,
//                  fileName: fileName[fileName.length - 1],
//                  showNotification: true,
//                  openFileFromNotification: true,
//                );
//                fcount++;
                    }
                  },
                )
        ],
      ),
    );
  }

  Future<void> openFile(String path) async {
    final filePath = path;
    if (await canLaunch(filePath)) {
      await launch(filePath);
    } else {
      throw 'Could not launch $filePath';
    }
  }
}

class ImageDialog extends StatelessWidget {
  final dynamic _path;

  ImageDialog(this._path);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 500,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRect(
            child: PhotoView(
              imageProvider: NetworkImage(_path),
              // Contained = the smallest possible size to fit one dimension of the screen
              minScale: PhotoViewComputedScale.contained * 0.8,
              // Covered = the smallest possible size to fit the whole screen
              maxScale: PhotoViewComputedScale.covered * 2,
              enableRotation: false,
              loadingBuilder: (context, progress) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                ),
              ),
              // loadingChild: Center(
              //   child: CircularProgressIndicator(),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
