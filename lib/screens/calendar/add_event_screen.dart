import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:health_gauge/models/calendar_models/cal_db_model.dart';
import 'package:health_gauge/models/calendar_models/calendar_add_event_model.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart'
    as userContact;
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/screens/home/home_screeen.dart';
import 'package:health_gauge/screens/inbox/compose_bloc.dart';
import 'package:health_gauge/screens/inbox/inbox_events.dart';
import 'package:health_gauge/screens/inbox/inbox_states.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/time_picker.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import '../../main.dart';

class AddEventScreen extends StatefulWidget {
  final DateTime date;
  final Function sendEvent;
  final int userID;

  AddEventScreen({required this.date, required this.userID, required this.sendEvent});

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEventScreen> {
  late DateTime _selectedFromDate;
  late DateTime _selectedToDate;
  late TimeOfDay _selectedFromTime;
  late TimeOfDay _selectedToTime;
  userContact.UserListModel? userList;
  bool isToCompressed = false;
  late List<userContact.UserData> toContactData;
  ComposeBloc? composeBloc;
  late TextEditingController composeMailToController;
  bool isToExpanded = false;
  late FocusNode toFocusnode;
  var datePicker = Date();
  var timePicker = Time();
  final dbHelper = DatabaseHelper.instance; //Database initialzation

  TextEditingController? addInfoController;

  @override
  void initState() {
    super.initState();
    _selectedFromDate = widget.date;
    _selectedFromTime = TimeOfDay.now();
    _selectedToDate = widget.date;
    _selectedToTime = TimeOfDay.now();
    addInfoController = TextEditingController();
    toContactData = [];
    composeMailToController = TextEditingController();
    toFocusnode = FocusNode();
    toFocusnode.addListener(onToFocusChange);
  }

  void onToFocusChange() {
    if (toFocusnode.hasFocus) {
      setState(() {
        isToCompressed = true;
      });
    } else {
      setState(() {
        /*isToCompressed = false;*/
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    addInfoController?.dispose();
  }

  void _selectFromDate() {
    datePicker.calendarSelectDate(context, _selectedFromDate).then((value) {
      if (value != null)
        setState(() {
          _selectedFromDate = value;
          if(_selectedToDate.isBefore(_selectedFromDate)){
            _selectedToDate = _selectedFromDate;
          }
        });
    });
  }

  void _selectToDate() {
    datePicker.calendarSelectDate(context, _selectedToDate).then((value) {
      if (value != null)
        setState(() {
          _selectedToDate = value;
          if(_selectedToDate.isBefore(_selectedFromDate)){
            _selectedFromDate = _selectedToDate;
          }
        });
    });
  }

  void _selectFromTime() {
    timePicker.selectTime(context, _selectedFromTime).then((value) {
      if (value != null)
        setState(() {
          _selectedFromTime = value;
        });
    });
  }

  void _selectToTime() {
    timePicker.selectTime(context, _selectedToTime).then((value) {
      if (value != null)
        setState(() {
          _selectedToTime = value;
        });
    });
  }

  String emailString(List<userContact.UserData> list) {
    String email = '';
    for (var v in list) {
      if (v.email != list.last.email)
        email += '${v.email},';
      else
        email += '${v.email}';
    }
    return email;
  }

  List<userContact.UserData> getSearchedList(String pattern) {
    List<userContact.UserData> list = [];
    List<String> elements = pattern.split(',');
    if (pattern.length > 0) {
      if(userList != null && userList!.data != null) {
        for (var v in userList!.data!) {
          if (v.firstName!.toUpperCase().contains(elements[elements.length - 1].toUpperCase()) ||
              v.lastName!.toUpperCase()
                  .contains(elements[elements.length - 1].toUpperCase()) ||
              '${v.firstName!.toUpperCase()} ${v.lastName!.toUpperCase()}'
                  .contains(elements[elements.length - 1].toUpperCase()))
            list.add(v);
        }
      }
    }
    return list;
  }

  void insertToFromEmail(
      String emailId, List<userContact.UserData> ContactData) async {
    if (userList == null) {
      dbHelper.database;
      var dbResult = await dbHelper.getContactsList(widget.userID);
      userList = UserListModel(data: dbResult, response: 200, result: true);
    }
    if (emailId != null) {
      List<String> elements = emailId.split(',');
      if(userList != null && userList!.data != null) {
        for (var v in userList!.data!) {
          for (int i = 0; i < elements.length; i++) {
            if (elements[i] == v.email) {
              setState(() {
                ContactData.add(v);
              });

              break;
            }
          }
        }
      }
    }
  }

  Widget suggestionTextField({
    String? hint,
    required TextInputType keyboardType,
    required int maxLines,
    TextEditingController? controller,
    required double padding,
    List<userContact.UserData>? dataList,
    FocusNode? node,
  }) {
    return TypeAheadField(
      hideOnEmpty: true,
      hideOnError: true,
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        focusNode: node,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: padding),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: StringLocalization.of(context)
                .getText(StringLocalization.searchContact),
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: AppColor.graydark,
            )),
      ),
      suggestionsCallback: (pattern) {
        if (userList == null) {
          composeBloc?.add(LoadContactList(userId: widget.userID));
        }
        return getSearchedList(pattern);
      },
      itemBuilder: (context,userContact.UserData element) {
        return ListTile(
          leading: element.picture != null ? CircleAvatar(
            backgroundImage: NetworkImage(element.picture!),
          ) : Container(),
          title: Text('${element.firstName} ${element.lastName}'),
        );
      },
      onSuggestionSelected: (userContact.UserData element) {
        setState(() {
          dataList?.add(element);
        });

        controller?.clear();
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    composeBloc = BlocProvider.of<ComposeBloc>(context);
    composeBloc?.add(LoadContactList(userId: widget.userID));
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
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
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              elevation: 0,
              title: Text(stringLocalization.getText(
                  StringLocalization.addAnEvent),style: TextStyle(
                  fontSize: 18,
                  color: HexColor.fromHex('62CBC9'),
                  fontWeight: FontWeight.bold)),
              leading: IconButton(
                padding: EdgeInsets.only(left: 10.w),
                onPressed: () {
                  if(Navigator.canPop(context)) {
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
              actions: [
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      if(addInfoController != null && addInfoController!.text == ''){
                        CustomSnackBar.buildSnackbar(
                            context, 'Add Event Title', 3);
                      }else{
                        widget.sendEvent(AddEventModel(
                            userID: widget.userID,
                            eventName: addInfoController!.text,
                            startDate: datePicker.dateToString(_selectedFromDate),
                            endDate: datePicker.dateToString(_selectedToDate),
                            timeZone: 'eventData.timeZone',
                            startTime:
                            '${_selectedFromTime.hour}:${_selectedFromTime.minute}',
                            endTime:
                            '${_selectedToTime.hour}:${_selectedToTime.minute}',
                            eventTagUserID: 0,
                            setReminderID: 0));
                        if(Navigator.canPop(context)){
                          Navigator.pop(context);
                        }
                      }


                    })
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocListener(
              bloc: composeBloc,
              listener: (BuildContext context, InboxState state) {
                if (state is LoadedContactList) {
                  userList = state.response;
                }
              },
              child: Container(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
              child: TextField(
                style: TextStyle(fontSize: 18),
                controller: addInfoController,
                decoration: InputDecoration(
                  hintText: 'Add Information',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(bottom: 10.h, top: 10.h, left: 20.w, right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.watch_later),
                  SizedBox(
                    width: 10.w,
                  ),
                  TitleText(text: stringLocalization.getText(
                        StringLocalization.from), fontSize: 18,),
                  SizedBox(
                    width: 10.w,
                  ),
                  GestureDetector(
                    onTap: _selectFromDate,
                    child: Row(children: [
                      TitleText(text: datePicker.dateToString(_selectedFromDate),
                          fontSize: 18),
                      Icon(Icons.keyboard_arrow_down),
                    ]),
                  ),
                  GestureDetector(
                    onTap: _selectFromTime,
                    child: Row(children: [
                      TitleText(
                          text: '${_selectedFromTime.hour}:${_selectedFromTime.minute}',
                          fontSize: 18,),
                      Icon(Icons.keyboard_arrow_down),
                    ]),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(bottom: 10.h, top: 10.h, left: 20.w, right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.watch_later),
                  SizedBox(
                    width: 10.w,
                  ),
                  TitleText(text: stringLocalization.getText(
                      StringLocalization.to),fontSize: 18),
                  SizedBox(
                    width: 10.w,
                  ),
                  GestureDetector(
                    onTap: _selectToDate,
                    child: Row(
                      children: <Widget>[
                        TitleText(text: datePicker.dateToString(_selectedToDate),
                            fontSize: 18),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _selectToTime,
                    child: Row(
                      children: <Widget>[
                        TitleText(
                            text: '${_selectedToTime.hour}:${_selectedToTime.minute}',
                            fontSize: 18),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(bottom: 10.h, top: 10.h, left: 20.w, right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.people),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Wrap(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: isToCompressed && toContactData.length > 2
                                ? Wrap(
                                    children: <Widget>[
                                      Container(
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                              color: AppColor.graydark),
                                          color: AppColor.white,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      toContactData[0].picture!),
                                              radius: 15,
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text(
                                                '${toContactData[0].firstName} ${toContactData[0].lastName}',
                                                style: TextStyle(fontSize: 18)),
                                            IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                size: 12,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  toContactData
                                                      .remove(toContactData[0]);
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                color: AppColor.graydark),
                                            color: AppColor.white),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      toContactData[1].picture!),
                                              radius: 15,
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text(
                                                '${toContactData[1].firstName} ${toContactData[1].lastName}',
                                                style: TextStyle(fontSize: 18)),
                                            IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                size: 12,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  toContactData
                                                      .remove(toContactData[1]);
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: AppColor.green,
                                        child: GestureDetector(
                                          child: Text(
                                            '+${toContactData.length - 2}',
                                            style: TextStyle(
                                                color: AppColor.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              isToCompressed = false;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Wrap(
                                    alignment: WrapAlignment.start,
                                    direction: Axis.horizontal,
                                    children: toContactData.map((item) {
                                      return Container(
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                color: AppColor.graydark),
                                            color: AppColor.white),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      item.picture!),
                                              radius: 15,
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text(
                                                '${item.firstName} ${item.lastName}',
                                                style: TextStyle(fontSize: 18)),
                                            IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                size: 12,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  toContactData.remove(item);
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: suggestionTextField(
                                  keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    controller: composeMailToController,
                                    padding: 15,
                                    dataList: toContactData),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
