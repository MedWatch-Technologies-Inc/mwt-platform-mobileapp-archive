import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/Library/LibraryWebView.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_bloc.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_event.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_state.dart';
import 'package:health_gauge/screens/Library_changes/link_share.dart';
import 'package:health_gauge/screens/Library_changes/models/library_detail_notifier_model.dart';
import 'package:health_gauge/screens/Library_changes/user_share.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable_action_pane.dart';
import 'package:health_gauge/utils/slider/src/widgets/slide_action.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_floating_action_button.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:provider/provider.dart';

class LibraryNewDetailScreen extends StatefulWidget {
  final String? userId;
  final int? libraryId;
  final String? title;
  final String? folderPath;
  final int? pID;

  LibraryNewDetailScreen(
      {this.userId, this.title, this.folderPath, this.libraryId, this.pID});

  @override
  _LibraryNewDetailScreenState createState() => _LibraryNewDetailScreenState();
}

class _LibraryNewDetailScreenState extends State<LibraryNewDetailScreen> {
  LibraryDetailNotifierModel _libraryDetailNotifierModel =
      LibraryDetailNotifierModel();
  TextEditingController? _searchController;
  TextEditingController? _createFolderController;
  LibraryBloc? libraryBloc;
  String initValue = 'Untitled Folder';
  IconData icon = Icons.arrow_upward;
  List<List<String>> fileNameList = [];
  List<String> base64FileList = [];
  List<String> fileExtensionList = [];
  List<List<int>> libraryIdList = [];

