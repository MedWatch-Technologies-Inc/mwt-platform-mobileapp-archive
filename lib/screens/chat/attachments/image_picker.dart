import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ImagePickerPage extends StatefulWidget {
  late final func;
  final File? image;

  ImagePickerPage({required this.func, this.image});

  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  late File _image;
  File? _video;
  late List<File> videoAssets = [];
  late List<File> imageAssets = [];
  late List<File> audioAssets = [];
  late List<File> fileAssets = [];
  late final picker = ImagePicker();
  late List<File> images = []; //
  String _error = 'No Error Dectected'; //
  List<String> imgPathList = [];
  late VideoPlayerController _videoPlayerController1;
  late ChewieController _chewieController;

//   _videoPlayerController1 = VideoPlayerController.network(_videoPath);
// //    TargetPlatform.fuchsia;

  @override
  void initState() {
    if (widget.image != null) _image = widget.image!;
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  Future getVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.camera);
    if (pickedFile != null && _video != null) {
      setState(() {
        _video = File(pickedFile.path);
        _videoPlayerController1 = VideoPlayerController.file(_video!);
        _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController1,
            aspectRatio: 3 / 2,
            looping: true,
            autoInitialize: true);
        print(_video);
      });
    }
  }

//  Future getImageFromGallery() async {
//    final pickedFile = await picker.getImage(source: ImageSource.gallery);
//
//    setState(() {
//      _image = File(pickedFile.path);
//    });
//  }

  void getImgData() async {
    // List<String> imgPathList = [];
    //
    // for (int i = 0; i < images.length; i++) {
    //   var path =
    //       await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
    //   imgPathList.add(path);
    // }
    //
    // if (images.isNotEmpty) {
    //   widget.func(imgPathList);
    //   Navigator.pop(context);
    // } else if (_image != null) {
    //   widget.func(_image);
    //   Navigator.pop(context);
    // }
  }

  //show the collected image
  Widget buildGridView() {
    print(images);
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        shrinkWrap: true,
        children: List.generate(images.length, (index) {
          File f = images[index];
          return Image.file(
            f,
            fit: BoxFit.cover,
          );
        }),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<File> resultList = List<File>.empty();
    try {
      // images = await FilePicker.getMultiFile(type: FileType.image);
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.image);
      if (result != null) {
        images = result.paths.map((path) => File(path!)).toList();
      }
      print(resultList);
      if (images.length > 0) {
        setState(() {});
      }
    } catch (e) {}
  }

  Future<void> loadAudioAssets() async {
    List<File> resultList = List<File>.empty();
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.audio);

      audioAssets = result!.paths.map((path) => File(path!)).toList();

      //   audioAssets = await FilePicker.getMultiFile(type: FileType.audio);
      print(audioAssets);
      if (audioAssets.length > 0) {
        setState(() {});
      }
    } catch (e) {}
  }

  Future<void> loadVideoAssets() async {
    List<File> resultList = List<File>.empty();
    String error = 'No Error Dectected';
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.video);

      videoAssets = result!.paths.map((path) => File(path!)).toList();

      //  videoAssets = await FilePicker.getMultiFile(type: FileType.video);
      if (videoAssets.length > 0) {
        setState(() {});
      }
    } catch (e) {}
  }

  dynamic loadVideoGrid() {
    print("INSIDE VIDEO GRID");
    List<VideoPlayerController> videoPlayerControllerList = [];
    List<ChewieController> chewieControllerList = [];
    for (int i = 0; i < videoAssets.length; i++) {
      videoPlayerControllerList.add(VideoPlayerController.file(videoAssets[i]));
      chewieControllerList.add(ChewieController(
        videoPlayerController: videoPlayerControllerList[i],
        aspectRatio: 4 / 3,
        looping: false,
        autoInitialize: true,
      ));
    }
    return Expanded(
      child: GridView.count(
        crossAxisCount: 1,
        children: List.generate(videoPlayerControllerList.length, (index) {
          return Container(
            height: 150,
            width: MediaQuery.of(context).size.width / 2,
            child: Expanded(
              child: Chewie(
                controller: chewieControllerList[index],
              ),
            ),
          );
        }),
      ),
    );
  }

  // loadFileAssets() async {
  //   List<File> resultList = List<File>();
  //   String error = 'No Error Dectected';
  //   try {
  //     fileAssets = await FilePicker.getMultiFile(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf', 'txt'],
  //     );
  //     print(fileAssets);
  //     setState(() {});
  //   } catch (e) {}
  // }

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

  loadAudioGrid() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        // ignore: missing_return
        children: List.generate(audioAssets.length, (index) {
          final l = audioAssets[index].path.split('/');
          return createContainer(
              Icons.headset, 'Audio', Colors.red, l[l.length - 1]);
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        title: Text('Image Picker',
            style: TextStyle(
                color: HexColor.fromHex("62CBC9"),
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
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
        actions: [
          IconButton(
            icon: Theme.of(context).brightness == Brightness.dark
                ? Image.asset(
                    "asset/send_dark.png",
                    width: 32,
                    height: 32,
                  )
                : Image.asset(
                    "asset/send.png",
                    width: 32,
                    height: 32,
                  ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            _image != null
                ? Expanded(
                    child: Image.file(
                    _image,
                    fit: BoxFit.cover,
                  ))
                : Container(),
            _video != null
                ? Chewie(
                    controller: _chewieController,
                  )
                : Container(),
            videoAssets.length == 0 ? Container() : loadVideoGrid(),
            images.length == 0 ? Container() : buildGridView(),
            audioAssets.length == 0 ? Container() : loadAudioGrid(),
            // Center(
            //     child: images.isNotEmpty
            //         ? Stack(
            //             alignment: Alignment.bottomCenter,
            //             children: <Widget>[
            //               Expanded(
            //                 child: Column(children: [buildGridView()]),
            //               ),
            //               MaterialButton(
            //                 color: AppColor.primaryColor,
            //                 child: Text('Send'),
            //                 onPressed: getImgData,
            //               )
            //             ],
            //           )
            //         : _image == null && _video == null
            //             ? Text('No file selected')
            //             : null),
          ],
        ),
      ),
      floatingActionButton: _image == null &&
              _video == null &&
              videoAssets.length == 0 &&
              imageAssets.length == 0 &&
              images.length == 0 &&
              audioAssets.length == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: getImage,
                  heroTag: 'image0',
                  tooltip: 'Take a photo',
                  child: const Icon(Icons.camera_alt),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FloatingActionButton(
//                onPressed: getImage,
                    onPressed: loadAssets,
                    heroTag: 'image1',
                    tooltip: 'Pick Image from camera',
                    child: const Icon(Icons.photo_library),
                  ),
                ),
//                Padding(
//                  padding: const EdgeInsets.only(top: 16.0),
//                  child: FloatingActionButton(
//                    backgroundColor: Colors.red,
//                    onPressed: getVideo,
//                    heroTag: 'video1',
//                    tooltip: 'Take a Video',
//                    child: const Icon(Icons.videocam),
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.only(top: 16.0),
//                  child: FloatingActionButton(
//                    backgroundColor: Colors.red,
//                    onPressed: loadVideoAssets,
//                    heroTag: 'video0',
//                    tooltip: 'Pick Video from gallery',
//                    child: const Icon(Icons.video_library),
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.only(top: 16.0),
//                  child: FloatingActionButton(
//                    backgroundColor: Colors.blue,
//                    onPressed: loadAudioAssets,
//                    heroTag: 'audio0',
//                    tooltip: 'pick audio',
//                    child: const Icon(Icons.headset),
//                  ),
//                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 16.0),
                //   child: FloatingActionButton(
                //     backgroundColor: Colors.blue,
                //     onPressed: loadFileAssets,
                //     heroTag: 'file0',
                //     tooltip: 'pick files',
                //     child: const Icon(Icons.insert_drive_file),
                //   ),
                // ),
              ],
            )
          : null,
    );
  }
}
