import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/Library/LibraryWebView.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_bloc.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_event.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_state.dart';
import 'package:health_gauge/screens/Library_changes/library_detail_screen.dart';
import 'package:health_gauge/screens/Library_changes/link_share.dart';
import 'package:health_gauge/screens/Library_changes/models/library_notifier_model.dart';
import 'package:health_gauge/screens/Library_changes/user_share.dart';
import 'package:health_gauge/screens/Library_changes/widgets/libraryDrawerItems.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/drawer_items.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable_action_pane.dart';
import 'package:health_gauge/utils/slider/src/widgets/slide_action.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_floating_action_button.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LibraryNewHomeScreen extends StatefulWidget {
  final int userId;

  LibraryNewHomeScreen(this.userId);

  @override
  _LibraryNewHomeScreenState createState() => _LibraryNewHomeScreenState();
}

class _LibraryNewHomeScreenState extends State<LibraryNewHomeScreen> {
  late LibraryBloc libraryBloc;
  late LibraryNotifierModel _libraryNotifierModel = LibraryNotifierModel();
  late TextEditingController _searchController;
  late TextEditingController _createFolderController;
  String? initValue = 'Untitled Folder';
  IconData? icon = Icons.arrow_upward;
  List<List<String>>? fileNameList = [];
  List<String>? base64FileList = [];
  List<String>? fileExtensionList = [];
  List<List<int>>? libraryIdList = [];
  // bool openKeyboardFolder = false;
  FocusNode? openKeyboardFocus = new FocusNode();
  DateFormat uploadDateTimeFormatter = DateUtil().getDateFormatter(formatType:DateUtil.yyyyMMddhhmm_a);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createFolderController = TextEditingController(text: initValue);
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    libraryBloc = BlocProvider.of<LibraryBloc>(context);
    libraryBloc.add(FetchLibraryEvent(
      userId: widget.userId.toString(),
      libraryId: _libraryNotifierModel.libraryId,
      pageId: _libraryNotifierModel.pageId,
    ));
  }

  @override
  void dispose() {
    super.dispose();
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
    return Container(
      padding: EdgeInsets.only(top: 16, left: 13, right: 13),
      child: Container(
        height: 56,
        decoration: ConcaveDecoration(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            depression: 7,
            colors: [
              Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#000000").withOpacity(0.8)
                  : HexColor.fromHex("#D1D9E6"),
              Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                  : Colors.white,
            ]),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: TextField(
            controller: _searchController,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                    : HexColor.fromHex("#384341")),
            onChanged: (value) {
              _libraryNotifierModel.searchData(value);
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: StringLocalization.of(context)
                    .getText(StringLocalization.search),
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex("#FFFFFF").withOpacity(0.38)
                      : HexColor.fromHex("#7F8D8C"),
                )),
          ),
        ),
      ),
    );
  }

  _createContainerForOpeningSorting(title, sortby) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          // print("clicked $title");
          // Navigator.of(context).pop();
          // _libraryNotifierModel.changeSortBy(title);
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: _libraryNotifierModel.sortBy == title
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
                  _libraryNotifierModel.sortBy),
              _createContainerForOpeningSorting(
                  StringLocalization.of(context)
                      .getText(StringLocalization.lastModified),
                  _libraryNotifierModel.sortBy),
              _createContainerForOpeningSorting(
                  StringLocalization.of(context)
                      .getText(StringLocalization.lastModifiedByMe),
                  _libraryNotifierModel.sortBy),
              _createContainerForOpeningSorting(
                  StringLocalization.of(context)
                      .getText(StringLocalization.lastOpenedByMe),
                  _libraryNotifierModel.sortBy),
            ],
          ),
        );
      },
    );
  }

  void getFileName(List<File> file) async {
    print(fileNameList);
    print(base64FileList!.length);
    if (file.isNotEmpty) {
      libraryBloc.add(LibraryUploadFolderEvent(
        filePath: file,
        libraryId: _libraryNotifierModel.libraryId,
        userId: widget.userId.toString(),
        folderPath: '/Content/LibraryDocument',
      ));
      _libraryNotifierModel.changeIsUploading();
      fileNameList = [];
      fileExtensionList = [];
      base64FileList = [];
    }
  }

  Future<void> loadAssets() async {
    List<File> resultsList = List<File>.empty();
    String error = 'No Error Detected';

    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, allowCompression: true);
      if (result != null) {
        resultsList = result.paths.map((path) => File(path!)).toList();
      }

      //  resultsList = await FilePicker.getMultiFile(allowCompression: true);
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
                      //         title: Text(stringLocalization.getText(
                      //             StringLocalization.createFolder)),
                      //         content: Container(
                      //           child: TextField(
                      //             controller: _createFolderController,
                      //             decoration: InputDecoration(hintText: ''),
                      //           ),
                      //         ),
                      //         actions: <Widget>[
                      //           FlatButton(
                      //             child: Text(
                      //               stringLocalization.getText(
                      //                   StringLocalization.cancel),
                      //               style: TextStyle(color: AppColor.red),
                      //             ),
                      //             onPressed: () {
                      //               Navigator.of(context).pop();
                      //             },
                      //           ),
                      //           FlatButton(
                      //             child: Text(
                      //               stringLocalization.getText(
                      //                   StringLocalization.create),
                      //               style:
                      //                   TextStyle(color: AppColor.primaryColor),
                      //             ),
                      //             onPressed: () {
                      //               print(_createFolderController.text);
                      //               libraryBloc.add(LibraryCreateFolderEvent(
                      //                 userId: widget.userId.toString(),
                      //                 libraryId:
                      //                     _libraryNotifierModel.libraryId,
                      //                 folderName: _createFolderController.text,
                      //                 folderPath: null,
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
                                                                _libraryNotifierModel
                                                                    .changeKeyboard(
                                                                        true);
                                                                true;
                                                                openKeyboardFocus!
                                                                    .requestFocus();
                                                                // setState(() {});
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 10
                                                                            .w,
                                                                        right: 10
                                                                            .w),
                                                                decoration: _libraryNotifierModel
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
                                                                  ignoring: _libraryNotifierModel
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
                                                              _createFolderController
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
                                                                      print(_createFolderController
                                                                          .text);
                                                                      libraryBloc
                                                                          .add(
                                                                              LibraryCreateFolderEvent(
                                                                        userId: widget
                                                                            .userId
                                                                            .toString(),
                                                                        libraryId:
                                                                            _libraryNotifierModel.libraryId,
                                                                        folderName:
                                                                            _createFolderController.text,
                                                                        folderPath:
                                                                            null,
                                                                      ));
                                                                      _createFolderController =
                                                                          TextEditingController(
                                                                              text: initValue);
                                                                      _createFolderController
                                                                              .selection =
                                                                          new TextSelection(
                                                                        baseOffset:
                                                                            0,
                                                                        extentOffset:
                                                                            initValue!.length,
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
                      // print("Clicked file upload");
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
          print("clicked $name");
          if (dLibraryId != null) {
            deleteDialog(widget.userId.toString(), dLibraryId,
                _libraryNotifierModel.libraryId);
            Navigator.of(context).pop();
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
    // return showDialog(
    //     context: context,
    //     useRootNavigator: true,
    //     builder: (context) => Dialog(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //         elevation: 0,
    //         backgroundColor: Theme.of(context).brightness == Brightness.dark
    //             ? HexColor.fromHex("#111B1A")
    //             : AppColor.backgroundColor,
    //         child: Container(
    //             decoration: BoxDecoration(
    //                 color: Theme.of(context).brightness == Brightness.dark
    //                     ? HexColor.fromHex("#111B1A")
    //                     : AppColor.backgroundColor,
    //                 borderRadius: BorderRadius.circular(10),
    //                 boxShadow: [
    //                   BoxShadow(
    //                     color: Theme.of(context).brightness == Brightness.dark
    //                         ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
    //                         : HexColor.fromHex("#DDE3E3").withOpacity(0.3),
    //                     blurRadius: 5,
    //                     spreadRadius: 0,
    //                     offset: Offset(-5, -5),
    //                   ),
    //                   BoxShadow(
    //                     color: Theme.of(context).brightness == Brightness.dark
    //                         ? HexColor.fromHex("#000000").withOpacity(0.75)
    //                         : HexColor.fromHex("#384341").withOpacity(0.9),
    //                     blurRadius: 5,
    //                     spreadRadius: 0,
    //                     offset: Offset(5, 5),
    //                   ),
    //                 ]),
    //             padding: EdgeInsets.only(
    //               top: 33,
    //               left: 26,
    //             ),
    //             height: 128,
    //             width: 309,
    //             child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   SizedBox(
    //                     height: 25,
    //                     child: Body1AutoText(
    //                       text: _libraryNotifierModel.currentScreen ==
    //                               StringLocalization.of(context)
    //                                   .getText(StringLocalization.bin)
    //                           ? StringLocalization.of(context).getText(
    //                                   StringLocalization.deletePermanently) +
    //                               "?"
    //                           : StringLocalization.of(context)
    //                                   .getText(StringLocalization.delete) +
    //                               '?',
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.w600,
    //                       color: Theme.of(context).brightness == Brightness.dark
    //                           ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
    //                           : HexColor.fromHex("#384341"),
    //                       maxLine: 1,
    //                       minFontSize: 8,
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 20,
    //                   ),
    //                   Row(mainAxisAlignment: MainAxisAlignment.end,
    //                       //mainAxisSize: MainAxisSize.min,
    //                       children: [
    //                         FlatButton(
    //                           child: SizedBox(
    //                             height: 25,
    //                             child: Body1AutoText(
    //                               text: StringLocalization.of(context)
    //                                   .getText(StringLocalization.cancel),
    //                               fontSize: 16,
    //                               fontWeight: FontWeight.bold,
    //                               color: HexColor.fromHex("#00AFAA"),
    //                               minFontSize: 8,
    //                               maxLine: 1,
    //                             ),
    //                           ),
    //                           onPressed: () async {
    //                             if (context != null) {
    //                               Navigator.of(context).pop();
    //                             }
    //                           },
    //                         ),
    //                         //SizedBox(width: 42,),
    //                         FlatButton(
    //                           child: SizedBox(
    //                             height: 25,
    //                             child: Body1AutoText(
    //                               text: StringLocalization.of(context)
    //                                   .getText(StringLocalization.ok)
    //                                   .toUpperCase(),
    //                               fontSize: 16,
    //                               fontWeight: FontWeight.bold,
    //                               color: HexColor.fromHex("#00AFAA"),
    //                               maxLine: 1,
    //                               minFontSize: 8,
    //                             ),
    //                           ),
    //                           onPressed: () async {
    //                             if (_libraryNotifierModel.currentScreen ==
    //                                 StringLocalization.of(context)
    //                                     .getText(StringLocalization.bin)) {
    //                               libraryBloc
    //                                   .add(LibraryDeleteFolderPermanentlyEvent(
    //                                 userId: widget.userId.toString(),
    //                                 deleteLibraryId: dLibraryId,
    //                                 libraryId: libraryId,
    //                               ));
    //                             } else if (_libraryNotifierModel
    //                                     .currentScreen ==
    //                                 StringLocalization.of(context).getText(
    //                                     StringLocalization.shareWithMe)) {
    //                               libraryBloc.add(DeleteSharedEvent(
    //                                 userId: widget.userId.toString(),
    //                                 deleteLibraryId: dLibraryId,
    //                                 libraryId: libraryId,
    //                               ));
    //                             } else {
    //                               libraryBloc.add(LibraryDeleteFolderEvent(
    //                                 userId: widget.userId.toString(),
    //                                 deleteLibraryId: dLibraryId,
    //                                 libraryId: libraryId,
    //                               ));
    //                             }
    //
    //                             Navigator.of(context).pop();
    //                           },
    //                         )
    //                       ])
    //                 ]))));
    return showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => CustomDialog(
              onClickYes: () {
                if (_libraryNotifierModel.currentScreen ==
                    StringLocalization.of(context)
                        .getText(StringLocalization.bin)) {
                  libraryBloc.add(LibraryDeleteFolderPermanentlyEvent(
                    userId: widget.userId.toString(),
                    deleteLibraryId: dLibraryId,
                    libraryId: libraryId,
                  ));
                } else if (_libraryNotifierModel.currentScreen ==
                    StringLocalization.of(context)
                        .getText(StringLocalization.shareWithMe)) {
                  libraryBloc.add(DeleteSharedEvent(
                    userId: widget.userId.toString(),
                    deleteLibraryId: dLibraryId,
                    libraryId: libraryId,
                  ));
                } else {
                  libraryBloc.add(LibraryDeleteFolderEvent(
                    userId: widget.userId.toString(),
                    deleteLibraryId: dLibraryId,
                    libraryId: libraryId,
                  ));
                }
                Navigator.of(context).pop();
              },
              onClickNo: () {
                if (context != null) {
                  Navigator.of(context).pop();
                }
              },
              title: _libraryNotifierModel.currentScreen ==
                      StringLocalization.of(context)
                          .getText(StringLocalization.bin)
                  ? StringLocalization.of(context)
                          .getText(StringLocalization.deletePermanently) +
                      "?"
                  : StringLocalization.of(context)
                          .getText(StringLocalization.delete) +
                      '?',
              subTitle: StringLocalization.of(context)
                  .getText(StringLocalization.deleteDialogMessage),
            ));
  }

  _openBottomActionSheetForDetail(
      String name, int deleteLibraryId, String url) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 250.h,
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
              _libraryNotifierModel.currentScreen !=
                      StringLocalization.of(context)
                          .getText(StringLocalization.bin)
                  ? _libraryNotifierModel.currentScreen !=
                          StringLocalization.of(context)
                              .getText(StringLocalization.shareWithMe)
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserSharePage(
                                    widget.userId, deleteLibraryId)));
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.share,
                                  size: 18,
                                  color: AppColor.primaryColor,
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Text(
                                  StringLocalization.of(context).getText(
                                      StringLocalization.shareWithUser),
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
                      : Container()
                  : GestureDetector(
                      onTap: () {
                        print("clicked $name");
                        libraryBloc.add(LibraryRestoreEvent(
                            userId: widget.userId, libraryId: deleteLibraryId));
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
                              width: 15.w,
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
              _libraryNotifierModel.currentScreen !=
                      StringLocalization.of(context)
                          .getText(StringLocalization.bin)
                  ? _libraryNotifierModel.currentScreen !=
                          StringLocalization.of(context)
                              .getText(StringLocalization.shareWithMe)
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LinkSharePage(
                                      userId: widget.userId,
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
                                  width: 15.w,
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
                      : Container()
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
    return ChangeNotifierProvider<LibraryNotifierModel>.value(
      value: _libraryNotifierModel,
      child: Consumer<LibraryNotifierModel>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
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
              title: Text(model.currentScreen,
                  style: TextStyle(
                      fontSize: 18,
                      color: HexColor.fromHex("62CBC9"),
                      fontWeight: FontWeight.bold)),
              actions: <Widget>[
                model.isSearchOpen
                    ? IconButton(
                        padding: EdgeInsets.only(right: 15),
                        icon: Theme.of(context).brightness == Brightness.dark
                            ? Image.asset(
                                "asset/dark_close.png",
                                width: 33,
                                height: 33,
                              )
                            : Image.asset(
                                "asset/close.png",
                                width: 33,
                                height: 33,
                              ),
                        onPressed: () {
                          model.changeIsSearchOpen();
                        },
                      )
                    : IconButton(
                        //padding: EdgeInsets.only(right: 15),
                        icon: Theme.of(context).brightness == Brightness.dark
                            ? Image.asset(
                                "asset/dark_search.png",
                                width: 33,
                                height: 33,
                              )
                            : Image.asset(
                                "asset/search.png",
                                width: 33,
                                height: 33,
                              ),
                        onPressed: () {
                          model.changeIsSearchOpen();
                        },
                      ),
                Builder(builder: (BuildContext context) {
                  return IconButton(
                    padding: EdgeInsets.only(right: 15),
                    icon: Theme.of(context).brightness == Brightness.dark
                        ? Image.asset(
                            "asset/dark_dots.png",
                            width: 33,
                            height: 28,
                          )
                        : Image.asset(
                            'asset/dots.png',
                            width: 33,
                            height: 28,
                          ),
                    onPressed: () {
                      // updateMailListNumbers();
                      Scaffold.of(context).openEndDrawer();
                    },
                  );
                }),
                // PopupMenuButton(
                //   icon: Image.asset(
                //     Theme.of(context).brightness == Brightness.dark
                //         ? 'asset/dark_buregr_menu_icon.png'
                //         : 'asset/buregr_menu_icon.png',
                //     height: 32,
                //     width: 32,
                //   ),
                //   onSelected: (value) {
                //     if (value ==
                //         StringLocalization.of(context)
                //             .getText(StringLocalization.shareWithMe)) {
                //       libraryBloc.add(FetchLibraryEvent(
                //         userId: widget.userId.toString(),
                //         libraryId: 0,
                //         pageId: 2,
                //       ));
                //       model.changeCurrentScreen(value);
                //       model.changePageID(2);
                //       model.clearDataList();
                //       if (model.isSearchOpen) {
                //         model.changeIsSearchOpen();
                //       }
                //     } else if (value ==
                //         StringLocalization.of(context)
                //             .getText(StringLocalization.bin)) {
                //       libraryBloc.add(FetchLibraryEvent(
                //         userId: widget.userId.toString(),
                //         //
                //         libraryId: 0,
                //         pageId: 3,
                //       ));
                //       model.changeCurrentScreen(value);
                //       model.changePageID(3);
                //       model.clearDataList();
                //       if (model.isSearchOpen) {
                //         model.changeIsSearchOpen();
                //       }
                //     } else if (value ==
                //         StringLocalization.of(context)
                //             .getText(StringLocalization.myDrive)) {
                //       libraryBloc.add(FetchLibraryEvent(
                //         userId: widget.userId.toString(),
                //         libraryId: 0,
                //         pageId: 1,
                //       ));
                //       model.changeCurrentScreen(value);
                //       model.changePageID(1);
                //       model.clearDataList();
                //       if (model.isSearchOpen) {
                //         model.changeIsSearchOpen();
                //       }
                //     }
                //   },
                //   itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                //     PopupMenuItem(
                //       value: StringLocalization.of(context)
                //           .getText(StringLocalization.myDrive),
                //       child: popUpMenuTile(
                //           iconData: Icons.insert_drive_file,
                //           title: StringLocalization.of(context)
                //               .getText(StringLocalization.myDrive),
                //           count: 0,
                //           selected: model.currentScreen),
                //     ),
                //     PopupMenuItem(
                //       value: StringLocalization.of(context)
                //           .getText(StringLocalization.shareWithMe),
                //       child: popUpMenuTile(
                //           iconData: Icons.share,
                //           title: StringLocalization.of(context)
                //               .getText(StringLocalization.shareWithMe),
                //           count: 0,
                //           selected: model.currentScreen),
                //     ),
                //     PopupMenuItem(
                //       value: StringLocalization.of(context)
                //           .getText(StringLocalization.bin),
                //       child: popUpMenuTile(
                //           iconData: Icons.delete,
                //           title: StringLocalization.of(context)
                //               .getText(StringLocalization.bin),
                //           count: 0,
                //           selected: model.currentScreen),
                //     ),
                //   ],
                // ),
              ],
            ),
            endDrawer: Container(
                width: 220.w,
                child: Drawer(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColor.darkBackgroundColor
                        : AppColor.backgroundColor,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        healthGauge(),
                        GestureDetector(
                            onTap: () {
                              libraryBloc.add(FetchLibraryEvent(
                                userId: widget.userId.toString(),
                                libraryId: 0,
                                pageId: 1,
                              ));
                              model.changeCurrentScreen(
                                  StringLocalization.of(context)
                                      .getText(StringLocalization.myDrive));
                              model.changePageID(1);
                              model.clearDataList();
                              if (model.isSearchOpen) {
                                model.changeIsSearchOpen();
                              }
                              Navigator.pop(context);
                            },
                            child: LibraryDrawerItems(
                                title: StringLocalization.myDrive,
                                icon: Icons.insert_drive_file,
                                iconPath: 'asset/inbox_icon.png',
                                selectedItem: model.currentScreen)),
                        GestureDetector(
                            onTap: () {
                              libraryBloc.add(FetchLibraryEvent(
                                userId: widget.userId.toString(),
                                libraryId: 0,
                                pageId: 2,
                              ));
                              model.changeCurrentScreen(
                                  StringLocalization.of(context)
                                      .getText(StringLocalization.shareWithMe));
                              model.changePageID(2);
                              model.clearDataList();
                              if (model.isSearchOpen) {
                                model.changeIsSearchOpen();
                              }
                              Navigator.pop(context);
                            },
                            child: LibraryDrawerItems(
                                icon: Icons.share,
                                title: StringLocalization.shareWithMe,
                                iconPath: "asset/sent.png",
                                selectedItem: model.currentScreen)),
                        GestureDetector(
                            onTap: () {
                              libraryBloc.add(FetchLibraryEvent(
                                userId: widget.userId.toString(),
                                //
                                libraryId: 0,
                                pageId: 3,
                              ));
                              model.changeCurrentScreen(
                                  StringLocalization.of(context)
                                      .getText(StringLocalization.bin));
                              model.changePageID(3);
                              model.clearDataList();
                              if (model.isSearchOpen) {
                                model.changeIsSearchOpen();
                              }
                              Navigator.pop(context);
                            },
                            child: LibraryDrawerItems(
                                icon: Icons.delete,
                                title: StringLocalization.bin,
                                iconPath: "asset/draft.png",
                                selectedItem: model.currentScreen)),
                      ],
                    ),
                  ),
                )),
            endDrawerEnableOpenDragGesture: false,
            body: Column(
              children: [
                model.isSearchOpen ? searchTextField() : Container(),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      //  _openBottomActionSheetForSorting();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Text(model.sortBy),
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
                    }
                    else if (state is LibraryFolderDeleteSuccessState) {
                      if (state.deleteFolderModel.result!) {
                        // Scaffold.of(context).showSnackBar(SnackBar(
                        //     content: Text('Deleted Folder/File Successfully')));

                        CustomSnackBar.buildSnackbar(
                            context,
                            StringLocalization.of(context).getText(
                                StringLocalization
                                    .deletedFileFolderSuccessfully),
                            3);
                        model.deleteDataFromApiID(state.deleteFolderModel.iD!);
                      }
                    }
                    else if (state is LibraryIsLoadedState) {
                      if (state.libraryDetailModel!.result!) {
                        if (model.isUploading) {
                          model.changeIsUploading();
                        }
                        model.clearDataList();
                        model.addToDataList(
                            state.libraryDetailModel!.data!.reversed.toList());
                      }
                    }
                    else if (state is RestoredSuccessState) {
                      if (state.deleteFolderModel.result!) {
                        // Scaffold.of(context).showSnackBar(SnackBar(
                        //     content:
                        //         Text('Restored Folder/File Successfully')));
                        CustomSnackBar.buildSnackbar(
                            context,
                            StringLocalization.of(context).getText(
                                StringLocalization
                                    .restoredFileFolderSuccessfully),
                            3);
                        model.deleteDataFromApiID(state.deleteFolderModel.iD!);
                      }
                    }
                    else if (state is LibraryFolderUploadSuccessfulState) {
                      // Scaffold.of(context).showSnackBar(
                      //     SnackBar(content: Text('Uploaded Successfully')));

                      CustomSnackBar.buildSnackbar(
                          context,
                          StringLocalization.of(context)
                              .getText(StringLocalization.uploadedSuccessfully),
                          3);
                      model.changeIsUploading();
                    }
                    else if (state is LibraryFolderUploadUnsuccessfulState) {
                      model.changeIsUploading();
                      // Scaffold.of(context).showSnackBar(
                      //     SnackBar(content: Text('Error while uploading')));
                      CustomSnackBar.buildSnackbar(
                          context,
                          StringLocalization.of(context)
                              .getText(StringLocalization.errorWhileUploading),
                          3);
                    }
                    else if (state is LibraryFolderDeleteUnsuccessfulState) {
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
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else if (state is LibraryFolderCreateSuccessState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else {
                      return (model.isSearchOpen||model.searchList.isNotEmpty)
                          ? model.searchList.isNotEmpty
                              ? Container(
                                  child: Expanded(
                                    child: ListView.builder(
                                      itemCount: model.searchList.length,
                                      itemBuilder: (context, index) {
                                        return Slidable(
                                          actionPane:
                                              SlidableDrawerActionPane(),
                                          actionExtentRatio: 0.25,
                                          // actions: model.currentScreen == StringLocalization.of(context)
                                          //     .getText(
                                          //     StringLocalization
                                          //         .bin) ? [
                                          //   Padding(
                                          //     padding: EdgeInsets.only(
                                          //         bottom:
                                          //              15),
                                          //     child: IconSlideAction(
                                          //       color: HexColor.fromHex("#00AFAA"),
                                          //       onTap: () {
                                          //         libraryBloc.add(LibraryRestoreEvent(
                                          //             userId: widget.userId, libraryId: model.searchList[index].libraryID));
                                          //         // Navigator.of(context).pop();
                                          //         // CustomSnackBar.buildSnackbar(
                                          //         //     context,
                                          //         //     StringLocalization.of(context)
                                          //         //         .getText(StringLocalization
                                          //         //         .emailRestoredSuccessfully),
                                          //         //     3);
                                          //       },
                                          //       iconWidget: Body1AutoText(
                                          //         text: StringLocalization.of(context)
                                          //             .getText(StringLocalization.untrash),
                                          //         fontSize: 16,
                                          //         fontWeight: FontWeight.bold,
                                          //         color: AppColor.backgroundColor,
                                          //         maxLine: 1,
                                          //         minFontSize: 2,
                                          //       ),
                                          //       topMargin: 18,
                                          //       height: 70,
                                          //       leftMargin: 13,
                                          //       rightMargin: 0,
                                          //     ),
                                          //   )
                                          // ] : null,
                                          secondaryActions: <Widget>[
                                            IconSlideAction(
                                              caption:
                                                  StringLocalization.of(context)
                                                      .getText(
                                                          StringLocalization
                                                              .delete),
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
                                                  model.searchList[index]
                                                      .libraryID!,
                                                  model.libraryId,
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
                                                    ? HexColor.fromHex(
                                                        "#111B1A")
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
                                            margin: EdgeInsets.fromLTRB(
                                                13, 18, 13, 0),
                                            child: GestureDetector(
                                              onTap: () {
                                                // go to detail of the folder
                                                // if file then open the file
                                                if (model.searchList[index]
                                                    .isFolder!) {
                                                  // open folder navigate to detail page
                                                  if (model.currentScreen !=
                                                      StringLocalization.of(
                                                              context)
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
                                                                  libraryId: model
                                                                      .dataList[
                                                                          index]
                                                                      .libraryID,
                                                                  title: model
                                                                      .dataList[
                                                                          index]
                                                                      .virtualFilePath,
                                                                  folderPath: model
                                                                      .dataList[
                                                                          index]
                                                                      .physicalFilePath,
                                                                  pID: model
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
                                                                  title: model
                                                                      .dataList[
                                                                          index]
                                                                      .virtualFilePath,
                                                                  url: model
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
                                                        : AppColor
                                                            .backgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? HexColor.fromHex(
                                                                      "#9F2DBC")
                                                                  .withOpacity(
                                                                      0.15)
                                                              : HexColor.fromHex(
                                                                      "#D1D9E6")
                                                                  .withOpacity(
                                                                      0.5),
                                                          Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? HexColor.fromHex(
                                                                      "#9F2DBC")
                                                                  .withOpacity(
                                                                      0)
                                                              : HexColor.fromHex(
                                                                      "#FFDFDE")
                                                                  .withOpacity(
                                                                      0),
                                                        ])),
                                                child: ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.black12,
                                                      child: Icon(
                                                        model.searchList[index]
                                                                .isFolder!
                                                            ? Icons.folder
                                                            : Icons
                                                                .insert_drive_file,
                                                        color: AppColor
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    title: Text(
                                                      model.searchList[index]
                                                          .virtualFilePath ??
                                                          '',
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                    subtitle: Text(uploadDateTimeFormatter.format(DateUtil()
                                                        .toDateFromTimestamp(
                                                        model
                                                            .searchList[
                                                        index]
                                                            .createdDateTimeStamp ??
                                                            DateTime
                                                                .now()
                                                                .millisecondsSinceEpoch
                                                                .toString()))
                                                        .toString()),
                                                    trailing: model.currentScreen ==
                                                        StringLocalization.of(context).getText(StringLocalization.shareWithMe)?null:IconButton(
                                                      icon:
                                                      Icon(Icons.more_vert),
                                                      onPressed: () {
                                                        _openBottomActionSheetForDetail(
                                                            model
                                                                .searchList[
                                                            index]
                                                                .virtualFilePath!,
                                                            model
                                                                .searchList[
                                                                    index]
                                                                .libraryID!,
                                                            model
                                                                .searchList[
                                                                    index]
                                                                .physicalFilePath!);
                                                      },
                                                    )
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : Container(
                                  child: Text(StringLocalization.of(context)
                                      .getText(
                                          StringLocalization.noRecordsFound)),
                                )
                          : model.dataList.isNotEmpty
                              ? Container(
                                  child: Expanded(
                                    child: ListView.builder(
                                      itemCount: model.dataList.length,
                                      itemBuilder: (context, index) {
                                        return Slidable(
                                          actionPane:
                                              SlidableDrawerActionPane(),
                                          actionExtentRatio: 0.25,
                                          // actions: model.currentScreen == StringLocalization.of(context)
                                          //     .getText(
                                          //     StringLocalization
                                          //         .bin) ? [
                                          //   Padding(
                                          //     padding: EdgeInsets.only(
                                          //         bottom:
                                          //         15),
                                          //     child: IconSlideAction(
                                          //       color: HexColor.fromHex("#00AFAA"),
                                          //       onTap: () {
                                          //         libraryBloc.add(LibraryRestoreEvent(
                                          //             userId: widget.userId, libraryId: model.dataList[index].libraryID));
                                          //         // CustomSnackBar.buildSnackbar(
                                          //         //     context,
                                          //         //     StringLocalization.of(context)
                                          //         //         .getText(StringLocalization
                                          //         //         .emailRestoredSuccessfully),
                                          //         //     3);
                                          //       },
                                          //       iconWidget: Body1AutoText(
                                          //         text: StringLocalization.of(context)
                                          //             .getText(StringLocalization.untrash),
                                          //         fontSize: 16,
                                          //         fontWeight: FontWeight.bold,
                                          //         color: AppColor.backgroundColor,
                                          //         maxLine: 1,
                                          //         minFontSize: 2,
                                          //       ),
                                          //       topMargin: 18,
                                          //       height: 70,
                                          //       leftMargin: 13,
                                          //       rightMargin: 0,
                                          //     ),
                                          //   )
                                          // ] : null,
                                          secondaryActions: <Widget>[
                                            IconSlideAction(
                                              caption:
                                                  StringLocalization.of(context)
                                                      .getText(
                                                          StringLocalization
                                                              .delete),
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
                                                  model.dataList[index]
                                                      .libraryID!,
                                                  model.libraryId,
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
                                                    ? HexColor.fromHex(
                                                        "#111B1A")
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
                                            margin: EdgeInsets.fromLTRB(
                                                13, 18, 13, 0),
                                            child: GestureDetector(
                                              onTap: () {
                                                // go to detail of the folder
                                                // if file then open the file
                                                if (model.dataList[index]
                                                    .isFolder!) {
                                                  // open folder navigate to detail page
                                                  if (model.currentScreen !=
                                                      StringLocalization.of(
                                                              context)
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
                                                                  libraryId: model
                                                                      .dataList[
                                                                          index]
                                                                      .libraryID,
                                                                  title: model
                                                                      .dataList[
                                                                          index]
                                                                      .virtualFilePath,
                                                                  folderPath: model
                                                                      .dataList[
                                                                          index]
                                                                      .physicalFilePath,
                                                                  pID: model
                                                                      .dataList[
                                                                          index]
                                                                      .parentID,
                                                                )));
                                                    // Navigator.of(context).push(
                                                    // MaterialPageRoute(
                                                    // builder: (context) => LibraryDetailScreen(
                                                    // userId: widget.userId,
                                                    // libraryId: dataList[index].libraryID,
                                                    // title: dataList[index].virtualFilePath,
                                                    // folderPath:
                                                    // dataList[index].physicalFilePath,
                                                    // pID: dataList[index].parentID,
                                                    // ),
                                                    // ),
                                                    // );
                                                  }
                                                } else {
                                                  // open file
                                                  // print("Opening File");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LibraryWebView(
                                                                  title: model
                                                                      .dataList[
                                                                          index]
                                                                      .virtualFilePath,
                                                                  url: model
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
                                                        : AppColor
                                                            .backgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? HexColor.fromHex(
                                                                      "#9F2DBC")
                                                                  .withOpacity(
                                                                      0.15)
                                                              : HexColor.fromHex(
                                                                      "#D1D9E6")
                                                                  .withOpacity(
                                                                      0.5),
                                                          Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? HexColor.fromHex(
                                                                      "#9F2DBC")
                                                                  .withOpacity(
                                                                      0)
                                                              : HexColor.fromHex(
                                                                      "#FFDFDE")
                                                                  .withOpacity(
                                                                      0),
                                                        ])),
                                                child: ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.black12,
                                                      child: Icon(
                                                        model.dataList[index]
                                                                .isFolder!
                                                            ? Icons.folder
                                                            : Icons
                                                                .insert_drive_file,
                                                        color: AppColor
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    title: Text(
                                                      model.dataList[index]
                                                          .virtualFilePath ??
                                                          '',
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                    subtitle: Text(uploadDateTimeFormatter.format(DateUtil()
                                                        .toDateFromTimestamp(
                                                        model
                                                            .searchList[
                                                        index]
                                                            .createdDateTimeStamp ??
                                                            DateTime
                                                                .now()
                                                                .millisecondsSinceEpoch
                                                                .toString()))
                                                        .toString()),
                                                    trailing: model.currentScreen ==
                                                        StringLocalization.of(context).getText(StringLocalization.shareWithMe)?null:IconButton(
                                                      icon:
                                                      Icon(Icons.more_vert),
                                                      onPressed: () {
                                                        _openBottomActionSheetForDetail(
                                                            model
                                                                .dataList[index]
                                                                .virtualFilePath!,
                                                            model
                                                                .dataList[index]
                                                                .libraryID!,
                                                            model
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
                                  child: Text(StringLocalization.of(context)
                                      .getText(
                                          StringLocalization.noRecordsFound)),
                                );
                    }
                  },
                ),
                model.isUploading
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
            floatingActionButton: model.currentScreen ==
                        StringLocalization.of(context)
                            .getText(StringLocalization.bin) ||
                    model.currentScreen ==
                        StringLocalization.of(context)
                            .getText(StringLocalization.shareWithMe)
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

  Widget healthGauge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 58.h, left: 26.w),
          child: Body1AutoText(
            text: stringLocalization.getText(StringLocalization.library),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: HexColor.fromHex("#62CBC9"),
            maxLine: 1,
            minFontSize: 10,
          ),
        ),
        Container(
          height: 1,
          margin: EdgeInsets.only(top: 10.h, right: 7.w),
          color: HexColor.fromHex("#BDC7C5"),
        )
      ],
    );
  }
}