  // bool openKeyboardFolder = false;
  FocusNode openKeyboardFocus = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createFolderController = TextEditingController(text: initValue);
    _libraryDetailNotifierModel.changeCurrentScreen(widget.title!);
    _libraryDetailNotifierModel.changeLibraryId(widget.libraryId!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    libraryBloc = BlocProvider.of<LibraryBloc>(context);
    libraryBloc!.add(FetchLibraryEvent(
      userId: widget.userId.toString(),
      libraryId: _libraryDetailNotifierModel.libraryId,
      pageId: _libraryDetailNotifierModel.pageId,
    ));
  }

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
              hintText: StringLocalization.of(context)
                  .getText(StringLocalization.searchInDrive),
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
//                color: AppColor.graydark,
              )),
          onSubmitted: (value) {},
        ));
  }

  _createContainerForOpeningSorting(title, sortby) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          _libraryDetailNotifierModel.changeSortBy(title);
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: _libraryDetailNotifierModel.sortBy == title
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
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 40,
                padding: const EdgeInsets.only(left: 12.0, top: 10.0),
                child: Text(
                  StringLocalization.of(context)
                      .getText(StringLocalization.sortBy),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Divider(),
              _createContainerForOpeningSorting(
                  StringLocalization.of(context)
                      .getText(StringLocalization.name),
                  _libraryDetailNotifierModel.sortBy),
              _createContainerForOpeningSorting(
                  StringLocalization.of(context)
                      .getText(StringLocalization.lastModified),
                  _libraryDetailNotifierModel.sortBy),
              _createContainerForOpeningSorting(
                  StringLocalization.of(context)
                      .getText(StringLocalization.lastModifiedByMe),
                  _libraryDetailNotifierModel.sortBy),
              _createContainerForOpeningSorting(
                  StringLocalization.of(context)
                      .getText(StringLocalization.lastOpenedByMe),
                  _libraryDetailNotifierModel.sortBy),
            ],
          ),
        );
      },
    );
  }

  void getFileName(List<File> file) async {
    print(fileNameList);
    print(base64FileList.length);
    if (file.isNotEmpty) {
      libraryBloc!.add(LibraryUploadFolderEvent(
        filePath: file,
        libraryId: _libraryDetailNotifierModel.libraryId,
        userId: widget.userId.toString(),
        folderPath: '/Content/LibraryDocument',
      ));
      _libraryDetailNotifierModel.changeIsUploading();
      fileNameList = [];
      fileExtensionList = [];
      base64FileList = [];
    }
  }

  Future<void> loadAssets() async {
    List<File> resultsList = List<File>.empty();
    String error = 'No Error Dectected';

    try {
      //   resultsList = await FilePicker.getMultiFile(allowCompression: true);

      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, allowCompression: true);
      if (result != null) {
        resultsList = result.paths.map((path) => File(path!)).toList();
      }
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    print(resultsList);

    getFileName(resultsList);
    resultsList = [];
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
                StringLocalization.of(context)
                    .getText(StringLocalization.createNew),
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
                      // showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AlertDialog(
                      //         title: Text(stringLocalization
                      //             .getText(StringLocalization.createFolder)),
                      //         content: Container(
                      //           child: TextField(
                      //             controller: _createFolderController,
                      //             decoration: InputDecoration(hintText: ''),
                      //           ),
                      //         ),
                      //         actions: <Widget>[
                      //           FlatButton(
                      //             child: Text(
                      //               stringLocalization
                      //                   .getText(StringLocalization.cancel),
                      //               style: TextStyle(color: AppColor.red),
                      //             ),
                      //             onPressed: () {
                      //               Navigator.of(context).pop();
                      //             },
                      //           ),
                      //           FlatButton(
                      //             child: Text(
                      //               stringLocalization
                      //                   .getText(StringLocalization.create),
                      //               style:
                      //                   TextStyle(color: AppColor.primaryColor),
                      //             ),
                      //             onPressed: () {
                      //               print(_createFolderController.text);
                      //               libraryBloc.add(LibraryCreateFolderEvent(
                      //                 userId: widget.userId.toString(),
                      //                 libraryId:
                      //                     _libraryDetailNotifierModel.libraryId,
                      //                 folderName: _createFolderController.text,
                      //                 folderPath: widget.folderPath +
                      //                     _createFolderController.text,
                      //               ));
                      //               _createFolderController =
                      //                   TextEditingController(text: initValue);
                      //               _createFolderController.selection =
                      //                   new TextSelection(
                      //                 baseOffset: 0,
                      //                 extentOffset: initValue.length,
                      //               );
                      //               Navigator.of(context).pop();
                      //             },
                      //           )
                      //         ],
                      //       );
                      //     });
                      showDialog(
                          context: context,
                          useRootNavigator: true,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex("#111B1A")
                                          : AppColor.backgroundColor,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? AppColor.darkBackgroundColor
                                              : AppColor.backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? HexColor.fromHex("#D1D9E6")
                                                      .withOpacity(0.1)
                                                  : HexColor.fromHex("#DDE3E3")
                                                      .withOpacity(0.3),
                                              blurRadius: 5,
                                              spreadRadius: 0,
                                              offset: Offset(-5, -5),
                                            ),
                                            BoxShadow(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? HexColor.fromHex("#000000")
                                                      .withOpacity(0.75)
                                                  : HexColor.fromHex("#384341")
                                                      .withOpacity(0.9),
                                              blurRadius: 5,
                                              spreadRadius: 0,
                                              offset: Offset(5, 5),
                                            ),
                                          ]),
                                      padding: EdgeInsets.only(
                                          top: 27, left: 26, right: 26),
                                      // height: 259.h,
                                      // width: 309.w,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 25,
                                              // child: AutoSizeText(
                                              //   StringLocalization.of(context)
                                              //       .getText(StringLocalization.weight),
                                              //   style: TextStyle(
                                              //       fontSize: 20.sp,
                                              //       fontWeight: FontWeight.bold,
                                              //       color: Theme.of(context).brightness ==
                                              //               Brightness.dark
                                              //           ? HexColor.fromHex("#FFFFFF")
                                              //               .withOpacity(0.87)
                                              //           : HexColor.fromHex("#384341")),
                                              //   maxLines: 1,
                                              //   minFontSize: 10,
                                              // ),
                                              child: Body1AutoText(
                                                text: stringLocalization
                                                    .getText(StringLocalization
                                                        .createFolder),
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? HexColor.fromHex(
                                                            "#FFFFFF")
                                                        .withOpacity(0.87)
                                                    : HexColor.fromHex(
                                                        "#384341"),
                                                minFontSize: 10,
                                                // maxLine: 1,
                                              ),
                                            ),
                                            Container(
                                                padding: EdgeInsets.only(
                                                  top: 16.h,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    // Container(
                                                    //   // height: 30.h,
                                                    //   child: Body1AutoText(
                                                    //       text: StringLocalization.of(context)
                                                    //           .getText(StringLocalization
                                                    //           .addWeightDescription),
                                                    //       maxLine: 1,
                                                    //       fontSize: 16.sp,
                                                    //       color: Theme.of(context)
                                                    //           .brightness ==
                                                    //           Brightness.dark
                                                    //           ? HexColor.fromHex("#FFFFFF")
                                                    //           .withOpacity(0.87)
                                                    //           : HexColor.fromHex("#384341")),
                                                    // ),
                                                    SizedBox(height: 12.h),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 5,
                                                          child: Container(
                                                            //height: 48.h,
                                                            decoration: BoxDecoration(
                                                                color: Theme.of(context)
                                                                            .brightness ==
                                                                        Brightness
                                                                            .dark
                                                                    ? HexColor
                                                                        .fromHex(
                                                                            "#111B1A")
                                                                    : AppColor
                                                                        .backgroundColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.h),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Theme.of(context).brightness ==
                                                                            Brightness
                                                                                .dark
                                                                        ? HexColor.fromHex("#D1D9E6").withOpacity(
                                                                            0.1)
                                                                        : Colors
                                                                            .white
                                                                            .withOpacity(0.7),
                                                                    blurRadius:
                                                                        4,
                                                                    spreadRadius:
                                                                        0,
                                                                    offset:
                                                                        Offset(
                                                                            -4,
                                                                            -4),
                                                                  ),
                                                                  BoxShadow(
                                                                    color: Theme.of(context).brightness ==
                                                                            Brightness
                                                                                .dark
                                                                        ? Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.75)
                                                                        : HexColor.fromHex("#9F2DBC")
                                                                            .withOpacity(0.15),
                                                                    blurRadius:
                                                                        4,
                                                                    spreadRadius:
                                                                        0,
                                                                    offset:
                                                                        Offset(
                                                                            4,
                                                                            4),
                                                                  ),
                                                                ]),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                _libraryDetailNotifierModel
                                                                    .changeKeyboard(
                                                                        true);
                                                                openKeyboardFocus
                                                                    .requestFocus();
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 10
                                                                            .w,
                                                                        right: 10
                                                                            .w),
                                                                decoration: _libraryDetailNotifierModel
                                                                        .openKeyboardFolder
                                                                    ? ConcaveDecoration(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(10
                                                                                .h)),
                                                                        depression:
                                                                            7,
                                                                        colors: [
                                                                            Theme.of(context).brightness == Brightness.dark
                                                                                ? Colors.black.withOpacity(0.5)
                                                                                : HexColor.fromHex("#D1D9E6"),
                                                                            Theme.of(context).brightness == Brightness.dark
                                                                                ? HexColor.fromHex("#D1D9E6").withOpacity(0.07)
                                                                                : Colors.white,
                                                                          ])
                                                                    : BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10.h)),
                                                                        color: Theme.of(context).brightness ==
                                                                                Brightness.dark
                                                                            ? HexColor.fromHex("#111B1A")
                                                                            : AppColor.backgroundColor,
                                                                      ),
                                                                child:
                                                                    IgnorePointer(
                                                                  ignoring: _libraryDetailNotifierModel
                                                                          .openKeyboardFolder
                                                                      ? false
                                                                      : true,
                                                                  child:
                                                                      TextFormField(
                                                                    focusNode:
                                                                        openKeyboardFocus,
                                                                    controller:
                                                                        _createFolderController,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16.0.sp),
                                                                    decoration: InputDecoration(
                                                                        border: InputBorder
                                                                            .none,
                                                                        focusedBorder:
                                                                            InputBorder
                                                                                .none,
                                                                        enabledBorder:
                                                                            InputBorder
                                                                                .none,
                                                                        errorBorder:
                                                                            InputBorder
                                                                                .none,
                                                                        disabledBorder:
                                                                            InputBorder
                                                                                .none,
                                                                        hintText:
                                                                            '',
                                                                        hintStyle: TextStyle(
                                                                            color: Theme.of(context).brightness == Brightness.dark
                                                                                ? Colors.white.withOpacity(0.38)
                                                                                : HexColor.fromHex("7F8D8C"),
                                                                            fontSize: 16.sp)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 30.h),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              GestureDetector(
                                                            child: Container(
                                                              height: 34.h,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(30
                                                                              .h),
                                                                  color: HexColor
                                                                          .fromHex(
                                                                              "#FF6259")
                                                                      .withOpacity(
                                                                          0.8),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Theme.of(context).brightness ==
                                                                              Brightness
                                                                                  .dark
                                                                          ? HexColor.fromHex("#D1D9E6").withOpacity(
                                                                              0.1)
                                                                          : Colors
                                                                              .white,
                                                                      blurRadius:
                                                                          5,
                                                                      spreadRadius:
                                                                          0,
                                                                      offset:
                                                                          Offset(
                                                                              -5,
                                                                              -5),
                                                                    ),
                                                                    BoxShadow(
                                                                      color: Theme.of(context).brightness ==
                                                                              Brightness
                                                                                  .dark
                                                                          ? Colors
                                                                              .black
                                                                              .withOpacity(0.75)
                                                                          : HexColor.fromHex("#D1D9E6"),
                                                                      blurRadius:
                                                                          5,
                                                                      spreadRadius:
                                                                          0,
                                                                      offset:
                                                                          Offset(
                                                                              5,
                                                                              5),
                                                                    ),
                                                                  ]),
                                                              child: Container(
                                                                decoration:
                                                                    ConcaveDecoration(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30.h),
                                                                        ),
                                                                        depression:
                                                                            10,
                                                                        colors: [
                                                                      Colors
                                                                          .white,
                                                                      HexColor.fromHex(
                                                                          "#D1D9E6"),
                                                                    ]),
                                                                child: Center(
                                                                  child: Text(
                                                                    stringLocalization
                                                                        .getText(
                                                                            StringLocalization.cancel)
                                                                        .toUpperCase(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Theme.of(context).brightness ==
                                                                              Brightness
                                                                                  .dark
                                                                          ? HexColor.fromHex(
                                                                              "#111B1A")
                                                                          : Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              _createFolderController!
                                                                      .text =
                                                                  'Untitled Folder';
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(width: 17.w),
                                                        Expanded(
                                                            child:
                                                                GestureDetector(
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          34.h,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(30
                                                                              .h),
                                                                          color:
                                                                              HexColor.fromHex("#00AFAA"),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex("#D1D9E6").withOpacity(0.1) : Colors.white,
                                                                              blurRadius: 5,
                                                                              spreadRadius: 0,
                                                                              offset: Offset(-5, -5),
                                                                            ),
                                                                            BoxShadow(
                                                                              color: Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(0.75) : HexColor.fromHex("#D1D9E6"),
                                                                              blurRadius: 5,
                                                                              spreadRadius: 0,
                                                                              offset: Offset(5, 5),
                                                                            ),
                                                                          ]),
                                                                      child:
                                                                          Container(
                                                                        decoration: ConcaveDecoration(
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(30.h),
                                                                            ),
                                                                            depression: 10,
                                                                            colors: [
                                                                              Colors.white,
                                                                              HexColor.fromHex("#D1D9E6"),
                                                                            ]),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            stringLocalization.getText(StringLocalization.create).toUpperCase(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14.sp,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex("#111B1A") : Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onTap: () {
                                                                      print(_createFolderController!
                                                                          .text);
                                                                      libraryBloc!
                                                                          .add(
                                                                              LibraryCreateFolderEvent(
                                                                        userId: widget
                                                                            .userId
                                                                            .toString(),
                                                                        libraryId:
                                                                            _libraryDetailNotifierModel.libraryId,
                                                                        folderName:
                                                                            _createFolderController!.text,
                                                                        folderPath:
                                                                            widget.folderPath! +
                                                                                _createFolderController!.text,
                                                                      ));
                                                                      _createFolderController =
                                                                          TextEditingController(
                                                                              text: initValue);
                                                                      _createFolderController!
                                                                              .selection =
                                                                          new TextSelection(
                                                                        baseOffset:
                                                                            0,
                                                                        extentOffset:
                                                                            initValue.length,
                                                                      );
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    })),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                            SizedBox(
                                              height: 25.h,
                                            )
                                          ])));
                            });
                          },
                          barrierDismissible: false);
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
                        Text(stringLocalization
                            .getText(StringLocalization.folder)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      loadAssets();
                      Navigator.of(context).pop();
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
                        Text(stringLocalization
                            .getText(StringLocalization.upload)),
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

  _createContainer(
      String name, IconData icon, int dLibraryId, Function deleteFolder) {
    return Container(
      child: GestureDetector(
        onTap: () {
          // deleteDialog(widget.userId.toString(), dLibraryId,
          //     _libraryDetailNotifierModel.libraryId);
          Navigator.of(context).pop();
          int? id = int.tryParse(widget.userId ?? '');
          if (id != null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserSharePage(id, widget.libraryId!)));
          }
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
                name,
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

  deleteDialog(String userId, int dLibraryId, int libraryId) {
    return showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => Dialog(
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
                          text: _libraryDetailNotifierModel.currentScreen ==
                                  StringLocalization.of(context)
                                      .getText(StringLocalization.bin)
                              ? StringLocalization.of(context).getText(
                                      StringLocalization.deletePermanently) +
                                  "?"
                              : StringLocalization.of(context)
                                      .getText(StringLocalization.delete) +
                                  '?',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                              : HexColor.fromHex("#384341"),
                          maxLine: 1,
                          minFontSize: 8,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              child: SizedBox(
                                height: 25,
                                child: Body1AutoText(
                                  text: StringLocalization.of(context)
                                      .getText(StringLocalization.ok)
                                      .toUpperCase(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor.fromHex("#00AFAA"),
                                  maxLine: 1,
                                  minFontSize: 8,
                                ),
                              ),
                              onPressed: () async {
                                if (_libraryDetailNotifierModel.currentScreen ==
                                    StringLocalization.of(context)
                                        .getText(StringLocalization.bin)) {
                                  libraryBloc!
                                      .add(LibraryDeleteFolderPermanentlyEvent(
                                    userId: widget.userId.toString(),
                                    deleteLibraryId: dLibraryId,
                                    libraryId: libraryId,
                                  ));
                                } else {
                                  libraryBloc!.add(LibraryDeleteFolderEvent(
                                    userId: widget.userId.toString(),
                                    deleteLibraryId: dLibraryId,
                                    libraryId: libraryId,
                                  ));
                                }

                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
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
                              ),
                              onPressed: () async {
                                if (context != null) {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            //SizedBox(width: 42,),

                          ])
                    ]))));
  }

  _openBottomActionSheetForDetail(
      String name, int deleteLibraryId, String url) {
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
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Divider(),
              _libraryDetailNotifierModel.currentScreen !=
                      StringLocalization.of(context)
                          .getText(StringLocalization.bin)
                  ? _createContainer(
                      StringLocalization.of(context)
                          .getText(StringLocalization.shareWithUser),
                      Icons.share,
                      0,
                      () {})
                  : GestureDetector(
                      onTap: () {
                        libraryBloc!.add(LibraryRestoreEvent(
                            userId: int.parse(widget.userId!),
                            libraryId: deleteLibraryId));
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.undo,
                              size: 18,
                              color: AppColor.primaryColor,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              StringLocalization.of(context)
                                  .getText(StringLocalization.untrash),
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
              _libraryDetailNotifierModel.currentScreen !=
                      StringLocalization.of(context)
                          .getText(StringLocalization.bin)
                  ? GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LinkSharePage(
                                  userId: int.parse(widget.userId!),
                                  libraryId: deleteLibraryId,
                                  url: url,
                                )));
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.attach_file,
                              size: 18,
                              color: AppColor.primaryColor,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              StringLocalization.of(context)
                                  .getText(StringLocalization.shareLink),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              // _createContainer(
              //     StringLocalization.of(context)
              //         .getText(StringLocalization.remove),
              //     Icons.delete,
              //     deleteLibraryId,
              //     deleteDialog),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return ChangeNotifierProvider<LibraryDetailNotifierModel>.value(
      value: _libraryDetailNotifierModel,
      child: Consumer<LibraryDetailNotifierModel>(
        builder: (context, detailModel, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              title: Text(detailModel.currentScreen,
                  style: TextStyle(
                      fontSize: 18,
                      color: HexColor.fromHex("62CBC9"),
                      fontWeight: FontWeight.bold)),
              leading: IconButton(
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
                onPressed: () {
                  libraryBloc!.add(FetchLibraryEvent(
                    userId: widget.userId,
//                libraryId: parentIdList.indexOf(parentIdList.length-2),//[0,59,62]
                    libraryId: widget.pID,
                    pageId: 1,
                  ));
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Column(
              children: [
                detailModel.isSearchOpen ? searchTextField() : Container(),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      _openBottomActionSheetForSorting();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Text(detailModel.sortBy),
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
                BlocListener(
                  bloc: libraryBloc,
                  listener: (context, state) {
                    if (state is LibraryFolderCreateSuccessState) {
                      // Scaffold.of(context).showSnackBar(SnackBar(
                      //     content: Text('Created Folder Successfully')));

                      CustomSnackBar.buildSnackbar(
                          context,
                          StringLocalization.of(context).getText(
                              StringLocalization.createdFolderSuccessfully),
                          3);
                    } else if (state is LibraryFolderDeleteSuccessState) {
                      if (state.deleteFolderModel.result!) {
                        // Scaffold.of(context).showSnackBar(SnackBar(
                        //     content: Text('Deleted Folder/File Successfully')));

                        CustomSnackBar.buildSnackbar(
                            context,
                            StringLocalization.of(context).getText(
                                StringLocalization
                                    .deletedFileFolderSuccessfully),
                            3);
                        detailModel
                            .deleteDataFromApiID(state.deleteFolderModel.iD!);
                      }
                    } else if (state is LibraryIsLoadedState) {
                      if (state.libraryDetailModel!.result!) {
                        detailModel.clearDataList();
                        detailModel.addToDataList(
                            state.libraryDetailModel!.data!.reversed.toList());
                      }
                    } else if (state is LibraryFolderUploadSuccessfulState) {
                      // Scaffold.of(context).showSnackBar(
                      //     SnackBar(content: Text('Uploaded Successfully')));

                      CustomSnackBar.buildSnackbar(
                          context,
                          StringLocalization.of(context)
                              .getText(StringLocalization.uploadedSuccessfully),
                          3);
                      detailModel.changeIsUploading();
                    } else if (state is LibraryFolderUploadUnsuccessfulState) {
                      detailModel.changeIsUploading();
                      // Scaffold.of(context).showSnackBar(
                      //     SnackBar(content: Text('Error while uploading')));

                      CustomSnackBar.buildSnackbar(
                          context,
                          StringLocalization.of(context)
                              .getText(StringLocalization.errorWhileUploading),
                          3);
                    } else if (state is LibraryFolderDeleteUnsuccessfulState) {
                      // Scaffold.of(context).showSnackBar(
                      //     SnackBar(content: Text('Error while deleting')));

                      CustomSnackBar.buildSnackbar(
                          context,
                          StringLocalization.of(context)
                              .getText(StringLocalization.errorWhileDeleting),
                          3);
                    }
                  },
                  child: Container(),
                ),
                BlocBuilder<LibraryBloc, LibraryState>(
                  builder: (context, state) {
                    if (state is LibraryIsLoadingState) {
                      return Container(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is LibraryFolderCreateSuccessState) {
                      return Container(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return detailModel.dataList.length > 0
                          ? Container(
                              child: Expanded(
                                child: ListView.builder(
                                  itemCount: detailModel.dataList.length,
                                  itemBuilder: (context, index) {
                                    return Slidable(
                                      actionPane: SlidableDrawerActionPane(),
                                      actionExtentRatio: 0.25,
                                      secondaryActions: <Widget>[
                                        IconSlideAction(
                                          caption: StringLocalization.of(
                                                  context)
                                              .getText(
                                                  StringLocalization.delete),
                                          color: Colors.red,
                                          icon: Icons.delete,
                                          topMargin: 25,
                                          height: 70,
                                          leftMargin: 13,
                                          rightMargin: 13,
                                          onTap: () {
                                            // do something
                                            deleteDialog(
                                              widget.userId.toString(),
                                              detailModel
                                                  .dataList[index].libraryID!,
                                              detailModel.libraryId,
                                            );
                                          },
                                        ),
                                      ],
                                      child: Container(
                                        height: 70,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? HexColor.fromHex("#111B1A")
                                                : AppColor.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? HexColor.fromHex(
                                                            "#D1D9E6")
                                                        .withOpacity(0.1)
                                                    : Colors.white,
                                                blurRadius: 4,
                                                spreadRadius: 0,
                                                offset: Offset(-4, -4),
                                              ),
                                              BoxShadow(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.black
                                                        .withOpacity(0.75)
                                                    : HexColor.fromHex(
                                                            "#9F2DBC")
                                                        .withOpacity(0.15),
                                                blurRadius: 4,
                                                spreadRadius: 0,
                                                offset: Offset(4, 4),
                                              ),
                                            ]),
                                        margin:
                                            EdgeInsets.fromLTRB(13, 18, 13, 0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // go to detail of the folder
                                            // if file then open the file
                                            if (detailModel
                                                .dataList[index].isFolder!) {
                                              // open folder navigate to detail page
                                              if (detailModel.currentScreen !=
                                                  StringLocalization.of(context)
                                                      .getText(
                                                          StringLocalization
                                                              .bin)) {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LibraryNewDetailScreen(
                                                              userId: widget
                                                                  .userId
                                                                  .toString(),
                                                              libraryId:
                                                                  detailModel
                                                                      .dataList[
                                                                          index]
                                                                      .libraryID,
                                                              title: detailModel
                                                                  .dataList[
                                                                      index]
                                                                  .virtualFilePath,
                                                              folderPath:
                                                                  detailModel
                                                                      .dataList[
                                                                          index]
                                                                      .physicalFilePath,
                                                              pID: detailModel
                                                                  .dataList[
                                                                      index]
                                                                  .parentID,
                                                            )));
                                              }
                                            } else {
                                              // open file
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LibraryWebView(
                                                              title: detailModel
                                                                  .dataList[
                                                                      index]
                                                                  .virtualFilePath,
                                                              url: detailModel
                                                                  .dataList[
                                                                      index]
                                                                  .physicalFilePath)));
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? HexColor.fromHex(
                                                        "#111B1A")
                                                    : AppColor.backgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex(
                                                                  "#9F2DBC")
                                                              .withOpacity(0.15)
                                                          : HexColor.fromHex(
                                                                  "#D1D9E6")
                                                              .withOpacity(0.5),
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex(
                                                                  "#9F2DBC")
                                                              .withOpacity(0)
                                                          : HexColor.fromHex(
                                                                  "#FFDFDE")
                                                              .withOpacity(0),
                                                    ])),
                                            child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.black12,
                                                  child: Icon(
                                                    detailModel.dataList[index]
                                                            .isFolder!
                                                        ? Icons.folder
                                                        : Icons
                                                            .insert_drive_file,
                                                    color:
                                                        AppColor.primaryColor,
                                                  ),
                                                ),
                                                title: Text(
                                                  detailModel.dataList[index]
                                                          .virtualFilePath ??
                                                      '',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text(DateUtil()
                                                    .toDateFromTimestamp(detailModel
                                                            .dataList[index]
                                                            .createdDateTimeStamp ??
                                                        DateTime.now()
                                                            .millisecondsSinceEpoch
                                                            .toString())
                                                    .toString()),
                                                trailing: IconButton(
                                                  icon: Icon(Icons.more_vert),
                                                  onPressed: () {
                                                    _openBottomActionSheetForDetail(
                                                        detailModel
                                                            .dataList[index]
                                                            .virtualFilePath!,
                                                        detailModel
                                                            .dataList[index]
                                                            .libraryID!,
                                                        detailModel
                                                            .dataList[index]
                                                            .physicalFilePath!);
                                                  },
                                                )),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Container(
                              child: Expanded(
                                  child: Text(StringLocalization.of(context)
                                      .getText(
                                          StringLocalization.noRecordsFound))),
                            );
                    }
                  },
                ),
                detailModel.isUploading
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 15,
                            ),
                            Text(StringLocalization.of(context).getText(
                                StringLocalization.yoursFilesAreUploading))
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
            floatingActionButton: detailModel.currentScreen == 'Bin'
                ? null
                : CustomFloatingActionButton(
                    onTap: () {
                      _showBottomActionSheetForAddingFolderAndUpload();
                    },
                  ),
          );
        },
      ),
    );
  }
}
