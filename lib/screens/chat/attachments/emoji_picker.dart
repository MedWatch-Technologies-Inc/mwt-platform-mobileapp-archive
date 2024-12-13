import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class Emoji_Picker extends StatefulWidget {
  Emoji_Picker({this.isShowSticker});

  final bool? isShowSticker;

  @override
  State<StatefulWidget> createState() {
    return _Emoji_Picker();
  }
}

class _Emoji_Picker extends State<Emoji_Picker> {
  bool? isCheck;
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    isCheck = widget.isShowSticker;
  }

  _onEmojiSelected(Emoji emoji) {
    _controller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  _onBackspacePressed() {
    _controller
      ..text = _controller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
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
          noRecents: Text('No Recents',
              style: TextStyle(fontSize: 20, color: Colors.black26)),
          categoryIcons: CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL),
    );
  }
}
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//      child: Stack(
//        children: <Widget>[
//          Column(
//            children: <Widget>[
//              // your list goes here
//
//              // Input content
//              buildInput(),
//
//              // Sticker
//              (isShowSticker ? buildSticker() : Container()),
//            ],
//          ),
//        ],
//      ),
//      onWillPop: onBackPress,
//    );
//  }

//  Widget buildInput() {
//    return Container(
//      child: Row(
//        children: <Widget>[
//          Material(
//            child: new Container(
//              margin: new EdgeInsets.symmetric(horizontal: 1.0),
//              child: new IconButton(
//                icon: new Icon(Icons.face),
//                onPressed: () {
//                  setState(() {
//                    isShowSticker = !isShowSticker;
//                  });
//                },
//                color: Colors.blueGrey,
//              ),
//            ),
//            color: Colors.white,
//          ),
//
//          // Edit text
//          Flexible(
//            child: Container(
//              child: TextField(
//                style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
//                decoration: InputDecoration.collapsed(
//                  hintText: 'Type your message...',
//                  hintStyle: TextStyle(color: Colors.blueGrey),
//                ),
//              ),
//            ),
//          )
//        ],
//      ),
//      width: double.infinity,
//      height: 50.0,
//      decoration: new BoxDecoration(
//          border: new Border(
//              top: new BorderSide(color: Colors.blueGrey, width: 0.5)),
//          color: Colors.white),
//    );
//  }
