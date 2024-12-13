import 'package:health_gauge/screens/chat/core/consts.dart';
import 'package:health_gauge/screens/chat/models/chat_item_model.dart';
import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class VidMsgWidget extends StatefulWidget {
  VidMsgWidget(
      {required this.chatItems,
      required this.index,
      required this.currentUser});
  late final List<ChatItemModel> chatItems;
  late final int index;
  late final String currentUser;
  @override
  State<StatefulWidget> createState() {
    return _VidMsgWidgetState();
  }
}

class _VidMsgWidgetState extends State<VidMsgWidget> {
  late String _videoPath;
  late TargetPlatform _platform;
  late VideoPlayerController _videoPlayerController1;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPath = widget.chatItems[widget.index].message;
    _videoPlayerController1 = VideoPlayerController.network(_videoPath);
//    TargetPlatform.fuchsia;
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        aspectRatio: 3 / 2,
        // aspectRatio: 3 / 2,
        looping: false,
        autoInitialize: true);
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      //aspectRatio: 3 / 2,
      aspectRatio: 3 / 2,
      child: Container(
        // padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        decoration: BoxDecoration(
          boxShadow: [new BoxShadow(offset: Offset(0.0, 1.0), blurRadius: 2)],
          color: widget.chatItems[widget.index].senderId == widget.currentUser
              ? AppColor.primaryColor
              : AppColor.graydark,
          borderRadius: BorderRadius.circular(15),
        ),
        width: MediaQuery.of(context).size.width * 0.85,
        child: Stack(
          children: <Widget>[
            Chewie(
              controller: _chewieController,
            ),
            // uncomment for download button to appear
            // IconButton(icon: Icon(Icons.file_download), onPressed: () async{
            //   print("Clicked");
            //   final status = await Permission.storage.request();
            //
            //   if (status.isGranted) {
            //     final externalDir = await getExternalStorageDirectory();
            //     print(externalDir);
            //     final id = await FlutterDownloader.enqueue(
            //       url: widget.chatItems[widget.index].message,
            //       savedDir: externalDir.path,
            //       fileName: "sample.mp4",
            //       showNotification: true,
            //       openFileFromNotification: true,
            //     );
            //   }
            // })
          ],
        ),
      ),
    );
  }
}
