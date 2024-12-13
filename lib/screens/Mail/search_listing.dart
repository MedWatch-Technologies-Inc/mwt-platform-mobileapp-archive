import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';


import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

/// Added by: Akhil
/// Added on: June/03/2020
///this class is for listing of search mails
class SearchListing extends StatefulWidget {
  final Function? open;
  late final List<InboxData> data;
  final String? userEmail;

  SearchListing({
    required this.data,
    this.open,
    this.userEmail,
  });

  @override
  _SearchListingState createState() => _SearchListingState();
}

/// Added by: Akhil
/// Added on: June/03/2020
///this class maintains the state of search listing widget
class _SearchListingState extends State<SearchListing> {
  @override
  Widget build(BuildContext context) {
    return widget.data.isNotEmpty
        ? ListView.builder(
            itemBuilder: (BuildContext context, index) {
              return GestureDetector(
                child: Container(
                  height: 70,
                  margin: EdgeInsets.only(left: 13, right: 13, top: 18),
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex("#111B1A")
                          : AppColor.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
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
                  child: ListTile(
                    title: SizedBox(
                      height: 25,
                      child: Body1AutoText(
                        text: widget.data[index].messageType == 4
                            ? StringLocalization.of(context)
                                .getText(StringLocalization.kDrafts)
                            : widget.data[index].messageType == 5
                                ? StringLocalization.of(context)
                                    .getText(StringLocalization.kOutBox)
                                : widget.data[index].messageFrom ==
                                        widget.userEmail
                                    ? widget.data[index].receiverUserName !=
                                            null
                                        ? widget.data[index].receiverUserName!
                                        : ""
                                    : widget.data[index].senderUserName != null
                                        ? widget.data[index].senderUserName!
                                        : "",
                        maxLine: 1,
                        minFontSize: 8,
                      ),
                      // child: FittedTitleText(
                      //   text: widget.data[index].messageType == 4
                      //       ? StringLocalization.of(context)
                      //           .getText(StringLocalization.kDrafts)
                      //       : widget.data[index].messageType == 5
                      //           ? StringLocalization.of(context)
                      //               .getText(StringLocalization.kOutBox)
                      //           : widget.data[index].messageFrom ==
                      //                   widget.userEmail
                      //               ? widget.data[index].receiverUserName !=
                      //                       null
                      //                   ? widget.data[index].receiverUserName
                      //                   : ""
                      //               : widget.data[index].senderUserName != null
                      //                   ? widget.data[index].senderUserName
                      //                   : "",
                      //   // maxLine: 1,
                      // ),
                    ),
                    subtitle: widget.data[index].messageType == 4 ||
                            widget.data[index].messageType == 5
                        ? SizedBox(
                            height: 19,
                            child: Body1AutoText(
                              text: widget.data[index].messageTo != null
                                  ? widget.data[index].messageTo!
                                  : widget.data[index].messageSubject != null
                                      ? widget.data[index].messageSubject!
                                      : widget.data[index].messageBody!,
                              maxLine: 1,
                              minFontSize: 8,
                            ),
                            // child: FittedTitleText(
                            //   text: widget.data[index].messageTo != null
                            //       ? widget.data[index].messageTo
                            //       : widget.data[index].messageSubject != null
                            //           ? widget.data[index].messageSubject
                            //           : widget.data[index].messageBody,
                            //   // maxLine: 1,
                            // ),
                          )
                        : SizedBox(
                            height: 19,
                            child: Body1AutoText(
                              text: widget.data[index].messageSubject ?? '',
                              maxLine: 1,
                              minFontSize: 8,
                            ),
                            // child: FittedTitleText(
                            //   text: widget.data[index].messageSubject,
                            // maxLine: 1,
                            // ),
                          ),
                    trailing: SizedBox(
                      height: 24,
//                       child: FittedBox(
//                         fit: BoxFit.scaleDown,
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           widget.data[index].messageType == 4 ||
//                                   widget.data[index].messageType == 5
//                               ? DateFormat('MMM dd, yy').format(
//                                   DateTime.fromMillisecondsSinceEpoch(
//                                     int.parse(
//                                       widget.data[index].createdDateTime
//                                           .substring(6, 19),
//                                     ),
//                                   ),
//                                 )
//                               : DateFormat('MMM dd,yy').format(
//                                   DateTime.parse(
//                                       widget.data[index].createdDateTime),
//                                 ),
//                           // minFontSize: 8,
//                           maxLines: 1,
// //                DateFormat.MMMd().format(
// //                    DateTime.fromMillisecondsSinceEpoch(int.parse(widget
// //                        .data[index].createdDateTime
// //                        .substring(6, 19))))
//                         ),
//                       ),
                      child: TitleText(
                        text: widget.data[index].messageType == 4 ||
                                widget.data[index].messageType == 5
                            ? DateFormat(DateUtil.MMMddyy).format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(
                                    widget.data[index].createdDateTime!
                                        .substring(6, 19),
                                  ),
                                ),
                              )
                            : DateFormat('MMM dd,yy').format(
                                DateTime.parse(
                                    widget.data[index].createdDateTime!),
                              ),
                        // maxLine: 1,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  widget.open!(index);
                },
              );
            },
            itemCount: widget.data.length,
          )
        : Container(
            child: Center(
              child: Text('No Result Found'),
            ),
          );
  }
}
