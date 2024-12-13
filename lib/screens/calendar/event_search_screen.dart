import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

class EventSearchScreen extends StatefulWidget {
  final Map<DateTime, List>? events;

  EventSearchScreen({this.events});
  @override
  _EventSearchScreenState createState() => _EventSearchScreenState();
}

class _EventSearchScreenState extends State<EventSearchScreen> {

  TextEditingController _searchController = TextEditingController();
  List<EventListItems> eventList = [];
  List<EventListItems> searchList = [];

  bool isSearching = false;

  @override
  void initState() {
    getEventList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            height: MediaQuery.of(context).size.height,
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
              centerTitle: true,
              title: Text('Calendar Search',
                  style: TextStyle(
                      color: HexColor.fromHex('#62CBC9'),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold)),
              elevation: 2,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              leading: IconButton(
                padding: EdgeInsets.only(left: 10.w),
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
            ),
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            searchTextField(),
            SizedBox(height: 12.h,),
            isSearching ?
            searchList.length > 0 ?
            Expanded(
              child: ListView.builder(
                  itemCount:  searchList.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      margin: EdgeInsets.only(top: index > 0 ?12.h : 0.0, left: 21.w, right: 13.w, bottom: searchList.length - 1 == index ? 16.h : 0 ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Body1Text(
                                text: DateFormat(DateUtil.MMM).format(
                                  DateTime.parse(
                                      eventList[index].date.toString()),
                                ),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                                color: Theme.of(context).brightness == Brightness.dark ? AppColor.white87 : AppColor.color384341,
                              ),
                              Body1Text(
                                text:
                                                DateFormat(DateUtil.dd).format(
                                              DateTime.parse(searchList[index]
                                                  .date
                                                  .toString()),
                                            ),
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                                color: Theme.of(context).brightness == Brightness.dark ? AppColor.white87 : AppColor.color384341,
                              )
                            ],
                          ),
                          SizedBox(width: 12.w,),
                          Expanded(
                            child: Container(
                              color : HexColor.fromHex('#FF6259').withOpacity(0.2),
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.w, right: 12.w, top: 5.h, bottom: 5.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Body1Text(
                                    text: searchList[index].title!,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                  color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex('#FFDFDE') :  HexColor.fromHex('#CC0A00'),),
                                  Body1Text(
                                    text: '${getTime(searchList[index].startTime!)}-${getTime(searchList[index].endTime!)}',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                    color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex('#FFDFDE') :  HexColor.fromHex('#CC0A00'),),
                                ],
                              ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
              }),
            ) : noEventsFound()
            : eventList.length > 0 ?
            Expanded(
              child: ListView.builder(
                  itemCount: eventList.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      margin: EdgeInsets.only(top: 12.h, left: 21.w, right: 13.w, bottom: eventList.length - 1 == index ? 16.h : 0 ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Body1Text(
                                text:
                                                DateFormat(DateUtil.MMM).format(
                                              DateTime.parse(eventList[index]
                                                  .date
                                                  .toString()),
                                            ),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              Body1Text(
                                text:
                                                DateFormat(DateUtil.dd).format(
                                              DateTime.parse(eventList[index]
                                                  .date
                                                  .toString()),
                                            ),
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,)
                            ],
                          ),
                          SizedBox(width: 12.w,),
                          Expanded(
                            child: Container(
                              color : HexColor.fromHex('#FF6259').withOpacity(0.2),
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.w, right: 12.w, top: 5.h, bottom: 5.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Body1Text(
                                      text: eventList[index].title!,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.sp,
                                      color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex('#FFDFDE') :  HexColor.fromHex('#CC0A00'),),
                                    Body1Text(
                                      text: '${getTime(eventList[index].startTime!)}-${getTime(eventList[index].endTime!)}',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.sp,
                                        color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex('#FFDFDE') :  HexColor.fromHex('#CC0A00')
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            )
                : noEventsFound(),
          ],
        )
      ),
    );
  }

  String getTime(String time){
    if(time.trim().isNotEmpty) {
      int t = int.parse(time.split(':')[0]);
      String min = time.split(':')[1];
      if (t == 12) {
        return '$t:$min PM';
      } else if (t > 12) {
        return '${t - 12}:$min PM';
      }

      return '$t:$min AM';
    }

    return '';
  }

  Widget searchTextField() {
    return Container(
        padding: EdgeInsets.only(top: 17.h, left: 13.w, right: 13.w),
        child: Container(
          height: 50.h,
          decoration: ConcaveDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.h)),
              depression: 7,
              colors: [
                Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#000000').withOpacity(0.8)
                    : HexColor.fromHex('#D1D9E6'),
                Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                    : Colors.white,
              ]),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Center(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                      : HexColor.fromHex('#384341')),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: StringLocalization.of(context)
                      .getText(StringLocalization.search),
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.38)
                        : HexColor.fromHex('#7F8D8C'),
                  )),
              onChanged: (value) {
                isSearching = true;
                getSearchList(value);
                setState(() {});
              },
            ),
          ),
        ));
  }


  Widget noEventsFound() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Center(
        child: Visibility(
          visible: true,
          child: Text(
            StringLocalization.of(context)
                .getText(StringLocalization.noEventsFound),
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  void getSearchList(String query) {
    searchList.clear();
    for (var v in eventList) {
      if (v.title!.toUpperCase().contains(query.toUpperCase())) {
        searchList.add(v);
      }
    }
  }

  getEventList(){
    widget.events!.forEach((key, value) {
      for(int i = 0; i < value.length; i++){
        eventList.add(EventListItems(date: key,
        endTime: value[i]['EndTime'],
        startTime: value[i]['StartTime'],
        title: value[i]['Name']));
      }
    });

    eventList.sort((b, a) {
      int cmp = a.date!.compareTo(b.date!);
      if (cmp != 0) return cmp;
      return Date().convertTimeFromString(a.startTime!).compareTo(Date().convertTimeFromString(b.startTime!));
    });
  }

}

class EventListItems {
  DateTime? date;
  String? startTime;
  String? endTime;
  String? title;

  EventListItems({this.date, this.startTime, this.endTime, this.title});
}
