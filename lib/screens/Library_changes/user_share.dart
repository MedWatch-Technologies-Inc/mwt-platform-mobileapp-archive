import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_bloc.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_event.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_state.dart';
import 'package:health_gauge/screens/Library_changes/models/library_share_model.dart';
import 'package:health_gauge/screens/inbox/contacts_bloc.dart';
import 'package:health_gauge/screens/inbox/inbox_events.dart';
import 'package:health_gauge/screens/inbox/inbox_states.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:provider/provider.dart';

import '../../value/string_localization_support/string_localization.dart';

class UserSharePage extends StatefulWidget {
  final int userID;
  final int libraryID;
  UserSharePage(this.userID, this.libraryID);
  @override
  _UserSharePageState createState() => _UserSharePageState();
}

class _UserSharePageState extends State<UserSharePage> {
  ContactsBloc? contactsBloc;
  LibraryShareModel _libraryShareModel = LibraryShareModel();
  TextEditingController? _textEditingController;
  LibraryBloc? libraryBloc;

  bool openKeyboard = false;
  bool writingNotes = false;
  FocusNode linkFocusNode = new FocusNode();
  FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
    contactsBloc = BlocProvider.of<ContactsBloc>(context);
    libraryBloc = BlocProvider.of<LibraryBloc>(context);
    contactsBloc!.add(LoadContactList(userId: widget.userID));
  }

  @override
  Widget build(BuildContext buildContext) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return Consumer<LibraryShareModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            // title: Text('Share'),
            title: Text('Share',
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
                var provider =
                    Provider.of<LibraryShareModel>(context, listen: false);
                provider.clearAllData();
                Navigator.of(context).pop();
              },
              ),
            ),
            body: Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : AppColor.backgroundColor,
              padding: EdgeInsets.all(15),
              child: Column(children: [
                BlocListener<ContactsBloc, InboxState>(
                  listener: (context, state) {
                    if (state is LoadedContactList) {
                    var provider =
                        Provider.of<LibraryShareModel>(context, listen: false);
                    provider.selectedUserList = [];
                    var contactList = state.response.data;
                    contactList!
                        .sort((a, b) => a.firstName!.compareTo(b.firstName!));
                    model.addToContactList(contactList);
                  }
                },
                  child: Container(),
                ),
                BlocListener<LibraryBloc, LibraryState>(
                  bloc: libraryBloc,
                  listener: (context, state) {
                    if (state is SaveAndUpdateSharedWithSuccessState) {

                      CustomSnackBar.buildSnackbar(buildContext,StringLocalization.of(buildContext)
                          .getText(StringLocalization.shareSuccessMessage), 3);
                      Navigator.of(context).pop();
                    } else if (state is SaveAndUpdateSharedWithUnSuccessState) {

                      CustomSnackBar.buildSnackbar(buildContext,StringLocalization.of(buildContext)
                          .getText(StringLocalization.shareFailureMessage), 3);
                      Navigator.of(context).pop();
                    }else if(state is SharingWithUserState){
                      setState(() {

                      });
                    }
                  },
                  child: Container(),
                ),
//                 Card(
//                     margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
//                     child: TextField(
//                       controller: _textEditingController,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 18,
//                       ),
//                       decoration: InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                           border: InputBorder.none,
//                           focusedBorder: InputBorder.none,
//                           enabledBorder: InputBorder.none,
//                           errorBorder: InputBorder.none,
//                           disabledBorder: InputBorder.none,
//                           hintText: '',
//                           hintStyle: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 18,
// //                color: AppColor.graydark,
//                           )),
//                       onSubmitted: (value) {},
//                       onChanged: (String value){
//                         model.clearSelectedUserList();
//                         model.searchInList(value);
//                       },
//                       onTap: (){
//
//                       },
//                     )),
                Container(
                  // height: 49.h,
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
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(-5.w, -5.h),
                        ),
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex("#D1D9E6"),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(5.w, 5.h),
                        ),
                      ]),
                  child: GestureDetector(
                    onTap: () {
                      // userIdFocusNode.requestFocus();
                      // openKeyboardUserId = true;
                      // openKeyboardPasswd = false;
                      linkFocusNode.unfocus();
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      decoration: openKeyboard
                          ? ConcaveDecoration(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.h)),
                              depression: 7,
                              colors: [
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black.withOpacity(0.5)
                                      : HexColor.fromHex("#D1D9E6"),
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex("#D1D9E6")
                                          .withOpacity(0.07)
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: IgnorePointer(
                              ignoring: false,
                              child: TextFormField(
                                  // textAlignVertical: TextAlignVertical.center,
                                  autofocus: openKeyboard,
                                  focusNode: linkFocusNode,
                                  // autovalidate: autoValidate,
                                  controller: _textEditingController,
                                  style: TextStyle(fontSize: 16.0),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'Search User',
                                      hintStyle: TextStyle(
                                          color: HexColor.fromHex("7F8D8C"))),
//                          validator: (value) {
//                            if (value.isEmpty) {
//                              return StringLocalization.of(context)
//                                  .getText(StringLocalization.emptyUserId);
//                            }
//                            return null;
//                          },
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    // openKeyboardPasswd = true;
                                    // openKeyboardUserId = false;
                                    // errorPaswd = false;
                                    // FocusScope.of(context)
                                    //     .requestFocus(passwordFocusNode);
                                    // setState(() {});
                                  },
                                  onChanged: (String value) {
                                    model.clearSelectedUserList();
                                    model.searchInList(value);
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: model.searchList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              // do something
                              model.addSelectedToList(index);
                            _textEditingController!.text =
                                '${model.searchList[index].firstName} ${model.searchList[index].lastName}';
                            model.stopSearch();
                            FocusScope.of(context).unfocus();
                          },
                            child: Container(
                                // child: Text('${model.searchList[index].firstName} ${model.searchList[index].lastName}',style: TextStyle(
                                //   fontSize: 15,
                                // ),),
                                child: Container(
                              height: 56,
                              margin:
                                  EdgeInsets.only(left: 13, right: 13, top: 16),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex("#111B1A")
                                      : AppColor.backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex("#D1D9E6")
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
                                          : HexColor.fromHex("#9F2DBC")
                                              .withOpacity(0.15),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                      offset: Offset(4, 4),
                                    ),
                                  ]),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex("#111B1A")
                                        : AppColor.backgroundColor,
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? HexColor.fromHex("#9F2DBC")
                                                  .withOpacity(0.15)
                                              : HexColor.fromHex("#D1D9E6")
                                                  .withOpacity(0.5),
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? HexColor.fromHex("#9F2DBC")
                                                  .withOpacity(0)
                                              : HexColor.fromHex("#FFDFDE")
                                                  .withOpacity(0),
                                        ])),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          model.searchList[index].picture!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) => Image.asset(
                                      "asset/m_profile_icon.png",
                                      color: Colors.white,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      "asset/m_profile_icon.png",
                                      color: Colors.white,
                                    ),
                                    // errorWidget: (context, url,
                                      //         error) =>
                                      //     Image.asset('"asset/m_profile_icon.png"'),
                                    ),
                                  ),
                                  title: SizedBox(
                                    height: 25,
                                    child: Body1AutoText(
                                      text:
                                          '${model.searchList[index].firstName} ${model.searchList[index].lastName}',
                                      fontSize: 16,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white.withOpacity(0.87)
                                          : HexColor.fromHex("#384341"),
                                      maxLine: 1,
                                      minFontSize: 8,
                                    ),
                                    // child: TitleText(
                                    //   align: TextAlign.left,
                                    //   text:
                                    //       '${model.searchList[index].firstName} ${model.searchList[index].lastName}',
                                    //   fontSize: 16,
                                    //   color: Theme.of(context)
                                    //               .brightness ==
                                    //           Brightness.dark
                                    //       ? Colors.white
                                    //           .withOpacity(0.87)
                                    //       : HexColor.fromHex(
                                    //           "#384341"),
                                    //   // maxLine: 1,
                                    // ),
                                  ),
                                ),
                              ),
                            )),
                          );
                        })),
                // model.selectedUserList.length > 0 ? Expanded(
                //   child: TextField(
                //     decoration: InputDecoration(
                //       hintText: 'Add share message'
                //     ),
                //   ),
                // ): Container(),
                model.selectedUserList.length > 0
                    ? Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 24.h, left: 15.w, right: 15.w),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.h)),
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex("#111B1A")
                                  : AppColor.backgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex("#D1D9E6")
                                          .withOpacity(0.1)
                                      : Colors.white.withOpacity(0.9),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: Offset(-5.w, -5.h),
                                ),
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black.withOpacity(0.75)
                                      : HexColor.fromHex("#D1D9E6"),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: Offset(5.w, 5.h),
                                ),
                              ]),
                          child: Container(
                            decoration: writingNotes
                                ? ConcaveDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.h)),
                                    depression: 10,
                                    colors: [
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.black.withOpacity(0.5)
                                            : HexColor.fromHex("#D1D9E6"),
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? HexColor.fromHex("#D1D9E6")
                                                .withOpacity(0.07)
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
                            child: Container(
                              height: 100,
                              child: IgnorePointer(
                                ignoring: false,
                                child: TextFormField(
                                  autofocus: writingNotes,
                                  focusNode: focusNode,
                                  minLines: 1,
                                  maxLines: 10,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 16.w, right: 16.w),
                                    hintText: 'Add share message',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.38)
                                            : HexColor.fromHex("#7F8D8C")),
                                  ),
                                  textInputAction: TextInputAction.newline,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                // model.selectedUserList.length > 0 ? InkWell(
                //   onTap: (){
                //     libraryBloc.add(
                //         SaveAndUpdateSharedWith(
                //           userID: widget.userID,
                //           fKLirabaryID: widget.libraryID,
                //           sharedMessage: '',
                //           fKSharedUserID: [model.selectedUserList[0].fKReceiverUserID],
                //           accessspicefire: 2,
                //           savedAccessID: [2],
                //           savedAccessChanged: [2]
                //         )
                //     );
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //         color: HexColor.fromHex("62CBC9"),
                //         borderRadius: BorderRadius.circular(20)),
                //     width: MediaQuery.of(context).size.width,
                //     margin: EdgeInsets.symmetric(horizontal: 20),
                //     padding: EdgeInsets.all(10),
                //     height: 60,
                //     child: Center(child: Text('Done')),
                //   ),
                // ): Container(),
                model.selectedUserList.length > 0
                    ? libraryBloc?.state is SharingWithUserState?
                Container(
                  padding: EdgeInsets.only(
                      left: 20.w, right: 20.w, top: 20.h, bottom: 15.h),
                  alignment: Alignment.center,child: CircularProgressIndicator(),)
                    :Container(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex("#111B1A")
                            : AppColor.backgroundColor,
                        padding: EdgeInsets.only(
                            left: 20.w, right: 20.w, top: 20.h, bottom: 15.h),
                        margin: EdgeInsets.only(top: 15.h),
                        child: GestureDetector(
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.h),
                                color: HexColor.fromHex("#00AFAA"),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex("#D1D9E6")
                                            .withOpacity(0.1)
                                        : Colors.white,
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    offset: Offset(-5.w, -5.h),
                                  ),
                                  BoxShadow(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black.withOpacity(0.75)
                                        : HexColor.fromHex("#D1D9E6"),
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    offset: Offset(5.w, 5.h),
                                  ),
                                ]),
                            child: Container(
                              decoration: ConcaveDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.h),
                                  ),
                                  depression: 10,
                                  colors: [
                                    Colors.white,
                                    HexColor.fromHex("#D1D9E6"),
                                  ]),
                              child: Center(
                                child: Text(
                                  'Share',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex("#111B1A")
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            libraryBloc!.add(SaveAndUpdateSharedWith(
                                userID: widget.userID,
                                fKLirabaryID: widget.libraryID,
                                sharedMessage: '',
                                fKSharedUserID: [
                                  model.selectedUserList[0].fKReceiverUserID!
                                ],
                                accessspicefire: 2,
                              savedAccessID: [2],
                              savedAccessChanged: [2]));
                        },
                      ),
                    )
                  : Container(),
            ]),
          ),
        );
      },
    );
  }
}
