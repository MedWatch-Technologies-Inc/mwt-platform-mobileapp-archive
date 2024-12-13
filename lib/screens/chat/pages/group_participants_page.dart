import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_bloc.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_event.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_state.dart';
import 'package:health_gauge/screens/chat/models/list_of_group_participants.dart';
import 'package:health_gauge/screens/chat/pages/add_group_participants_page.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable_action_pane.dart';
import 'package:health_gauge/utils/slider/src/widgets/slide_action.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/loading_indicator_overlay.dart';

class GroupParticipantsPage extends StatefulWidget {
  final String? groupMaskedName;
  GroupParticipantsPage(this.groupMaskedName);
  @override
  _GroupParticipantsPageState createState() => _GroupParticipantsPageState();
}

class _GroupParticipantsPageState extends State<GroupParticipantsPage> {
  List<String> searchList = [];
  late ChatBloc chatBloc;
  List<GroupParticipantsData> groupParticipantsList = [];
  String searchString = '';
  late TextEditingController textEditingController;
  late OverlayEntry entry;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc
        .add(FetchGroupParticipantsEvent(groupName: widget.groupMaskedName));
  }

  @override
  void dispose() {
    super.dispose();
    // chatBloc.add(DisposeEvent());
    // chatBloc.close();
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
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  // chatList = [];
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
              centerTitle: true,
              title: Text(
                'Participants',
                // widget.groupName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: HexColor.fromHex('62CBC9'),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                BlocBuilder(
                    bloc: chatBloc,
                    buildWhen: (previousState, curState) {
                      return curState is FetchGroupParticipantsSuccessState;
                    },
                    builder: (context, state) {
                      if (state is FetchGroupParticipantsSuccessState) {
                        return IconButton(
                          icon: Image.asset(
                            Theme.of(context).brightness == Brightness.dark
                                ? 'asset/dark_addContact.png'
                                : 'asset/addContact.png',
                            height: 32,
                            width: 32,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: chatBloc,
                                  child: AddGroupParticipantPage(
                                    groupMaskedName: widget.groupMaskedName,
                                    groupParticipantsList:
                                        groupParticipantsList,
                                  ),
                                ),
                              ),
                            ).then((val) {
                              chatBloc.add(FetchGroupParticipantsEvent(
                                  groupName: widget.groupMaskedName));
                            });
                          },
                        );
                      }
                      return Container();
                    }),
              ],
            ),
          )),
      body: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : AppColor.backgroundColor,
        child: Column(
          children: [
            //todo Search Participant
            // CustomSearchWidget(
            //   textEditingController: textEditingController,
            //   onChanged: (value) {
            //     searchList = [];
            //     print('****************');
            //     print(value);
            //     print('****************');
            //     searchString = value;
            //     // searchQuery();
            //     // setState(() {});
            //     chatBloc.add(
            //         SearchGroupList(query: searchString, userData: groupParticipantsList));
            //   },
            // ),
            BlocConsumer(
              bloc: BlocProvider.of<ChatBloc>(context),
              listener: (context, state) {
                if (state is RemoveGroupParticipantSuccessState) {
                  groupParticipantsList.removeAt(state.index!);
                  // Constants.progressDialog(false, context);
                  if (entry != null) {
                    entry.remove();
                  }
                  CustomSnackBar.buildSnackbar(
                      context, 'Successfully Removed Participant', 3);
                } else if (state is RemoveGroupParticipantErrorState ||
                    state is RemoveGroupParticipantFailureState) {
                  // Constants.progressDialog(false, context);
                  if (entry != null) {
                    entry.remove();
                  }
                  CustomSnackBar.buildSnackbar(
                      context, 'Something went Wrong', 3);
                } else if (state is RemoveGroupParticipantLoadingState) {
                  // Constants.progressDialog(true, context);
                  entry = showOverlay(context);
                }
              },
              buildWhen: (previousState, curState) {
                return curState is FetchGroupParticipantsLoadingState ||
                    curState is FetchGroupParticipantsSuccessState ||
                    curState is FetchGroupParticipantsErrorState ||
                    // curState is RemoveGroupParticipantLoadingState ||
                    curState is RemoveGroupParticipantSuccessState;
              },
              builder: (context, state) {
                if (state is FetchGroupParticipantsSuccessState) {
                  groupParticipantsList = state.dataModel.data;
                  if (groupParticipantsList != null &&
                      groupParticipantsList.isEmpty) {
                    return Center(child: Text('No Participant'));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: groupParticipantsList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => ));
                          },
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                color: HexColor.fromHex('#FF6259'),
                                onTap: () {
                                  chatBloc.add(RemoveGroupParticipantEvent(
                                      memberIds:
                                          '${groupParticipantsList[index].userID}',
                                      groupName: widget.groupMaskedName,
                                      index: index));
                                },
                                height: 70,
                                topMargin: 16,
                                iconWidget: Text(
                                  StringLocalization.of(context)
                                      .getText(StringLocalization.remove),
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
                                alignment: Alignment.center,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Center(
                                      child: Text(
                                        // groupParticipantsList[index]
                                        //     .firstName[0]
                                        //     .toUpperCase(),
                                        '${groupParticipantsList[index].firstName![0].toUpperCase()}' +
                                            '${groupParticipantsList[index].lastName![0].toUpperCase()}',
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
                                    '${'${groupParticipantsList[index].firstName}'} ${'${groupParticipantsList[index].lastName} '}',
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
                } else if (state is FetchGroupParticipantsErrorState) {
                  print(state.exception);
                  return Expanded(
                    child: Center(
                      child: Text('Something Went Wrong!'),
                    ),
                  );
                } else if (state is RemoveGroupParticipantSuccessState) {
                  if (groupParticipantsList != null &&
                      groupParticipantsList.isEmpty) {
                    return Center(child: Text('No Participant'));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: groupParticipantsList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => ));
                          },
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                color: HexColor.fromHex('#FF6259'),
                                onTap: () {
                                  chatBloc.add(RemoveGroupParticipantEvent(
                                      memberIds:
                                          '${groupParticipantsList[index].userID}',
                                      groupName: widget.groupMaskedName,
                                      index: index));
                                },
                                height: 70,
                                topMargin: 16,
                                iconWidget: Text(
                                  StringLocalization.of(context)
                                      .getText(StringLocalization.remove),
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
                                alignment: Alignment.center,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Center(
                                      child: Text(
                                        // groupParticipantsList[index]
                                        //     .firstName[0]
                                        //     .toUpperCase(),
                                        '${groupParticipantsList[index].firstName![0].toUpperCase()}' +
                                            '${groupParticipantsList[index].lastName![0].toUpperCase()}',
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
                                    '${'${groupParticipantsList[index].firstName}'} ${'${groupParticipantsList[index].lastName} '}',
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

                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
