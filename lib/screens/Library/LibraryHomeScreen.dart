import 'dart:io';
//import 'dart:html';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/library_models/library_list.dart';
import 'package:health_gauge/screens/Library/LibraryDetailScreen.dart';
import 'package:health_gauge/screens/Library/LibraryWebView.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_bloc.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_event.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_state.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable_action_pane.dart';
import 'package:health_gauge/utils/slider/src/widgets/slide_action.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';

class LibraryHomeScreen extends StatefulWidget {
  final String userId;

  LibraryHomeScreen(this.userId);

  @override
  _LibraryHomeScreenState createState() => _LibraryHomeScreenState();
}

class _LibraryHomeScreenState extends State<LibraryHomeScreen> {
  bool? isSearchOpen = false;
  int? libraryId = 0;
  int? pageId = 1; // 1 -> MyDrive 2-> Share With Me 3-> Bin
  String? currentScreen = 'MyDrive';
  TextEditingController? _searchController;
  TextEditingController? _createFolderController;
  String? sortBy = 'Name';
  String? initValue = 'Untitled Folder';
  IconData? icon = Icons.arrow_upward;
  LibraryBloc? libraryBloc;
  List<LibraryList>? dataList = [];
  List<List<String>>? fileNameList = [];
  List<String>? base64FileList = [];
  List<String>? fileExtensionList = [];
  List<List<int>>? libraryIdList = [];

  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createFolderController = TextEditingController(text: initValue);
    _createFolderController!.selection = new TextSelection(
      baseOffset: 0,
      extentOffset: initValue!.length,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    libraryBloc = BlocProvider.of<LibraryBloc>(context);
    libraryBloc!.add(FetchLibraryEvent(
      userId: widget.userId,
      libraryId: libraryId,
      pageId: pageId,
    ));

    print('DATABASE CALL');
    Map<String, dynamic> data = {
      'userId': 329,
      'pageId': 0,
      'parentId': 0,
      'VirtualFilePath': 'Ross',
    };
    // var info = dbHelper.insertIntoLibraryDB(data);
    print("---------------K-------------");
    // print(info);
  }

