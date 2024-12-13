import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_bloc.dart';
import 'package:health_gauge/screens/chat/models/access_chatted_with_model.dart';
import 'package:health_gauge/screens/chat/pages/user_chat_page.dart';
import 'package:health_gauge/screens/inbox/contacts_bloc.dart';
import 'package:health_gauge/screens/inbox/inbox_events.dart';
import 'package:health_gauge/screens/inbox/inbox_states.dart';
import 'package:health_gauge/utils/chat_connection_global.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/slider/flutter_slidable.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_search_widget.dart';
// import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_core/signalr_core.dart';

/// Added by: Akhil
/// Added on: July/27/2020
/// This class is to show the list of user contacts and list of requested contancts
class ChatContactsPage extends StatefulWidget {
  final HubConnection? hubConnection;

  ChatContactsPage({this.hubConnection});

  @override
  _ContactsState createState() => _ContactsState();
}

/// Added by: Akhil
///  Added on: July/27/2020
/// This class maintains state for Contacts Screen
class _ContactsState extends State<ChatContactsPage> {
  late ContactsBloc contactsBloc;
  bool isSearchOpen = false;
  late TextEditingController textEditingController;
  late String searchString = '';
  late GetInvitationListBloc getInvitationListBloc;
  late int userId;

  @override
  void initState() {
    userId = globalUser != null && globalUser?.userId != null
        ? int.parse(globalUser!.userId!)
        : 0;
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contactsBloc = BlocProvider.of<ContactsBloc>(context);
    getInvitationListBloc = BlocProvider.of<GetInvitationListBloc>(context);
    getInvitationListBloc.add(GetInvitationListEvent(userId: userId));

    contactsBloc.add(LoadContactList(userId: userId));
  }

  late List<UserData> contactList = [];
  late List<UserData> searchList = [];

  searchQuery() {
    for (var v in contactList) {
      if (v.firstName!.toUpperCase().contains(searchString.toUpperCase()) ||
          v.lastName!.toUpperCase().contains(searchString.toUpperCase()) ||
          "${v.firstName!.toUpperCase()} ${v.lastName!.toUpperCase()}"
              .contains(searchString.toUpperCase())) {
        searchList.add(v);
      }
    }
  }

