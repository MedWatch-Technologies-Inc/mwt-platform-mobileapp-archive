import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:health_gauge/RepositoryDB/email_data.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart'
    as userContact;
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';
import 'package:health_gauge/screens/inbox/compose_bloc.dart';
import 'package:health_gauge/screens/inbox/inbox_events.dart';
import 'package:health_gauge/screens/inbox/inbox_states.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Added by: Akhil
/// Added on: May/29/2020ComposeMail
/// This widget is responsible for all the compoase mail actions such as saving drafts send mail saving outbox and all
/// the handling related to database
class ComposeMail extends StatefulWidget {
  final int? draftId;
  final String? to;
  final String? subject;
  final String? cc;
  final String? body;
  final InboxData? data;
  final String? userEmail;
  final int? userId;
  final Function? sendMail;
  final String? from;
  final userContact.UserData? uData;
  final int? messageId;
  final int? messageResponseType;
  final String? parentGUIID;
  final bool? isComingFromContactScreen;
  final String? requestType;

  ComposeMail(
      {this.subject,
      this.to,
      this.cc,
      this.body,
      this.data,
      this.userEmail,
      this.userId,
      this.sendMail,
      this.from,
      this.uData,
      this.messageId,
      this.messageResponseType,
      this.parentGUIID,
      this.draftId,
      this.isComingFromContactScreen,
      this.requestType});

  @override
  _ComposeMailState createState() => _ComposeMailState();
}

class _ComposeMailState extends State<ComposeMail> {
  late TextEditingController composeMailToController;
  late TextEditingController composeMailSubjectController;
  late TextEditingController composeMailMailBodyController;
  late TextEditingController composeMailCcController;
  bool isToExpanded = false;
  ComposeBloc? composeBloc;
  SharedPreferences? sharedPreferences;
  EmailData? emailData;
  bool? isInternetAvailable;
  Function? sendMail;
  userContact.UserListModel? userList;
  String toContacts = '';
  List<userContact.UserData>? toContactData;
  List<userContact.UserData>? ccContactData;
  FocusNode? toFocusnode;
  FocusNode? ccFocusNode;
  bool isToCompressed = false;
  bool isCcCompressed = false;
  FocusNode? subjectFocusNode;
  FocusNode? bodyFocusNode;
  final dbHelper = DatabaseHelper.instance;
  List<List<String>> fileNameList = [];
  List<String> base64FileList = [];
  List<String> fileExtensionList = [];
  String _error = 'No Error Dectected';
  List<File> resultsList = [];
  List<File> filteredResultList = [];

  String emailString(List<userContact.UserData> list) {
    String email = '';
    for (var v in list) {
      if (v.email != list.last.email)
        email += '${v.email},';
      else
        email += '${v.email}';
    }
    return email;
  }

  List<userContact.UserData> getSearchedList(String pattern) {
    print('Search Contact Query : $pattern');
    List<String> elements = pattern.split(',');
    if (pattern.isNotEmpty) {
      return userList?.data?.where((v) {
            return (v.firstName!
                    .toUpperCase()
                    .contains(elements.last.toUpperCase()) ||
                v.lastName!
                    .toUpperCase()
                    .contains(elements.last.toUpperCase()) ||
                '${v.firstName!.toUpperCase()} ${v.lastName!.toUpperCase()}'
                    .contains(elements.last.toUpperCase()));
          }).toList() ??
          [];
    }
    return [];
  }

  /// Added by: Akhil
  /// Added on: May/29/2020
  /// this method is responsible for disposing all the controllers and blocs
  @override
  void dispose() {
    print('ComposeMail Dispose');
    super.dispose();
    composeBloc?.close();
    toFocusnode?.dispose();
    ccFocusNode?.dispose();
    bodyFocusNode?.dispose();
    subjectFocusNode?.dispose();
    composeMailCcController.dispose();
    composeMailMailBodyController.dispose();
    composeMailSubjectController.dispose();
    composeMailToController.dispose();
  }

  void onToFocusChange() {
    if (toFocusnode!.hasFocus) {
      setState(() {
        isToCompressed = true;
      });
    } else {
      setState(() {
        /*isToCompressed = false;*/
      });
    }
  }

  void onCcFocusChange() {
    if (toFocusnode!.hasFocus) {
      setState(() {
        isCcCompressed = true;
      });
    } else {
      setState(() {
        isCcCompressed = false;
      });
    }
  }

  void insertToFromEmail(
      String emailId, List<userContact.UserData> ContactData) async {
    if (userList == null) {
      dbHelper.database;
      var dbResult = await dbHelper.getContactsList(widget.userId!);
      userList = UserListModel(data: dbResult, response: 200, result: true);
    }
    if (emailId != null) {
      List<String> elements = emailId.split(',');
      for (var v in userList!.data!) {
        for (int i = 0; i < elements.length; i++) {
          if (elements[i] == v.email) {
            setState(() {
              ContactData.add(v);
            });

            break;
          }
        }
      }
    }
  }

