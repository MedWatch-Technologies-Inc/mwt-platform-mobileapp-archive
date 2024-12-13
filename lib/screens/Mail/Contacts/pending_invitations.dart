import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/contact_models/pending_invitation_model.dart';
import 'package:health_gauge/screens/inbox/inbox_events.dart';
import 'package:health_gauge/screens/inbox/inbox_states.dart';
import 'package:health_gauge/screens/inbox/invitation_bloc.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';

/// Added by: Akhil
/// Added on: July/27/2020
/// This class is to show the list of pending invitations

class PendingInvitation extends StatefulWidget {
 late final int userId;

  PendingInvitation({required this.userId});

  @override
  _PendingInvitationState createState() => _PendingInvitationState();
}

/// Added by: Akhil
///  Added on: July/27/2020
/// This class maintains state for Contacts Screen
class _PendingInvitationState extends State<PendingInvitation> {
  InvitationBloc? invitationBloc;
  List<InvitationList> invitations = [];
  List<InvitationList> databaseList = [];
  List<InvitationList> dataList = [];
  bool value = false;
  bool searching = false;
  bool isSearchOpen = false;
  late TextEditingController _searchController;

  /// Added by: Akhil
  /// Added on: July/27/2020
  /// Lifecycle method of stateful widget, Provided the context of InvitationBloc and hit the api.
  @override
  void initState() {
    // TODO: implement initState
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    invitationBloc = BlocProvider.of<InvitationBloc>(context);
    invitationBloc?.add(GetInvitations(userId: widget.userId));
  }

