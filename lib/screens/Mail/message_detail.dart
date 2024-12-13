import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';
import 'package:health_gauge/screens/inbox/mail_detail_bloc.dart';
import 'package:health_gauge/screens/inbox/mail_detail_events.dart';
import 'package:health_gauge/screens/inbox/mail_detail_states.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

import 'compose_mail.dart';

///for object purpose
class ReplyMailData {
  final InboxData? data;
  final String? userEmail;
  final int? userId;
  final Function? sendMail;
  final String? screenFrom;

  ReplyMailData(
      {this.data, this.userEmail, this.userId, this.sendMail, this.screenFrom});
}

class MailDetail extends StatefulWidget {
  final InboxData? data;
  final String? userEmail;
  final int? userId;
  final Function? sendMail;
  final String? screenFrom;

  MailDetail(
      {this.data, this.userEmail, this.userId, this.sendMail, this.screenFrom});

  @override
  _MailDetailState createState() => _MailDetailState();
}

class _MailDetailState extends State<MailDetail> {
  MailDetailBloc? mailBloc;

  getMessageDetails(messageID) async {
    // bool isInternetAvailable = await Constants.isInternetAvailable();
    // if (isInternetAvailable) {
    mailBloc?.add(GetMessageDetailEvent(
        messageId: messageID, logedInEmailID: widget.userEmail!));

    // }
  }

  bool? isInternetAvailable;

  getInternetAvailability() async {
    isInternetAvailable = await Constants.isInternetAvailable();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mailBloc = BlocProvider.of<MailDetailBloc>(context);
    getInternetAvailability();
    getMessageDetails(widget.data!.messageID);
  }

  @override
  Widget build(context) {
    //passing this data to statefull class
    int flag = 0;
    int count = 0;
    ReplyMailData replyMailData = ReplyMailData(
        data: widget.data,
        userEmail: widget.userEmail,
        userId: widget.userId,
        sendMail: widget.sendMail,
        screenFrom: widget.screenFrom);

    return widget.screenFrom != null &&
            widget.screenFrom!.toLowerCase() == 'outbox'
        ? MailDetailBlocClass(
            state: MessageDetailSuccessState(
                MessageDetailListModel(result: true, data: widget.data!)),
            replyMailData: replyMailData,
          )
        : BlocBuilder<MailDetailBloc, MailDetailState>(
            bloc: mailBloc,
            builder: (context, MailDetailState state) {
              // state -> ui
              if (state is MessageDetailLoadingState) {
                print('MessageDetailLoadingState');
                flag = 1;
                return Scaffold(
                  body: Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints.expand(),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              if (state is MessageDetailSuccessState) {
                print('MessageDetailSuccessState');
                if (flag == 1 || count == 1) {
                  flag = 0;
                  count = 0;
                  return MailDetailBlocClass(
                    state: state,
                    replyMailData: replyMailData,
                  );
                } else {
                  count++;
                  return Scaffold(
                    body: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints.expand(),
                      child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
              } else if (state is MessageDetailErrorState) {
                print(state.message);
                String message = state.message;
                if (message != null) {
                  if (message.contains('internet')) {
                    message = StringLocalization.of(context)
                        .getText(StringLocalization.enableInternet);
                  }
                } else {
                  message = '';
                }
                return Scaffold(
                  appBar: PreferredSize(
                      preferredSize: Size.fromHeight(kToolbarHeight),
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors.black.withOpacity(0.5)
                                : HexColor.fromHex('#384341').withOpacity(0.2),
                            offset: Offset(0, 2.0),
                            blurRadius: 4.0,
                          )
                        ]),
                        child: AppBar(
                          elevation: 0,
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#111B1A')
                                  : AppColor.backgroundColor,
                          leading: IconButton(
                            padding: EdgeInsets.only(left: 10),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Image.asset(
                                        'asset/dark_leftArrow.png',
                                        width: 13,
                                        height: 22,
                                      )
                                    : Image.asset(
                                        'asset/leftArrow.png',
                                        width: 13,
                                        height: 22,
                                      ),
                          ),
                          title: Text(
                            StringLocalization.of(context)
                                .getText(StringLocalization.detail),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: HexColor.fromHex('62CBC9'),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          centerTitle: true,
                        ),
                      )),
                  body: Center(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            message,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ))),
                );
              } else if (state is MessageDetailEmptyState) {
                return Scaffold(
                  body: Center(
                      child: Container(
                          child: Text(stringLocalization
                              .getText(StringLocalization.noDataFound)))),
                );
              } else {
                print(state);
              }
              return Container();
            },
          );
  }
}

