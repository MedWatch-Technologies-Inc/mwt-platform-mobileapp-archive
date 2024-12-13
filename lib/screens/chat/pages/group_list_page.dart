import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_bloc.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_event.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_state.dart';
import 'package:health_gauge/screens/chat/models/group_list_model.dart';
import 'package:health_gauge/screens/chat/pages/group_chat_page.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable_action_pane.dart';
import 'package:health_gauge/utils/slider/src/widgets/slide_action.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_search_widget.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';

class GroupListPage extends StatefulWidget {
  final int userID;
  GroupListPage(this.userID);
  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  List<Data> searchList = [];
  late ChatBloc chatBloc;
  List<Data> groupList = [];
  String searchString = '';
  late TextEditingController textEditingController;
  bool deleteFlag = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    // chatBloc.add(GroupListingEvent(userId: widget.userID));
  }

  @override
  void dispose() {
    super.dispose();
    // chatBloc.add(DisposeEvent());
    // chatBloc.close();
  }

  void deleteGroup(groupName) {
    groupList.remove(groupName);
    deleteFlag = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      child: Column(
        children: [
          CustomSearchWidget(
            fontSize: 14,
            textEditingController: textEditingController,
            onChanged: (String? value) {
              if (value != null) {
                searchString = value;
                // searchQuery();
                // setState(() {});
                chatBloc.add(
                    SearchGroupList(query: searchString, userData: groupList));
              }
            }
          ),
          BlocConsumer(
            buildWhen: (prevState, curState) {
              return curState is GroupListingSuccessState ||
                  curState is GroupListingErrorState ||
                  curState is GroupChatSearchEmptyState ||
                  curState is GroupChatSearchSuccessState;
            },
            bloc: BlocProvider.of<ChatBloc>(context),
            listener: (context, state) {
              if (state is GroupRemoveSuccessState) {
                CustomSnackBar.buildSnackbar(
                    context, 'Group Removed SuccessFully', 3);
                deleteFlag = false;
              } else if (state is GroupRemoveDoesNotExistState) {
                CustomSnackBar.buildSnackbar(context,
                    'Group  has already been removed. Please refresh', 3);
                deleteFlag = false;
              }
            },
            builder: (context, state) {
              if (state is GroupListingSuccessState) {
                groupList = state.dataModel.data;
                if (groupList != null && groupList.isEmpty) {
                  return Center(child: Text('No Result Found'));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: groupList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                    value: chatBloc,
                                    child: GroupChatPage(
                                      groupMaskedName:
                                          groupList[index].maskedGroupName,
                                      senderUserName: globalUser!.userName,
                                      groupNameReal: groupList[index].groupName,
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
                                chatBloc.add(GroupRemoveEvent(
                                    groupName:
                                        groupList[index].maskedGroupName));
                                deleteGroup(groupList[index].maskedGroupName);
                                chatBloc.add(GroupListingEvent(
                                    userId: int.parse(globalUser!.userId!)));
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
                            child: Container(
                              // color: Colors.green,
                              alignment: Alignment.center,
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Center(
                                    child: Text(
                                      // groupParticipantsList[index]
                                      //     .firstName[0]
                                      //     .toUpperCase(),
                                      '${groupList[index].groupName![0].toUpperCase()}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.black
                                              : HexColor.fromHex('#EEF1F1')),
                                    ),
                                  ),
                                  radius: 21,
                                  backgroundColor: HexColor.fromHex('#9F2DBC'),
                                ),
                                title: Text(
                                  '${groupList[index].groupName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white.withOpacity(0.87)
                                        : HexColor.fromHex('#384341'),
                                  ),
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
              if (state is GroupListingErrorState) {
                return Expanded(
                  child: Center(child: Text('Something went Wrong')),
                );
                // CustomSnackBar.buildSnackbar(
                //     context, 'Something went Wrong', 3);
              }

              if (state is GroupChatSearchSuccessState) {
                searchList = state.searchData;
                return Expanded(
                  child: ListView.builder(
                    itemCount: searchList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                      value: chatBloc,
                                      child: GroupChatPage(
                                        // hubConnection: hubConnection,
                                        groupMaskedName:
                                            searchList[index].maskedGroupName,
                                        senderUserName: globalUser!.userName,
                                        groupNameReal: searchList[index].groupName,
                                        // pageSize: 10,
                                        // pageIndex: 1,
                                        // chatUserData: groupList[index],
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
                              margin:
                                  EdgeInsets.only(left: 13, right: 13, top: 16),
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
                                // leading: Text(''),
                                title: Text('${searchList[index].groupName}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white.withOpacity(0.87)
                                          : HexColor.fromHex('#384341'),
                                    )),
                                // subtitle: Text('',
                                //     style: TextStyle(
                                //       fontSize: 14,
                                //       color: Theme.of(context).brightness ==
                                //               Brightness.dark
                                //           ? Colors.white.withOpacity(0.87)
                                //           : HexColor.fromHex("#384341"),
                                //     )),
                                // trailing: Text('',
                                //     style: TextStyle(
                                //       fontSize: 14,
                                //       color: Theme.of(context).brightness ==
                                //               Brightness.dark
                                //           ? Colors.white.withOpacity(0.87)
                                //           : HexColor.fromHex("#384341"),
                                //     )),
                              ),
                            ),
                          ));
                    },
                  ),
                );
              }
              if (state is GroupChatSearchEmptyState) {
                return Center(
                  child: Text('No Result Found'),
                );
              }

               return CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}
