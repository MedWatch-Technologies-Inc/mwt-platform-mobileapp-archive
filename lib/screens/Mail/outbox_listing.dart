import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/slider/flutter_slidable.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';

import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

/// Added by: Akhil
/// Added on: July/02/2020
/// this widget is responsible for displaying listing of emails in outbox.
/// @delete - function to delete the mail
/// @open - function to open the mail
/// @data - list of outbox emails
class OutboxListing extends StatefulWidget {
  final Function? delete;
  final Function? open;
  final List<InboxData>? data;

  OutboxListing({
    this.data,
    this.delete,
    this.open,
  });

  @override
  _OutboxListingState createState() => _OutboxListingState();
}

/// Added by: Akhil
/// Added on: July/02/2020
/// this class maintains the state of listing widget.
class _OutboxListingState extends State<OutboxListing> {
  @override

  /// Added by: Akhil
  /// Added on: July/02/2020
  /// this is lifecycle method of widget to build the UI on the screen.
  Widget build(BuildContext context) {
    /// Added by: Akhil
    /// Added on: July/02/2020
    ///This is the listViewBuilder for all the emails.
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      child: ListView.builder(
        itemBuilder: (BuildContext context, index) {
          return GestureDetector(
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      bottom: index == (widget.data!.length - 1) ? 15.h : 0),
                  child: IconSlideAction(
                    color: HexColor.fromHex("#FF6259"),
                    onTap: () async {
                      await widget.delete!(widget.data![index].id, index);
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
                    },
                    height: 70.h,
                    topMargin: 18.h,
                    iconWidget: Body1AutoText(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.delete),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.backgroundColor,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 2,
                      // maxLines: 1,
                    ),
                    rightMargin: 13.w,
                    leftMargin: 0,
                  ),
                ),
//              IconSlideAction(
//                  caption: StringLocalization.of(context).getText(StringLocalization.delete),
//                  color: Colors.red,
//                  icon: Icons.delete,
//                  onTap: (){
//                    widget.delete(widget.data[index].id, index);
//                    Scaffold.of(context).showSnackBar(SnackBar(
//                      content: Text(StringLocalization.of(context).getText(StringLocalization.emailDeletedSuccessfully),style: TextStyle(color: Colors.green)),
//                    ));
//                  }
//              ),
              ],
              child: Container(
                  height: 70.h,
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
                  child: Container(
                    padding: EdgeInsets.only(left: 15,right: 15,top: 12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 25.h,
                              // child: FittedBox(
                              //   fit: BoxFit.scaleDown,
                              //   alignment: Alignment.centerLeft,
                              //   child: Text(
                              //     widget.data[index].messageTo,
                              //     style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //         fontSize: 14.sp,
                              //         color: Theme.of(context).brightness ==
                              //                 Brightness.dark
                              //             ? HexColor.fromHex("#FFFFFF")
                              //                 .withOpacity(0.87)
                              //             : HexColor.fromHex("#384341")),
                              //     maxLines: 1,
                              //     // minFontSize: 8,
                              //   ),
                              // ),
                              child: TitleText(
                                text: widget.data![index].messageTo ?? '',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                                    : HexColor.fromHex("#384341"),
                                // maxLine: 1,
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              height: 24.h,
                              // child: FittedBox(
                              //   fit: BoxFit.scaleDown,
                              //   alignment: Alignment.centerLeft,
                              //   child: Text(
                              //     DateFormat('MMM dd,yy').format(
                              //       DateTime.fromMillisecondsSinceEpoch(
                              //         int.parse(
                              //           widget.data[index].createdDateTime
                              //               .substring(6, 19),
                              //         ),
                              //       ),
                              //     ),
                              //     style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //         fontSize: 12.sp,
                              //         color: Theme.of(context).brightness ==
                              //                 Brightness.dark
                              //             ? HexColor.fromHex("#FFFFFF")
                              //                 .withOpacity(0.87)
                              //             : HexColor.fromHex("#384341")),
                              //     maxLines: 1,
                              //     // minFontSize: 8,
                              //   ),
                              // ),
                              child: TitleText(
                                text: DateFormat('MMM dd,yy').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(
                                      widget.data![index].createdDateTime!
                                          .substring(6, 19),
                                    ),
                                  ),
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                                    : HexColor.fromHex("#384341"),
                                // maxLine: 1,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 19.h,
                              // child: FittedBox(
                              //   fit: BoxFit.scaleDown,
                              //   alignment: Alignment.centerLeft,
                              //   child: Text(
                              //     widget.data[index].messageSubject,
                              //     style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //         fontSize: 14.sp,
                              //         color: Theme.of(context).brightness ==
                              //                 Brightness.dark
                              //             ? HexColor.fromHex("#FFFFFF").withOpacity(0.6)
                              //             : HexColor.fromHex("#5D6A68")),
                              //     maxLines: 1,
                              //     // minFontSize: 8,
                              //   ),
                              // ),
                              child: TitleText(
                                text: widget.data![index].messageSubject ?? '',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex("#FFFFFF").withOpacity(0.6)
                                    : HexColor.fromHex("#5D6A68"),
                                // maxLine: 1,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    // title: SizedBox(
                    //   height: 25.h,
                    //   // child: FittedBox(
                    //   //   fit: BoxFit.scaleDown,
                    //   //   alignment: Alignment.centerLeft,
                    //   //   child: Text(
                    //   //     widget.data[index].messageTo,
                    //   //     style: TextStyle(
                    //   //         fontWeight: FontWeight.bold,
                    //   //         fontSize: 14.sp,
                    //   //         color: Theme.of(context).brightness ==
                    //   //                 Brightness.dark
                    //   //             ? HexColor.fromHex("#FFFFFF")
                    //   //                 .withOpacity(0.87)
                    //   //             : HexColor.fromHex("#384341")),
                    //   //     maxLines: 1,
                    //   //     // minFontSize: 8,
                    //   //   ),
                    //   // ),
                    //   child: TitleText(
                    //     text: widget.data[index].messageTo,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 14.sp,
                    //     color: Theme.of(context).brightness == Brightness.dark
                    //         ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                    //         : HexColor.fromHex("#384341"),
                    //     // maxLine: 1,
                    //   ),
                    // ),
                    // subtitle: SizedBox(
                    //   height: 19.h,
                    //   // child: FittedBox(
                    //   //   fit: BoxFit.scaleDown,
                    //   //   alignment: Alignment.centerLeft,
                    //   //   child: Text(
                    //   //     widget.data[index].messageSubject,
                    //   //     style: TextStyle(
                    //   //         fontWeight: FontWeight.bold,
                    //   //         fontSize: 14.sp,
                    //   //         color: Theme.of(context).brightness ==
                    //   //                 Brightness.dark
                    //   //             ? HexColor.fromHex("#FFFFFF").withOpacity(0.6)
                    //   //             : HexColor.fromHex("#5D6A68")),
                    //   //     maxLines: 1,
                    //   //     // minFontSize: 8,
                    //   //   ),
                    //   // ),
                    //   child: TitleText(
                    //     text: widget.data[index].messageSubject,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 14.sp,
                    //     color: Theme.of(context).brightness == Brightness.dark
                    //         ? HexColor.fromHex("#FFFFFF").withOpacity(0.6)
                    //         : HexColor.fromHex("#5D6A68"),
                    //     // maxLine: 1,
                    //   ),
                    // ),
                    // trailing: SizedBox(
                    //   height: 24.h,
                    //   // child: FittedBox(
                    //   //   fit: BoxFit.scaleDown,
                    //   //   alignment: Alignment.centerLeft,
                    //   //   child: Text(
                    //   //     DateFormat('MMM dd,yy').format(
                    //   //       DateTime.fromMillisecondsSinceEpoch(
                    //   //         int.parse(
                    //   //           widget.data[index].createdDateTime
                    //   //               .substring(6, 19),
                    //   //         ),
                    //   //       ),
                    //   //     ),
                    //   //     style: TextStyle(
                    //   //         fontWeight: FontWeight.bold,
                    //   //         fontSize: 12.sp,
                    //   //         color: Theme.of(context).brightness ==
                    //   //                 Brightness.dark
                    //   //             ? HexColor.fromHex("#FFFFFF")
                    //   //                 .withOpacity(0.87)
                    //   //             : HexColor.fromHex("#384341")),
                    //   //     maxLines: 1,
                    //   //     // minFontSize: 8,
                    //   //   ),
                    //   // ),
                    //   child: TitleText(
                    //     text: DateFormat('MMM dd,yy').format(
                    //       DateTime.fromMillisecondsSinceEpoch(
                    //         int.parse(
                    //           widget.data[index].createdDateTime
                    //               .substring(6, 19),
                    //         ),
                    //       ),
                    //     ),
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 12.sp,
                    //     color: Theme.of(context).brightness == Brightness.dark
                    //         ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                    //         : HexColor.fromHex("#384341"),
                    //     // maxLine: 1,
                    //   ),
                    // ),
                  )),
            ),
            onTap: () {
              widget.open!(index);
            },
          );
        },
        itemCount: widget.data!.length,
      ),
    );
  }
}
