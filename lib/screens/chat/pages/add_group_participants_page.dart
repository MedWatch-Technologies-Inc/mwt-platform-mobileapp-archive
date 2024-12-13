import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:http/http.dart'as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_bloc.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_event.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_state.dart';
import 'package:health_gauge/screens/chat/models/list_of_group_participants.dart';
import 'package:health_gauge/screens/inbox/contacts_bloc.dart';
import 'package:health_gauge/screens/inbox/inbox_events.dart';
import 'package:health_gauge/screens/inbox/inbox_states.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_search_widget.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';

class AddGroupParticipantPage extends StatefulWidget {
  late final List<GroupParticipantsData> groupParticipantsList;
  final String? groupMaskedName;

  AddGroupParticipantPage({
    required this.groupParticipantsList,
    required this.groupMaskedName,
  });

  @override
  _AddGroupParticipantPageState createState() =>
      _AddGroupParticipantPageState();
}

class _AddGroupParticipantPageState extends State<AddGroupParticipantPage> {
  late ChatBloc chatBloc;
  ContactsBloc? contactsBloc;
  bool memberLengthZero = false;

  FocusNode groupNameFocusNode = FocusNode();
  bool openKeyboard = false;
  List<UserData>? contactList = [];
  List<UserData>? searchList = [];
  Set<int>? userIds = {};
  String? selectedMembers = '';
  late OverlayEntry entry;
  TextEditingController textEditingController = TextEditingController();

  Future<void> createGroup() async {
    selectMemberId();

    var usersId = selectedMembers;
    print('Member Ids $usersId');

    if (memberLengthZero) {
      var dialog = CustomInfoDialog(
        title: 'Error',
        subTitle: 'Select atleast one participant',
        maxLine: 2,
        primaryButton:
            stringLocalization.getText(StringLocalization.ok).toUpperCase(),
        onClickYes: () {
          if (Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        },
      );
      showDialog(
          context: context,
          useRootNavigator: true,
          builder: (context) => dialog,
          barrierDismissible: false);
    } else {
      entry = showOverlay(context);

      chatBloc.add(AddGroupParticipantEvent(
          groupName: widget.groupMaskedName, memberIds: usersId));
    }
  }

  void selectMemberId() {
    late var memberId = <String>[];
   var contacts= contactList!.where((element) => element.isSelected).toList().map((e) => e.id!).toList();

    selectedMembers = contacts.join(',');
    if (memberId.isEmpty) {
      memberLengthZero = true;
    } else {
      memberLengthZero = false;
    }
  }

  bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    contactsBloc = BlocProvider.of<ContactsBloc>(context);
    contactsBloc!.add(LoadContactList(userId: int.parse(globalUser!.userId!)));
    super.initState();
  }

