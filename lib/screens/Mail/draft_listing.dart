import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/slider/flutter_slidable.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

/// Added by: Akhil
/// Added on: June/03/2020
/// this widget is responsible for displaying listing of drafts.
class DraftListing extends StatefulWidget {
  final Function? delete;
  final Function? open;
  final List<InboxData>? data;

  DraftListing({
    this.data,
    this.delete,
    this.open,
  });

  @override
  _DraftListingState createState() => _DraftListingState();
}

/// Added by: Akhil
/// Added on: June/03/2020
/// this class maintains the state of draft listing widget.
class _DraftListingState extends State<DraftListing> {
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return Container(
      //height: MediaQuery.of(context).size.height,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      child: ListView.builder(
        itemBuilder: (BuildContext context, index) {
          return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              actions: widget.data![index].isDeleted ?? false
                  ? <Widget>[
                      IconSlideAction(
                          caption: StringLocalization.of(context)
                              .getText(StringLocalization.untrash),
                          color: Colors.green,
                          icon: Icons.delete,
                          onTap: () {})
                    ]
                  : <Widget>[],
              secondaryActions: <Widget>[
                /// Added by: Akhil
                /// Added on: June/03/2020
                ///this is for providing functionality of  deleting email.
                Padding(
                  padding: EdgeInsets.only(
                      bottom: index == (widget.data!.length - 1) ? 15.h : 0),
                  child: IconSlideAction(
                      color: HexColor.fromHex("#FF6259"),
                      iconWidget: Text(
                        StringLocalization.of(context)
                            .getText(StringLocalization.delete),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.backgroundColor,
                        ),
                      ),
                      height: 110.h,
                      leftMargin: 0,
                      rightMargin: 13.w,
                      topMargin: 18.h,
                      onTap: () {
                        widget.delete!(widget.data![index].id, index);
                        // Scaffold.of(context).showSnackBar(SnackBar(
                        //   content: Text(
                        //     StringLocalization.of(context).getText(
                        //         StringLocalization.emailDeletedSuccessfully),
                        //     style: TextStyle(color: Colors.green),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ));
                        CustomSnackBar.buildSnackbar(
                            context,
                            StringLocalization.of(context).getText(
                                StringLocalization.emailDeletedSuccessfully),
                            3);
                        setState(() {});
                      }),
                ),
              ],
              child: GestureDetector(
                key: Key(widget.data![index].messageSubject!),
                child: Container(
                  // height: 110.h,
                  margin: EdgeInsets.only(
                      left: 13.w,
                      right: 13.w,
                      top: 18.h,
                      bottom: index == (widget.data!.length - 1) ? 15.h : 0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex("#111B1A")
                          : AppColor.backgroundColor,
                      borderRadius: BorderRadius.circular(10.h),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                              : Colors.white,
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: Offset(-4, -4),
                        ),
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex("#9F2DBC").withOpacity(0.15),
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: Offset(4, 4),
                        ),
                      ]),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 14.h),
                            child: CircleAvatar(
                              child: Center(
                                child: Visibility(
                                  visible: getInitialNames(
                                          widget.data![index].receiverUserName)
                                      .isNotEmpty,
                                  child: Text(
                                    getInitialNames(
                                        widget.data![index].receiverUserName),
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.black
                                            : HexColor.fromHex("#EEF1F1")),
                                  ),
                                  replacement: ImageIcon(
                                    AssetImage('asset/m_profile_icon.png'),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              radius: 21.w,
                              backgroundColor: HexColor.fromHex("#9F2DBC"),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 25.h,
                                      child: Body1AutoText(
                                        text: StringLocalization.of(context)
                                            .getText(
                                                StringLocalization.kDrafts),
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? HexColor.fromHex("#FF6259")
                                            : HexColor.fromHex("#FF6259"),
                                        fontSize: 16.sp,
                                        maxLine: 1,
                                        minFontSize: 8,
                                      ),
                                      // child: FittedTitleText(
                                      //   text: StringLocalization.of(context)
                                      //       .getText(StringLocalization.kDrafts),
                                      //   color: Theme.of(context).brightness ==
                                      //           Brightness.dark
                                      //       ? HexColor.fromHex("#FF6259")
                                      //       : HexColor.fromHex("#FF6259"),
                                      //   fontSize: 16.sp,
                                      //   // maxLine: 1,
                                      // ),
                                    ),
                                    Spacer(),
                                    SizedBox(
                                      height: 24.h,
                                      // child: FittedBox(
                                      //   fit: BoxFit.scaleDown,
                                      //   alignment: Alignment.centerLeft,
                                      //   child: Text(
                                      //     DateFormat('MMM dd, yy').format(
                                      //       DateTime.fromMillisecondsSinceEpoch(
                                      //         int.parse(
                                      //           widget.data[index].createdDateTime
                                      //               .substring(6, 19),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     style: TextStyle(
                                      //       color: Theme.of(context).brightness ==
                                      //               Brightness.dark
                                      //           ? HexColor.fromHex("#FFFFFF")
                                      //               .withOpacity(0.38)
                                      //           : HexColor.fromHex("#7F8D8C"),
                                      //       fontSize: 12.sp,
                                      //       fontWeight: FontWeight.bold,
                                      //     ),
                                      //     // minFontSize: 8,
                                      //     maxLines: 1,
                                      //   ),
                                      // ),
                                      child: TitleText(
                                        text:
                                            DateFormat(DateUtil.MMMddyy).format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(
                                              widget
                                                  .data![index].createdDateTime!
                                                  .substring(6, 19),
                                            ),
                                          ),
                                        ),
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? HexColor.fromHex("#FFFFFF")
                                                .withOpacity(0.38)
                                            : HexColor.fromHex("#7F8D8C"),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        // maxLine: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                widget.data![index].messageTo != null &&
                                        widget
                                            .data![index].messageTo!.isNotEmpty
                                    ? Container(
                                        child: SizedBox(
                                          height: 19,
                                          // child: FittedBox(
                                          //   fit: BoxFit.scaleDown,
                                          //   alignment: Alignment.centerLeft,
                                          //   child: Text(
                                          //     widget.data[index].messageTo,
                                          //     overflow: TextOverflow.ellipsis,
                                          //     style: TextStyle(
                                          //         color: Theme.of(context)
                                          //                     .brightness ==
                                          //                 Brightness.dark
                                          //             ? HexColor.fromHex(
                                          //                     "#FFFFFF")
                                          //                 .withOpacity(0.38)
                                          //             : HexColor.fromHex(
                                          //                 "#7F8D8C"),
                                          //         fontSize: 14.sp),
                                          //     maxLines: 1,
                                          //     // minFontSize: 8,
                                          //   ),
                                          // ),
                                          child: TitleText(
                                            text:
                                                widget.data![index].messageTo ??
                                                    '',
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? HexColor.fromHex("#FFFFFF")
                                                    .withOpacity(0.38)
                                                : HexColor.fromHex("#7F8D8C"),
                                            fontSize: 14.sp,
                                            // maxLine: 1,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                widget.data![index].messageSubject != null &&
                                        widget.data![index].messageSubject!
                                            .isNotEmpty
                                    ? Container(
                                        child: SizedBox(
                                          height: 19.h,
                                          // child: FittedBox(
                                          //   fit: BoxFit.scaleDown,
                                          //   alignment: Alignment.centerLeft,
                                          //   child: Text(
                                          //     widget.data[index].messageSubject,
                                          //     overflow: TextOverflow.ellipsis,
                                          //     style: TextStyle(
                                          //         color: Theme.of(context)
                                          //                     .brightness ==
                                          //                 Brightness.dark
                                          //             ? HexColor.fromHex(
                                          //                     "#FFFFFF")
                                          //                 .withOpacity(0.38)
                                          //             : HexColor.fromHex(
                                          //                 "#7F8D8C"),
                                          //         fontSize: 14.sp),
                                          //     maxLines: 1,
                                          //     // minFontSize: 8,
                                          //   ),
                                          // ),
                                          child: TitleText(
                                            text: widget.data![index]
                                                    .messageSubject ??
                                                '',
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? HexColor.fromHex("#FFFFFF")
                                                    .withOpacity(0.38)
                                                : HexColor.fromHex("#7F8D8C"),
                                            fontSize: 14.sp,
                                            // maxLine: 1,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                widget.data![index].messageBody != null &&
                                        widget.data![index].messageBody!
                                            .isNotEmpty
                                    ? Container(
                                        child: SizedBox(
                                          height: 19.h,
                                          // child: FittedBox(
                                          //   fit: BoxFit.scaleDown,
                                          //   alignment: Alignment.centerLeft,
                                          //   child: Text(
                                          //     widget.data[index].messageBody,
                                          //     overflow: TextOverflow.ellipsis,
                                          //     style: TextStyle(
                                          //         color: Theme.of(context)
                                          //                     .brightness ==
                                          //                 Brightness.dark
                                          //             ? HexColor.fromHex(
                                          //                     "#FFFFFF")
                                          //                 .withOpacity(0.38)
                                          //             : HexColor.fromHex(
                                          //                 "#7F8D8C"),
                                          //         fontSize: 14.sp),
                                          //     maxLines: 1,
                                          //     // minFontSize: 8,
                                          //   ),
                                          // ),
                                          child: TitleText(
                                            text: widget
                                                    .data![index].messageBody ??
                                                '',
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? HexColor.fromHex("#FFFFFF")
                                                    .withOpacity(0.38)
                                                : HexColor.fromHex("#7F8D8C"),
                                            fontSize: 14.sp,
                                            // maxLine: 1,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: [
                          //     SizedBox(
                          //       height: 24.h,
                          //       // child: FittedBox(
                          //       //   fit: BoxFit.scaleDown,
                          //       //   alignment: Alignment.centerLeft,
                          //       //   child: Text(
                          //       //     DateFormat('MMM dd, yy').format(
                          //       //       DateTime.fromMillisecondsSinceEpoch(
                          //       //         int.parse(
                          //       //           widget.data[index].createdDateTime
                          //       //               .substring(6, 19),
                          //       //         ),
                          //       //       ),
                          //       //     ),
                          //       //     style: TextStyle(
                          //       //       color: Theme.of(context).brightness ==
                          //       //               Brightness.dark
                          //       //           ? HexColor.fromHex("#FFFFFF")
                          //       //               .withOpacity(0.38)
                          //       //           : HexColor.fromHex("#7F8D8C"),
                          //       //       fontSize: 12.sp,
                          //       //       fontWeight: FontWeight.bold,
                          //       //     ),
                          //       //     // minFontSize: 8,
                          //       //     maxLines: 1,
                          //       //   ),
                          //       // ),
                          //       child: TitleText(
                          //         text: DateFormat('MMM dd, yy').format(
                          //           DateTime.fromMillisecondsSinceEpoch(
                          //             int.parse(
                          //               widget.data[index].createdDateTime
                          //                   .substring(6, 19),
                          //             ),
                          //           ),
                          //         ),
                          //         color: Theme.of(context).brightness ==
                          //                 Brightness.dark
                          //             ? HexColor.fromHex("#FFFFFF")
                          //                 .withOpacity(0.38)
                          //             : HexColor.fromHex("#7F8D8C"),
                          //         fontSize: 12.sp,
                          //         fontWeight: FontWeight.bold,
                          //         // maxLine: 1,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ]),
                  ),
                ),
                onTap: () {
                  widget.open!(index);
                },
              ));
        },
        itemCount: widget.data!.length,
      ),
    );
  }

  double heightOfDraft(int index) {
    int dataCount = 0;
    if (widget.data![index].messageTo != null &&
        widget.data![index].messageTo!.isNotEmpty) dataCount++;
    if (widget.data![index].messageSubject != null &&
        widget.data![index].messageSubject!.isNotEmpty) dataCount++;
    if (widget.data![index].messageBody != null &&
        widget.data![index].messageBody!.isNotEmpty) dataCount++;
    return dataCount == 3
        ? 100.0
        : dataCount == 2
            ? 85.0
            : 70.0;
  }

  String getInitialNames(String? userName) {
    if (userName != null) {
      String firstName = userName.split(" ")[0];
      String lastName = userName.split(" ")[1];
      return "${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}";
    }
    return "";
  }
}