  // Added by: Akhil
  /// Added on: Aug/17/2020
  //function to Select the File from Gallery
  Future<void> loadAssets() async {
    // if(resultsList.length == 0){
    //   resultsList = List<File>();
    // }
    String error = 'No Error Dectected';
    filteredResultList = <File>[];
    fileNameList = [];
    base64FileList = [];
    fileExtensionList = [];
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, allowCompression: true);
      if (result != null) {
        double totalSize = 0;
        bool flag = false;
        int index = 0;
        resultsList =
            resultsList + result.paths.map((path) => File(path!)).toList();
        resultsList = resultsList.toSet().toList();
        for (var element in resultsList) {
          double sizeInMb = element.lengthSync() / (1024 * 1024);
          if (totalSize + sizeInMb >= 25) {
            flag = true;
            break;
          } else {
            filteredResultList.add(element);
            totalSize += sizeInMb;
            index += 1;
          }
        }
        if (flag) {
          if (resultsList.length == 1) {
            CustomSnackBar.buildSnackbar(
                context,
                'The files you are trying to send exceed the 25 MB total attachment limit.',
                3);
          } else {
            CustomSnackBar.buildSnackbar(
                context, 'One or more files not attached. Limit 25 MB', 3);
          }
          resultsList.removeRange(index, resultsList.length);
        }
      }
      //  resultsList = await FilePicker.getMultiFile(allowCompression: true);
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      getFileName(filteredResultList);
      _error = error;
    });
  }

  /// Added by: Akhil
  /// Added on: Aug/17/2020
  //function to Show the Collected File
  Widget buildGridView() {
    // return Wrap(
    //   spacing: 10,
    //   runSpacing: 20,
    //   children: <Widget>[
    //     // for loop
    //     for (int i = 0; i < fileNameList.length; i++)
    //       Container(
    //           width: MediaQuery.of(context).size.width * 0.90,
    //           height: 40,
    //           color: AppColor.primaryColor,
    //           child: Stack(
    //             children: <Widget>[
    //               Container(
    //                   color: AppColor.gray,
    //                   padding: EdgeInsets.only(left: 5, right: 5),
    //                   alignment: Alignment.center,
    //                   child: Row(
    //                     children: <Widget>[
    //                       Text('${fileNameList[i][1]}: ',style: TextStyle(
    //                         color: Colors.black,
    //                       ),),
    //                       Container(
    //                         padding: const EdgeInsets.only(right: 5),
    //                         child: Text(
    //                           fileNameList[i][2].length <= 55
    //                               ? '${(fileNameList[i][2])}'
    //                               : '${(fileNameList[i][2]).substring(0, 55)}',
    //                           style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             color: Colors.black,
    //                           ),
    //                           maxLines: 1,
    //                         ),
    //                       )
    //                     ],
    //                   )),
    //               Container(
    //                 alignment: Alignment.topRight,
    //                 child: IconButton(
    //                   splashColor: Colors.grey,
    //                   padding: EdgeInsets.all(1),
    //                   color: Colors.white,
    //                   icon: Icon(
    //                     Icons.cancel,
    //                     color: AppColor.primaryColor,
    //                     size: 15,
    //                   ),
    //                   onPressed: () {
    //                     onCancel(i);
    //                   },
    //                 ),
    //               )
    //             ],
    //           ))
    //   ],
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < fileNameList.length; i++)
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: fileNameList[i][0].toLowerCase() == 'image'
                ? Stack(
                    children: [
                      Image.file(
                        resultsList[i],
                        width: 300.w,
                        height: 180.h,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 50.h,
                        child: Container(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[800]
                                    : Colors.grey[300],
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.insert_photo_sharp,
                                  color: HexColor.fromHex("#62CBC9"),
                                ),
                                SizedBox(
                                  width: 9,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Body1AutoText(
                                      text: fileNameList[i][2].length <= 55
                                          ? '${(fileNameList[i][2])}'
                                          : '${(fileNameList[i][2]).substring(0, 55)}',
                                      maxLine: 1,
                                      overflow: TextOverflow.ellipsis,
                                      minFontSize: 16,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                    child: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    onCancel(i);
                                  },
                                ))
                              ],
                            )),
                      )
                    ],
                  )
                : Container(
                    width: 300.w,
                    height: 40.h,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[300],
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 4.w),
                        fileNameList[i][0].toLowerCase() == 'video'
                            ? Icon(
                                Icons.video_collection,
                                color: HexColor.fromHex("#62CBC9"),
                              )
                            : Icon(
                                Icons.insert_drive_file,
                                color: HexColor.fromHex("#62CBC9"),
                              ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            child: Body1AutoText(
                              text: fileNameList[i][2].length <= 55
                                  ? '${(fileNameList[i][2])}'
                                  : '${(fileNameList[i][2]).substring(0, 55)}',
                              fontWeight: FontWeight.bold,
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 16,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.clear,
                            ),
                            onPressed: () {
                              onCancel(i);
                            },
                          ),
                        )
                      ],
                    )),
          )
      ],
    );
  }

  /// Added by: Akhil
  /// Added on: Aug/17/2020
  //function to cancel/unselect the image
  void onCancel(index) {
    if (fileNameList != []) {
      fileNameList.removeAt(index);
      resultsList.removeAt(index);
      filteredResultList.removeAt(index);
    }
    setState(() {});
  }

  /// Added by: Akhil
  /// Added on: Aug/17/2020
  /// function to get the file details i.e. name, path.
  void getFileName(List<File> file) async {
    List<List<String>> nameOfFile = [];
    Uint8List encode;
    for (int i = 0; i < file.length; i++) {
      final path = file[i].path;

      List<String> name = path.split('/');
      //to get the type of file
      String mimeStr = lookupMimeType(path) ?? '';
      nameOfFile.add(mimeStr.split('/'));
      //to get the name of file
      nameOfFile[i].add(name[name.length - 1]);
      fileNameList.add(nameOfFile[i]);
      fileExtensionList.add(nameOfFile[i][1]);
      //encode the every file in list
      encode = await File(path).readAsBytesSync();
      base64FileList.add(base64Encode(encode));
    }
  }

  /// Added by: Akhil
  /// Added on: May/29/2020
  /// in this function we are initializing all the variables and objects that are needed in widgets
  @override
  void initState() {
    super.initState();
    composeMailCcController = TextEditingController();
    composeMailMailBodyController = TextEditingController();
    composeMailSubjectController = TextEditingController();
    composeMailToController = TextEditingController();
    composeMailCcController.text = widget.cc ?? '';
    toContactData = [];
    ccContactData = [];
    toFocusnode = FocusNode();
    toFocusnode?.addListener(onToFocusChange);
    ccFocusNode = FocusNode();
    ccFocusNode?.addListener(onCcFocusChange);
    bodyFocusNode = FocusNode();
    subjectFocusNode = FocusNode();
    widget.uData != null ? toContactData?.add(widget.uData!) : null;

    /// Added by: Akhil
    /// Added on: May/29/2020
    /// in this state ment we are checking if user email is same as 'to' then set the value of toController as from
    if (widget.to != null) {
      widget.userEmail == widget.to
          ? insertToFromEmail(widget.from!, toContactData!)
          : insertToFromEmail(widget.to!, toContactData!);
    }
    if (widget.cc != null) {
      insertToFromEmail(widget.cc!, ccContactData!);
    }

    /// Added by: Akhil
    /// Added on: May/29/2020
    /// setting message body
    composeMailMailBodyController.text = widget.body ?? '';

    /// Added by: Akhil
    /// Added on: May/29/2020
    /// setting message  subject
    composeMailSubjectController.text = widget.subject ?? '';
    emailData = EmailData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    composeBloc = ComposeBloc();
    //composeBloc = BlocProvider.of<ComposeBloc>(context);
    print('Compose State ${composeBloc?.state.runtimeType}');
    composeBloc?.add(LoadContactList(userId: widget.userId!));

    /// Added by: Akhil
    /// Added on: May/29/2020
    /// initializing compose bloc
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    print('Entered in compose mail');
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

              /// Added by: Akhil
              /// Added on: May/29/2020
              /// Widget of close button
              leading: IconButton(
                  key: Key('closeComposeScreen'),
                  padding: EdgeInsets.only(left: 13),
                  icon: Theme.of(context).brightness == Brightness.dark
                      ? Image.asset(
                          'asset/dark_close.png',
                          height: 33,
                          width: 33,
                        )
                      : Image.asset(
                          'asset/close.png',
                          height: 33,
                          width: 33,
                        ),
                  onPressed: () async {
                    /// Added by: Akhil
                    /// Added on: May/29/2020
                    /// if to or subject is not empty then check
                    /// if mail data was passed or not at time of initialization
                    /// if data was passed then save the drafts data on the same message id
                    print(composeMailToController.text);
                    print(composeMailSubjectController.text);
                    if (composeMailToController.text.isNotEmpty ||
                        composeMailSubjectController.text.isNotEmpty ||
                        emailString(toContactData!).isNotEmpty) {
                      if (widget.data != null) {
                        widget.data?.messageTo = emailString(toContactData!);
                        widget.data?.messageBody =
                            composeMailMailBodyController.text;
                        widget.data?.messageSubject =
                            composeMailSubjectController.text;
                        widget.data?.messageCc = emailString(ccContactData!);
                        await emailData?.updateDrafts(
                            inboxData: widget.data!, id: widget.data!.id);
                        Navigator.of(context).pop();
                      }

                      /// Added by: Akhil
                      /// Added on: May/29/2020
                      /// else show dialog to confirm user to save the drafts
                      else {
                        showDialog(
                            context: context,
                            useRootNavigator: true,
                            barrierColor: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? HexColor.fromHex('#7F8D8C').withOpacity(0.6)
                                : HexColor.fromHex('#384341').withOpacity(0.6),
                            builder: (context) => draftConfirmationDialog());
                      }
                    }

                    /// Added by: Akhil
                    /// Added on: May/29/2020
                    /// if to and subjects are empty then pop
                    else {
                      Navigator.pop(context);
                    }
                  }),

              title: Text(
                  StringLocalization.of(context)
                      .getText(StringLocalization.compose),
                  style: TextStyle(
                      color: HexColor.fromHex('#62CBC9'),
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              centerTitle: true,
              actions: <Widget>[
                /// Added by: Akhil
                /// Added on: May/29/2020
                /// button for adding attachment
                IconButton(
                  padding: EdgeInsets.only(right: 15),
                  icon: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'asset/attachment_dark.png'
                        : 'asset/attachment.png',
                    width: 33,
                    height: 33,
                  ),
                  onPressed: () async {
                    /// Added by: Akhil
                    /// Added on: Aug/17/2020
                    /// to select the multiple files
                    loadAssets();
                  },
                ),
                IconButton(
                  key: Key('sendMail'),
                  padding: EdgeInsets.only(right: 15),
                  icon: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'asset/send_dark.png'
                        : 'asset/send.png',
                    width: 33,
                    height: 33,
                  ),

                  /// Added by: Akhil
                  /// Added on: May/29/2020
                  /// by pressing this button function wil check is to and subject field are not empty
                  /// if to and subject field are not empty then check if internet is available
                  /// if internet is us available then add send event
                  /// else save the mail to out box
                  onPressed: () {
                    print(toContactData);
                    print(composeMailSubjectController.text);
                    print(widget.sendMail);
                    print(widget.userEmail);
                    print(base64FileList);
                    print('____________________________________');

                    if (toContactData!.isNotEmpty &&
                        composeMailSubjectController.text.trim().isNotEmpty) {
                      widget.sendMail!(
                        InboxData(
                            messageFrom: widget.userEmail ?? '',
                            messageBody:
                                composeMailMailBodyController.text.trim(),
                            messageCc: emailString(ccContactData!),
                            messageTo: emailString(toContactData!),
                            messageSubject:
                                composeMailSubjectController.text.trim(),
                            userFile: base64FileList.isNotEmpty
                                ? base64FileList[0]
                                : null,
                            fileExtension: fileExtensionList.isNotEmpty
                                ? fileExtensionList[0]
                                : null,
                            messageID: widget.messageId ?? -1,
                            parentGUIID: widget.parentGUIID ?? '',
                            msgResponseTypeID: widget.messageResponseType ?? 0,
                            requestType: 'api'),
                        // can add draftId if compose is from draft
                        widget.draftId,
                      );
                      composeMailSubjectController.clear();
                      composeMailToController.clear();
                      composeMailCcController.clear();
                      composeMailMailBodyController.clear();

                      print('here is ');
                      print(widget.isComingFromContactScreen);
                      print(context);
                      if (widget.isComingFromContactScreen != null) {
                        // Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName))
                        Navigator.of(context).pop();
                      } else {
                        print('inside compose mail.dart file in context!=null');
                        Navigator.of(context).popUntil(
                          (route) {
                            print(route.settings.name);
                            // MailLandingPage not in route.settings.name
                            return route.settings.name == 'MailLandingPage';
                          },
                        );
                      }
                    }

                    /// Added by: Akhil
                    /// Added on: May/29/2020
                    ///if to or subject is empty then show a dialog suggesting user that theese field cannot be empty
                    else {
                      showDialog(
                          context: context,
                          barrierColor: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? HexColor.fromHex('#7F8D8C').withOpacity(0.6)
                              : HexColor.fromHex('#384341').withOpacity(0.6),
                          useRootNavigator: true,
                          builder: (context) => dialog());
                    }
                  },
                ),
              ],
            ),
          )),
      body: GestureDetector(
        ///Added by: Akhil
        ///Added on:Aug/26/2020
        ///to dismiss the keyboard
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: <Widget>[
            BlocListener(
              bloc: composeBloc,
              listener: (BuildContext context, InboxState state) {
                print('BlocListener State : ${state.runtimeType}');
                if (state is LoadedContactList) {
                  userList = state.response;
                }
              },
              child: Container(),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(13.w, 16.h, 13.w, 16.h),
                padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// Added by: Akhil
                      /// Added on: May/29/2020
                      /// Widget of To text field
                      Padding(
                        padding: EdgeInsets.only(top: 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 18),
                              child: Text(
                                StringLocalization.of(context)
                                    .getText(StringLocalization.to),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white.withOpacity(0.38)
                                        : HexColor.fromHex('#7F8D8C'),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                ),
                                child: Wrap(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: isToCompressed &&
                                              toContactData!.length > 2
                                          ? Wrap(
                                              children: <Widget>[
                                                Container(
                                                  // height: 30.h,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5.h, right: 5.w),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      border: Border.all(
                                                          color: AppColor
                                                              .graydark),
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? AppColor
                                                              .darkBackgroundColor
                                                          : AppColor
                                                              .backgroundColor),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      CircleAvatar(
                                                        // backgroundImage:
                                                        //     CachedNetworkImageProvider(
                                                        //         toContactData[0]
                                                        //             .picture),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              toContactData![0]
                                                                      .picture ??
                                                                  '',
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width: 20.0.w,
                                                            height: 20.0.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Image.asset(
                                                            "asset/m_profile_icon.png",
                                                            color: Colors.white,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            "asset/m_profile_icon.png",
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        radius: 15,
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      Text(
                                                        "${toContactData![0].firstName} ${toContactData![0].lastName}",
                                                        style: TextStyle(
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                    .withOpacity(
                                                                        0.87)
                                                                : AppColor
                                                                    .darkBackgroundColor),
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      GestureDetector(
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 12,
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            toContactData?.remove(
                                                                toContactData?[
                                                                    0]);
                                                            userList?.data?.add(
                                                                toContactData![
                                                                    0]);
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  // height: 30.h,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5.h, right: 5.w),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      border: Border.all(
                                                          color: AppColor
                                                              .graydark),
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? AppColor
                                                              .darkBackgroundColor
                                                          : AppColor
                                                              .backgroundColor),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      CircleAvatar(
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              toContactData![1]
                                                                      .picture ??
                                                                  '',
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width: 50.0.w,
                                                            height: 50.0.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Image.asset(
                                                            "asset/m_profile_icon.png",
                                                            color: Colors.white,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            "asset/m_profile_icon.png",
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        radius: 15,
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      Text(
                                                        "${toContactData![1].firstName} ${toContactData![1].lastName}",
                                                        style: TextStyle(
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                    .withOpacity(
                                                                        0.87)
                                                                : AppColor
                                                                    .darkBackgroundColor),
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      GestureDetector(
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 12,
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            toContactData?.remove(
                                                                toContactData?[
                                                                    1]);
                                                            userList?.data?.add(
                                                                toContactData![
                                                                    1]);
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                CircleAvatar(
                                                  backgroundColor:
                                                      AppColor.green,
                                                  child: GestureDetector(
                                                    child: Text(
                                                      '+${toContactData!.length - 2}',
                                                      style: TextStyle(
                                                          color: AppColor.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        isToCompressed = false;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Wrap(
                                              alignment: WrapAlignment.start,
                                              direction: Axis.horizontal,
                                              children:
                                                  toContactData!.map((item) {
                                                return Container(
                                                  // height: 30.h,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5.h, right: 5.w),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      border: Border.all(
                                                          color: AppColor
                                                              .graydark),
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? AppColor
                                                              .darkBackgroundColor
                                                          : AppColor
                                                              .backgroundColor),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      CircleAvatar(
                                                        // backgroundImage:
                                                        //     CachedNetworkImageProvider(
                                                        //         item.picture),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              item.picture ??
                                                                  '',
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width: 20.0.w,
                                                            height: 20.0.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Image.asset(
                                                            "asset/m_profile_icon.png",
                                                            color: Colors.white,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            "asset/m_profile_icon.png",
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        radius: 15,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${item.firstName} ${item.lastName}",
                                                        style: TextStyle(
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                    .withOpacity(
                                                                        0.87)
                                                                : AppColor
                                                                    .darkBackgroundColor),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      GestureDetector(
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 12,
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            toContactData!
                                                                .remove(item);
                                                            userList!.data!
                                                                .add(item);
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          key: Key('enterTo'),
                                          child: suggestionTextField(
                                              hint: 'enterTo',
                                              maxLines: null,
                                              controller:
                                                  composeMailToController,
                                              padding: 15,
                                              keyboardType: TextInputType.text,
                                              dataList: toContactData),
                                        ),
                                        IconButton(
                                          key: Key('showCC'),
                                          icon: Icon(isToExpanded
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down),
                                          onPressed: () {
                                            setState(() {
                                              isToExpanded = !isToExpanded;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            /// Added by: Akhil
                            /// Added on: May/29/2020
                            /// button to expand to field to add cc
                          ],
                        ),
                      ),

                      /// Added by: Akhil
                      /// Added on: May/29/2020
                      /// Widget of cc text field
                      Container(
                        // margin: EdgeInsets.only(top:7),
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.15)
                            : HexColor.fromHex('#D9E0E0'),
                      ),
                      isToExpanded
                          ? Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  StringLocalization.of(context)
                                      .getText(StringLocalization.cc),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white.withOpacity(0.38)
                                          : HexColor.fromHex('#7F8D8C'),
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: isCcCompressed &&
                                            ccContactData!.length > 2
                                        ? Wrap(
                                            children: <Widget>[
                                              Container(
                                                // height: 30.h,
                                                margin: EdgeInsets.only(
                                                    bottom: 5.h, right: 5.w),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    border: Border.all(
                                                        color:
                                                            AppColor.graydark),
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? AppColor
                                                            .darkBackgroundColor
                                                        : AppColor
                                                            .backgroundColor),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      // backgroundImage:
                                                      // CachedNetworkImageProvider(
                                                      //     ccContactData[0]
                                                      //         .picture),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            ccContactData![0]
                                                                    .picture ??
                                                                '',
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          width: 20.0.w,
                                                          height: 20.0.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        placeholder:
                                                            (context, url) =>
                                                                Image.asset(
                                                          "asset/m_profile_icon.png",
                                                          color: Colors.white,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          "asset/m_profile_icon.png",
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      radius: 15,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "${ccContactData![0].firstName} ${ccContactData![0].lastName}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                                  .withOpacity(
                                                                      0.87)
                                                              : HexColor.fromHex(
                                                                  "#7F8D8C"),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    GestureDetector(
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 12,
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          ccContactData?.remove(
                                                              ccContactData![
                                                                  0]);
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                // height: 30.h,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    border: Border.all(
                                                        color:
                                                            AppColor.graydark),
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? AppColor
                                                            .darkBackgroundColor
                                                        : AppColor
                                                            .backgroundColor),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      // backgroundImage:
                                                      //     CachedNetworkImageProvider(
                                                      //         ccContactData[1]
                                                      //             .picture),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            ccContactData![1]
                                                                    .picture ??
                                                                '',
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          width: 50.0.w,
                                                          height: 50.0.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        placeholder:
                                                            (context, url) =>
                                                                Image.asset(
                                                          "asset/m_profile_icon.png",
                                                          color: Colors.white,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          "asset/m_profile_icon.png",
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      radius: 15,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "${ccContactData![1].firstName} ${ccContactData![1].lastName}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                                  .withOpacity(
                                                                      0.87)
                                                              : HexColor.fromHex(
                                                                  "#7F8D8C"),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    GestureDetector(
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 12,
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          ccContactData?.remove(
                                                              ccContactData![
                                                                  1]);
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircleAvatar(
                                                backgroundColor: AppColor.green,
                                                child: GestureDetector(
                                                  child: Text(
                                                    '+${ccContactData!.length - 2}',
                                                    style: TextStyle(
                                                        color: AppColor.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      isCcCompressed = false;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : Wrap(
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.start,
                                                  direction: Axis.horizontal,
                                                  children: ccContactData!
                                                      .map((item) {
                                                    return Container(
                                                      // height: 30.h,
                                                      margin: EdgeInsets.only(
                                                          bottom: 5.h,
                                                          right: 5.w),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          border: Border.all(
                                                              color: AppColor
                                                                  .graydark),
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? AppColor
                                                                  .darkBackgroundColor
                                                              : AppColor
                                                                  .backgroundColor),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          CircleAvatar(
                                                            // backgroundImage:
                                                            //     CachedNetworkImageProvider(
                                                            //         item.picture),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  item.picture ??
                                                                      '',
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                width: 50.0.w,
                                                                height: 50.0.h,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Image
                                                                          .asset(
                                                                "asset/m_profile_icon.png",
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.asset(
                                                                "asset/m_profile_icon.png",
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            radius: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          SizedBox(
                                                            height: 20.h,
                                                            child: Body1AutoText(
                                                                text:
                                                                    "${item.firstName} ${item.lastName}",
                                                                fontSize: 14,
                                                                color: Theme.of(context)
                                                                            .brightness ==
                                                                        Brightness
                                                                            .dark
                                                                    ? Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.87)
                                                                    : HexColor
                                                                        .fromHex(
                                                                            "#7F8D8C"),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            // child: FittedBox(
                                                            //   fit: BoxFit
                                                            //       .fitWidth,
                                                            //   child: Text(
                                                            //     "${item.firstName} ${item.lastName}",
                                                            //     style: TextStyle(
                                                            //         fontSize:
                                                            //             14,
                                                            //         color: Theme.of(context).brightness ==
                                                            //                 Brightness
                                                            //                     .dark
                                                            //             ? Colors
                                                            //                 .white
                                                            //                 .withOpacity(
                                                            //                     0.87)
                                                            //             : HexColor.fromHex(
                                                            //                 "#7F8D8C"),
                                                            //         fontWeight:
                                                            //             FontWeight
                                                            //                 .bold),
                                                            //     maxLines: 1,
                                                            //     // minFontSize: 8,
                                                            //   ),
                                                            // ),
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          GestureDetector(
                                                            child: Icon(
                                                              Icons.close,
                                                              size: 12,
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                ccContactData!
                                                                    .remove(
                                                                        item);
                                                              });
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              suggestionTextField(
                                                  hint: 'enterCC',
                                                  node: toFocusnode,
                                                  maxLines: null,
                                                  controller:
                                                      composeMailCcController,
                                                  padding: 15,
                                                  dataList: ccContactData,
                                                  keyboardType:
                                                      TextInputType.text),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      isToExpanded
                          ? Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: HexColor.fromHex("#D9E0E0"),
                            )
                          : Container(),
                      Row(
                        children: <Widget>[
                          Text(
                            StringLocalization.of(context)
                                .getText(StringLocalization.subject),
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white.withOpacity(0.38)
                                    : HexColor.fromHex("#7F8D8C"),
                                fontWeight: FontWeight.bold),
                          ),

                          /// Added by: Akhil
                          /// Added on: May/29/2020
                          /// Widget of subject text field
                          Expanded(
                            child: customTextField(
                                hint: 'subject',
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                padding: 15,
                                node: subjectFocusNode,
                                controller: composeMailSubjectController),
                          )
                        ],
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                        color: HexColor.fromHex("#D9E0E0"),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          customTextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            hint: StringLocalization.of(context)
                                .getText(StringLocalization.body),
                            padding: 2,
                            node: bodyFocusNode,
                            controller: composeMailMailBodyController,
                          ),
                          SizedBox(height: 30.h),
                          fileNameList.isNotEmpty
                              ? buildGridView()
                              : SizedBox(height: 10.h),
                          SizedBox(height: 10.h)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      /// Added by: Akhil
      /// Added on: May/29/2020
      /// this button handles all the send functionality
    );
  }

  /// Added by: Akhil
  /// Added on: May/29/2020
  /// this is a custom text field created to make widget reusable
  Widget customTextField(
      {String? hint,
      TextInputType? keyboardType,
      int? maxLines,
      TextEditingController? controller,
      double? padding,
      FocusNode? node}) {
    return TextField(
      key: Key(hint!),
      focusNode: node,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.87)
            : HexColor.fromHex("#384341"),
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: padding ?? 0.0),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 16,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.38)
              : HexColor.fromHex("#7F8D8C"),
        ),
      ),
    );
  }

  Widget suggestionTextField({
    String? hint,
    TextInputType? keyboardType,
    int? maxLines,
    TextEditingController? controller,
    double? padding,
    List<userContact.UserData>? dataList,
    FocusNode? node,
  }) {
    print('&&&&&&&&&&&&&&&&&&&&&&');
    print(dataList);
    print('&&&&&&&&&&&&&&&&&&&&&&&');
    return TypeAheadField(
      key: Key(hint!),
      hideOnEmpty: true,
      hideOnError: true,
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.numberWithOptions(),
        maxLines: maxLines ?? 1,
        focusNode: node,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: padding ?? 0.0),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
//            hintText: StringLocalization.of(context)
//                .getText(StringLocalization.searchContact),
//            hintStyle: TextStyle(
//              fontWeight: FontWeight.w400,
//              fontSize: 18,
//              color: AppColor.graydark,
//        )
        ),
      ),
      suggestionsCallback: (pattern) {
        print('userList : $userList');
        print('userList data : ${userList?.data?.length}');
        if (userList == null || userList?.data?.length == 0) {
          composeBloc?.add(LoadContactList(userId: widget.userId!));
        }
        return getSearchedList(pattern);
      },
      itemBuilder: (context, userContact.UserData element) {
        return Container(
          key: Key('${element.firstName}'),
          // height: 56.h,
          margin: EdgeInsets.only(bottom: 16.h, left: 4.w, right: 4.w),
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
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#9F2DBC').withOpacity(0.15)
                          : HexColor.fromHex('#D1D9E6').withOpacity(0.5),
                      Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#9F2DBC').withOpacity(0)
                          : HexColor.fromHex('#FFDFDE').withOpacity(0),
                    ])),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              CircleAvatar(
                // backgroundImage: NetworkImage(element.picture),
                child: CachedNetworkImage(
                  imageUrl: element.picture ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    width: 42.0.w,
                    height: 42.0.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Image.asset(
                    'asset/m_profile_icon.png',
                    color: Colors.white,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'asset/m_profile_icon.png',
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              SizedBox(
                height: 25.h,
                child: Body1AutoText(
                  text: '${element.firstName} ${element.lastName}',
                  maxLine: 1,
                  minFontSize: 8,
                ),
                // child: FittedTitleText(
                //   text: '${element.firstName} ${element.lastName}',
                //   // maxLine: 1,
                // ),
              ),
            ]),
          ),
        );
      },
      onSuggestionSelected: (userContact.UserData element) {
        setState(() {
          dataList?.add(element);
          userList?.data?.removeWhere((e) => element.id == e.id);
        });

        controller?.clear();
      },
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        elevation: 0.0,
      ),
    );
  }

  /// Added by: Akhil
  /// Added on: May/29/2020
  /// this dialog suggest user to to fill to and subject feilds before sending
  Widget dialog() {
    var text = '';
    if (toContactData!.length == 0 && composeMailSubjectController.text == '') {
      text = StringLocalization.of(context)
          .getText(StringLocalization.pleaseEnterToSubject);
    } else if (toContactData!.length == 0) {
      text = 'Please select a contact.';
    } else if (composeMailSubjectController != null &&
        composeMailSubjectController.text.trim() == '') {
      text = 'Do you wish to Continue?';
      return CustomDialog(
        title: 'Subject is Empty',
        subTitle: text,
        // primaryButton: StringLocalization.of(context).getText(StringLocalization.yes).toUpperCase(),
        secondaryButton: StringLocalization.of(context)
            .getText(StringLocalization.no)
            .toUpperCase(),
        onClickYes: () {
          widget.sendMail!(
            InboxData(
                messageFrom: widget.userEmail!,
                messageBody: composeMailMailBodyController.text.trim(),
                messageCc: emailString(ccContactData!),
                messageTo: emailString(toContactData!),
                messageSubject: composeMailSubjectController.text.trim(),
                userFile: base64FileList.isNotEmpty ? base64FileList[0] : null,
                fileExtension:
                    fileExtensionList.isNotEmpty ? fileExtensionList[0] : null,
                messageID: widget.messageId ?? -1,
                parentGUIID: widget.parentGUIID ?? '',
                msgResponseTypeID: widget.messageResponseType != null
                    ? widget.messageResponseType
                    : 0,
                requestType: "api"),
            // can add draftId if compose is from draft
            widget.draftId,
          );
          composeMailSubjectController.clear();
          composeMailToController.clear();
          composeMailCcController.clear();
          composeMailMailBodyController.clear();

          print('here is ');
          print(widget.isComingFromContactScreen);
          if (context != null) {
            print(context);
            if (widget.isComingFromContactScreen != null) {
              // Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName))
              Navigator.of(context).pop();
            } else {
              print("inside composemail.dart file in context!=null");
              Navigator.of(context).popUntil(
                (route) {
                  print(route.settings.name);
                  // MailLandingPage not in route.settings.name
                  return route.settings.name == 'MailLandingPage';
                },
              );
            }
          }
          Navigator.of(context, rootNavigator: true).pop();
        },
        onClickNo: () {
          if (context != null) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        },
      );
    }
    return CustomInfoDialog(
      title: StringLocalization.of(context)
          .getText(StringLocalization.enterAllFields),
      subTitle: text,
      primaryButton: StringLocalization.of(context)
          .getText(StringLocalization.ok)
          .toUpperCase(),
      onClickYes: () {
        if (context != null) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
    );
    // return Dialog(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     elevation: 0,
    //     backgroundColor: Theme.of(context).brightness == Brightness.dark
    //         ? HexColor.fromHex("#111B1A")
    //         : AppColor.backgroundColor,
    //     child: Container(
    //         decoration: BoxDecoration(
    //             color: Theme.of(context).brightness == Brightness.dark
    //                 ? HexColor.fromHex("#111B1A")
    //                 : AppColor.backgroundColor,
    //             borderRadius: BorderRadius.circular(10),
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Theme.of(context).brightness == Brightness.dark
    //                     ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
    //                     : HexColor.fromHex("#DDE3E3").withOpacity(0.3),
    //                 blurRadius: 5,
    //                 spreadRadius: 0,
    //                 offset: Offset(-5, -5),
    //               ),
    //               BoxShadow(
    //                 color: Theme.of(context).brightness == Brightness.dark
    //                     ? HexColor.fromHex("#000000").withOpacity(0.75)
    //                     : HexColor.fromHex("#384341").withOpacity(0.9),
    //                 blurRadius: 5,
    //                 spreadRadius: 0,
    //                 offset: Offset(5, 5),
    //               ),
    //             ]),
    //         padding: EdgeInsets.only(top: 27.h, left: 16.w, right: 10.w),
    //         height: 188.h,
    //         width: 309.w,
    //         child:
    //             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    //           Padding(
    //               padding: EdgeInsets.symmetric(horizontal: 10.w),
    //               child: SizedBox(
    //                 height: 25.h,
    //                 child: Body1AutoText(
    //                   text: StringLocalization.of(context)
    //                       .getText(StringLocalization.enterAllFields),
    //                   fontSize: 20,
    //                   fontWeight: FontWeight.bold,
    //                   color: Theme.of(context).brightness == Brightness.dark
    //                       ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
    //                       : HexColor.fromHex("#384341"),
    //                   maxLine: 1,
    //                   minFontSize: 8,
    //                 ),
    //                 // child: FittedTitleText(
    //                 //   text: StringLocalization.of(context)
    //                 //       .getText(StringLocalization.enterAllFields),
    //                 //   fontSize: 20,
    //                 //   fontWeight: FontWeight.bold,
    //                 //   color: Theme.of(context).brightness == Brightness.dark
    //                 //       ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
    //                 //       : HexColor.fromHex("#384341"),
    //                 //   // maxLine: 1,
    //                 // ),
    //               )),
    //           Container(
    //               padding: EdgeInsets.only(
    //                 top: 16.h,
    //               ),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: <Widget>[
    //                   Padding(
    //                     padding: const EdgeInsets.symmetric(horizontal: 10),
    //                     child: SizedBox(
    //                       height: 50.h,
    //                       child: Body1AutoText(
    //                           // text: StringLocalization.of(context)
    //                           //     .getText(StringLocalization.pleaseEnterToSubject),
    //                           text: text,
    //                           maxLine: 2,
    //                           fontSize: 16,
    //                           color: Theme.of(context).brightness ==
    //                                   Brightness.dark
    //                               ? HexColor.fromHex("#FFFFFF")
    //                                   .withOpacity(0.87)
    //                               : HexColor.fromHex("#384341")),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 20.h,
    //                   ),
    //                   Align(
    //                     alignment: Alignment.bottomRight,
    //                     child: FlatButton(
    //                       onPressed: () {
    //                         if (context != null) {
    //                           Navigator.of(context, rootNavigator: true).pop();
    //                         }
    //                       },
    //                       child: SizedBox(
    //                         height: 23.h,
    //                         child: Body1AutoText(
    //                           text: StringLocalization.of(context)
    //                               .getText(StringLocalization.ok)
    //                               .toUpperCase(),
    //                           fontWeight: FontWeight.bold,
    //                           fontSize: 16,
    //                           color: HexColor.fromHex("#00AFAA"),
    //                           maxLine: 1,
    //                           minFontSize: 8,
    //                         ),
    //                         // child: FittedTitleText(
    //                         //   text: StringLocalization.of(context)
    //                         //       .getText(StringLocalization.ok)
    //                         //       .toUpperCase(),
    //                         //   fontWeight: FontWeight.bold,
    //                         //   fontSize: 16,
    //                         //   color: HexColor.fromHex("#00AFAA"),
    //                         //   // maxLine: 1,
    //                         // ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ))
    //         ])));
  }

//      AlertDialog(
//        title: Text(StringLocalization.of(context)
//            .getText(StringLocalization.enterAllFields)),
//        content: Text(StringLocalization.of(context)
//            .getText(StringLocalization.pleaseEnterToSubject)),
//        actions: <Widget>[
//          FlatBtn(
//              onPressed: () {
//                if (context != null) {
//                  Navigator.of(context, rootNavigator: true).pop();
//                }
//              },
//              text:
//                  StringLocalization.of(context).getText(StringLocalization.ok))
//        ],
//      );

  /// Added by: Akhil
  /// Added on: May/29/2020
  /// this dialog confirms user to save drafts
  Widget draftConfirmationDialog() => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.h),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10.h),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#000000').withOpacity(0.75)
                      : HexColor.fromHex('#384341').withOpacity(0.9),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5),
                ),
              ]),
          padding: EdgeInsets.only(
            top: 27.h,
            left: 26.w,
          ),
          // height: 206.h,
          width: 309.w,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // height: 28.h,
                  child: Body1AutoText(
                    text: StringLocalization.of(context)
                        .getText(StringLocalization.addToDrafts),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                    maxLine: 1,
                    minFontSize: 20,
                  ),
                  // child: FittedTitleText(
                  //   text: StringLocalization.of(context)
                  //       .getText(StringLocalization.addToDrafts),
                  //   fontSize: 20.sp,
                  //   fontWeight: FontWeight.bold,
                  //   color: Theme.of(context).brightness == Brightness.dark
                  //       ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                  //       : HexColor.fromHex("#384341"),
                  //   // maxLine: 1,
                  // ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 33.w),
                  child: Body1AutoText(
                    text: StringLocalization.of(context)
                        .getText(StringLocalization.draftConfirmation),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                    maxLine: 3,
                    minFontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: TextButton(
                        // minWidth: 50,
                        child: Body1AutoText(
                          text: StringLocalization.of(context)
                              .getText(StringLocalization.ok)
                              .toUpperCase(),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: HexColor.fromHex('#00AFAA'),
                          maxLine: 1,
                          minFontSize: 12,
                        ),
                        onPressed: () async {
                          /// Added by: Akhil
                          /// Added on: May/29/2020
                          ///this function saves drafts n database
                          await emailData?.insertDraft(InboxData(
                              messageFrom: widget.userEmail ?? '',
                              messageBody: composeMailMailBodyController.text,
                              messageCc: emailString(ccContactData!),
                              messageTo: emailString(toContactData!),
                              messageSubject: composeMailSubjectController.text,
                              receiverUserName: toContactData!.isNotEmpty
                                  ? "${toContactData![0].firstName} ${toContactData![0].lastName}"
                                  : null,
                              // createdDateTime: DateTime.now().toString(),
                              // changes in createdate
                              createdDateTime:
                              '/Date(${DateTime.now().millisecondsSinceEpoch})',
                              messageType: 4,
                              userId: widget.userId ?? -1,
                              isSync: 0));
                          // Scaffold.of(context).showSnackBar(SnackBar(
                          //   content: Text('Draft Saved Successfully'),
                          //   duration: Duration(seconds: 3),
                          // ));
                          CustomSnackBar.buildSnackbar(
                              context, 'Draft Saved Successfully', 3);
                          if (context != null) {
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: TextButton(
                        key: Key('pressDraftCancel'),
                        // minWidth: 50,
                        child: Body1AutoText(
                          text: StringLocalization.of(context)
                              .getText(StringLocalization.cancel)
                              .toUpperCase(),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: HexColor.fromHex('#00AFAA'),
                          minFontSize: 12,
                          maxLine: 1,
                        ),
                        onPressed: () async {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: TextButton(
                        key: Key('pressDraftDiscard'),
                        // minWidth: 50,
                        child: Body1AutoText(
                          text: StringLocalization.of(context)
                              .getText(StringLocalization.discard)
                              .toUpperCase(),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: HexColor.fromHex('#00AFAA'),
                          minFontSize: 12,
                          maxLine: 1,
                        ),
                        onPressed: () async {
                          if (context != null) {
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    //SizedBox(width: 42,),

                  ],
                ),
              ])));
}