class MailDetailBlocClass extends StatefulWidget {
  final state;
  final ReplyMailData? replyMailData;

  MailDetailBlocClass({this.state, this.replyMailData});

  @override
  _MailDetailBlocClassState createState() => _MailDetailBlocClassState();
}

class _MailDetailBlocClassState extends State<MailDetailBlocClass> {
  List<bool> isOpened = [];

  @override
  Widget build(BuildContext context) {
    for (int i = 0;
        i < widget.state.messageDetailListModel.data.messageTree.length;
        i++) isOpened.add(false);
    return loadPage(widget.state, widget.replyMailData!.screenFrom!);
  }

  /// Added by: Akhil
  /// Added on: Aug/21/2020
  /// this widget is responsible to show the user reply details
  Widget replyBox(int index, int totalLen, InboxData model) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOpened[index] = !isOpened[index];
          for (int i = 0; i < totalLen; i++)
            if (i != index && isOpened[i] == true) isOpened[i] = false;
        });
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                    : Colors.white,
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(-4, -4),
              ),
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.75)
                    : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(4, 4),
              ),
            ]),
        child: Center(
            child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 20.0, left: 10),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 23,
                      // child: FittedBox(
                      //   fit: BoxFit.scaleDown,
                      //   alignment: Alignment.centerLeft,
                      //   child: Text(
                      //     '${StringLocalization.of(context).getText(StringLocalization.from)} :',
                      //     style:
                      //         TextStyle(fontSize: 18, color: AppColor.graydark),
                      //     maxLines: 1,
                      //     // minFontSize: 8,
                      //   ),
                      // ),
                      child: TitleText(
                        text:
                            '${StringLocalization.of(context).getText(StringLocalization.from)} : ',
                        fontSize: 18,
                        color: AppColor.graydark,
                        // maxLine: 1,
                      ),
                    ),
                    Expanded(
                        child: SizedBox(
                      height: 23,
                      // child: FittedBox(
                      //   fit: BoxFit.scaleDown,
                      //   alignment: Alignment.centerLeft,
                      //   child: Text(
                      //     model.senderUserName != null
                      //         ? '${model.senderUserName}'
                      //         : model.messageFrom,
                      //     style: TextStyle(
                      //         fontSize: 18, fontWeight: FontWeight.bold),
                      //     maxLines: 1,
                      //     // minFontSize: 8,
                      //   ),
                      // ),
                      child: TitleText(
                        text: model.senderUserName != null
                            ? '${model.senderUserName}'
                            : model.messageFrom!,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // maxLine: 1,
                      ),
                    )),
                  ]),
            ),
            SizedBox(height: 5),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                child: model.receiverUserName != null
                    ? splitMessageTo(model.receiverUserName!)
                    : Row(
                        children: [
                          SizedBox(
                            height: 23,
                            // child: FittedBox(
                            //   fit: BoxFit.scaleDown,
                            //   alignment: Alignment.centerLeft,
                            //   child: Text(
                            //     'To :',
                            //     style: TextStyle(
                            //         fontSize: 18, color: AppColor.graydark),
                            //     maxLines: 1,
                            //     // minFontSize: 8,
                            //   ),
                            // ),
                            child: TitleText(
                              text: 'To : ',
                              fontSize: 18,
                              color: AppColor.graydark,
                              // maxLine: 1,
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 23,
                              // child: FittedBox(
                              //   fit: BoxFit.scaleDown,
                              //   alignment: Alignment.centerLeft,
                              //   child: Text(
                              //     '${model.messageTo}',
                              //     style: TextStyle(
                              //         fontSize: 18, fontWeight: FontWeight.bold),
                              //     // minFontSize: 8,
                              //     maxLines: 1,
                              //   ),
                              // ),
                              child: TitleText(
                                text: '${model.messageTo}',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                // maxLine: 1,
                              ),
                            ),
                          ),
                        ],
                      )),
            SizedBox(height: 5),
            isOpened[index]
                ? model.messageCc != null
                    ? Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 10),
                        child: splitMessageCc(model.messageCc!),
                      )
                    : SizedBox()
                : SizedBox(),
            Container(
                height: 40,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                child: Row(children: <Widget>[
                  Text(
                      '${StringLocalization.of(context).getText(StringLocalization.date)} :',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, color: AppColor.graydark)),
                  Text(
                      DateFormat(DateUtil.yyyyMMddkkmm).format(
                        DateTime.parse(model.createdDateTime!),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      // '${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(model.createdDateTime.substring(6, 19))))}',
                      style: TextStyle(fontSize: 16)),
                ])),
            isOpened[index]
                ? Column(children: <Widget>[
                    SizedBox(height: 5),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 10.0, left: 10),
                        child: Text(
                            '${StringLocalization.of(context).getText(StringLocalization.reply)} :',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: AppColor.graydark))),
                    SizedBox(height: 5),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          left: 20.0, top: 40, bottom: 30, right: 20),
                      child: Text('${model.messageBody}',
                          style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 5),
                    model.attachmentFiles != null
                        ? Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5.0),
                            child: Text('${model.attachmentFiles}'),
                          )
                        : SizedBox(),
                  ])
                : SizedBox(height: 10),
          ],
        )),
      ),
    );
  }

  /// Added by: Akhil
  /// Added on: Aug/21/2020
  ///function to Show the Collected File
  Widget buildGridView(userFileList, fileExtension) {
    // Map map = userFileList[0];
    //print(map['FileName']);
    return userFileList is List
        ? Wrap(
            spacing: 10,
            runSpacing: 20,
            children: <Widget>[
              // for loop
              for (int i = 0; i < userFileList.length; i++)
                GestureDetector(
                    onTap: () {
                      var text = '';
                      text =
                          fileExtension != null ? '${fileExtension[i]}: ' : '';
                      var text2 = '';
                      text2 = userFileList[i].length <= 55
                          ? '${(userFileList[i]['FileName'])}'
                          : '${(userFileList[i]['FileName']).substring(0, 55)}';
                      if (text + text2 != '') {
                        print(text + text2);
                        FlutterClipboard.copy(text + text2)
                            .then((value) => print('copied'));
                        CustomSnackBar.buildSnackbar(
                            context, "Added to Clipboard", 2);
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: 40,
                      color: AppColor.primaryColor,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          color: AppColor.gray,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          alignment: Alignment.center,
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: fileExtension != null
                                  ? '${fileExtension[i]}: '
                                  : '',
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                    text: userFileList[i].length <= 55
                                        ? '${(userFileList[i]['FileName'])}'
                                        : '${(userFileList[i]['FileName']).substring(0, 55)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                          // Row(
                          //   children: <Widget>[
                          //     fileExtension != null
                          //         ? Text('${fileExtension[i]}: ')
                          //         : Text(''),
                          //     Container(
                          //       padding: const EdgeInsets.only(right: 5),
                          //       child: Text(
                          //         userFileList[i].length <= 55
                          //             ? '${(userFileList[i]['FileName'])}'
                          //             : '${(userFileList[i]['FileName']).substring(0, 55)}',
                          //         style: TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //         maxLines: 1,
                          //       ),
                          //     )
                          //   ],
                          // )
                          ),
                    ))
            ],
          )
        : Container();
  }

  /// Added by : Akhil
  /// Added on : 24/Aug/2020
  /// this fucn splits the messageCc
  Widget splitMessageCc(String messageCc) {
    var ccList = messageCc.split(',');
    return Column(
      children: <Widget>[
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text(
              '${StringLocalization.of(context).getText(StringLocalization.cc)} : ',
              style: TextStyle(fontSize: 18, color: AppColor.graydark)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (int i = 0; i < ccList.length; i++)
                Container(
                  // width: 250,
                  // child: FittedBox(
                  //   fit: BoxFit.scaleDown,
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     '${ccList[i]}',
                  //     style:
                  //         TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  //     maxLines: 1,
                  //     // minFontSize: 12,
                  //   ),
                  // ),
                  child: TitleText(
                    text: '${ccList[i]}',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    // maxLine: 1,
                  ),
                )
            ],
          )
        ]),
        SizedBox(
          height: 5,
        )
      ],
    );
  }

  /// Added by : Akhil
  /// Added on : 24/Aug/2020
  /// this fucn splits the messageTo
  Widget splitMessageTo(String messageTo) {
    var toList = [];
    if (messageTo != null) {
      toList = messageTo.split(',');
    }
    return Column(
      children: <Widget>[
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text(
              '${StringLocalization.of(context).getText(StringLocalization.to)} : ',
              style: TextStyle(fontSize: 18, color: AppColor.graydark)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (int i = 0; i < toList.length; i++)
                Container(
                  // width: 250,
                  child: Text(
                    '${toList[i]}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    // minFontSize: 12,
                  ),
                ),
            ],
          )
        ]),
        SizedBox(
          height: 5,
        )
      ],
    );
  }

  Widget loadPage(MessageDetailSuccessState state, String screenFrom) {
    print("messageDetailListModel_create  ${state.messageDetailListModel.data!.createdDateTime}");
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex('#384341').withOpacity(0.2),
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              leading: IconButton(
                key: Key('emailDetailBackButton'),
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Theme.of(context).brightness == Brightness.dark
                    ? Image.asset(
                        'asset/dark_leftArrow.png',
                        width: 13,
                        height: 22,
                      )
                    : Image.asset(
                        'asset/leftArrow.png',
                        width: 13,
                        height: 22,
                      ),
              ),
              actions: [
                IconButton(
                  padding: EdgeInsets.only(right: 15),
                  icon: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'asset/delete_dark.png'
                        : 'asset/delete.png',
                    width: 33,
                    height: 33,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
              title: Text(
                StringLocalization.of(context)
                    .getText(StringLocalization.detail),
                style: TextStyle(
                    color: HexColor.fromHex('62CBC9'),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          )),
      body: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, right: 13, left: 13),
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : Colors.white,
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(-4, -4),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.75)
                            : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(4, 4),
                      ),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /// Added by: Akhil
                    /// Added on: June/1/2020
                    /// this container is responsible for displaying subject of mail
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 15),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              state
                                  .messageDetailListModel.data!.messageSubject!,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.87)
                                      : HexColor.fromHex('#384341')),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, right: 15),
                            child: Text(
                              stringLocalization
                                  .getText(screenFrom)
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.38)
                                      : HexColor.fromHex('#7F8D8C')),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      color: HexColor.fromHex('#D9E0E0'),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,

                      /// Added by: Akhil
                      /// Added on: June/1/2020
                      /// this column contains fields for message to ,message from, message body and created date time
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    '${StringLocalization.of(context).getText(StringLocalization.from)} : ',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColor.graydark)),
                                Expanded(
                                    child: Container(
                                  width: 250,
                                  child: Body1AutoText(
                                    text: state.messageDetailListModel.data!
                                                .senderUserName !=
                                            null
                                        ? '${state.messageDetailListModel.data!.senderUserName}'
                                        : screenFrom.toLowerCase() == 'outbox'
                                            ? '${state.messageDetailListModel.data!.messageFrom}'
                                            : '${state.messageDetailListModel.data!.senderUserName}',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    minFontSize: 12,
                                    maxLine: 1,
                                  ),
                                )),