  // PopUp menu Tile
  Widget popUpMenuTile(
      {IconData? iconData, String? title, int? count, String? selected}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Icon(iconData),
            title: Text(title!),
          ),
          selected == title
              ? Container(
                  color: IconTheme.of(context).color,
                  height: 1,
                  child: Row(),
                )
              : Container()
        ],
      ),
    );
  }

  // showing text field when user click on search icon on top on appbar
  Widget searchTextField() {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'Search in Drive',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
//                color: AppColor.graydark,
              )),
          onSubmitted: (value) {},
        ));
  }

  _showBottomActionSheetForAddingFolderAndUpload() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Create new',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Clicked Folder");
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(stringLocalization
                                  .getText(StringLocalization.createFolder)),
                              content: Container(
                                child: TextField(
                                  controller: _createFolderController,
                                  decoration: InputDecoration(hintText: ''),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    "Create",
                                    style:
                                    TextStyle(color: AppColor.primaryColor),
                                  ),
                                  onPressed: () {
                                    print(_createFolderController!.text);
                                    libraryBloc!.add(LibraryCreateFolderEvent(
                                      userId: widget.userId,
                                      libraryId: libraryId,
                                      folderName: _createFolderController!.text,
                                      folderPath: '',
                                    ));
                                    _createFolderController =
                                        TextEditingController(text: initValue);
                                    _createFolderController!.selection =
                                    new TextSelection(
                                      baseOffset: 0,
                                      extentOffset: initValue!.length,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: AppColor.red),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),

                              ],
                            );
                          });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          child: Icon(
                            Icons.folder,
                            color: AppColor.primaryColor,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        Text('Folder'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Clicked file upload");
                      loadAssets();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          child: Icon(Icons.file_upload,
                              color: AppColor.primaryColor),
                          backgroundColor: Colors.transparent,
                        ),
                        Text('Upload'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _createContainerForOpeningSorting(title, sortby) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          print("clicked $title");
          Navigator.of(context).pop();
          setState(() {
            sortBy = title;
          });
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: sortBy == title
                  ? AppColor.primaryColor.withOpacity(0.3)
                  : null,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              sortby == title
                  ? Icon(
                      Icons.arrow_upward,
                      size: 18,
                      color: sortby == title ? AppColor.primaryColor : null,
                    )
                  : Container(
                      width: 18,
                    ),
              SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: sortby == title ? AppColor.primaryColor : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openBottomActionSheetForSorting() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 40,
                padding: const EdgeInsets.only(left: 12.0, top: 10.0),
                child: Text(
                  'Sort By',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Divider(),
              _createContainerForOpeningSorting('Name', sortBy),
              _createContainerForOpeningSorting('Last modified', sortBy),
              _createContainerForOpeningSorting('Last modified by me', sortBy),
              _createContainerForOpeningSorting('Last opened by me', sortBy),
            ],
          ),
        );
      },
    );
  }

  _createContainer(
      String? name, IconData? icon, int? dLibraryId, Function? deleteFolder) {
    return Container(
      child: GestureDetector(
        onTap: () {
          print("clicked $name");
          deleteDialog(widget.userId, dLibraryId!, libraryId!);
          Navigator.of(context).pop();
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 18,
                color: AppColor.primaryColor,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                name!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openBottomActionSheetForDetail(String name, int deleteLibraryId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 40,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Divider(),
              currentScreen != 'Bin'
                  ? _createContainer('Share', Icons.share, null, null)
                  : _createContainer('Restore', Icons.undo, null, null),
              _createContainer(
                  'Remove', Icons.delete, deleteLibraryId, deleteDialog),
            ],
          ),
        );
      },
    );
  }

  deleteDialog(String userId, int dLibraryId, int libraryId) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                currentScreen == 'Bin' ? "Delete Permanently ?" : 'Delete ?'),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: AppColor.primaryColor),
                ),
                onPressed: () {
                  if (currentScreen == 'Bin') {
                    libraryBloc!.add(LibraryDeleteFolderPermanentlyEvent(
                      userId: widget.userId,
                      deleteLibraryId: dLibraryId,
                      libraryId: libraryId,
                    ));
                  } else {
                    libraryBloc!.add(LibraryDeleteFolderEvent(
                      userId: widget.userId,
                      deleteLibraryId: dLibraryId,
                      libraryId: libraryId,
                    ));
                  }
                  print("Clicked Delete button");

                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'No',
                  style: TextStyle(color: AppColor.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

            ],
          );
        });
  }

  void getFileName(List<File> file) async {
    List<List<String>> nameOfFile = [];
    List<String> paths = [];
    Uint8List encode;
//    for (int i = 0; i < file.length; i++) {
//      final path = file[i].path;
//
//      print(path);
//      paths.add(path);

//      List<String> name = path.split('/');
//      //to get the type of file
//      String mimeStr = lookupMimeType(path);
//      nameOfFile.add(mimeStr.split('/'));
//      //to get the name of file
//      nameOfFile[i].add(name[name.length - 1]);
//      fileNameList.add(nameOfFile[i]);
//      fileExtensionList.add(nameOfFile[i][1]);
//      encode = await File(path).readAsBytesSync();
//      base64FileList.add(base64Encode(encode));
//    }
    print(fileNameList);
    print(base64FileList!.length);
    libraryBloc!.add(LibraryUploadFolderEvent(
      filePath: file,
      libraryId: libraryId,
      userId: widget.userId,
      folderPath: '/Content/LibraryDocument',
    ));
    fileNameList = [];
    fileExtensionList = [];
    base64FileList = [];
  }

  Future<void> loadAssets() async {
    List<File> resultsList = List<File>.empty();
    String error = 'No Error Dectected';

    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, allowCompression: true);

      resultsList = result!.paths.map((path) => File(path!)).toList();

      //  resultsList = await FilePicker.getMultiFile(allowCompression: true);
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    print('result list');
    print(resultsList);

    getFileName(resultsList);
    resultsList = [];
  }

  @override
  void dispose() {
    _createFolderController?.dispose();
    _searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(currentScreen!),
        actions: <Widget>[
          isSearchOpen!
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      isSearchOpen = false;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearchOpen = true;
                    });
                  },
                ),
          PopupMenuButton(
            icon: Icon(Icons.menu),
            onSelected: (value) {
              if (value == 'Share With Me') {
                libraryBloc!.add(FetchLibraryEvent(
                  userId: widget.userId,
                  libraryId: 0,
                  pageId: 2,
                ));
                setState(() {
                  currentScreen = value.toString();
                  pageId = 2;
                });
              } else if (value == "Bin") {
                libraryBloc!.add(FetchLibraryEvent(
                  userId: widget.userId,
                  //
                  libraryId: 0,
                  pageId: 3,
                ));
                setState(() {
                  currentScreen = value.toString();
                  pageId = 3;
                });
              } else if (value == "MyDrive") {
                libraryBloc!.add(FetchLibraryEvent(
                  userId: widget.userId,
                  libraryId: 0,
                  pageId: 1,
                ));
                setState(() {
                  currentScreen = value.toString();
                  pageId = 1;
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: "MyDrive",
                child: popUpMenuTile(
                    iconData: Icons.insert_drive_file,
                    title: 'MyDrive',
                    count: 0,
                    selected: currentScreen),
              ),
              PopupMenuItem(
                value: "Share With Me",
                child: popUpMenuTile(
                    iconData: Icons.share,
                    title: 'Share With Me',
                    count: 0,
                    selected: currentScreen),
              ),
              PopupMenuItem(
                value: "Bin",
                child: popUpMenuTile(
                    iconData: Icons.delete,
                    title: 'Bin',
                    count: 0,
                    selected: currentScreen),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            isSearchOpen! ? searchTextField() : Container(),
            BlocListener(
              bloc: libraryBloc,
              listener: (context, state) {
                if (state is LibraryFolderCreateSuccessState) {
                  // Scaffold.of(context).showSnackBar(
                  //     SnackBar(content: Text('Created Folder Successfully')));

                  CustomSnackBar.buildSnackbar(
                      context, 'Created Folder Successfully', 3);
                } else if (state is LibraryFolderDeleteSuccessState) {
                  // Scaffold.of(context).showSnackBar(SnackBar(
                  //     content: Text('Deleted Folder/File Successfully')));
                  CustomSnackBar.buildSnackbar(
                      context, 'Deleted Folder/File Successfully', 3);
                }
              },
              child: Container(),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  _openBottomActionSheetForSorting();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Text(sortBy!),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        icon,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                print('Inside library home screen.dart file');
                if (state is LibraryIsLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LibraryIsLoadedState) {
                  if (state.libraryDetailModel!.result!) {
                    dataList =
                        state.libraryDetailModel!.data!.reversed.toList();
                    return Expanded(
                      child: ListView.builder(
                        itemCount: dataList!.length,
                        itemBuilder: (context, index) {
                          return Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: StringLocalization.of(context)
                                    .getText(StringLocalization.delete),
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  // do something
                                  deleteDialog(widget.userId,
                                      dataList![index].libraryID!, libraryId!);
                                },
                              ),
                            ],
                            child: GestureDetector(
                              onTap: () {
                                // go to detail of the folder
                                // if file then open the file
                                if (dataList![index].isFolder!) {
                                  // open folder navigate to detail page
                                  print("Open Detail Page");
                                  if (currentScreen != 'Bin') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LibraryDetailScreen(
                                          userId: widget.userId,
                                          libraryId: dataList![index].libraryID,
                                          title:
                                              dataList![index].virtualFilePath,
                                          folderPath:
                                              dataList![index].physicalFilePath,
                                          pID: dataList![index].parentID,
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  // open file
                                  print("Opening File");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LibraryWebView(
                                              title: dataList![index]
                                                  .virtualFilePath!,
                                              url: dataList![index]
                                                  .physicalFilePath!)));
                                }
                              },
                              child: Card(
                                child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.black12,
                                      child: Icon(
                                        dataList![index].isFolder!
                                            ? Icons.folder
                                            : Icons.insert_drive_file,
                                        color: AppColor.primaryColor,
                                      ),
                                    ),
                                    title:
                                        Text(dataList![index].virtualFilePath!),
                                    subtitle:
                                        Text(dataList![index].createdDateTime!),
                                    trailing: IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        _openBottomActionSheetForDetail(
                                          dataList![index].virtualFilePath!,
                                          dataList![index].libraryID!,
                                        );
                                      },
                                    )),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(stringLocalization
                          .getText(StringLocalization.noRecordsFound)),
                    );
                  }
                } else if (state is LibraryFolderCreateSuccessState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: currentScreen == 'Bin'
          ? null
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _showBottomActionSheetForAddingFolderAndUpload();
              },
            ),
    );
  }
}
