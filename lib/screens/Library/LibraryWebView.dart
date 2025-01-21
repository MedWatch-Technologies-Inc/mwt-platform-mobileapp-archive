import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:health_gauge/utils/constants.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:flutter/foundation.dart';
// import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class LibraryWebView extends StatefulWidget {
  final String? title;
  final String? url;
  LibraryWebView({this.title, this.url});

  @override
  _LibraryWebViewState createState() => _LibraryWebViewState();
}

class _LibraryWebViewState extends State<LibraryWebView> {
  final Completer<WebViewController>? _controller =
      Completer<WebViewController>();
  WebViewController? webController;
  String? urlPDFPath = '';
  String? typeOfFile = '';
  bool? _isLoading = true;
  PDFDocument? document;
  List<String> allowedFormat = [
    'pdf', // working
    'doc',
    'docx',
    'xls',
    'xlsx',
    'txt',
    'ppt',
    'pptx',
    'csv',
    'bmp',
    'gif',
    'jpg', // working
    'jpeg', // working
    'png', // working
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkType();
    if (typeOfFile == 'pdf') {
      loadDocument();
    }
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(getUrl());

    setState(() => _isLoading = false);
  }

  checkType() {
    List<String>? t = widget.title!.split('.');
    typeOfFile = t[t.length - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (typeOfFile == 'xls' ||
        typeOfFile == 'xlxs' ||
        typeOfFile == 'ppt' ||
        typeOfFile == 'pptx' ||
        typeOfFile == 'csv' ||
        typeOfFile == 'bmp' ||
        typeOfFile == 'doc' ||
        typeOfFile == 'docx') {
      return Scaffold(
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
            title: Text(widget.title!,
                style: TextStyle(
                    fontSize: 18,
                    color: HexColor.fromHex("62CBC9"),
                    fontWeight: FontWeight.bold)),
            actions: <Widget>[
              // IconButton(
              //     icon: Icon(Icons.file_download),
              //     onPressed: () async {
              //       final status = await Permission.storage.request();
              //
              //       if (status.isGranted) {
              //         final externalDir = await getExternalStorageDirectory();
              //         final id = await FlutterDownloader.enqueue(
              //           url: getUrl(),
              //           savedDir: externalDir.path,
              //           fileName: widget.title,
              //           showNotification: true,
              //           openFileFromNotification: true,
              //         );
              //       }
              //     })
            ]),
        body: Container(
          color: Colors.black12,
          child: Center(
            child: Container(
              color: AppColor.primaryColor,
              width: 200,
              margin: EdgeInsets.only(
                  top:
                      (MediaQuery.of(context).size.height - kToolbarHeight) * 0,
                  left: (MediaQuery.of(context).size.width) / 5,
                  right: (MediaQuery.of(context).size.width) / 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.file_download,
                        color: AppColor.white,
                      ),
                      onPressed: () async {
                        // await downloadFile(getUrl(),filename: widget.title);
                        final status = await Permission.storage.request();

                        if (status.isGranted) {
                          final externalDir =
                              await getExternalStorageDirectory();
                          final id = await FlutterDownloader.enqueue(
                            url: getUrl(),
                            savedDir: externalDir!.path,
                            fileName: widget.title,
                            showNotification: true,
                            openFileFromNotification: true,
                          );
                        }
                      }),
                  Text(
                    'No Preview Available',
                    style: TextStyle(color: AppColor.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (typeOfFile == 'pdf') {
      return Scaffold(
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
            title: Text(widget.title!,
                style: TextStyle(
                    fontSize: 18,
                    color: HexColor.fromHex("62CBC9"),
                    fontWeight: FontWeight.bold)),
            actions: <Widget>[
              // IconButton(
              //     icon: Icon(Icons.file_download),
              //     onPressed: () async {
              //       final status = await Permission.storage.request();
              //
              //       if (status.isGranted) {
              //         final externalDir = await getExternalStorageDirectory();
              //         final id = await FlutterDownloader.enqueue(
              //           url: getUrl(),
              //           savedDir: externalDir.path,
              //           fileName: widget.title,
              //           showNotification: true,
              //           openFileFromNotification: true,
              //         );
              //       }
              //     })
            ]),
        body: Center(
          child: _isLoading!
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : PDFViewer(
                  document: document!,
                  zoomSteps: 1,
                  scrollDirection: Axis.vertical,
                ),
        ),
      );
    } else if (typeOfFile == 'txt') {
     /* return WebviewScaffold(
        resizeToAvoidBottomInset: true,
        url: getUrl(),
        withZoom: true,
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
          title: Text(widget.title!,
              style: TextStyle(
                  fontSize: 18,
                  color: HexColor.fromHex("62CBC9"),
                  fontWeight: FontWeight.bold)),
          actions: <Widget>[
            // IconButton(
            //     icon: Icon(Icons.file_download),
            //     onPressed: () async {
            //       final status = await Permission.storage.request();
            //
            //       if (status.isGranted) {
            //         final externalDir = await getExternalStorageDirectory();
            //         final id = await FlutterDownloader.enqueue(
            //           url: getUrl(),
            //           savedDir: externalDir.path,
            //           fileName: widget.title,
            //           showNotification: true,
            //           openFileFromNotification: true,
            //         );
            //       }
            //       // File file = await downloadFile(getUrl(),filename: widget.title);
            //     })
          ],
        ),
        useWideViewPort: true,
      );*/
      return Container();
    } else {
      // return WebviewScaffold( resizeToAvoidBottomInset: true,
      //   url: getUrl(),
      //   withZoom: true,
      //   appBar: AppBar(
      //     title: Text(widget.title),
      //     actions: <Widget>[
      //       IconButton(
      //           icon: Icon(Icons.file_download),
      //           onPressed: () async {
      //             // File file = await downloadFile(getUrl(),filename: widget.title);
      //           })
      //     ],
      //   ),
      //   useWideViewPort: true,
      // );

      return Scaffold(
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
          title: Text(widget.title!,
              style: TextStyle(
                  fontSize: 18,
                  color: HexColor.fromHex("62CBC9"),
                  fontWeight: FontWeight.bold)),
          actions: <Widget>[
            // IconButton(
            //     icon: Icon(Icons.file_download),
            //     onPressed: () async {
            //       final status = await Permission.storage.request();
            //
            //       if (status.isGranted) {
            //         final externalDir = await getExternalStorageDirectory();
            //         final id = await FlutterDownloader.enqueue(
            //           url: getUrl(),
            //           savedDir: externalDir.path,
            //           fileName: widget.title,
            //           showNotification: true,
            //           openFileFromNotification: true,
            //         );
            //       }
            //     })
          ],
        ),
        body: PhotoView(
          imageProvider: NetworkImage(getUrl()),
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
      );
    }
  }

  String getUrl() {
    String newUrl;
    if (widget.url!.startsWith('/')) {
      newUrl = '${Constants.baseHost}/${widget.url!}';
    } else {
      newUrl = widget.url!;
    }
    return newUrl;
  }

  urlLaunch() async {
    String newUrl;
    if (widget.url!.startsWith('/')) {
      newUrl = '${Constants.baseHost}/${widget.url!}';
    } else {
      newUrl = widget.url!;
    }

    if (canLaunch(newUrl) != null) {
      await launch(newUrl,
          forceWebView: true,
          forceSafariVC: true,
          enableDomStorage: true,
          headers: {'title': 'name'});
    } else {
      setState(() {});
    }
  }

  downloadFile(String url, {String? filename}) async {
    var httpClient = http.Client();
    var request = new http.Request('GET', Uri.parse(url));
    var response = httpClient.send(request);
    String? dir = (await getApplicationDocumentsDirectory()).path;

    List<List<int>>? chunks = new List.empty();
    int? downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {
        // Display percentage of completion
        debugPrint(
            'downloadPercentage: ${downloaded! / r.contentLength! * 100}');

        chunks.add(chunk);
        downloaded = downloaded! + chunk.length;
      }, onDone: () async {
        // Display percentage of completion
        debugPrint(
            'downloadPercentage: ${downloaded! / r.contentLength! * 100}');

        // Save the file
        File file = new File('$dir/$filename');
        print(file);
        final Uint8List bytes = Uint8List(r.contentLength!);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await file.writeAsBytes(bytes);
        return;
      });
    });
  }

  Future<File> _downloadFile() async {
    String url = getUrl();
    String filename = widget.title!;
    http.Client client = new http.Client();
    print(Uri.parse(url));
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    print(dir);
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  loadLocalHTML() async {
    String newUrl = getUrl();

    webController!.loadRequest(Uri.parse(newUrl));
  }
}

// var httpClient = new HttpClient();

// return Scaffold(
//     appBar: AppBar(
//       title: Text(
//         widget.title
//       ),
//     actions: <Widget>[
//       IconButton(icon: Icon(Icons.file_download), onPressed: (){})
//     ],
//     ),
//     // body: WebView(
//     //   initialUrl: '',
//     //   javascriptMode: JavascriptMode.unrestricted,
//     //   onWebViewCreated: (WebViewController webViewController) {
//     //     webController = webViewController;
//     //     _controller.complete(webViewController);
//     //     loadLocalHTML();
//     //
//     //   },
//     // )
//
// );