//                        Material(
//                            borderRadius: BorderRadius.circular(20),
//                            child: InkWell(
//                              borderRadius: BorderRadius.circular(4),
//                              radius: 50,
//                              onTap: ()=>{},
//                              splashColor: Colors.grey[200],
//                              child: Container(
//                                width: 20, height: 22,
//                                padding: EdgeInsets.only(right: 35),
//                                child: Icon(
//                                  Icons.more_vert,
//                                  color: AppColor.primaryColor,
//                                  size: 25,
//                                ),
//                              ),))
                              ]),
                          SizedBox(height: 5),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: state.messageDetailListModel.data!
                                          .receiverUserName !=
                                      null
                                  ? splitMessageTo(state.messageDetailListModel
                                      .data!.receiverUserName!)
                                  : screenFrom.toLowerCase() == 'outbox'
                                      ? splitMessageTo(state
                                          .messageDetailListModel
                                          .data!
                                          .messageTo!)
                                      : Container()),
                          SizedBox(height: 5),
//                    || state.messageDetailListModel.data.messageCc.trim()!=''
                          state.messageDetailListModel.data!.messageCc != null
                              ? Container(
                                  alignment: Alignment.centerLeft,
                                  child: state.messageDetailListModel.data!
                                              .userNameCc !=
                                          null
                                      ? splitMessageCc(state
                                          .messageDetailListModel
                                          .data!
                                          .userNameCc!)
                                      : Container())
                              : SizedBox(),
                          state.messageDetailListModel.data!.messageType == 5
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColor.gray,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 2,
                                            color: AppColor.graydark)
                                      ]),
                                  child: Text(
                                      '${StringLocalization.of(context).getText(StringLocalization.date)} : ${DateFormat('yyyy-MM-dd – kk:mm').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(
                                            state.messageDetailListModel.data!
                                                .createdDateTime!
                                                .substring(6, 19),
                                          ),
                                        ),
                                      )}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColor.graydark)))
