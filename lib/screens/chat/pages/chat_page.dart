import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_bloc.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_event.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_state.dart';
import 'package:health_gauge/screens/chat/models/access_chatted_with_model.dart';
import 'package:health_gauge/screens/chat/pages/user_chat_page.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/chat_connection_global.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable_action_pane.dart';
import 'package:health_gauge/utils/slider/src/widgets/slide_action.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_search_widget.dart';
import 'package:intl/intl.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatPage extends StatefulWidget {
  final int userID;

  ChatPage(this.userID);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUserData> searchList = [];
  List<ChatUserData> chatList = [];
  late TextEditingController textEditingController;
  String searchString = '';
  bool isSearching = false;
  late HubConnection hubConnection;
  late ChatBloc chatBloc;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    // connectToHub();
    // ChatConnectionGlobal().connectToHub();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(GetAccessChattedWith(userID: widget.userID));
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // chatBloc.add(GetAccessChattedWith(userID: widget.userID));
  }

  @override
  void dispose() {
    super.dispose();
    // chatBloc.add(DisposeEvent());
    // chatBloc.close();
  }

  void searchQuery() {
    for (var v in chatList) {
      if (v.firstName!.toUpperCase().contains(searchString.toUpperCase()) ||
          v.lastName!.toUpperCase().contains(searchString.toUpperCase()) ||
          '${v.firstName!.toUpperCase()} ${v.lastName!.toUpperCase()}'
              .contains(searchString.toUpperCase())) {
        searchList.add(v);
      }
    }
  }

  // added by me
  Widget loadSearched() {
    if (searchList.isEmpty) {
      return Text(stringLocalization.getText(StringLocalization.noResultFound));
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: searchList.length,
          itemBuilder: (context, index) {
            if (widget.userID == searchList[index].userID) {
              return Container();
            } else {
              return GestureDetector(
                  onTap: () {},
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        color: HexColor.fromHex('#FF6259'),
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
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#111B1A')
                              : AppColor.backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                  : Colors.white,
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: Offset(-4, -4),
                            ),
                            BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black.withOpacity(0.75)
                                  : HexColor.fromHex('#9F2DBC')
                                      .withOpacity(0.15),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: Offset(4, 4),
                            ),
                          ]),
                      child: ListTile(
                          // leading: Image.asset(chatList[index].profile_picture),
                          // title: Text('${searchList[index].contact.name}',
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       color:
                          //           Theme.of(context).brightness == Brightness.dark
                          //               ? Colors.white.withOpacity(0.87)
                          //               : HexColor.fromHex("#384341"),
                          //     )),
                          // subtitle: Text('${searchList[index].lastMessage}',
                          //     style: TextStyle(
                          //       fontSize: 14,
                          //       color:
                          //           Theme.of(context).brightness == Brightness.dark
                          //               ? Colors.white.withOpacity(0.87)
                          //               : HexColor.fromHex("#384341"),
                          //     )),
                          // trailing: Text(
                          //     getDateInFormat(
                          //         searchList[index].lastMessageTime, 'dd MMM'),
                          //     style: TextStyle(
                          //       fontSize: 14,
                          //       color:
                          //           Theme.of(context).brightness == Brightness.dark
                          //               ? Colors.white.withOpacity(0.87)
                          //               : HexColor.fromHex("#384341"),
                          //     )),
                          ),
                    ),
                  ));
            }
          },
        ),
      );
    }
  }

  String getDateInFormat(String date, String outputFormat) {
    return DateFormat(outputFormat).format(DateTime.parse(date));
    // "dd-MM-yyyy"
  }

  @override
  Widget build(BuildContext context) {
    print(
        'chat event mapEventToState ********INSIDE CHAT PAGE *******************');
    // print(ChatConnectionGlobal().connectionState);
    print(ChatConnectionGlobal().hubConnection?.state);
    print('****************END ***********************');

    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      child: Column(
        children: <Widget>[
          CustomSearchWidget(
            fontSize: 14,
            textEditingController: textEditingController,
            onChanged: (String? value) {
              searchList = [];
              if (value != null) {
                searchString = value;
                searchQuery();
                // setState(() {});
                chatBloc.add(
                    SearchChatList(query: searchString, userData: chatList));
                if (mounted) {
                  setState(() {});
                }
              }
            },
          ),
          BlocConsumer(
              bloc: chatBloc,
              buildWhen: (prevState, curState) {
                return curState is AccessChattedWithSuccessState ||
                    curState is DatabaseLoadedState ||
                    curState is ChatErrorState ||
                    curState is ChatSearchSuccessState ||
                    curState is ChatSearchEmptyState;
              },
              listener: (context, state) {},
              builder: (context, state) {
                print('chat event mapEventToState build stat ${state}');
                if (state is AccessChattedWithSuccessState) {
                  chatList = state.dataModel.data!;
                  if (chatList.isEmpty) {
                    return Center(
                      child: Text('No Result Found'),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        if (widget.userID == chatList[index].userID) {
                          return Container();
                        } else {
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                      value: chatBloc,
                                      child: UserChatPage(
                                        toUserId: chatList[index].userID,
                                        fromUserId: widget.userID,
                                        chatUserData: chatList[index],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    color: HexColor.fromHex('#FF6259'),
                                    onTap: () {
                                      //  contactsBloc.add(DeleteContact(fromUserId: widget.userId,toUserId: state.response.data[index].fKReceiverUserID,id: state.response.data[index].id));
                                      // setState(() {
                                      //   contactList
                                      //       .remove(state.response.data[index]);
                                      // });
                                      // Scaffold.of(context).showSnackBar(SnackBar(
                                      //   content: Text(
                                      //       StringLocalization.of(context)
                                      //           .getText(StringLocalization
                                      //           .contactDeleted)),
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
                                  margin: EdgeInsets.only(
                                      left: 13, right: 13, top: 16),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                          : AppColor.backgroundColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? HexColor.fromHex('#D1D9E6')
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
                                              : HexColor.fromHex('#9F2DBC')
                                                  .withOpacity(0.15),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          offset: Offset(4, 4),
                                        ),
                                      ]),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Center(
                                        child: Text(
                                          '${chatList[index].firstName![0].toUpperCase()}${chatList[index].lastName![0].toUpperCase()}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.black
                                                  : HexColor.fromHex(
                                                      '#EEF1F1')),
                                        ),
                                      ),
                                      radius: 21,
                                      backgroundColor:
                                          HexColor.fromHex('#9F2DBC'),
                                    ),
                                    title: Text(
                                        '${chatList[index].firstName} ${chatList[index].lastName}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white.withOpacity(0.87)
                                              : HexColor.fromHex('#384341'),
                                        )),
                                    subtitle: Text('',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white.withOpacity(0.87)
                                              : HexColor.fromHex('#384341'),
                                        )),
                                    trailing: Text('',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white.withOpacity(0.87)
                                              : HexColor.fromHex('#384341'),
                                        )),
                                  ),
                                ),
                              ));
                        }
                      },
                    ),
                  );
                }
                if (state is DatabaseLoadedState) {
                  chatList = state.dataModel.data!;
                  if (chatList.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                        value: chatBloc,
                                        child: UserChatPage(
                                          toUserId: chatList[index].userID,
                                          fromUserId: widget.userID,
                                          chatUserData: chatList[index],
                                        ),
                                      )));
                            },
                            child: Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  color: HexColor.fromHex('#FF6259'),
                                  onTap: () {
                                    //  contactsBloc.add(DeleteContact(fromUserId: widget.userId,toUserId: state.response.data[index].fKReceiverUserID,id: state.response.data[index].id));
                                    // setState(() {
                                    //   contactList
                                    //       .remove(state.response.data[index]);
                                    // });
                                    // Scaffold.of(context).showSnackBar(SnackBar(
                                    //   content: Text(
                                    //       StringLocalization.of(context)
                                    //           .getText(StringLocalization
                                    //           .contactDeleted)),
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
                                margin: EdgeInsets.only(
                                    left: 13, right: 13, top: 16),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#111B1A')
                                        : AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? HexColor.fromHex('#D1D9E6')
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
                                            : HexColor.fromHex('#9F2DBC')
                                                .withOpacity(0.15),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: Offset(4, 4),
                                      ),
                                    ]),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Center(
                                      child: Text(
                                        '${chatList[index].firstName![0].toUpperCase()}${chatList[index].lastName![0].toUpperCase()}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors.black
                                                : HexColor.fromHex('#EEF1F1')),
                                      ),
                                    ),
                                    radius: 21,
                                    backgroundColor:
                                        HexColor.fromHex('#9F2DBC'),
                                  ),
                                  title: Text(
                                      '${chatList[index].firstName} ${chatList[index].lastName}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex('#384341'),
                                      )),
                                  subtitle: Text('',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex('#384341'),
                                      )),
                                  trailing: Text('',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex('#384341'),
                                      )),
                                ),
                              ),
                            ));
                      },
                    ),
                  );
                }
                if (state is ChatErrorState) {
                  // Scaffold.of(context).showSnackBar(
                  //     SnackBar(content: Text('Something went Wrong')));

                  // CustomSnackBar.buildSnackbar(
                  //     context, 'Something went Wrong', 3);
                }
                if (state is ChatSearchSuccessState) {
                  searchList = state.searchData;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: searchList.length,
                      itemBuilder: (context, index) {
                        if (widget.userID == searchList[index].userID) {
                          return Container();
                        } else {
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                          value: chatBloc,
                                          child: UserChatPage(
                                            toUserId: searchList[index].userID,
                                            fromUserId: widget.userID,
                                            chatUserData: searchList[index],
                                          ),
                                        )));
                              },
                              child: Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    color: HexColor.fromHex('#FF6259'),
                                    onTap: () {
                                      //  contactsBloc.add(DeleteContact(fromUserId: widget.userId,toUserId: state.response.data[index].fKReceiverUserID,id: state.response.data[index].id));
                                      // setState(() {
                                      //   contactList
                                      //       .remove(state.response.data[index]);
                                      // });
                                      // Scaffold.of(context).showSnackBar(SnackBar(
                                      //   content: Text(
                                      //       StringLocalization.of(context)
                                      //           .getText(StringLocalization
                                      //           .contactDeleted)),
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
                                    margin: EdgeInsets.only(
                                        left: 13, right: 13, top: 16),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? HexColor.fromHex('#111B1A')
                                            : AppColor.backgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? HexColor.fromHex('#D1D9E6')
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
                                                : HexColor.fromHex('#9F2DBC')
                                                    .withOpacity(0.15),
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                            offset: Offset(4, 4),
                                          ),
                                        ]),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: Center(
                                          child: Text(
                                            // "${searchList[index].firstName} ${searchList[index].lastName}",
                                            '${searchList[index].firstName![0].toUpperCase()}${searchList[index].lastName![0].toUpperCase()}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.black
                                                    : HexColor.fromHex(
                                                        '#EEF1F1')),
                                          ),
                                        ),
                                        radius: 21,
                                        backgroundColor:
                                            HexColor.fromHex('#9F2DBC'),
                                      ),
                                      title: Text(
                                          '${searchList[index].firstName} ${searchList[index].lastName}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors.white.withOpacity(0.87)
                                                : HexColor.fromHex('#384341'),
                                          )),
                                      subtitle: Text('',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors.white.withOpacity(0.87)
                                                : HexColor.fromHex('#384341'),
                                          )),
                                      trailing: Text('',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors.white.withOpacity(0.87)
                                                : HexColor.fromHex('#384341'),
                                          )),
                                    )),
                              ));
                        }
                      },
                    ),
                  );
                }
                if (state is ChatSearchEmptyState) {
                  return Center(
                    child: Text('No Result Found'),
                  );
                }
                if (state is ChatLoading) {
                  return CircularProgressIndicator();
                }

                return Center(
                  child: Text(state.toString()),
                );
              }),
        ],
      ),
      // ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {},
//        child: Icon(
//          Icons.add,
//        ),
//        backgroundColor: AppColor.primaryColor,
//      ),
    );
  }
}
