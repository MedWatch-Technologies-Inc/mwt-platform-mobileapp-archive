import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:video_player/video_player.dart';
//import 'package:pdf_previewer/pdf_previewer.dart';

class FilePickerPage extends StatefulWidget {
  final func;
  FilePickerPage({this.func});
  @override
  _FilePickerPageState createState() => _FilePickerPageState();
}

class _FilePickerPageState extends State<FilePickerPage> {
  late File _file;
  List<String> file_name = [];
  List<File> assets = [];
  int vIndex = 0;

  String _openResult = '';

  Future<void> openFile() async {
    final filePath = _file;
    final result = await OpenFile.open(filePath.path);
  }

  Future getFileFromGallery() async {
    // final pickedFile = await FilePicker.getFile(
    //   allowCompression: true
    // );

    /*    assets = await FilePicker.getMultiFile(
        //allowedExtensions: ['pdf','txt','doc'],
        allowCompression: true,
        type: FileType.any);*/

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      // allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      assets = result.paths.map((path) => File(path!)).toList();
      setState(() {
        // _file = File(pickedFile.path);
        // file_name = _file.path.split('/');
      });
    } else {
      // User canceled the picker
    }

/*    if (result.count > 0) {
      setState(() {
        // _file = File(pickedFile.path);
        // file_name = _file.path.split('/');
      });
    }*/
  }

  void getFileData() {
    if (_file != null) {
      widget.func(_file.path);
      Navigator.pop(context);
    }
  }

  createContainer(IconData icon, String format, Color color, String name) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white54,
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 45,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(format.toUpperCase()),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                child: Text(
              name,
              overflow: TextOverflow.clip,
              maxLines: 1,
              softWrap: false,
            )),
          ],
        ));
  }

  Widget buildGridView() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        // ignore: missing_return
        children: List.generate(assets.length, (index) {
          final extension = assets[index].path.split('.').last;
          final nameOfFile = assets[index]
              .path
              .split('/')[assets[index].path.split('/').length - 1];
          print(extension);
          print(assets[index].absolute);
          if (extension == 'jpg' || extension == 'png' || extension == 'jpeg') {
            return Container(
              child: Image.file(
                assets[index],
                fit: BoxFit.cover,
              ),
            );
          } else if (extension == 'mp4' ||
              extension == 'mov' ||
              extension == 'gif') {
            //final nameOfFile = assets[index].path.split('/')[7];
            // return Chewie(
            //   controller: ChewieController(
            //     videoPlayerController:
            //         VideoPlayerController.file(assets[index]),
            //     // aspectRatio: 4 / 3,
            //     looping: false,
            //     autoInitialize: true,
            //   ),
            // );
            return createContainer(
                Icons.videocam, extension, Colors.red, nameOfFile);
          } else if (extension == 'pdf') {
            return createContainer(
                Icons.insert_drive_file, extension, Colors.red, nameOfFile);
          } else if (extension == 'doc' ||
              extension == 'docx' ||
              extension == 'txt' ||
              extension == 'srt') {
            return createContainer(
                Icons.insert_drive_file, extension, Colors.blue, nameOfFile);
          } else if (extension == 'apk') {
            return createContainer(
                Icons.android, extension, Colors.lightGreen, nameOfFile);
          } else if (extension == 'mp3') {
            return createContainer(
                Icons.headset, extension, Colors.lightBlueAccent, nameOfFile);
          } else {
            return createContainer(
                Icons.insert_drive_file, 'Unknown', Colors.grey, nameOfFile);

            // return Container(
            //   width: MediaQuery.of(context).size.width,
            //   child: MaterialButton(
            //     color: Colors.white60,
            //     elevation: 10,
            //     height: 100,
            //     onPressed: () async {
            //       final result = await OpenFile.open(assets[index].path);
            //     },
            //     child: Text(assets[index].path.split('/').last),
            //   ),
            // );
          }
        }),
      ),
    );
  }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : AppColor.backgroundColor,
        appBar: AppBar(
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
          title: Text('File Picker',
              style: TextStyle(
                  fontSize: 18,
                  color: HexColor.fromHex("62CBC9"),
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Theme.of(context).brightness == Brightness.dark
                    ? Image.asset(
                        'asset/send_dark.png',
                        width: 32,
                        height: 32,
                      )
                    : Image.asset(
                        'asset/send.png',
                        width: 32,
                        height: 32,
                      ),
                onPressed: () {}),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
              : AppColor.backgroundColor,
          alignment: Alignment.center,
          child: assets.length == 0
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 100),
                  child: Text('No file selected.'))
              : Container(
                  alignment: Alignment.center,
                  child: buildGridView(),
                  // child: Column(
                  //   children: <Widget>[
                  //     ...createContainer(),
                  //     // Container(
                  //     //   width: 350,
                  //     //   child: MaterialButton(
                  //     //       color: AppColor.graydark,
                  //     //       elevation: 10,
                  //     //       height: 100,
                  //     //       onPressed: openFile,
                  //     //       child: Text(file_name[file_name.length-1]),),
                  //     // ),
                  //     // Container(
                  //     //   width: 350,
                  //     //   child: MaterialButton(
                  //     //     elevation: 5,
                  //     //     color: AppColor.primaryColor,
                  //     //     child: Text('Send'),
                  //     //     onPressed: getFileData,
                  //     //   ),
                  //     // )
                  //   ],
                  // ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getFileFromGallery,
          tooltip: 'Pick File From Gallery',
          child: Icon(Icons.insert_drive_file),
        ));
  }
}
