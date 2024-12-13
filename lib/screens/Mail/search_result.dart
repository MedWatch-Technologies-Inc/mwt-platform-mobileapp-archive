import 'package:flutter/material.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';
import 'package:health_gauge/screens/Mail/message_detail.dart';
import 'package:health_gauge/screens/Mail/search_listing.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'compose_mail.dart';

/// Added by: Akhil
/// Added on: June/03/2020
///this class is for searching mails from listing of emails
class SearchResults extends StatefulWidget {
  final String? query;
  final List<InboxData>? list;
  final String? screen;
  final int? userId;
  final String? userEmail;

  SearchResults(
      {this.list, this.screen, this.query, this.userId, this.userEmail});

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

/// Added by: Akhil
/// Added on: June/03/2020
///this class maintains the state of Search Result Widget
class _SearchResultsState extends State<SearchResults> {
  late TextEditingController _controller;
  List<InboxData> listItem = <InboxData>[];
  bool search = false;

  /// Added by: Akhil
  /// Added on: June/03/2020
  ///this method is used to dispose the controller
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  /// Added by: Akhil
  /// Added on: June/03/2020
  ///this is initial life cycle method
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.query ?? '';
    searchList(query: widget.query!.toLowerCase());
  }

  /// Added by: Akhil
  /// Added on: June/03/2020
  ///this method is for opening the mails to view detail of particular mail
  ///@param index - the index of particular mail whose detail is to be seen
  void openMail(int index) {
    if (listItem[index].messageType == 4) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ComposeMail(
                    subject: listItem[index].messageSubject,
                    to: listItem[index].messageTo,
                    body: listItem[index].messageBody,
                    cc: listItem[index].messageCc,
                    data: listItem[index],
                    userEmail: widget.userEmail,
                    userId: widget.userId,
                  )));
    } else
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MailDetail(
                    data: listItem[index],
                    userId: widget.userId,
                    userEmail: widget.userEmail,
                    screenFrom: widget.screen,
                  )));
  }

  /// Added by: Akhil
  /// Added on: June/03/2020
  ///this method is for searching from the list according to the query
  ///@param query - query searched by user
  void searchList({String query = ''}) {
    List<InboxData> searchListItem = <InboxData>[];
    for (var item in widget.list!) {
      if (item.messageSubject == null
          ? false
          : item.messageSubject!.toLowerCase().contains(query))
        searchListItem.add(item);
      else if (item.messageTo == null
          ? false
          : item.messageTo!.toLowerCase().contains(query))
        searchListItem.add(item);
      else if (item.messageFrom == null
          ? false
          : item.messageFrom!.contains(query))
        searchListItem.add(item);
      else if (item.messageCc == null
          ? false
          : item.messageCc!.toLowerCase().contains(query))
        searchListItem.add(item);
      else if (item.messageBody == null
          ? false
          : item.messageBody!.toLowerCase().contains(query))
        searchListItem.add(item);
      else if (item.senderUserName == null
          ? false
          : item.senderUserName!.toLowerCase().contains(query))
        searchListItem.add(item);
      else if (item.messageType != 2 || item.receiverUserName == null
          ? false
          : item.receiverUserName!.toLowerCase().contains(query))
        searchListItem.add(item);
    }
    listItem = searchListItem;
  }

  /// Added by: Akhil
  /// Added on: June/03/2020
  /// this is lifecycle method of widget to build the UI on the screen.
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
            key: Key('searchResultBackButton'),
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
          actions: <Widget>[
            IconButton(
              icon: search
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Image.asset(
                          "asset/dark_close.png",
                          width: 33,
                          height: 33,
                        )
                      : Image.asset(
                          "asset/close.png",
                          width: 33,
                          height: 33,
                        )
                  : Theme.of(context).brightness == Brightness.dark
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
                setState(() {
                  setState(() {
                    search = !search;
                  });
                });
              },
            )
          ],
          title: search
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    controller: _controller,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: StringLocalization.of(context)
                                .getText(StringLocalization.kSearchMailHint) +
                            " " +
                            widget.screen!,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        )),
                    onChanged: (value) {
                      setState(() {
                        searchList(query: value);
                      });
                    },
                  ),
                )
              : Text(
            _controller.text,
            style: TextStyle(color: HexColor.fromHex('#62CBC9')),
          ),
          centerTitle: true,
        ),
        body: SearchListing(
          data: listItem,
          open: openMail,
          userEmail: widget.userEmail,
        ));
  }
}