  /// Added by: Akhil
  /// Added on: July/27/2020
  /// this method is responsible for building UI
  @override
  Widget build(BuildContext context) {
    print("Inside Contact");
    return
        // Scaffold(
        // appBar: PreferredSize(
        //     preferredSize: Size.fromHeight(kToolbarHeight),
        //     child: Container(
        //       decoration: BoxDecoration(boxShadow: [
        //         BoxShadow(
        //           color: Theme.of(context).brightness == Brightness.dark
        //               ? Colors.black.withOpacity(0.5)
        //               : HexColor.fromHex("#384341").withOpacity(0.2),
        //           offset: Offset(0, 2.0),
        //           blurRadius: 4.0,
        //         )
        //       ]),
        //       child: AppBar(
        //         elevation: 0,
        //         backgroundColor: Theme.of(context).brightness == Brightness.dark
        //             ? HexColor.fromHex('#111B1A')
        //             : AppColor.backgroundColor,
        //         title: Row(
        //           children: <Widget>[
        //             Expanded(
        //                 child: Center(
        //                     child: Text(
        //               StringLocalization.of(context)
        //                   .getText(StringLocalization.contacts),
        //               style: TextStyle(
        //                   color: HexColor.fromHex("62CBC9"),
        //                   fontSize: 18,
        //                   fontWeight: FontWeight.bold),
        //             ))),
        //           ],
        //         ),
        //         leading: IconButton(
        //           padding: EdgeInsets.only(left: 10),
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //           icon: Theme.of(context).brightness == Brightness.dark
        //               ? Image.asset(
        //                   "asset/dark_leftArrow.png",
        //                   width: 13,
        //                   height: 22,
        //                 )
        //               : Image.asset(
        //                   "asset/leftArrow.png",
        //                   width: 13,
        //                   height: 22,
        //                 ),
        //         ),
        //         centerTitle: false,
        //         actions: <Widget>[
        //           isSearchOpen
        //               ? IconButton(
        //                   padding: EdgeInsets.only(right: 15),
        //                   icon: Theme.of(context).brightness == Brightness.dark
        //                       ? Image.asset(
        //                           "asset/dark_close.png",
        //                           width: 33,
        //                           height: 33,
        //                         )
        //                       : Image.asset(
        //                           "asset/close.png",
        //                           width: 33,
        //                           height: 33,
        //                         ),
        //                   onPressed: () {
        //                     setState(() {
        //                       isSearchOpen = false;
        //                       searchString = '';
        //                       searchList = [];
        //                       // searching = false;
        //                     });
        //                   },
        //                 )
        //               : IconButton(
        //                   //padding: EdgeInsets.only(right: 15),
        //                   icon: Theme.of(context).brightness == Brightness.dark
        //                       ? Image.asset(
        //                           "asset/dark_search.png",
        //                           width: 33,
        //                           height: 33,
        //                         )
        //                       : Image.asset(
        //                           "asset/search.png",
        //                           width: 33,
        //                           height: 33,
        //                         ),
        //                   onPressed: () {
        //                     setState(() {
        //                       isSearchOpen = true;
        //                       searchList = contactList;
        //                     });
        //                   },
        //                 ),
        //         ],
        //       ),
        //     )),
        // body:
        Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      // height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CustomSearchWidget(
            fontSize: 14,
            textEditingController: textEditingController,
            onChanged: (String? value) {
              isSearchOpen = true;
              searchList = [];
              if (value != null) {
                searchString = value;
                // searchQuery();

                contactsBloc.add(SearchContactListEvents(
                  query: searchString,
                  userData: contactList,
                ));
                if (mounted) {
                  setState(() {});
                }
              }
            },
          ),
          BlocBuilder<ContactsBloc, InboxState>(builder: (context, state) {
            if (state is LoadedContactList) {
              if (state.response.data!.length > 0) {
                contactList = state.response.data!;
                contactList
                    .sort((a, b) => a.firstName!.compareTo(b.firstName!));
                return Expanded(
                    // mainAxisSize: MainAxisSize.min,
                    child: ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          print('c: ${contactList[index].toJson()}');
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<ChatBloc>(context),
                              child: UserChatPage(
                                chatUser: contactList[index],
                                fromUserId: int.parse(globalUser!.userId!),
                                toUserId: contactList[index].fKReceiverUserID,
                                chatUserData: ChatUserData(
                                  firstName: contactList[index].firstName!,
                                  lastName: contactList[index].lastName!,
                                  userID: contactList[index].fKReceiverUserID,
                                  username: contactList[index].username,
                                  isGroup: 0,
                                ),
                              ),
                            ),
                          ));
                        },
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              color: HexColor.fromHex("#FF6259"),
                              onTap: () {
                                // Scaffold.of(context).showSnackBar(SnackBar(
                                //   content: Text(StringLocalization.of(context)
                                //       .getText(
                                //       StringLocalization.contactDeleted)),
                                // ));
                              },
                              height: 70,
                              topMargin: 16,
                              iconWidget: Text(
                                StringLocalization.of(context)
                                    .getText(StringLocalization.delete),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.backgroundColor,
                                ),
                              ),
                              rightMargin: 13,
                              leftMargin: 0,
                            )
                          ],
                          child: Container(
                            height: 70,
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
                            child: ListTile(
                              leading: CircleAvatar(
                                child: CachedNetworkImage(
                                  imageUrl: contactList[index].picture!,
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
                                // backgroundImage:
                                //     CachedNetworkImageProvider(
                                //         isSearchOpen
                                //             ? searchList[index]
                                //                 .picture
                                //             : contactList[index]
                                //                 .picture),
                              ),
                              title: Text(
                                  '${contactList[index].firstName} ${contactList[index].lastName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white.withOpacity(0.87)
                                        : HexColor.fromHex("#384341"),
                                  )),
                            ),
                          ),
                        ));
                  },
                ));
              } else {
                return Container(
                  child: Center(
                    child: Text(
                      StringLocalization.of(context)
                          .getText(StringLocalization.noContactFound),
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                );
              }
            }
            if (state is SearchApiErrorState) {
              return Column(
                children: [
                  isSearchOpen
                      ? Container(
                          padding:
                              EdgeInsets.only(top: 16, left: 13, right: 13),
                          child: Container(
                            height: 56,
                            decoration: ConcaveDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                depression: 7,
                                colors: [
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex("#000000")
                                          .withOpacity(0.8)
                                      : HexColor.fromHex("#D1D9E6"),
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex("#D1D9E6")
                                          .withOpacity(0.1)
                                      : Colors.white,
                                ]),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Center(
                              child: TextField(
                                controller: textEditingController,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex("#FFFFFF")
                                            .withOpacity(0.87)
                                        : HexColor.fromHex("#384341")),
                                onChanged: (value) {
                                  searchList = [];
                                  print('****************');
                                  print(value);
                                  print('****************');
                                  searchString = value;
                                  searchQuery();
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: StringLocalization.of(context)
                                        .getText(
                                            StringLocalization.searchContact),
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex("#FFFFFF")
                                              .withOpacity(0.38)
                                          : HexColor.fromHex("#7F8D8C"),
                                    )),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                          isSearchOpen ? searchList.length : contactList.length,
                          (index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<ChatBloc>(context),
                                  child: UserChatPage(
                                    hubConnection: widget.hubConnection,
                                    chatUser: isSearchOpen
                                        ? searchList[index]
                                        : contactList[index],
                                    fromUserId: int.parse(globalUser!.userId!),
                                    toUserId: isSearchOpen
                                        ? searchList[index].fKReceiverUserID
                                        : contactList[index].fKReceiverUserID,
                                    chatUserData: ChatUserData(
                                      firstName: isSearchOpen
                                          ? searchList[index].firstName!
                                          : contactList[index].firstName!,
                                      lastName: isSearchOpen
                                          ? searchList[index].lastName!
                                          : contactList[index].lastName!,
                                      userID: isSearchOpen
                                          ? searchList[index].fKReceiverUserID
                                          : contactList[index].fKReceiverUserID,
                                      username: isSearchOpen
                                          ? searchList[index].username
                                          : contactList[index].username,
                                      // username: isSearchOpen
                                      //     ? searchList[index].fKReceiverUserID
                                      //     : contactList[index].fKReceiverUserID,
                                      isGroup: 0,
                                    ),
                                  ),
                                ),
                              ));
                              // builder: (_) => ChatItemPage(
                              //     hubConnection: widget.hubConnection,
                              //     chatUser: isSearchOpen
                              //         ? searchList[index]
                              //         : contactList[index])));
                            },
                            child: Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  color: HexColor.fromHex("#FF6259"),
                                  onTap: () {
                                    //  contactsBloc.add(DeleteContact(fromUserId: widget.userId,toUserId: state.response.data[index].fKReceiverUserID,id: state.response.data[index].id));
                                    // setState(() {
                                    //   contactList
                                    //       .remove(state.response.data[index]);
                                    // });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          StringLocalization.of(context)
                                              .getText(StringLocalization
                                                  .contactDeleted)),
                                    ));
                                  },
                                  height: 56,
                                  topMargin: 16,
                                  iconWidget: Text(
                                    StringLocalization.of(context)
                                        .getText(StringLocalization.delete),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.backgroundColor,
                                    ),
                                  ),
                                  rightMargin: 13,
                                  leftMargin: 0,
                                )
                              ],
                              child: Container(
                                height: 56,
                                margin: EdgeInsets.only(
                                    left: 13, right: 13, top: 16),
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
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: CachedNetworkImage(
                                      imageUrl: isSearchOpen
                                          ? searchList[index].picture!
                                          : contactList[index].picture!,
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
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        "asset/m_profile_icon.png",
                                        color: Colors.white,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        "asset/m_profile_icon.png",
                                        color: Colors.white,
                                      ),
                                    ),
                                    // backgroundImage:
                                    //     CachedNetworkImageProvider(
                                    //         isSearchOpen
                                    //             ? searchList[index].picture
                                    //             : contactList[index]
                                    //                 .picture),
                                  ),
                                  title: Text(
                                      isSearchOpen
                                          ? '${searchList[index].firstName} ${searchList[index].lastName}'
                                          : '${contactList[index].firstName} ${contactList[index].lastName}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex("#384341"),
                                      )),
                                ),
                              ),
                            ));
                      })),
                ],
              );
            }
            if (state is ContactSearchSuccessState) {
              searchList = state.searchData;
              return Expanded(
                child: ListView.builder(
                  itemCount: searchList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<ChatBloc>(context),
                            child: UserChatPage(
                              hubConnection: widget.hubConnection,
                              chatUser: searchList[index],
                              fromUserId: int.parse(globalUser!.userId!),
                              toUserId: searchList[index].fKReceiverUserID,
                              chatUserData: ChatUserData(
                                firstName: searchList[index].firstName!,
                                lastName: searchList[index].lastName!,
                                userID: searchList[index].fKReceiverUserID,
                                username: searchList[index].username,
                                isGroup: 0,
                              ),
                            ),
                          ),
                        ));
                      },
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            color: HexColor.fromHex("#FF6259"),
                            onTap: () {},
                            height: 70,
                            topMargin: 16,
                            iconWidget: Text(
                              StringLocalization.of(context)
                                  .getText(StringLocalization.delete),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.backgroundColor,
                              ),
                            ),
                            rightMargin: 13,
                            leftMargin: 0,
                          )
                        ],
                        child: Container(
                          height: 70,
                          margin: EdgeInsets.only(left: 13, right: 13, top: 16),
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
                          child: ListTile(
                            leading: CircleAvatar(
                              child: CachedNetworkImage(
                                imageUrl: searchList[index].picture!,
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
                              // backgroundImage:
                              //     CachedNetworkImageProvider(
                              //         isSearchOpen
                              //             ? searchList[index]
                              //                 .picture
                              //             : contactList[index]
                              //                 .picture),
                            ),
                            title: Text(
                              '${searchList[index].firstName} ${searchList[index].lastName}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex("#384341"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            if (state is ContactSearchEmptyState) {
              return Center(
                child: Text('No Result Found'),
              );
            }

            return Container(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }),
        ],
      ),
      // ),
    );
  }
}
