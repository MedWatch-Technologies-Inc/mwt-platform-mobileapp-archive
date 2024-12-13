import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_bloc.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_event.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_state.dart';
import 'package:health_gauge/screens/inbox/contacts_bloc.dart';
import 'package:health_gauge/screens/inbox/inbox_events.dart';
import 'package:health_gauge/screens/inbox/inbox_states.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:http/http.dart' as http;

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late ChatBloc chatBloc;
  late ContactsBloc contactsBloc;
  TextEditingController groupNameController = TextEditingController();
  TextEditingController usersIdController = TextEditingController();
  bool memberLengthLessThanTwo = false;

  FocusNode groupNameFocusNode = FocusNode();
  bool openKeyboard = false;
  List<UserData> contactList = [];
  Set<int> userIds = {};
  String selectedMembers = '';
  late OverlayEntry entry;

  Future<void> createGroup() async {
    selectMemberId();

    var groupName = groupNameController.text;
    var usersId = selectedMembers;
    print('Member Ids $usersId');

    if (groupName.trim() == '') {
      var dialog = CustomInfoDialog(
        title: 'Error',
        subTitle: "Group name can't be empty",
        maxLine: 2,
        primaryButton: stringLocalization.getText(StringLocalization.ok).toUpperCase(),
        onClickYes: () {
          if (context != null) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        },
      );
      showDialog(
          context: context,
          useRootNavigator: true,
          builder: (context) => dialog,
          barrierDismissible: false);
    } else if (memberLengthLessThanTwo) {
      var dialog = CustomInfoDialog(
        title: 'Error',
        subTitle: 'Members should be more than 2',
        maxLine: 2,
        primaryButton: stringLocalization.getText(StringLocalization.ok).toUpperCase(),
        onClickYes: () {
          if (context != null) {
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
      try {
        var dio = Dio(
          BaseOptions(
            baseUrl: Constants.baseUrl,
            headers: Constants.header,
          ),
        );

        var response = await dio.post(
            '${Constants.baseUrl}${ApiConstants.accessCreateChatGroup}?groupName=${groupName.trim()}&memberIds=$usersId');
        print(response.realUri.toString().replaceAll('/', '||'));

        print(response.statusCode);
        print(response.data);
        entry.remove();
        //todo pass memberList
        if (Navigator.canPop(context)) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        print(e);
        entry.remove();
        //todo pass memberList
        if (Navigator.canPop(context)) {
          Navigator.pop(context, true);
        }
      }
      // chatBloc
      //     .add(CreateGroupEvent(groupName: groupName.trim(), userIds: usersId));
      // CustomSnackBar.buildSnackbar(context, "Group Created Successfully", 3);
      // Navigator.pop(context);

      // BlocConsumer(
      // bloc: BlocProvider.of<ChatBloc>(context),
      // listener: (context, state) {
      //   if (state is CreateGroupAlreadyExistState) {
      //     var dialog = CustomInfoDialog(
      //       title: 'Error',
      //       subTitle: "Group name already exist",
      //       maxLine: 2,
      //       primaryButton: stringLocalization
      //           .getText(StringLocalization.ok)
      //           .toUpperCase(),
      //       onClickYes: () {
      //         if (context != null) {
      //           Navigator.of(context, rootNavigator: true).pop();
      //         }
      //       },
      //     );
      //     showDialog(
      //         context: context,
      //         useRootNavigator: true,
      //         builder: (context) => dialog,
      //         barrierDismissible: false);
      //   }
      //   if (state is CreateGroupSuccessState) {
      // CustomSnackBar.buildSnackbar(
      //     context, "Group Created Successfully", 3);
      // Navigator.pop(context);
      //   }
      // },
      // builder: (context, a) => Container());
    }
  }

  void selectMemberId() {
    var memberId = <String>[];
    var userId = preferences?.getString(Constants.prefUserIdKeyInt);
    for (var index = 0; index < contactList.length; index++) {
      if (contactList[index].isSelected) {
        memberId.add(contactList[index].fKReceiverUserID.toString());
      }
    }
    memberId.add(userId!);
    selectedMembers = memberId.join(',');
    if (memberId.length <= 2) {
      memberLengthLessThanTwo = true;
    } else {
      memberLengthLessThanTwo = false;
    }
  }

  bool isDarkMode(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    contactsBloc = BlocProvider.of<ContactsBloc>(context);
    // contactsBloc.add(LoadContactList(userId: int.parse(globalUser!.userId!)));
    super.initState();
  }

  ///this method is used to show circular loading screen
  OverlayEntry showOverlay(BuildContext context) {
    var overlayState = Overlay.of(context)!;
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
    overlayState.insert(overlayEntry);
    return overlayEntry;
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
            title: Text(
              'Create Group',
              style: TextStyle(
                  color: HexColor.fromHex('62CBC9'), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is CreateGroupAlreadyExistState) {
            if (entry != null) entry.remove();
            var dialog = CustomInfoDialog(
              title: 'Group Already Exists',
              subTitle: state.dataModel.message,
              maxLine: 2,
              primaryButton: stringLocalization.getText(StringLocalization.ok).toUpperCase(),
              onClickYes: () {
                if (context != null) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
            );
            showDialog(
                context: context,
                useRootNavigator: true,
                builder: (context) => dialog,
                barrierDismissible: false);
          } else if (state is CreateGroupErrorState) {
            if (entry != null) entry.remove();
            var dialog = CustomInfoDialog(
              title: 'Group creation failed',
              subTitle: 'Group creation failed',
              maxLine: 2,
              primaryButton: stringLocalization.getText(StringLocalization.ok).toUpperCase(),
              onClickYes: () {
                if (context != null) {
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
          } else if (state is CreateGroupSuccessState) {
            if (entry != null) entry.remove();
            Navigator.pop(context, true); //true when group created successfully
            // CustomSnackBar.buildSnackbar(context, state.dataModel.message, 3);
          }
        },
        // builder:(context, state) {
        //   if(state is ChatLoading){
        //     // entry = showOverlay(context);
        //     return Container();
        //   }
        //   else {
        //   return
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: isDarkMode(context) ? AppColor.darkBackgroundColor : AppColor.backgroundColor,
          child: Column(
            children: [
              groupNameField(),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Add Members',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              contactsList(),
              button()
            ],
          ),
        ),
        // }
        // }
      ),
    );
  }

  Widget contactsList() {
    return BlocBuilder<ContactsBloc, InboxState>(builder: (context, state) {
      if (state is LoadedContactList) {
        if (state.response.data!.isNotEmpty) {
          contactList = state.response.data!;
          contactList.sort((a, b) => a.firstName!.compareTo(b.firstName!));
          return Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, index) {
                return CheckboxListTile(
                  selected: contactList[index].isSelected,
                  value: contactList[index].isSelected,
                  onChanged: (val) {
                    setState(() {
                      contactList[index].isSelected = val!;
                    });
                  },
                  title: Text(
                    '${contactList[index].firstName} ${contactList[index].lastName}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  secondary: CircleAvatar(
                    child: CachedNetworkImage(
                      imageUrl: contactList[index].picture!,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
              itemCount: contactList.length,
            ),
          );
        }
      }
      return Container();
    });
  }

  Widget groupNameField() {
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 17.h),
      decoration: BoxDecoration(
          color: isDarkMode(context) ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(10.h),
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode(context) ? HexColor.fromHex('#D1D9E6').withOpacity(0.1) : Colors.white,
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(-5.w, -5.h),
            ),
            BoxShadow(
              color: isDarkMode(context)
                  ? Colors.black.withOpacity(0.75)
                  : HexColor.fromHex('#D1D9E6'),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(5.w, 5.h),
            ),
          ]),
      child: GestureDetector(
        onTap: () {
          groupNameFocusNode.requestFocus();
          openKeyboard = true;
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          decoration: openKeyboard
              ? ConcaveDecoration(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
                  depression: 7,
                  colors: [
                      isDarkMode(context)
                          ? Colors.black.withOpacity(0.5)
                          : HexColor.fromHex('#D1D9E6'),
                      isDarkMode(context)
                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                          : Colors.white,
                    ])
              : BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.h)),
                  color:
                      isDarkMode(context) ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.group, size: 20.h),
              SizedBox(width: 10.0.w),
              Expanded(
                child: IgnorePointer(
                  ignoring: openKeyboard ? false : true,
                  child: TextFormField(
                    autofocus: openKeyboard,
                    focusNode: groupNameFocusNode,
                    controller: groupNameController,
                    style: TextStyle(fontSize: 16.0),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'Enter Group Name',
                        hintStyle: TextStyle(color: HexColor.fromHex('7F8D8C'))),
                    onFieldSubmitted: (value) {
                      openKeyboard = false;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                'Create',
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
        onTap: createGroup);
  }
}
