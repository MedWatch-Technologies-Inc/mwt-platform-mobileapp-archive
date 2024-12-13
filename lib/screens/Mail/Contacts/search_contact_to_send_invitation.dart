import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/contact_models/search_contact_list.dart';
import 'package:health_gauge/screens/inbox/inbox_events.dart';
import 'package:health_gauge/screens/inbox/inbox_states.dart';
import 'package:health_gauge/screens/inbox/search_contact_bloc.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';

import 'package:health_gauge/widgets/text_utils.dart';

/// Added by: Saubhagya
/// Added on: Jun/15/2020
/// This widget is responsible displaying list of users according to query entered by user
/// This widget is also responsible for sending invitations to the users
class SearchContactToInviteScreen extends StatefulWidget {
  /// Added by: Saubhagya
  /// Added on: Jun/15/2020
  /// user Id Of Current logged in user this is initialized at the time of initialization of widget
  late final int userId;

  SearchContactToInviteScreen({required this.userId});

  @override
  _SearchContactToInviteScreenState createState() =>
      _SearchContactToInviteScreenState();
}

/// Added by: Saubhagya
/// Added on: Jun/15/2020
/// this class maintains the state of above stateful widget
class _SearchContactToInviteScreenState
    extends State<SearchContactToInviteScreen> {
  /// Added by: Saubhagya
  /// Added on: Jun/15/2020
  /// declaration of bloc for this screen
  SearchContactToInviteBloc? bloc;

  /// Added by: Saubhagya
  /// Added on: Jun/15/2020
  /// List of type UserData to store user Information temporarily
  List<SearchedUserData>? userList;

  /// Added by: Saubhagya
  /// Added on: Jun/15/2020
  /// texteditingcontroller for the search textfield
  late TextEditingController _searchController;

  /// Added by: Saubhagya
  /// Added on: Jun/15/2020
  /// this bool varible maintains the state of visibility of search text field
  bool isSearchOpen = true;

  /// Added by: Saubhagya
  /// Added on: Jun/15/2020
  /// this bool variable is responsible to check if invite is loading
  bool isInviteLoading = false;

  bool isInternetAvailable = false;

  /// Added by: Saubhagya
  /// Added on: Jun/15/2020
  /// this method is called before the rendering of the widget to create initial state of widget
  @override
  void initState() {
    super.initState();

    /// Added by: Saubhagya
    /// Added on: Jun/15/2020
    /// initializing local userdata list with empty list at creation of widget
    userList = [];

    /// Added by: Saubhagya
    /// Added on: Jun/15/2020
    /// initializing controller of search text field for Searching contacts for Searching contacts
    _searchController = TextEditingController();

    /// Added by: Saubhagya
    /// Added on: Jun/15/2020
    ///initializing bloc for screeen with the context of provider
    bloc = BlocProvider.of<SearchContactToInviteBloc>(context);
    bloc?.add(SearchContactListEvent(userId: widget.userId, Query: ''));
    checkInternetAvailable();
  }

  checkInternetAvailable() async {
    isInternetAvailable = await Constants.isInternetAvailable();
    setState(() {});
  }

  /// Added by: Saubhagya
  /// Added on: Jun/15/2020
  /// this function user to add search contact event in the bloc
  void searchContactFromQuery() {
    if (_searchController.text.isNotEmpty) {
      bloc?.add(SearchContactListEvent(
          userId: widget.userId, Query: _searchController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex("#384341").withOpacity(0.2),
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              elevation: 0,
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
              title: Text(
                StringLocalization.of(context)
                    .getText(StringLocalization.addContacts),
                style: TextStyle(
                    color: HexColor.fromHex("62CBC9"),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              // title: TitleText(
              //     text: StringLocalization.of(context)
              //         .getText(StringLocalization.addContacts),
              //     color: HexColor.fromHex("62CBC9"),
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold),
              actions: <Widget>[
                /// Added by: Saubhagya
                /// Added on: Jun/15/2020
                /// button to toggle between visibility of search text field for contacts
                IconButton(
                  padding: EdgeInsets.only(right: 15),
                  icon: isSearchOpen
                      ? Theme.of(context).brightness == Brightness.dark
                          ? Image.asset(
                              "asset/dark_close.png",
                              width: 33,
                              height: 33,
                            )
                          : Image.asset("asset/close.png")
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
                      isSearchOpen = !isSearchOpen;
                    });
                  },
                )
              ],
            ),
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: Column(
          children: <Widget>[
            /// Added by: Saubhagya
            /// Added on: Jun/15/2020
            /// Search Text Field
            isSearchOpen ? searchField() : Container(),
            BlocListener(
              bloc: bloc,
              listener: (BuildContext context, InboxState state) {
                if (state is SendingInvitationState) {
                  Constants.progressDialog(true, context);
                } else if (state is SearchApiErrorState) {
                  Constants.progressDialog(false, context);
                }
                if (state is SendInvitationSucessfulState) {
                  Constants.progressDialog(false, context);
                  if (state.response.result ?? false) {
                    // Scaffold.of(context).showSnackBar(SnackBar(
                    //   content: Text(StringLocalization.of(context)
                    //       .getText(StringLocalization.invitedSucessfully)),
                    // ));

                    // CustomSnackBar.buildSnackbar(
                    //     context,
                    //     StringLocalization.of(context)
                    //         .getText(StringLocalization.invitedSucessfully),
                    //     3);
                    var dialog = SingleLineCustomDialog(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.invitedSucessfully),
                      primaryButton: StringLocalization.of(context)
                          .getText(StringLocalization.ok)
                          .toUpperCase(),
                      onClickYes: () {
                        if (context != null) {
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                      },
                    );
                    showDialog(
                        context: context,
                        barrierColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex("#7F8D8C").withOpacity(0.6)
                                : HexColor.fromHex("#384341").withOpacity(0.6),
                        useRootNavigator: true,
                        builder: (context) => dialog);
                    print('#############');
                    print(state.index);
                    print(userList![state.index].firstName);
                    print(userList![state.index].lastName);
                    print('#############');
                    // userList[state.index]
                    //     .isSendingInvitation = false;
                    // userList.removeAt(state.index);
                    userList?.removeWhere(
                        (element) => element.userID == state.userId);
                    _searchController.text = '';
                  } else {
                    // Scaffold.of(context).showSnackBar(SnackBar(
                    //   content: Text(StringLocalization.of(context)
                    //       .getText(StringLocalization.invitationFailed)),
                    // ));
                    // userList[state.index]
                    //     .isSendingInvitation = false;
                    int index = userList!.indexWhere(
                        (element) => element.userID == state.userId);
                    try {
                      userList![index].isSendingInvitation = false;
                    } catch (e) {}
                    // CustomSnackBar.buildSnackbar(
                    //     context,
                    //     StringLocalization.of(context)
                    //         .getText(StringLocalization.invitationFailed),
                    //     3);
                    var dialog = SingleLineCustomDialog(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.invitationFailed),
                      // subTitle: StringLocalization.of(context)
                      //     .getText(StringLocalization.invitedSucessfully),
                      primaryButton: StringLocalization.of(context)
                          .getText(StringLocalization.ok)
                          .toUpperCase(),
                      onClickYes: () {
                        if (context != null) {
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                      },
                    );
                    showDialog(
                        context: context,
                        barrierColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex("#7F8D8C").withOpacity(0.6)
                                : HexColor.fromHex("#384341").withOpacity(0.6),
                        useRootNavigator: true,
                        builder: (context) => dialog);
                  }
                }
              },
              child: Container(),
            ),
            !isInternetAvailable
                ? Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Internet not available',
                      ),
                    ),
                  )
                : Expanded(
                    child: BlocBuilder<SearchContactToInviteBloc, InboxState>(
                        builder: (context, state) {
                      if (state is SearchContactListState) {
                        if (state is InitialSearchState)
                          return Text(
                            StringLocalization.of(context)
                                .getText(StringLocalization.searchNameOfUser),
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex('#111B1A'),
                                fontWeight: FontWeight.w800),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          );
                        if (state.response != null &&
                            state.response.result != null &&
                            state.response.result!) {
                          userList = state.response.data;
                          if (state.response.data != null) {
                            return ListView.builder(
                                itemCount:
                                    userList != null ? userList?.length : 0,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 56,
                                    margin: EdgeInsets.only(
                                        left: 13,
                                        right: 13,
                                        top: 14,
                                        bottom: index == userList!.length - 1
                                            ? 14
                                            : 0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? HexColor.fromHex("#111B1A")
                                            : AppColor.backgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? HexColor.fromHex("#D1D9E6")
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                    ? HexColor.fromHex(
                                                            "#9F2DBC")
                                                        .withOpacity(0.15)
                                                    : HexColor.fromHex(
                                                            "#D1D9E6")
                                                        .withOpacity(0.5),
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? HexColor.fromHex(
                                                            "#9F2DBC")
                                                        .withOpacity(0)
                                                    : HexColor.fromHex(
                                                            "#FFDFDE")
                                                        .withOpacity(0),
                                              ])),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            userList![index]
                                                                    .picture ??
                                                                '',
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          width: 50.0,
                                                          height: 50.0,
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
                                                    ),
                                                    SizedBox(
                                                      width: 16,
                                                    ),
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 23,
                                                        // width: 180,
                                                        child: Text(
                                                          '${userList![index].firstName} ${userList![index].lastName}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? HexColor.fromHex(
                                                                        "#FFFFFF")
                                                                    .withOpacity(
                                                                        0.87)
                                                                : HexColor.fromHex(
                                                                    "#384341"),
                                                            fontSize: 14,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          softWrap: false,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (BuildContext
                                                          context) {
                                                        return contactInformationDialog(
                                                            userData: userList![
                                                                index],
                                                            context: context);
                                                      });
                                                },
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                margin:
                                                    EdgeInsets.only(right: 15),
                                                decoration: BoxDecoration(
                                                    color: HexColor.fromHex(
                                                        "#00AFAA"),
                                                    shape: BoxShape.circle),
                                                child: Container(
                                                  decoration: ConcaveDecoration(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      depression: 8,
                                                      colors: [
                                                        Colors.white,
                                                        HexColor.fromHex(
                                                            "#D1D9E6")
                                                      ]),
                                                  child: IconButton(
                                                    icon: Image.asset(
                                                      "asset/plus_icon.png",
                                                      height: 12,
                                                      width: 12,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.black
                                                          : Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      print('#############');
                                                      print(index);
                                                      print('##########');
                                                      userList?[index]
                                                              .isSendingInvitation =
                                                          true;
                                                      bloc?.add(SendInvitationEvent(
                                                          loggedInUserId:
                                                              widget.userId,
                                                          inviteeUserId:
                                                              userList![index]
                                                                  .userID,
                                                          index: index));
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return Center(
                              child: Text(
                                StringLocalization.of(context)
                                    .getText(StringLocalization.nothingToShow),
                                style: TextStyle(
                                    color: AppColor.graydark,
                                    fontWeight: FontWeight.w800),
                              ),
                            );
                          }
                        } else
                          return Center(
                            child: Text(
                              StringLocalization.of(context)
                                  .getText(StringLocalization.searchNameOfUser),
                              style: TextStyle(
                                  color: AppColor.graydark,
                                  fontWeight: FontWeight.w800),
                            ),
                          );
                      } else if (state is LoadingSearchState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return userList == null || userList?.length == 0
                          ? Center(
                              child: Text(
                                StringLocalization.of(context)
                                    .getText(StringLocalization.nothingToShow),
                                style: TextStyle(
                                    color: AppColor.graydark,
                                    fontWeight: FontWeight.w800),
                              ),
                            )
                          : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: userList?.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 56,
                                  margin: EdgeInsets.only(
                                      left: 13,
                                      right: 13,
                                      top: 14,
                                      bottom: index == userList!.length - 1
                                          ? 14
                                          : 0),
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
                                                userList![index].picture ?? '',
                                            imageBuilder:
                                                (context, imageProvider) =>
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
                                            placeholder: (context, url) =>
                                                Image.asset(
                                              "asset/m_profile_icon.png",
                                              color: Colors.white,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              "asset/m_profile_icon.png",
                                              color: Colors.white,
                                            ),
                                          ),
                                          // backgroundImage:
                                          // NetworkImage(userList[index].picture),
                                          // radius: 21,
                                        ),
                                        title: Body1AutoText(
                                          text:
                                              '${userList![index].firstName} ${userList![index].lastName}',
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? HexColor.fromHex("#FFFFFF")
                                                  .withOpacity(0.87)
                                              : HexColor.fromHex("#384341"),
                                          fontSize: 14,
                                          maxLine: 2,
                                          minFontSize: 8,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing:
                                            // userList[index]
                                            //         .isSendingInvitation
                                            //     ? Padding(
                                            //         padding:
                                            //             const EdgeInsets.all(10.0),
                                            //         child:
                                            //             CircularProgressIndicator(),
                                            //       )
                                            //     :
                                            Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    color: userList![index]
                                                            .isSendingInvitation
                                                        ? HexColor.fromHex(
                                                            "#D3D3D3")
                                                        : HexColor.fromHex(
                                                            "#00AFAA"),
                                                    shape: BoxShape.circle),
                                                child: Container(
                                                  decoration: ConcaveDecoration(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      depression: 8,
                                                      colors: [
                                                        Colors.white,
                                                        HexColor.fromHex(
                                                            "#D1D9E6")
                                                      ]),
                                                  child: IconButton(
                                                    icon: Image.asset(
                                                      "asset/plus_icon.png",
                                                      height: 12,
                                                      width: 12,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.black
                                                          : Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        userList![index]
                                                                .isSendingInvitation =
                                                            true;
                                                      });
                                                      bloc?.add(SendInvitationEvent(
                                                          loggedInUserId:
                                                              widget.userId,
                                                          inviteeUserId:
                                                              userList![index]
                                                                  .userID,
                                                          index: index));
                                                    },
                                                  ),
                                                ))),
                                  ),
                                );
                              });
                    }),
                  )
          ],
        ),
      ),
    );
  }

  Widget searchField() {
    return Container(
        height: 88,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 13,
        ),
        child: Container(
            height: 56,
            decoration: ConcaveDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
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
              onChanged: (query) {
                searchContactFromQuery();
              },
              controller: _searchController,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex("#D1D9E6").withOpacity(0.87)
                      : HexColor.fromHex("#384341")),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).brightness != Brightness.dark
                      ? Colors.black12
                      : Colors.white10,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: StringLocalization.of(context)
                      .getText(StringLocalization.searchUser),
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex("#FFFFFF").withOpacity(0.38)
                        : HexColor.fromHex("#7F8D8C"),
                  )),
              onSubmitted: (value) {
                searchContactFromQuery();
              },
            ))));
  }

  Widget contactInformationDialog(
      {SearchedUserData? userData, // Function sendMail,
      BuildContext? context}) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(top: 44),
                  width: MediaQuery.of(context!).size.width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex("#111B1A")
                          : AppColor.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                              : HexColor.fromHex("#DDE3E3").withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(-5, -5),
                        ),
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex("#7F8D8C"),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(5, 5),
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 68,
                        ),
                        Body1AutoText(
                          text: '${userData?.firstName} ${userData?.lastName}',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                              : HexColor.fromHex("#384341"),
                          maxLine: 2,
                          minFontSize: 15,
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        // Body1AutoText(
                        //   text: '${userData?.email}',
                        //   fontSize: 16,
                        //   color: Theme.of(context).brightness == Brightness.dark
                        //       ? HexColor.fromHex("#FFFFFF").withOpacity(0.6)
                        //       : HexColor.fromHex("#5D6A68"),
                        //   maxLine: 2,
                        //   minFontSize: 10,
                        // ),
                        // userData?.phoneNo != null && userData?.phoneNo?.trim() != ""
                        //     ? Row(
                        //   children: <Widget>[
                        //     SizedBox(
                        //       height: 25,
                        //       child: TitleText(
                        //         text: '${userData?.phoneNo}',
                        //         fontSize: 16,
                        //         color: Theme.of(context).brightness ==
                        //             Brightness.dark
                        //             ? HexColor.fromHex("#FFFFFF")
                        //             .withOpacity(0.6)
                        //             : HexColor.fromHex("#5D6A68"),
                        //         // maxLine: 1,
                        //       ),
                        //     ),
                        //     Spacer(),
                        //   ],
                        // )
                        //     : Container(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  radius: 50,
                  child: CachedNetworkImage(
                    imageUrl: userData?.picture ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => Image.asset(
                      "asset/m_profile_icon.png",
                      color: Colors.white,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "asset/m_profile_icon.png",
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