//                      Row(children: <Widget>[
//                        Text('${StringLocalization.of(context).getText(StringLocalization.date)} :', style: TextStyle(fontSize: 18, color: AppColor.graydark)),
//                        Text('${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(state.messageDetailListModel.data.createdDateTime))}', style: TextStyle(fontSize: 20))
//                      ])
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColor.gray,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 2,
                                            color: AppColor.graydark)
                                      ]),
                                  child: Text(
                                    '${StringLocalization.of(context).getText(StringLocalization.date)} : ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse('${state.messageDetailListModel.data!.createdDateTime!}').toLocal())}',
                                    style: TextStyle(
                                        fontSize: 16, color: AppColor.graydark),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
//                      Row(children: <Widget>[
//                        Text('${StringLocalization.of(context).getText(StringLocalization.date)} :', style: TextStyle(fontSize: 18, color: AppColor.graydark)),
//                        Text('${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(state.messageDetailListModel.data.createdDateTime.substring(6, 19))))}', style: TextStyle(fontSize: 18))
//                      ]),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    /// Added by: Akhil
                    /// Added on: June/1/2020
                    /// this container displays body of message
                    screenFrom.toLowerCase() == 'outbox'
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.messageDetailListModel.data!
                                              .messageBody ==
                                          null
                                      ? ''
                                      : state.messageDetailListModel.data!
                                          .messageBody!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white.withOpacity(0.87)
                                          : HexColor.fromHex('#384341'),
                                      fontWeight: FontWeight.w500),
                                ),
                                state.messageDetailListModel.data!
                                            .attachmentFiles !=
                                        null
                                    ? state.messageDetailListModel.data!
                                            .attachmentFiles!.isNotEmpty
                                        ? buildGridView(
                                            state.messageDetailListModel.data!
                                                .attachmentFiles,
                                            state.messageDetailListModel.data!
                                                .fileExtension)
                                        : SizedBox(height: 10)
                                    :
                                    // state.messageDetailListModel.data.userFile!= null ? buildGridView(state.messageDetailListModel.data.userFile, state.messageDetailListModel.data.fileExtension):
                                    SizedBox(height: 10)
                              ],
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                state.messageDetailListModel.data!
                                            .requestType ==
                                        'api'
                                    ? Text(
                                        state.messageDetailListModel.data!
                                                    .messageBody ==
                                                null
                                            ? ''
                                            : state.messageDetailListModel.data!
                                                .messageBody!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors.white.withOpacity(0.87)
                                                : HexColor.fromHex('#384341'),
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Html(
                                        data: state.messageDetailListModel.data!
                                                    .messageBody ==
                                                null
                                            ? ''
                                            : state.messageDetailListModel.data!
                                                .messageBody,
                                        style: {
                                            'html': Style.fromTextStyle(
                                              TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                          .withOpacity(0.87)
                                                      : HexColor.fromHex(
                                                          '#384341'),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          }),
                                state.messageDetailListModel.data!
                                            .attachmentFiles !=
                                        null
                                    ? state.messageDetailListModel.data!
                                            .attachmentFiles!.isNotEmpty
                                        ? buildGridView(
                                            state.messageDetailListModel.data!
                                                .attachmentFiles,
                                            state.messageDetailListModel.data!
                                                .fileExtension)
                                        : SizedBox(height: 10)
                                    :
                                    // state.messageDetailListModel.data.userFile!= null ? buildGridView(state.messageDetailListModel.data.userFile, state.messageDetailListModel.data.fileExtension):
                                    SizedBox(height: 10)
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    state.messageDetailListModel.data!.messageTree!.isNotEmpty
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.messageDetailListModel.data!
                                .messageTree!.length,
                            itemBuilder: (context, index) {
                              return replyBox(
                                  index,
                                  state.messageDetailListModel.data!
                                      .messageTree!.length,
                                  state.messageDetailListModel.data!
                                      .messageTree![index]);
                            },
                          )
                        : SizedBox(),
                  ],
                ),
              ),

              state.messageDetailListModel.data!.messageType != 5
                  ? state.messageDetailListModel.data!.messageType == 3
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(
                              top: 20, left: 13, right: 13, bottom: 20),
                          child: Container(
                              height: 33,
                              child: Row(children: <Widget>[
                                Expanded(
                                  /// Added by: Akhil
                                  /// Added on: June/1/2020
                                  /// pushing this button wil cause the compose mail screen to be pushed with to , subject with re: prfix
                                  child: Container(
                                    height: 33,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? HexColor.fromHex('#00AFAA')
                                                .withOpacity(0.9)
                                            : HexColor.fromHex('#00AFAA')
                                                .withOpacity(0.7),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? HexColor.fromHex('#D1D9E6')
                                                    .withOpacity(0.1)
                                                : Colors.white,
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                            offset: Offset(-5, -5),
                                          ),
                                          BoxShadow(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors.black.withOpacity(0.75)
                                                : HexColor.fromHex('#D1D9E6'),
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                            offset: Offset(5, 5),
                                          ),
                                        ]),
                                    child: Container(
                                      decoration: ConcaveDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          depression: 10,
                                          colors: [
                                            Colors.white,
                                            HexColor.fromHex('#D1D9E6'),
                                          ]),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 13, right: 20),
                                        child: TextButton(
                                          key: Key('reply'),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Image.asset(
                                                'asset/reply.png',
                                                width: 19,
                                                height: 15,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.black
                                                    : null,
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  height: 23,
                                                  child: Center(
                                                    // child: FittedBox(
                                                    //   fit: BoxFit.scaleDown,
                                                    //   alignment:
                                                    //       Alignment.centerLeft,
                                                    //   child: Text(
                                                    //     StringLocalization.of(
                                                    //             context)
                                                    //         .getText(
                                                    //             StringLocalization
                                                    //                 .reply),
                                                    //     style: TextStyle(
                                                    //       fontWeight:
                                                    //           FontWeight.bold,
                                                    //       fontSize: 14,
                                                    //       color: Theme.of(context)
                                                    //                   .brightness ==
                                                    //               Brightness.dark
                                                    //           ? HexColor.fromHex(
                                                    //               '#111B1A')
                                                    //           : Colors.white,
                                                    //     ),
                                                    //     maxLines: 1,
                                                    //     // minFontSize: 8,
                                                    //   ),
                                                    // ),
                                                    child: Body1AutoText(
                                                      text: StringLocalization
                                                              .of(context)
                                                          .getText(
                                                              StringLocalization
                                                                  .reply),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex(
                                                              '#111B1A')
                                                          : Colors.white,
                                                      maxLine: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          onPressed: () {
                                            if (context != null) {
                                              String subj;
                                              List<String> subjList =
                                                  <String>[];
                                              if ((widget.replyMailData!.data!
                                                      .messageSubject)!
                                                  .contains('Re : ')) {
                                                subjList = widget.replyMailData!
                                                    .data!.messageSubject!
                                                    .split('Re : ');
                                                subj = subjList[1];
                                              } else {
                                                subj = widget.replyMailData!
                                                    .data!.messageSubject!;
                                              }
                                              Navigator.of(context).push(
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          ComposeMail(
                                                            messageId: widget
                                                                .replyMailData!
                                                                .data!
                                                                .messageID,
                                                            messageResponseType:
                                                                1,
                                                            to: widget
                                                                .replyMailData!
                                                                .data!
                                                                .messageFrom,
                                                            subject:
                                                                'Re : ${subj}',
                                                            userId: widget
                                                                .replyMailData!
                                                                .userId!,
                                                            userEmail: widget
                                                                .replyMailData!
                                                                .userEmail!,
                                                            sendMail: widget
                                                                .replyMailData!
                                                                .sendMail!,
                                                            from: widget
                                                                .replyMailData!
                                                                .data!
                                                                .messageTo,
                                                            parentGUIID: state
                                                                .messageDetailListModel
                                                                .data!
                                                                .parentGUIID,
                                                          )));
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 9,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 33,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? HexColor.fromHex('#00AFAA')
                                                .withOpacity(0.9)
                                            : HexColor.fromHex('#00AFAA')
                                                .withOpacity(0.7),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? HexColor.fromHex('#D1D9E6')
                                                    .withOpacity(0.1)
                                                : Colors.white,
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                            offset: Offset(-5, -5),
                                          ),
                                          BoxShadow(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors.black.withOpacity(0.75)
                                                : HexColor.fromHex('#D1D9E6'),
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                            offset: Offset(5, 5),
                                          ),
                                        ]),
                                    child: Container(
                                      decoration: ConcaveDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          depression: 10,
                                          colors: [
                                            Colors.white,
                                            HexColor.fromHex('#D1D9E6'),
                                          ]),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 13, right: 11),
                                        child: TextButton(
                                          key: Key('replyAll'),

                                          /// Added by: Akhil
                                          /// Added on: June/1/2020
                                          /// pushing this button wil cause the compose mail screen to be pushed with to ,cc and subject with re: prefix

                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Image.asset(
                                                'asset/reply_all.png',
                                                width: 24.5,
                                                height: 15,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.black
                                                    : null,
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  height: 18,
                                                  child: Center(
                                                    // child: FittedBox(
                                                    //   fit: BoxFit.scaleDown,
                                                    //   alignment:
                                                    //       Alignment.centerLeft,
                                                    //   child: Text(
                                                    //     StringLocalization.of(
                                                    //             context)
                                                    //         .getText(
                                                    //             StringLocalization
                                                    //                 .replyAll),
                                                    //     style: TextStyle(
                                                    //         fontWeight:
                                                    //             FontWeight.bold,
                                                    //         fontSize: 14,
                                                    //         color: Theme.of(context)
                                                    //                     .brightness ==
                                                    //                 Brightness.dark
                                                    //             ? HexColor.fromHex(
                                                    //                 '#111B1A')
                                                    //             : Colors.white),
                                                    //     maxLines: 1,
                                                    //     // minFontSize: 4,
                                                    //   ),
                                                    // ),
                                                    child: Body1AutoText(
                                                      text:
                                                          StringLocalization.of(
                                                                  context)
                                                              .getText(
                                                        StringLocalization
                                                            .replyAll,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex(
                                                              '#111B1A')
                                                          : Colors.white,
                                                      maxLine: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          onPressed: () {
                                            String subj;
                                            List<String> subjList = <String>[];
                                            if ((widget.replyMailData!.data!
                                                    .messageSubject)!
                                                .contains('Re :')) {
                                              subjList = widget.replyMailData!
                                                  .data!.messageSubject!
                                                  .split('Re :');
                                              subj = subjList[1];
                                            } else {
                                              subj = widget.replyMailData!.data!
                                                  .messageSubject!;
                                            }
                                            if (context != null) {
                                              Navigator.of(context).push(
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          ComposeMail(
                                                            messageId: widget
                                                                .replyMailData!
                                                                .data!
                                                                .messageID,
                                                            messageResponseType:
                                                                2,
                                                            cc: widget
                                                                .replyMailData!
                                                                .data!
                                                                .messageCc,
                                                            subject:
                                                                'Re : ${subj}',
                                                            userId: widget
                                                                .replyMailData!
                                                                .userId!,
                                                            userEmail: widget
                                                                .replyMailData!
                                                                .userEmail!,
                                                            sendMail: widget
                                                                .replyMailData!
                                                                .sendMail!,
                                                            from: widget
                                                                .replyMailData!
                                                                .data!
                                                                .messageTo,
                                                            to: widget
                                                                .replyMailData!
                                                                .data!
                                                                .messageFrom,
                                                            parentGUIID: state
                                                                .messageDetailListModel
                                                                .data!
                                                                .parentGUIID,
                                                          )));
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 9,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 33,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? HexColor.fromHex('#00AFAA')
                                                .withOpacity(0.9)
                                            : HexColor.fromHex('#00AFAA')
                                                .withOpacity(0.7),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? HexColor.fromHex('#D1D9E6')
                                                    .withOpacity(0.1)
                                                : Colors.white,
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                            offset: Offset(-5, -5),
                                          ),
                                          BoxShadow(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors.black.withOpacity(0.75)
                                                : HexColor.fromHex('#D1D9E6'),
                                            blurRadius: 5,
                                            spreadRadius: 0,
                                            offset: Offset(5, 5),
                                          ),
                                        ]),
                                    child: Container(
                                      decoration: ConcaveDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          depression: 10,
                                          colors: [
                                            Colors.white,
                                            HexColor.fromHex('#D1D9E6'),
                                          ]),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13),
                                        child: TextButton(
                                          key: Key('forward'),

                                          /// Added by: Akhil
                                          /// Added on: June/1/2020
                                          /// pushing this button wil cause the compose mail screen to be pushed with subject with fwd prefix and the body of mail

                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Image.asset(
                                                'asset/forward.png',
                                                width: 19,
                                                height: 15,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.black
                                                    : null,
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  height: 23,
                                                  child: Center(
                                                    // child: FittedBox(
                                                    //   fit: BoxFit.scaleDown,
                                                    //   alignment:
                                                    //       Alignment.centerLeft,
                                                    //   child: Text(
                                                    //     StringLocalization.of(
                                                    //             context)
                                                    //         .getText(
                                                    //             StringLocalization
                                                    //                 .forward),
                                                    //     style: TextStyle(
                                                    //       fontWeight:
                                                    //           FontWeight.bold,
                                                    //       fontSize: 14,
                                                    //       color: Theme.of(context)
                                                    //                   .brightness ==
                                                    //               Brightness.dark
                                                    //           ? HexColor.fromHex(
                                                    //               '#111B1A')
                                                    //           : Colors.white,
                                                    //     ),
                                                    //     maxLines: 1,
                                                    //     // minFontSize: 8,
                                                    //   ),
                                                    // ),
                                                    child: Body1AutoText(
                                                      text: StringLocalization
                                                              .of(context)
                                                          .getText(
                                                              StringLocalization
                                                                  .forward),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex(
                                                              '#111B1A')
                                                          : Colors.white,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLine: 1,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          onPressed: () {
                                            String subj;
                                            List<String> subjList = <String>[];
                                            if ((widget.replyMailData!.data!
                                                    .messageSubject)!
                                                .contains('Fwd :')) {
                                              subjList = widget.replyMailData!
                                                  .data!.messageSubject!
                                                  .split('Fwd :');
                                              subj = subjList[1];
                                            } else {
                                              subj = widget.replyMailData!.data!
                                                  .messageSubject!;
                                            }
                                            if (context != null) {
                                              Navigator.of(context).push(
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          ComposeMail(
                                                            messageId: widget
                                                                .replyMailData!
                                                                .data!
                                                                .messageID,
                                                            messageResponseType:
                                                                3,
                                                            body: widget
                                                                .replyMailData!
                                                                .data!
                                                                .messageBody,
                                                            subject:
                                                                'Fwd : ${subj}',
                                                            userId: widget
                                                                .replyMailData!
                                                                .userId!,
                                                            userEmail: widget
                                                                .replyMailData!
                                                                .userEmail!,
                                                            from: widget
                                                                .replyMailData!
                                                                .data!
                                                                .messageFrom,
                                                            sendMail: widget
                                                                .replyMailData!
                                                                .sendMail!,
                                                            parentGUIID: state
                                                                .messageDetailListModel
                                                                .data!
                                                                .parentGUIID,
                                                          )));
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ])))
                  : Container(),

              /// Added by: Akhil
              /// Added on: June/1/2020
              /// this expanded contains row of three buttons i.e., reply ,reply all , forward
            ],
          ),
        ),
      ),
    );
  }

  String isHtml(String testString) {
    RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);

    return testString.replaceAll(exp, '');
  }
}
