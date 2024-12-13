// ignore_for_file: prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/slider/flutter_slidable.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

/// Added by: Akhil
/// Added on: June/02/2020
/// this widget is responsible for displaying listing of emails.
class Listing extends StatefulWidget {
  final Function? delete;
  final Function? open;
  final List<InboxData> data;
  final String? userEmail;
  final Function? restore;
  final ScrollController? controller;
  final Function? deleteMultiple;

  Listing(
      {required this.data,
      this.delete,
      this.open,
      this.userEmail,
      this.controller,
      this.restore,
      this.deleteMultiple});

  @override
  _ListingState createState() => _ListingState();
}

/// Added by: Akhil
/// Added on: June/02/2020
/// this class maintains the state of listing widget.
class _ListingState extends State<Listing> {
  final dbHelper = DatabaseHelper.instance;
  bool isSelection = false;
  bool selectAll = false;
  List<InboxData> selectedList = [];
  // List<InboxData> widget.data = [];

  // int increaseLength = 1;
  // ScrollController _scrollController = ScrollController();
  // int maxValue = 10;

  //@override
  // void initState() {
  //   super.initState();
  //   widget.data = widget.data.sublist(0, maxValue);
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.pixels ==
  //         _scrollController.position.maxScrollExtent) {

  //       getMoreData();
  //     }
  //   });
  // }

  // getMoreData() {
  //   if (maxValue <= widget.data.length) {
  //     for (int i = maxValue; i < maxValue + 10; i++) {
  //       widget.data = widget.data.sublist(0, maxValue);
  //     }
  //     maxValue += 10;
  //     if (widget.data.length==widget.data.length) {
  //       print(widget.data.length);
  //       print(widget.data.length);
  //       increaseLength = 0;
  //     }
  //     setState(() {});
  //   }
  // }

  /// Added by: Akhil
  /// Added on: June/02/2020
  /// this function changes isSeleted property of inboxData according to value passed to it.
  /// @param bool isSelected
  void selectAllFunc(bool value) {
    for (var i in widget.data) {
      i.isSelected = value;
    }
  }

  /// Added by: Akhil
  /// Added on: June/02/2020
  /// this function is used to insert all the selected emails into the list.
  void insertIdInList() {
    for (var v in widget.data) {
      if (v.isSelected ?? false) {
        selectedList.add(v);
      }
    }
  }

