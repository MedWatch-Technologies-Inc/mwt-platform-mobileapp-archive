import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/screens/Mail/Contacts/model/contact_screen_model.dart';
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
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:provider/provider.dart';

import 'pending_invitations.dart';
import 'search_contact_to_send_invitation.dart';

/// Added by: Akhil
/// Added on: July/27/2020
/// This class is to show the list of user contacts and list of requested contancts
class Contacts extends StatefulWidget {
  late final int userId;
  final bool isChat;
  // final Function? sendMail;

  Contacts({
    required this.userId,
    this.isChat = true,
    // this.sendMail,
  });

  @override
  _ContactsState createState() => _ContactsState();
}

/// Added by: Akhil
///  Added on: July/27/2020
/// This class maintains state for Contacts Screen
class _ContactsState extends State<Contacts> with ChangeNotifier {
  ContactsBloc? contactsBloc;
  bool isSearchOpen = false;
  GetInvitationListBloc? getInvitationListBloc;
  late TextEditingController _searchController;
  List<UserData> dataList = [];
  List<UserData> databaseList = [];
  bool searching = false;
  bool isLoading = false;
  ContactScreenModel contactScreenModel = ContactScreenModel();

  /// Added by: Akhil
  /// Added on: July/27/2020
  /// Lifecycle method of stateful widget, Provided the context of ContactsBloc, GetInvitationListBloc, and hit the api.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLoading = true;
    contactsBloc = BlocProvider.of<ContactsBloc>(context);
    getInvitationListBloc = BlocProvider.of<GetInvitationListBloc>(context);
    contactsBloc?.add(LoadContactList(userId: widget.userId));
    getInvitationListBloc?.add(GetInvitationListEvent(userId: widget.userId));
    _searchController = TextEditingController();
  }

  List<UserData> contactList = [];

  @override
  void dispose() {
    // TODO: implement dispose
    print('Chat Loggggg :: dispose _ContactsState');
    ChatConnectionGlobal().connectionId = "";
    ChatConnectionGlobal().hubConnection?.off('sendchat');
    ChatConnectionGlobal().hubConnection?.stop();
    ChatConnectionGlobal().hubConnection = null;

    super.dispose();
  }

  /// Added by: Akhil
  /// Added on: July/27/2020
  /// this method is responsible for building UI
  @override
  Widget build(BuildContext context) {
    print('Inside Contact');
    return ChangeNotifierProvider.value(
      value: contactScreenModel,
      child: Consumer<ContactScreenModel>(
        builder: (context, model, child) {
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
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                    title: Row(
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.only(right: 10),
                          icon: Theme.of(context).brightness == Brightness.dark
                              ? Image.asset(
                                  'asset/dark_Invitation_icon.png',
                                  width: 33,
                                  height: 33,
                                )
                              : Image.asset(
                                  'asset/invitation_icon.png',
                                  width: 33,
                                  height: 33,
                                ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PendingInvitation(
                                          userId: widget.userId,
                                        ))).then((_) {
                              model.changeLoading(true);
                              // contactsBloc = BlocProvider.of<ContactsBloc>(context);
                              getInvitationListBloc =
                                  BlocProvider.of<GetInvitationListBloc>(
                                      context);
                              getInvitationListBloc?.add(GetInvitationListEvent(
                                  userId: widget.userId));
                              contactsBloc!
                                  .add(LoadContactList(userId: widget.userId));
                            });
                          },
                        ),
                        Expanded(
                            child: Center(
                                child: Text(
                          StringLocalization.of(context)
                              .getText(StringLocalization.contacts),
                          style: TextStyle(
                              color: HexColor.fromHex('62CBC9'),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ))),
                      ],
                    ),
                    leading: IconButton(
                      key: Key('contactBackButton'),
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
                    centerTitle: false,
                    actions: <Widget>[
                      model.isSearchOpen
                          ? IconButton(
                              padding: EdgeInsets.only(right: 15),
                              icon: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Image.asset(
                                      'asset/dark_close.png',
                                      width: 33,
                                      height: 33,
                                    )
                                  : Image.asset(
                                      'asset/close.png',
                                      width: 33,
                                      height: 33,
                                    ),
                              onPressed: () {
                                model.changeSearching(false);
                                model.changeSearchOpen(false);
                              },
                            )
                          : IconButton(
                              //padding: EdgeInsets.only(right: 15),
                              icon: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Image.asset(
                                      'asset/dark_search.png',
                                      width: 33,
                                      height: 33,
                                    )
                                  : Image.asset(
                                      'asset/search.png',
                                      width: 33,
                                      height: 33,
                                    ),
                              onPressed: () {
                                model.changeSearchOpen(true);
                                searchList('');
//                Navigator.of(context).push(new MaterialPageRoute<Null>(
//                    builder: (BuildContext context) {
//                      return ContactSearchPage(
//                        searchedContacts: contactList,
//                        isFromChat: false,
//                      );
//                    },
//                    fullscreenDialog: true));
                              },
                            ),
                      IconButton(
                        padding: EdgeInsets.only(right: 15),
                        icon: Theme.of(context).brightness == Brightness.dark
                            ? Image.asset(
                                'asset/dark_addContact.png',
                                width: 33,
                                height: 33,
                              )
                            : Image.asset(
                                'asset/addContact.png',
                                height: 33,
                                width: 33,
                              ),
                        //iconSize: 10,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchContactToInviteScreen(
                                        userId: widget.userId,
                                      ))).then((_) {
                            model.changeLoading(true);
                            // contactsBloc = BlocProvider.of<ContactsBloc>(context);
                            getInvitationListBloc =
                                BlocProvider.of<GetInvitationListBloc>(context);
                            getInvitationListBloc?.add(
                                GetInvitationListEvent(userId: widget.userId));
                            contactsBloc!
                                .add(LoadContactList(userId: widget.userId));
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
                  ? AppColor.darkBackgroundColor
                  : AppColor.backgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    model.isSearchOpen ? searchTextField() : Container(),
                    BlocListener(
                      bloc: contactsBloc,
                      listener: (BuildContext context, InboxState state) {
                        if (state is DeletedContact) {
                          if (state.response.result!) {
                            // Scaffold.of(context).showSnackBar(SnackBar(
                            //   content: Text(StringLocalization.of(context)
                            //       .getText(StringLocalization.contactDeleted)),
                            // ));
                            CustomSnackBar.buildSnackbar(
                                context,
                                StringLocalization.of(context)
                                    .getText(StringLocalization.contactDeleted),
                                3);
                          }
                        }
                        if (state is LoadedContactList) {
                          // print('contactbloc');

                          if (state.response.isFromDb ?? false) {
                            print('contactbloc1');
                            model.changeLoading(true);
                            if (state.response.data != null &&
                                state.response.data is List &&
                                state.response.data!.isNotEmpty) {
                              databaseList = state.response.data!;
                              // model.changeDataList(databaseList);
                            }
                          } else {
                            print('contactbloc2');
                            model.changeLoading(false);
                            if (state.response.data != null &&
                                state.response.data is List &&
                                state.response.data!.isNotEmpty) {
                              print('contactbloc3');
                              // contactList = state.response.data;
                              model.changeDataList(state.response.data!);
                            } else {
                              print('contactbloc4');
                              model.changeDataList(databaseList);
                            }
                          }
                        }

                        if (state is SearchApiErrorState) {
                          model.changeLoading(false);
                        }
                      },
                      child: Container(),
                    ),
                    model.isLoading
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : model.searching
                            ? model.searchList.isNotEmpty
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      model.searchList.length,
                                      (index) {
                                        return GestureDetector(
                                          onTap: () {
                                            print(
                                                'c: ${model.searchList[index].toJson()}');
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider.value(
                                                value:
                                                    BlocProvider.of<ChatBloc>(
                                                        context),
                                                child: UserChatPage(
                                                  chatUser:
                                                      model.searchList[index],
                                                  fromUserId: int.parse(
                                                      globalUser!.userId!),
                                                  toUserId: model
                                                      .searchList[index]
                                                      .fKReceiverUserID,
                                                  chatUserData: ChatUserData(
                                                    firstName: model
                                                        .searchList[index]
                                                        .firstName!,
                                                    lastName: model
                                                        .searchList[index]
                                                        .lastName!,
                                                    userID: model
                                                        .searchList[index]
                                                        .fKReceiverUserID,
                                                    username: model
                                                        .searchList[index]
                                                        .username,
                                                    isGroup: 0,
                                                      picture: model
                                                          .dataList[index].picture.toString()
                                                  ),
                                                ),
                                              ),
                                            ));

                                            // showDialog(
                                            //   context: context,
                                            //   barrierDismissible: true,
                                            //   builder: (BuildContext context) {
                                            //     return contactInformationDialog(
                                            //         userData:
                                            //         model.searchList[index],
                                            //         // sendMail: widget.sendMail,
                                            //         context: context);
                                            //   },
                                            // );
                                          },
                                          child: Container(
                                            height: 56,
                                            margin: EdgeInsets.only(
                                              left: 13,
                                              right: 13,
                                              top: 16,
                                              bottom: index ==
                                                      model.searchList
                                                              .length -
                                                          1
                                                  ? 16
                                                  : 0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? HexColor.fromHex(
                                                      '#111B1A')
                                                  : AppColor.backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? HexColor.fromHex(
                                                              '#D1D9E6')
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
                                                      ? Colors.black
                                                          .withOpacity(0.75)
                                                      : HexColor.fromHex(
                                                              '#9F2DBC')
                                                          .withOpacity(0.15),
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                  offset: Offset(4, 4),
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? HexColor.fromHex(
                                                        '#111B1A')
                                                    : AppColor
                                                        .backgroundColor,
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex(
                                                                '#9F2DBC')
                                                            .withOpacity(0.15)
                                                        : HexColor.fromHex(
                                                                '#D1D9E6')
                                                            .withOpacity(0.5),
                                                    Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex(
                                                                '#9F2DBC')
                                                            .withOpacity(0)
                                                        : HexColor.fromHex(
                                                                '#FFDFDE')
                                                            .withOpacity(0),
                                                  ],
                                                ),
                                              ),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  child: CachedNetworkImage(
                                                    imageUrl: model
                                                        .searchList[index]
                                                        .picture!,
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
                                                            fit:
                                                                BoxFit.cover),
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            Image.asset(
                                                      'asset/m_profile_icon.png',
                                                      color: Colors.white,
                                                    ),
                                                    errorWidget: (context,
                                                        url, error) {
                                                      return Image.asset(
                                                        'asset/m_profile_icon.png',
                                                        color: Colors.white,
                                                      );
                                                    },
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
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                            .withOpacity(0.87)
                                                        : HexColor.fromHex(
                                                            '#384341'),
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
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : noContactsFound()
                            : model.dataList.isNotEmpty
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      model.dataList.length,
                                      (index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider.value(
                                                value:
                                                    BlocProvider.of<ChatBloc>(
                                                        context),
                                                child: UserChatPage(
                                                  chatUser:
                                                      model.dataList[index],
                                                  fromUserId: int.parse(
                                                      globalUser!.userId!),
                                                  toUserId: model
                                                      .dataList[index]
                                                      .fKReceiverUserID,
                                                  chatUserData: ChatUserData(
                                                    firstName: model
                                                        .dataList[index]
                                                        .firstName!,
                                                    lastName: model
                                                        .dataList[index]
                                                        .lastName!,
                                                    userID: model
                                                        .dataList[index]
                                                        .fKReceiverUserID,
                                                    username: model
                                                        .dataList[index]
                                                        .username,
                                                    isGroup: 0,
                                                      picture: model
                                                          .dataList[index].picture.toString()
                                                  ),
                                                ),
                                              ),
                                            ));
                                            // showDialog(
                                            //   context: context,
                                            //   barrierDismissible: true,
                                            //   builder: (BuildContext context) {
                                            //     return contactInformationDialog(
                                            //         userData:
                                            //         model.dataList[index],
                                            //         // sendMail: widget.sendMail,
                                            //         context: context);
                                            //   },
                                            // );
                                          },
                                          child: Container(
                                            height: 56,
                                            margin: EdgeInsets.only(
                                                left: 13,
                                                right: 13,
                                                top: 16,
                                                bottom: index ==
                                                        model.dataList
                                                                .length -
                                                            1
                                                    ? 16
                                                    : 0),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? HexColor.fromHex(
                                                        '#111B1A')
                                                    : AppColor
                                                        .backgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex(
                                                                '#D1D9E6')
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
                                                        ? Colors.black
                                                            .withOpacity(0.75)
                                                        : HexColor.fromHex(
                                                                '#9F2DBC')
                                                            .withOpacity(
                                                                0.15),
                                                    blurRadius: 4,
                                                    spreadRadius: 0,
                                                    offset: Offset(4, 4),
                                                  ),
                                                ]),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? HexColor.fromHex(
                                                          '#111B1A')
                                                      : AppColor
                                                          .backgroundColor,
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Theme.of(context)
                                                                    .brightness ==
                                                                Brightness
                                                                    .dark
                                                            ? HexColor.fromHex(
                                                                    '#9F2DBC')
                                                                .withOpacity(
                                                                    0.15)
                                                            : HexColor.fromHex(
                                                                    '#D1D9E6')
                                                                .withOpacity(
                                                                    0.5),
                                                        Theme.of(context)
                                                                    .brightness ==
                                                                Brightness
                                                                    .dark
                                                            ? HexColor.fromHex(
                                                                    '#9F2DBC')
                                                                .withOpacity(
                                                                    0)
                                                            : HexColor.fromHex(
                                                                    '#FFDFDE')
                                                                .withOpacity(
                                                                    0),
                                                      ])),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  child: CachedNetworkImage(
                                                    imageUrl: model
                                                        .dataList[index]
                                                        .picture!,
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
                                                            fit:
                                                                BoxFit.cover),
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            Image.asset(
                                                      'asset/m_profile_icon.png',
                                                      color: Colors.white,
                                                    ),
                                                    errorWidget: (context,
                                                            url, error) =>
                                                        Image.asset(
                                                      'asset/m_profile_icon.png',
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                title: SizedBox(
                                                  height: 25,
                                                  child: Body1AutoText(
                                                    text:
                                                        '${model.dataList[index].firstName} ${model.dataList[index].lastName}',
                                                    fontSize: 16,
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                            .withOpacity(0.87)
                                                        : HexColor.fromHex(
                                                            '#384341'),
                                                    maxLine: 1,
                                                    minFontSize: 6,
                                                  ),
                                                  // child: TitleText(
                                                  //   text:
                                                  //       '${model.dataList[index].firstName} ${model.dataList[index].lastName}',
                                                  //   fontSize: 16,
                                                  //   color: Theme.of(context)
                                                  //               .brightness ==
                                                  //           Brightness.dark
                                                  //       ? Colors.white
                                                  //           .withOpacity(0.87)
                                                  //       : HexColor.fromHex(
                                                  //           "#384341"),
                                                  //   maxLine: 1,

                                                  // ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(),
                    model.isSearchOpen || model.isLoading
                        ? Container()
                        : BlocBuilder<GetInvitationListBloc, InboxState>(
                            builder: (context, state) {
                            // print('getinvitationlistbloc');
                            if (state is GetInvitationListState) {
                              if (state.response.data != null) {
                                model.lengthInvitationList =
                                    state.response.data!.length;

                                if (state.response.data != null &&
                                    state.response.data is List &&
                                    state.response.data!.isNotEmpty) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                        state.response.data!.length, (index) {
                                      return Container(
                                        height: 56,
                                        margin: EdgeInsets.only(
                                            left: 13,
                                            right: 13,
                                            top: 15,
                                            bottom: index ==
                                                    state.response.data!
                                                            .length -
                                                        1
                                                ? 15
                                                : 0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                                      .brightness ==
                                                  Brightness.dark
                                              ? HexColor.fromHex('#111B1A')
                                              : AppColor.backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? HexColor.fromHex(
                                                          '#D1D9E6')
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
                                                  ? Colors.black
                                                      .withOpacity(0.75)
                                                  : HexColor.fromHex(
                                                          '#9F2DBC')
                                                      .withOpacity(0.15),
                                              blurRadius: 4,
                                              spreadRadius: 0,
                                              offset: Offset(4, 4),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? HexColor.fromHex('#111B1A')
                                                : AppColor.backgroundColor,
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? HexColor.fromHex(
                                                            '#9F2DBC')
                                                        .withOpacity(0.15)
                                                    : HexColor.fromHex(
                                                            '#D1D9E6')
                                                        .withOpacity(0.5),
                                                Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? HexColor.fromHex(
                                                            '#9F2DBC')
                                                        .withOpacity(0)
                                                    : HexColor.fromHex(
                                                            '#FFDFDE')
                                                        .withOpacity(0),
                                              ],
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              child: CachedNetworkImage(
                                                imageUrl: state.response
                                                    .data![index].picture!,
                                                imageBuilder: (context,
                                                        imageProvider) =>
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
                                                  'asset/m_profile_icon.png',
                                                  color: Colors.white,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  'asset/m_profile_icon.png',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            title: SizedBox(
                                              height: 25,
                                              child: Text(
                                                '${state.response.data![index].firstName} ${state.response.data![index].lastName}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                          .withOpacity(0.87)
                                                      : HexColor.fromHex(
                                                          '#384341'),
                                                ),
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              // child: FittedTitleText(
                                              //   text:
                                              //       '${state.response.data[index].firstName} ${state.response.data[index].lastName}',
                                              //   fontSize: 16,
                                              //   color: Theme.of(context)
                                              //               .brightness ==
                                              //           Brightness.dark
                                              //       ? Colors.white.withOpacity(0.87)
                                              //       : HexColor.fromHex("#384341"),
                                              //   // maxLine: 1,
                                              // ),
                                            ),
                                            trailing: Container(
                                              width: 95,
                                              height: 23,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: HexColor.fromHex(
                                                    '#62CBC9'),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex(
                                                                '#D1D9E6')
                                                            .withOpacity(0.1)
                                                        : HexColor.fromHex(
                                                            '#FFFFFF'),
                                                    blurRadius: 10,
                                                    spreadRadius: 0,
                                                    offset: Offset(-10, -10),
                                                  ),
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex(
                                                                '#000000')
                                                            .withOpacity(0.75)
                                                        : HexColor.fromHex(
                                                            '#D1D9E6'),
                                                    blurRadius: 10,
                                                    spreadRadius: 0,
                                                    offset: Offset(10, 10),
                                                  )
                                                ],
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: HexColor.fromHex(
                                                      '#62CBC9'),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex(
                                                                  '#9F2DBC')
                                                              .withOpacity(
                                                                  0.8)
                                                          : HexColor.fromHex(
                                                                  '#9F2DBC')
                                                              .withOpacity(
                                                                  0.8),
                                                      blurRadius: 4,
                                                      spreadRadius: 0.1,
                                                      offset: Offset(0, 0),
                                                    ),
                                                  ],
                                                ),
                                                child: Container(
                                                  decoration:
                                                      ConcaveDecoration(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                          depression: 5,
                                                          colors: [
                                                        Theme.of(context)
                                                                    .brightness ==
                                                                Brightness
                                                                    .dark
                                                            ? HexColor
                                                                .fromHex(
                                                                    '#D1D9E6')
                                                            : Colors.white,
                                                        Theme.of(context)
                                                                    .brightness ==
                                                                Brightness
                                                                    .dark
                                                            ? HexColor
                                                                .fromHex(
                                                                    '#BD78CE')
                                                            : HexColor.fromHex(
                                                                '#D1D9E6'),
                                                      ]),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                              horizontal: 10),
                                                      // child: FittedBox(
                                                      //   fit: BoxFit.scaleDown,
                                                      //   alignment:
                                                      //       Alignment.centerLeft,
                                                      //   child: Text(
                                                      //     StringLocalization.of(
                                                      //             context)
                                                      //         .getText(
                                                      //             StringLocalization
                                                      //                 .requested),
                                                      //     style: TextStyle(
                                                      //         color:
                                                      //             HexColor.fromHex(
                                                      //                 "#9F2DBC"),
                                                      //         fontWeight:
                                                      //             FontWeight.bold,
                                                      //         fontSize: 14),
                                                      //     maxLines: 1,
                                                      //     // minFontSize: 8,
                                                      //   ),
                                                      // ),
                                                      child: TitleText(
                                                        text: StringLocalization
                                                                .of(context)
                                                            .getText(
                                                                StringLocalization
                                                                    .requested),
                                                        color:
                                                            HexColor.fromHex(
                                                                '#9F2DBC'),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        // maxLine: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                } else {
                                  if (model.dataList.isEmpty) {
                                    return noContactsFound();
                                  } else {
                                    return Container();
                                  }
                                }
                              }
                            } else {
                              return Center(
                                child: Container(),
                              );
                            }
                            if (model.dataList.isNotEmpty) {
                              return Center(
                                child: Container(),
                              );
                            } else {
                              return Center(
                                child: noContactsFound(),
                              );
                            }
                          }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget noContactsFound() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Center(
        child: Visibility(
          visible: true,
          child: Text(
            StringLocalization.of(context)
                .getText(StringLocalization.noContactFound),
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  /// Added by: Akhil
  /// Added on: July/27/2020
  /// this widget is for showing the detail of contact
  Widget contactInformationDialog(
      {UserData? userData, // Function sendMail,
      BuildContext? context}) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(8),
                width: MediaQuery.of(context!).size.width,
                height: 156,
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : HexColor.fromHex('#DDE3E3').withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(-5, -5),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.75)
                            : HexColor.fromHex('#7F8D8C'),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(5, 5),
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 68,
                      ),
                      SizedBox(
                        height: 30,
                        child: Body1AutoText(
                          text: '${userData?.firstName} ${userData?.lastName}',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                          maxLine: 1,
                          minFontSize: 10,
                        ),
                        // child: FittedTitleText(
                        //   text: '${userData.firstName} ${userData.lastName}',
                        //   fontSize: 24,
                        //   fontWeight: FontWeight.bold,
                        //   color: Theme.of(context).brightness == Brightness.dark
                        //       ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                        //       : HexColor.fromHex("#384341"),
                        //   // maxLine: 1,
                        // ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      // Row(
                      //   children: <Widget>[
                      // SizedBox(
                      //   height: 25,
                      //   // child: FittedBox(
                      //   //   fit: BoxFit.scaleDown,
                      //   //   alignment: Alignment.centerLeft,
                      //   //   child: Text(
                      //   //     '${userData.email}',
                      //   //     style: TextStyle(
                      //   //         fontSize: 16,
                      //   //         color: Theme.of(context).brightness ==
                      //   //                 Brightness.dark
                      //   //             ? HexColor.fromHex("#FFFFFF")
                      //   //                 .withOpacity(0.6)
                      //   //             : HexColor.fromHex("#5D6A68")),
                      //   //     maxLines: 1,
                      //   //     // minFontSize: 8,
                      //   //   ),
                      //   // ),
                      //   child: TitleText(
                      //     text: '${userData?.email}',
                      //     fontSize: 16,
                      //     color: Theme.of(context).brightness == Brightness.dark
                      //         ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                      //         : HexColor.fromHex('#5D6A68'),
                      //     // maxLine: 1,
                      //   ),
                      // ),
                      // Spacer(),
                      //   ],
                      // ),
                      // userData?.phone != null && userData?.phone?.trim() != ''
                      //     ? Row(
                      //         children: <Widget>[
                      //           SizedBox(
                      //             height: 25,
                      //             // child: FittedBox(
                      //             //   fit: BoxFit.scaleDown,
                      //             //   alignment: Alignment.centerLeft,
                      //             //   child: Text(
                      //             //     '${userData.phone}',
                      //             //     style: TextStyle(
                      //             //         fontSize: 16,
                      //             //         color: Theme.of(context).brightness ==
                      //             //                 Brightness.dark
                      //             //             ? HexColor.fromHex("#FFFFFF")
                      //             //                 .withOpacity(0.6)
                      //             //             : HexColor.fromHex("#5D6A68")),
                      //             //     // minFontSize: 8,
                      //             //     maxLines: 1,
                      //             //   ),
                      //             // ),
                      //             child: TitleText(
                      //               text: '${userData?.phone}',
                      //               fontSize: 16,
                      //               color: Theme.of(context).brightness ==
                      //                       Brightness.dark
                      //                   ? HexColor.fromHex('#FFFFFF')
                      //                       .withOpacity(0.6)
                      //                   : HexColor.fromHex('#5D6A68'),
                      //               // maxLine: 1,
                      //             ),
                      //           ),
                      //           Spacer(),
                      //           IconButton(
                      //             icon: Image.asset(
                      //               'asset/phone_icon.png',
                      //               height: 30,
                      //               width: 30,
                      //             ),
                      //             onPressed: () async {
                      //               if (await canLaunch(
                      //                   'tel://${userData?.phone}')) {
                      //                 await launch('tel://${userData?.phone}');
                      //               } else {
                      //                 throw 'Could not dial ${userData?.phone}';
                      //               }
                      //             },
                      //           )
                      //         ],
                      //       )
                      //     : Container(),
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
                    'asset/m_profile_icon.png',
                    color: Colors.white,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'asset/m_profile_icon.png',
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void searchList(String query) {
    var tempList = <UserData>[];
    for (var v in contactScreenModel.dataList) {
      if (v.firstName!.toUpperCase().contains(query.toUpperCase()) ||
          v.lastName!.toUpperCase().contains(query.toUpperCase()) ||
          '${v.firstName!.toUpperCase()} ${v.lastName!.toUpperCase()}'
              .contains(query.toUpperCase())) {
        tempList.add(v);
      }
    }
    contactScreenModel.addInSearchList(tempList);
  }

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
                    ? HexColor.fromHex('#000000').withOpacity(0.8)
                    : HexColor.fromHex('#D1D9E6'),
                Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
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
                      ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                      : HexColor.fromHex('#384341')),
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
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.38)
                        : HexColor.fromHex('#7F8D8C'),
                  )),
              onChanged: (value) {
                contactScreenModel.changeSearching(true);
                searchList(value);
              },
            ),
          ),
        ));
  }
}