  ///this method is used to show circular loading screen
  OverlayEntry showOverlay(BuildContext context) {
    var overlayState = Overlay.of(context);
    var overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(child: CircularProgressIndicator()),
          color: Colors.black26,
        ),
      ),
    );
    overlayState?.insert(overlayEntry);
    return overlayEntry;
  }

  void removeParticipants(List<UserData>? list) {
    Set<int>? participantIds = {};
    for (var val in widget.groupParticipantsList) {
      participantIds.add(val.userID);
    }
    for (var i = 0; i < list!.length; ++i) {
      if (participantIds.contains(list[i].fKReceiverUserID)) {
        list.removeAt(i);
        --i;
      }
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
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
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
            title: Text(
              'Add Participant',
              style: TextStyle(
                  color: HexColor.fromHex('62CBC9'),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is AddGroupParticipantFailureState) {
            entry.remove();
            var dialog = CustomInfoDialog(
              title: 'Adding participation failed',
              // subTitle: 'Group creation failed',
              maxLine: 2,
              primaryButton: stringLocalization
                  .getText(StringLocalization.ok)
                  .toUpperCase(),
              onClickYes: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
            );
            showDialog(
                context: context,
                useRootNavigator: true,
                builder: (context) => dialog,
                barrierDismissible: false);
            // CustomSnackBar.buildSnackbar(context, , 3);
          } else if (state is AddGroupParticipantErrorState) {
            CustomSnackBar.buildSnackbar(
                context, 'Error Adding Participant', 3);
            entry.remove();
          } else if (state is AddGroupParticipantSuccessState) {
            entry.remove();
            //todo pass memberList
            if (Navigator.canPop(context)) {
              Navigator.pop(context, true);
            } //true when participant added successfully
            // CustomSnackBar.buildSnackbar(context, state.dataModel.message, 3);
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: isDarkMode(context)
              ? AppColor.darkBackgroundColor
              : AppColor.backgroundColor,
          child: Column(
            children: [
              CustomSearchWidget(
                textEditingController: textEditingController,
                fontSize: 14,
                onChanged: (value) {
                  print('****************');
                  print(value);
                  print('****************');
                  contactsBloc?.add(SearchContactListEvents(
                      userData: contactList, query: value));
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              contactsList(),
              button()
            ],
          ),
        ),
      ),
    );
  }

  Widget contactsList() {
    return BlocBuilder<ContactsBloc, InboxState>(builder: (context, state) {
      if (state is LoadedContactList) {
        if (state.response.data!.isNotEmpty) {
          contactList = state.response.data;
          removeParticipants(contactList);
          contactList?.sort((a, b) => a.firstName!.compareTo(b.firstName!));
          return Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, index) {
                return CheckboxListTile(
                  selected: contactList![index].isSelected,
                  value: contactList![index].isSelected,
                  onChanged: (val) {
                    setState(() {
                      contactList![index].isSelected = val!;
                    });
                  },
                  title: Text(
                    '${contactList![index].firstName} ${contactList![index].lastName}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  secondary: CircleAvatar(
                    child: CachedNetworkImage(
                      imageUrl: contactList![index].picture!,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50.0,
                        height: 50.0,
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
                );
              },
              itemCount: contactList!.length,
            ),
          );
        } else {
          return Expanded(
            child: Center(
              child: Text(
                StringLocalization.of(context)
                    .getText(StringLocalization.noContactFound),
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          );
        }
      } else if (state is SearchApiErrorState) {
        return Expanded(
          child: Center(
            child: Text('Something went wrong!'),
          ),
        );
      } else if (state is ContactSearchSuccessState) {
        if (state.searchData.isNotEmpty) {
          searchList = state.searchData;
          return Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, index) {
                return CheckboxListTile(
                  selected: searchList![index].isSelected,
                  value: searchList![index].isSelected,
                  onChanged: (val) {
                    setState(() {
                      searchList![index].isSelected = val!;
                    });
                  },
                  title: Text(
                    '${searchList![index].firstName} ${searchList![index].lastName}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  secondary: CircleAvatar(
                    child: CachedNetworkImage(
                      imageUrl: searchList![index].picture!,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50.0,
                        height: 50.0,
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
                );
              },
              itemCount: searchList?.length,
            ),
          );
        } else {
          return Expanded(
            child: Center(
              child: Text(
                StringLocalization.of(context)
                    .getText(StringLocalization.noContactFound),
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          );
        }
      } else if (state is ContactSearchEmptyState) {
        return Expanded(
          child: Center(
            child: Text('No Result Found'),
          ),
        );
      }
      return Container();
    });
  }

  Widget button() {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h, top: 5.h),
          width: 150.w,
          height: 34.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.h),
              color: HexColor.fromHex('#00AFAA'),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : Colors.white,
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
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
                  borderRadius: BorderRadius.circular(30.h),
                ),
                depression: 10,
                colors: [
                  Colors.white,
                  HexColor.fromHex('#D1D9E6'),
                ]),
            child: Center(
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#111B1A')
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
        onTap: (){
          createGroup();
        });
  }
}