  /// Added by: Akhil
  /// Added on: June/04/2020
  /// this method is responsible for building UI
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
                    .getText(StringLocalization.invitations),
                style: TextStyle(
                    color: HexColor.fromHex("62CBC9"),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                isSearchOpen
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
                          setState(() {
                            isSearchOpen = false;
                            searching = false;
                          });
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
                          if (invitations.length == 0) {
                            CustomSnackBar.buildSnackbar(
                                context,
                                StringLocalization.of(context).getText(
                                    StringLocalization
                                        .noPendingInvitationToSearchFrom),
                                3);
                          }
                          setState(() {
                            isSearchOpen = true;
                          });
                        },
                      ),
              ],
            ),
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : AppColor.backgroundColor,
        child: Column(
          children: <Widget>[
            isSearchOpen ? searchTextField() : Container(),
            BlocListener(
              bloc: invitationBloc,
              listener: (BuildContext context, InboxState state) {
                if (state is AcceptRejectInvitationSucessState) {
                  if (state.response.result ?? false) {
                    // Scaffold.of(context).showSnackBar(SnackBar(
                    //   content: Text(state.response.message),
                    // ));
                    if (state.response.message!.contains('accepted')) {
                      CustomSnackBar.buildSnackbar(
                          context,
                          StringLocalization.of(context).getText(
                              StringLocalization
                                  .invitationAcceptedSuccessfully),
                          3);
                    }else{
                      CustomSnackBar.buildSnackbar(
                          context, state.response.message!, 3);
                    }
                  }
                }
              },
              child: Container(),
            ),
            Expanded(
              child: BlocBuilder<InvitationBloc, InboxState>(
                  builder: (context, state) {
                if (state is LoadedInvitations) {
                  if (state.response.isFromDb ?? false) {
                    databaseList = state.response.invitationList!;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (state.response.invitationList!.length == 0) {
                      invitations = databaseList;
                    } else
                      invitations = state.response.invitationList!;
                    if (!searching) dataList = invitations;
                  }
                  if (searching && dataList.length == 0) {
                    return Center(
                      child: Text(StringLocalization.of(context)
                          .getText(StringLocalization.noPendingInvitations)),
                    );
                  }

                  if (invitations.length > 0) {
                    return ListView.builder(
                      itemCount:
                          isSearchOpen ? dataList.length : invitations.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 56,
                          margin: EdgeInsets.only(left: 13, right: 13, top: 14),
                          padding: EdgeInsets.only(left: 15, right: 13),
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
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                // radius: 21,
                                child: CachedNetworkImage(
                                  imageUrl: isSearchOpen
                                      ? dataList[index].senderPicture!
                                      : invitations[index].senderPicture!,
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
                                ),
                                // backgroundImage: CachedNetworkImageProvider(
                                //   isSearchOpen
                                //       ? dataList[index].senderPicture
                                //       : invitations[index].senderPicture,
                                // ),
                              ),
                              Spacer(
                                flex: 2,
                              ),
                              Text(
                                isSearchOpen
                                    ? '${dataList[index].senderFirstName} ${dataList[index].senderLastName}'
                                    : '${invitations[index].senderFirstName} ${invitations[index].senderLastName}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex("#FFFFFF")
                                            .withOpacity(0.87)
                                        : HexColor.fromHex("#384341"),
                                    fontSize: 14),
                              ),
                              Spacer(flex: 10),
                              Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: HexColor.fromHex("#FF6259"),
                                      shape: BoxShape.circle),
                                  child: Container(
                                    decoration: ConcaveDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        depression: 5,
                                        colors: [
                                          Colors.white,
                                          HexColor.fromHex("#D1D9E6")
                                        ]),
                                    child: IconButton(
                                      icon: Image.asset(
                                        "asset/whiteCross.png",
                                        height: 11,
                                        width: 11,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      onPressed: () {
                                        invitationBloc?.add(
                                            AcceptRejectInvitation(
                                                contactId: invitations[index]
                                                    .contactID,
                                                isAccepted: false));
                                        if (isSearchOpen) {
                                          dataList.removeAt(index);
                                        }
                                        invitations.removeAt(index);
                                      },
                                    ),
                                  )),
                              SizedBox(
                                width: 28,
                              ),
                              Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: HexColor.fromHex("#00AFAA"),
                                      shape: BoxShape.circle),
                                  child: Container(
                                    decoration: ConcaveDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        depression: 6,
                                        colors: [
                                          Colors.white,
                                          HexColor.fromHex("#D1D9E6")
                                        ]),
                                    child: IconButton(
                                      icon: Image.asset(
                                        "asset/check.png",
                                        height: 12,
                                        width: 16,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      onPressed: () {
                                        invitationBloc?.add(
                                            AcceptRejectInvitation(
                                                contactId: invitations[index]
                                                    .contactID,
                                                isAccepted: true));
                                        if (isSearchOpen) {
                                          dataList.removeAt(index);
                                        }
                                        invitations.removeAt(index);
                                      },
                                    ),
                                  ))
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(StringLocalization.of(context)
                          .getText(StringLocalization.noPendingInvitations)),
                    );
                  }
                }
                if (state is LoadingSearchState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return invitations.length > 0
                    ? ListView.builder(
                        itemCount: invitations.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 56,
                            margin:
                                EdgeInsets.only(left: 13, right: 13, top: 14),
                            padding: EdgeInsets.only(left: 15, right: 13),
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
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  // radius: 21,
                                  child: CachedNetworkImage(
                                    imageUrl: invitations[index].senderPicture!,
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
                                  ),
                                  // backgroundImage: CachedNetworkImageProvider(
                                  //   isSearchOpen
                                  //       ? dataList[index].senderPicture
                                  //       : invitations[index].senderPicture,
                                  // ),
                                ),
                                Spacer(
                                  flex: 2,
                                ),
                                Text(
                                  '${invitations[index].senderFirstName} ${invitations[index].senderLastName}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex("#FFFFFF")
                                              .withOpacity(0.87)
                                          : HexColor.fromHex("#384341"),
                                      fontSize: 14),
                                ),
                                Spacer(flex: 10),
                                Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: HexColor.fromHex("#FF6259"),
                                        shape: BoxShape.circle),
                                    child: Container(
                                      decoration: ConcaveDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          depression: 6,
                                          colors: [
                                            Colors.white,
                                            HexColor.fromHex("#D1D9E6")
                                          ]),
                                      child: IconButton(
                                        icon: Image.asset(
                                          "asset/check.png",
                                          height: 12,
                                          width: 16,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        onPressed: () {
                                          invitationBloc?.add(
                                              AcceptRejectInvitation(
                                                  contactId: invitations[index]
                                                      .contactID,
                                                  isAccepted: true));
                                          invitations.removeAt(index);
                                        },
                                      ),
                                    )),
                                SizedBox(
                                  width: 28,
                                ),
                                Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: HexColor.fromHex("#00AFAA"),
                                        shape: BoxShape.circle),
                                    child: Container(
                                      decoration: ConcaveDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          depression: 6,
                                          colors: [
                                            Colors.white,
                                            HexColor.fromHex("#D1D9E6")
                                          ]),
                                      child: IconButton(
                                        icon: Image.asset(
                                          "asset/whiteCross.png",
                                          height: 11,
                                          width: 11,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        onPressed: () {
                                          invitationBloc?.add(
                                              AcceptRejectInvitation(
                                                  contactId: invitations[index]
                                                      .contactID,
                                                  isAccepted: false));
                                          invitations.removeAt(index);
                                        },
                                      ),
                                    ))
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(StringLocalization.of(context)
                            .getText(StringLocalization.noPendingInvitations)),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Added by: shahzad
  ///  Added on: 8th jan 2021
  /// this function filters the search list
  List<InvitationList> searchList(String query) {
    List<InvitationList> dataList = [];
    for (var v in invitations) {
      if (v.senderFirstName!.toUpperCase().contains(query.toUpperCase()) ||
          v.senderLastName!.toUpperCase().contains(query.toUpperCase()) ||
          "${v.senderFirstName!.toUpperCase()} ${v.senderLastName!.toUpperCase()}"
              .contains(query.toUpperCase())) {
        dataList.add(v);
      }
    }
    return dataList;
  }

  /// Added by: shahzad
  ///  Added on: 8th jan 2021
  /// this is the search widget
  Widget searchTextField() {
    return Container(
        padding: EdgeInsets.only(top: 16, left: 13, right: 13),
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
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                      : HexColor.fromHex("#384341")),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).brightness != Brightness.dark ? Colors.black12  :Colors.white10,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: StringLocalization.of(context)
                      .getText(StringLocalization.searchContact),
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex("#FFFFFF").withOpacity(0.38)
                        : HexColor.fromHex("#7F8D8C"),
                  )),
              onChanged: (value) {
                searching = true;
                setState(() {
                  dataList = searchList(value);
                });
              },
            ),
          ),
        ));
  }
}