  /// Added by: Akhil
  /// Added on: June/02/2020
  /// this is lifecycle method of widget to build the UI on the screen.
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          isSelection
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      //checkbox for selecting and deselecting
                      Checkbox(
                        value: selectAll,
                        onChanged: (value) {
                          setState(() {
                            selectAll = value ?? false;
                            selectAllFunc(value ?? false);
                          });
                        },
                      ),
                      Text(StringLocalization.of(context)
                          .getText(StringLocalization.selectAll)),
                      Expanded(
                        child: Container(),
                      ),
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            isSelection = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: AppColor.red,
                        ),
                        onPressed: () {
                          insertIdInList();
                          widget.deleteMultiple!(selectedList);
                        },
                      )
                    ],
                  ),
                )
              : Container(),

          /// Added by: Akhil
          /// Added on: June/02/2020
          ///This is the listViewBuilder for all the emails.
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, index) {
                // if (index == widget.data.length && increaseLength == 1) {
                //   return Center(
                //     child: CircularProgressIndicator(),
                //   );
                // }
                return isSelection
                    ? ListTile(
                        leading: Checkbox(
                          tristate: false,
                          value: widget.data[index].isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              widget.data[index].isSelected = value ?? false;
                            });
                          },
                        ),
                        title: Text(
                          widget.data[index].messageFrom! == widget.userEmail!
                              ? widget.data[index].receiverUserName != null
                                  ? widget.data[index].receiverUserName!
                                  : widget.data[index].senderUserName != null
                                      ? widget.data[index].senderUserName!
                                      : ''
                              : '',
                          style: TextStyle(
                              fontWeight: widget.data[index].isViewed ?? false
                                  ? FontWeight.w300
                                  : FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          widget.data[index].messageSubject ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      )

                    /// Added by: Akhil
                    /// Added on: June/02/2020
                    ///this widget is providing sliding action to list tile for restoring the email from trash.
                    : Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        actions: widget.data[index].messageType == 3
                            ? <Widget>[
                                //this is for providing functionality of  restoring email from trash
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: index == (widget.data.length - 1)
                                          ? 15.h
                                          : 0),
                                  child: IconSlideAction(
                                    color: HexColor.fromHex('#00AFAA'),
                                    onTap: () {
                                      widget.restore!(
                                          widget.data[index], index);
                                      CustomSnackBar.buildSnackbar(
                                          context,
                                          StringLocalization.of(context)
                                              .getText(StringLocalization
                                                  .emailRestoredSuccessfully),
                                          3);
                                      // Scaffold.of(context)
                                      //     .showSnackBar(SnackBar(
                                      //   content: Text(
                                      //     StringLocalization.of(context)
                                      //         .getText(StringLocalization
                                      //             .emailRestoredSuccessfully),
                                      //     style: TextStyle(color: Colors.green),
                                      //     textAlign: TextAlign.center,
                                      //   ),
                                      // ));
                                      setState(() {});
                                    },
                                    iconWidget: Body1AutoText(
                                      text: StringLocalization.of(context)
                                          .getText(StringLocalization.untrash),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.backgroundColor,
                                      maxLine: 1,
                                      minFontSize: 2,
                                    ),
                                    topMargin: 18.h,
                                    height: 70.h,
                                    leftMargin: 13.w,
                                    rightMargin: 0,
                                  ),
                                )
                              ]
                            : <Widget>[],
                        secondaryActions: <Widget>[
                          /// Added by: Akhil
                          /// Added on: June/02/2020
                          ///this is for providing functionality of  deleting email.
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: index == (widget.data.length - 1)
                                    ? 15.h
                                    : 0),
                            child: IconSlideAction(
                              color: HexColor.fromHex('#FF6259'),
                              onTap: () async {
                                await widget.delete!(
                                    index, widget.data[index].messageID);
                                // Scaffold.of(context).showSnackBar(SnackBar(
                                //   content: Text(
                                //     StringLocalization.of(context).getText(
                                //         StringLocalization
                                //             .emailDeletedSuccessfully),
                                //     style: TextStyle(color: Colors.green),
                                //     textAlign: TextAlign.center,
                                //   ),
                                // ));
                                CustomSnackBar.buildSnackbar(
                                    context,
                                    StringLocalization.of(context).getText(
                                        StringLocalization
                                            .emailDeletedSuccessfully),
                                    3);
                                setState(() {});
                              },
                              height: 70.h,
                              topMargin: 18.h,
                              iconWidget: Body1AutoText(
                                text: StringLocalization.of(context)
                                    .getText(StringLocalization.delete),

                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.backgroundColor,
                                overflow: TextOverflow.ellipsis,
                                maxLine: 1,
                                minFontSize: 2,
                                // maxLines: 1,
                              ),
                              rightMargin: 13.w,
                              leftMargin: 0,
                            ),
                          ),
                        ],
                        child: GestureDetector(
                          key: Key(widget.data[index].messageSubject!),
                          child: Container(
                            height: 70.h,
                            margin: EdgeInsets.only(
                                left: 13.w,
                                right: 13.w,
                                top: 18.h,
                                bottom: index == (widget.data.length - 1)
                                    ? 15.h
                                    : 0),
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? HexColor.fromHex('#111B1A')
                                    : AppColor.backgroundColor,
                                borderRadius: BorderRadius.circular(10.h),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#D1D9E6')
                                            .withOpacity(0.1)
                                        : Colors.white,
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: Offset(-4, -4),
                                  ),
                                  BoxShadow(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black.withOpacity(0.75)
                                        : HexColor.fromHex('#9F2DBC')
                                            .withOpacity(0.15),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: Offset(4, 4),
                                  ),
                                ]),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 15.w, right: 15.w, top: 12.h),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex('#111B1A')
                                      : AppColor.backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? widget.data[index].isViewed ??
                                                    false
                                                ? Colors.transparent
                                                : HexColor.fromHex('#9F2DBC')
                                                    .withOpacity(0.15)
                                            : widget.data[index].isViewed ??
                                                    false
                                                ? Colors.transparent
                                                : HexColor.fromHex('#D1D9E6')
                                                    .withOpacity(0.5),
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? widget.data[index].isViewed ??
                                                    false
                                                ? Colors.transparent
                                                : HexColor.fromHex('#9F2DBC')
                                                    .withOpacity(0)
                                            : widget.data[index].isViewed ??
                                                    false
                                                ? Colors.transparent
                                                : HexColor.fromHex('#FFDFDE')
                                                    .withOpacity(0),
                                      ])),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 14.h),
                                      child: CircleAvatar(
                                          child: Center(
                                            child: Body1AutoText(
                                              text: widget.data[index]
                                                          .messageFrom ==
                                                      widget.userEmail
                                                  ? widget.data[index]
                                                              .receiverUserName !=
                                                          null
                                                      ? getInitialNames(widget
                                                          .data[index]
                                                          .receiverUserName!)
                                                      : ''
                                                  : widget.data[index]
                                                              .senderUserName !=
                                                          null
                                                      ? getInitialNames(widget
                                                              .data[index]
                                                              .senderUserName ??
                                                          '')
                                                      : '',
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.black
                                                  : widget.data[index]
                                                              .isViewed ??
                                                          false
                                                      ? Colors.white
                                                      : HexColor.fromHex(
                                                          '#EEF1F1',
                                                        ),
                                              overflow: TextOverflow.ellipsis,
                                              minFontSize: 6,
                                            ),
                                          ),
                                          radius: 21.w,
                                          backgroundColor: Theme.of(context)
                                                      .brightness ==
                                                  Brightness.dark
                                              ? widget.data[index].isViewed ??
                                                      false
                                                  ? HexColor.fromHex('#D1D9E6')
                                                      .withOpacity(0.6)
                                                  : HexColor.fromHex('#9F2DBC')
                                              : widget.data[index].isViewed ??
                                                      false
                                                  ? HexColor.fromHex('#D1D9E6')
                                                  : HexColor.fromHex('#9F2DBC')

                                          //   child: widget.data[index].senderPicture != null ? Image.network(widget.data[index].senderPicture) : Image.asset('asset/avatar.png'),
                                          ),
                                    ),
                                    SizedBox(
                                      width: 16.w,
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 189.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 25.h,
                                              // child: FittedBox(
                                              //   fit: BoxFit.scaleDown,
                                              //   alignment: Alignment.centerLeft,
                                              //   child: Text(
                                              //     widget.data[index]
                                              //                 .messageFrom ==
                                              //             widget.userEmail
                                              //         ? widget.data[index]
                                              //                     .receiverUserName !=
                                              //                 null
                                              //             ? widget.data[index]
                                              //                 .receiverUserName
                                              //             : ""
                                              //         : widget.data[index]
                                              //                     .senderUserName !=
                                              //                 null
                                              //             ? widget.data[index]
                                              //                 .senderUserName
                                              //             : "",
                                              //     style: TextStyle(
                                              //         fontWeight:
                                              //             FontWeight.bold,
                                              //         color: Theme.of(context)
                                              //                     .brightness ==
                                              //                 Brightness.dark
                                              //             ? widget.data[index]
                                              //                     .isViewed
                                              //                 ? HexColor.fromHex(
                                              //                         "#FFFFFF")
                                              //                     .withOpacity(
                                              //                         0.6)
                                              //                 : HexColor.fromHex(
                                              //                         "#FFFFFF")
                                              //                     .withOpacity(
                                              //                         0.87)
                                              //             : widget.data[index]
                                              //                     .isViewed
                                              //                 ? HexColor
                                              //                     .fromHex(
                                              //                         "#5D6A68")
                                              //                 : HexColor.fromHex(
                                              //                     "#384341"),
                                              //         fontSize: 16.sp),
                                              //     overflow:
                                              //         TextOverflow.ellipsis,
                                              //     maxLines: 1,
                                              //     // minFontSize: 10,
                                              //   ),
                                              // ),
                                              child: Body1AutoText(
                                                text: widget.data[index]
                                                            .messageFrom ==
                                                        widget.userEmail
                                                    ? widget.data[index]
                                                                .receiverUserName !=
                                                            null
                                                        ? widget.data[index]
                                                            .receiverUserName!
                                                        : ''
                                                    : widget.data[index]
                                                                .senderUserName !=
                                                            null
                                                        ? widget.data[index]
                                                            .senderUserName!
                                                        : '',
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? widget.data[index]
                                                                .isViewed ??
                                                            false
                                                        ? HexColor.fromHex(
                                                                '#FFFFFF')
                                                            .withOpacity(0.6)
                                                        : HexColor.fromHex(
                                                                '#FFFFFF')
                                                            .withOpacity(0.87)
                                                    : widget.data[index]
                                                                .isViewed ??
                                                            false
                                                        ? HexColor.fromHex(
                                                            '#5D6A68')
                                                        : HexColor.fromHex(
                                                            '#384341'),
                                                fontSize: 16.sp,
                                                minFontSize: 10,
                                                overflow: TextOverflow.ellipsis,
                                                // maxLine: 1,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 19.h,
                                              // child: FittedBox(
                                              //   fit: BoxFit.contain,
                                              //   child: Text(
                                              //     widget.data[index]
                                              //         .messageSubject,
                                              //     style: TextStyle(
                                              //         fontWeight:
                                              //             FontWeight.bold,
                                              //         color: Theme.of(context)
                                              //                     .brightness ==
                                              //                 Brightness.dark
                                              //             ? widget.data[index]
                                              //                     .isViewed
                                              //                 ? HexColor.fromHex(
                                              //                         "#FFFFFF")
                                              //                     .withOpacity(
                                              //                         0.38)
                                              //                 : HexColor.fromHex(
                                              //                         "#FFFFFF")
                                              //                     .withOpacity(
                                              //                         0.6)
                                              //             : widget.data[index]
                                              //                     .isViewed
                                              //                 ? HexColor
                                              //                     .fromHex(
                                              //                         "#7F8D8C")
                                              //                 : HexColor.fromHex(
                                              //                     "#5D6A68"),
                                              //         fontSize: 14.sp),
                                              //     overflow:
                                              //         TextOverflow.ellipsis,
                                              //     maxLines: 1,
                                              //     // minFontSize: 8,
                                              //   ),
                                              // ),
                                              child: Body1AutoText(
                                                text: widget.data[index]
                                                        .messageSubject ??
                                                    '',
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? widget.data[index]
                                                                .isViewed ??
                                                            false
                                                        ? HexColor.fromHex(
                                                                '#FFFFFF')
                                                            .withOpacity(0.38)
                                                        : HexColor.fromHex(
                                                                '#FFFFFF')
                                                            .withOpacity(0.6)
                                                    : widget.data[index]
                                                                .isViewed ??
                                                            false
                                                        ? HexColor.fromHex(
                                                            '#7F8D8C')
                                                        : HexColor.fromHex(
                                                            '#5D6A68'),
                                                fontSize: 14.sp,
                                                minFontSize: 10,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 24.h,
                                          // child: FittedBox(
                                          //   fit: BoxFit.scaleDown,
                                          //   child: Text(
                                          //     DateFormat('MMM dd, yy').format(
                                          //       DateTime.parse(widget
                                          //           .data[index]
                                          //           .createdDateTime),
                                          //     ),
                                          //     style: TextStyle(
                                          //         fontWeight: FontWeight.bold,
                                          //         fontSize: 12.sp,
                                          //         color: Theme.of(context)
                                          //                     .brightness ==
                                          //                 Brightness.dark
                                          //             ? widget.data[index]
                                          //                     .isViewed
                                          //                 ? HexColor.fromHex(
                                          //                         "#FFFFFF")
                                          //                     .withOpacity(0.38)
                                          //                 : HexColor.fromHex(
                                          //                         "#FFFFFF")
                                          //                     .withOpacity(0.87)
                                          //             : widget.data[index]
                                          //                     .isViewed
                                          //                 ? HexColor.fromHex(
                                          //                     "#7F8D8C")
                                          //                 : HexColor.fromHex(
                                          //                     "#384341")),
                                          //     maxLines: 1,
                                          //     // minFontSize: 8,
                                          //   ),
                                          // ),
                                          child: TitleText(
                                            text: DateFormat(DateUtil.MMMddyy)
                                                .format(
                                              DateTime.parse(widget.data[index]
                                                      .createdDateTime ??
                                                  ''),
                                            ),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp,
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? widget.data[index].isViewed ??
                                                        false
                                                    ? HexColor.fromHex(
                                                            '#FFFFFF')
                                                        .withOpacity(0.38)
                                                    : HexColor.fromHex(
                                                            '#FFFFFF')
                                                        .withOpacity(0.87)
                                                : widget.data[index].isViewed ??
                                                        false
                                                    ? HexColor.fromHex(
                                                        '#7F8D8C')
                                                    : HexColor.fromHex(
                                                        '#384341'),
                                            // maxLine: 1,
                                          ),
                                        ),
                                        if (widget.data[index].userFile !=
                                                null &&
                                            widget.data[index].userFile!
                                                .isNotEmpty)
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Image.asset(
                                                'asset/attachment.png',
                                                height: 27,
                                                width: 27,
                                              ))
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                          onTap: () {
                            print(widget.data[index].id);
                            widget.open!(
                              widget.data[index].messageID,
                              widget.data[index].messageSubject,
                              widget.data[index],
                            );
                          },
                          onLongPress: () {
                            setState(() {
                              HapticFeedback.vibrate();
                              widget.data[index].isSelected = true;
                              isSelection = true;
                            });
                          },
                        ),
                      );
              },
              controller: widget.controller,
              itemCount: widget.data.length,
            ),
          ),
        ],
      ),
    );
  }

  String getInitialNames(String userName) {
    var firstName = userName.split(' ')[0];
    var lastName = userName.split(' ')[1];
    return "${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}";
  }
}
