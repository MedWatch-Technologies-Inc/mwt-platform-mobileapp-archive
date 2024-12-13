import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/screens/inbox/contacts_bloc.dart';
import 'package:health_gauge/screens/inbox/inbox_events.dart';
import 'package:health_gauge/screens/inbox/inbox_states.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_search_widget.dart';

class AddInvitees extends StatefulWidget {
  @override
  _AddInviteesState createState() => _AddInviteesState();
}

class _AddInviteesState extends State<AddInvitees> {
  ContactsBloc? contactsBloc;
  bool isSearchOpen = false;
  TextEditingController textEditingController = TextEditingController();
  String searchString = '';
  GetInvitationListBloc? getInvitationListBloc;
  List<int> selectdContacts = [];
  List<String> selectedContactsName = [];
  late int userId;
  bool isContactSelected = false;
  Map<int, String> mappedInvitee = {};

  @override
  void initState() {
    userId = globalUser != null && globalUser!.userId != null
        ? int.parse(globalUser!.userId!)
        : 0;
    super.initState();
  }

  void contactsToMap() {
    if (selectdContacts != null) {
      for (int i = 0; i < selectedContactsName.length; i++) {
        mappedInvitee[selectdContacts[i]] = selectedContactsName[i];
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contactsBloc = BlocProvider.of<ContactsBloc>(context);

    contactsBloc?.add(LoadContactList(userId: userId));
  }

  List<UserData> contactList = [];
  List<UserData> searchList = [];

  searchQuery() {
    for (var v in contactList) {
      if(v.firstName != null && v.lastName != null) {
        if (v.firstName!.toUpperCase().contains(searchString.toUpperCase()) ||
            v.lastName!.toUpperCase().contains(searchString.toUpperCase()) ||
            '${v.firstName!.toUpperCase()} ${v.lastName!.toUpperCase()}'
                .contains(searchString.toUpperCase())) {
          searchList.add(v);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Inside Contact');
    return Padding(
      padding: EdgeInsets.only(top: 50.h),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.h),
                topRight: Radius.circular(20.h))),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // height: 50.h,

                  child: CustomSearchWidget(
                    isDense: true,
                    hintText: 'Add Invitees',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    // prefixIcon: Image.asset(
                    //   'asset/search_icon.png',
                    //   width: 33.h,
                    //   height: 33.h,
                    // ),
                    textEditingController: textEditingController,
                    onChanged: (String? value) {
                      isSearchOpen = true;
                      searchList = [];
                      if(value != null) {
                        searchString = value;
                        contactsBloc?.add(SearchContactListEvents(
                          query: searchString,
                          userData: contactList,
                        ));
                        if (mounted) {
                          setState(() {});
                        }
                      }
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (contactList != null) {
                      contactsToMap();
                    }
                    if (contactList != null) {
                      Navigator.of(context).pop(mappedInvitee);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 13.w),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: HexColor.fromHex('#00AFAA'),
                      ),
                    ),
                  ),
                )
              ],
            ),
            BlocBuilder<ContactsBloc, InboxState>(builder: (context, state) {
              if (state is LoadedContactList) {
                if (state.response.data != null && state.response.data!.isNotEmpty) {
                  contactList = state.response.data!;
                  contactList.sort((a, b) {
                    if(a.firstName != null && b.firstName != null) return a.firstName!.compareTo(b.firstName!);
                    return 0;
                  });
                  return Expanded(
                      child: ListView.builder(
                    itemCount: contactList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                              if (selectdContacts.contains(contactList[index].fKReceiverUserID)) {
                                selectdContacts.remove(contactList[index].fKReceiverUserID);
                                selectedContactsName.remove('${contactList[index].firstName} ${contactList[index].lastName}');
                              } else {
                                selectdContacts.add(contactList[index].fKReceiverUserID ?? 0);
                                selectedContactsName.add('${contactList[index].firstName} ${contactList[index].lastName}');
                              }
                              setState(() {});
                          },
                          child: Container(
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex('#111B1A')
                                  : AppColor.backgroundColor,
                              // borderRadius: BorderRadius.circular(10),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Theme.of(context).brightness ==
                              //             Brightness.dark
                              //         ? HexColor.fromHex('#D1D9E6')
                              //             .withOpacity(0.1)
                              //         : Colors.white,
                              //     blurRadius: 4,
                              //     spreadRadius: 0,
                              //     offset: Offset(-4, -4),
                              //   ),
                              //   BoxShadow(
                              //     color: Theme.of(context).brightness ==
                              //             Brightness.dark
                              //         ? Colors.black.withOpacity(0.75)
                              //         : HexColor.fromHex('#9F2DBC')
                              //             .withOpacity(0.15),
                              //     blurRadius: 4,
                              //     spreadRadius: 0,
                              //     offset: Offset(4, 4),
                              //   ),
                              // ]
                            ),
                            child: Container(
                              // margin: EdgeInsets.only(left: 13.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 13.w),
                                        child: CircleAvatar(
                                          child: CachedNetworkImage(
                                            imageUrl: contactList[index].picture ?? '',
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
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16.w,
                                      ),
                                      Text(
                                          '${contactList[index].firstName} ${contactList[index].lastName}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                    .withOpacity(0.87)
                                                : HexColor.fromHex('#384341'),
                                          )),
                                      Spacer(),
                                      selectdContacts.contains(contactList[index].fKReceiverUserID)
                                          ? Image.asset(
                                              'asset/check_icon.png',
                                              width: 37.h,
                                              height: 37.h,
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 16.w,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 9.h,
                                  ),
                                  Divider(
                                    thickness: 1,
                                    height: 1,
                                  )
                                ],
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
                                        ? HexColor.fromHex('#000000')
                                            .withOpacity(0.8)
                                        : HexColor.fromHex('#D1D9E6'),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#D1D9E6')
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
                                          ? HexColor.fromHex('#FFFFFF')
                                              .withOpacity(0.87)
                                          : HexColor.fromHex('#384341')),
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
                                            ? HexColor.fromHex('#FFFFFF')
                                                .withOpacity(0.38)
                                            : HexColor.fromHex('#7F8D8C'),
                                      )),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                            isSearchOpen
                                ? searchList.length
                                : contactList.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              if (selectdContacts.contains(contactList[index].fKReceiverUserID)) {
                                selectdContacts.remove(contactList[index].fKReceiverUserID);
                                selectedContactsName.remove('${contactList[index].firstName} ${contactList[index].lastName}');
                              } else {
                                selectdContacts.add(contactList[index].fKReceiverUserID ?? 0);
                                selectedContactsName.add('${contactList[index].firstName} ${contactList[index].lastName}');
                              }
                              setState(() {});
                            },
                          );
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
                          if (selectdContacts.contains(contactList[index].fKReceiverUserID)) {
                            selectdContacts.remove(contactList[index].fKReceiverUserID);
                            selectedContactsName.remove('${contactList[index].firstName} ${contactList[index].lastName}');
                          } else {
                            selectdContacts.add(contactList[index].fKReceiverUserID ?? 0);
                            selectedContactsName.add('${contactList[index].firstName} ${contactList[index].lastName}');
                          }
                          setState(() {});
                        },
                        child: Container(
                          height: 70,
                          margin: EdgeInsets.only(
                              left: 13.w, right: 13.w, top: 16.h),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#111B1A')
                                    : AppColor.backgroundColor,
                          ),
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: CachedNetworkImage(
                                        imageUrl: searchList[index].picture ?? '',
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
                                          'asset/m_profile_icon.png',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16.w,
                                    ),
                                    Text(
                                      '${searchList[index].firstName} ${searchList[index].lastName}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex('#384341'),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 9.h,
                                ),
                                Divider(
                                  thickness: 1,
                                  height: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              if (state is ContactSearchEmptyState) {
                return Container(
                  child: Center(
                    child: Text('No Result Found'),
                  ),
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
      ),
    );
  }
}
