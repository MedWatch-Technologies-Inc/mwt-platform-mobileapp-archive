import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:health_gauge/value/app_color.dart';

import 'day_week_month.dart';

enum HTab { day, week, month }
class AppTabbar extends StatelessWidget {
  AppTabbar({
    required this.tabs,
    required this.tabController,
    required this.onChange,
    required this.dateTime,
    required this.hTab,
    required this.onDateChange,
    super.key,
  });

  final List<Tab> tabs;
  final TabController tabController;
  final Function(int) onChange;
  final DateTime dateTime;
  final HTab hTab;
  final Function(DateTime) onDateChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 35,
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FF9E99').withOpacity(0.8)
                    : HexColor.fromHex('#9F2DBC').withOpacity(0.8),
                spreadRadius: 0.5,
                blurRadius: 3,
                offset: Offset(0, 0),
              ),
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#000000').withOpacity(0.25)
                    : HexColor.fromHex('#00AFAA').withOpacity(0.05),
                spreadRadius: 5,
                blurRadius: 6,
                offset: Offset(10, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: TabBar(
              controller: tabController,
              tabs: tabs,
              // tabAlignment: TabAlignment.fill,
              indicatorSize: TabBarIndicatorSize.tab,
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return states.contains(MaterialState.focused) ? null : Colors.transparent;
                },
              ),
              indicatorColor: Colors.transparent,
              indicatorWeight: 0,
              indicator: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FF9E99')
                    : HexColor.fromHex('#FF6259'),
              ),
              labelColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : Colors.white,
              unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#FF9E99')
                  : HexColor.fromHex('#FF6259'),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
              onTap: onChange,
            ),
          ),
        ),
        DayWeekMonth(
          dateTime: dateTime,
hTab: hTab,
          onPrevious: () {
            if (hTab == HTab.day) {
              onDateChange(dateTime.copyWith(day: dateTime.day - 1));
            }
            if (hTab == HTab.week) {
              onDateChange(dateTime.copyWith(day: dateTime.day - 7));
            }
            if (hTab == HTab.month) {
              onDateChange(DateTime(dateTime.year, dateTime.month - 1, 1));
            }
          },
          onNext: () {
            if (hTab == HTab.day) {
              onDateChange(dateTime.copyWith(day: dateTime.day + 1));
            }
            if (hTab == HTab.week) {
              onDateChange(dateTime.copyWith(day: dateTime.day + 7));
            }
            if (hTab == HTab.month) {
              onDateChange(DateTime(dateTime.year, dateTime.month + 1, 1));
            }
          },
        ),
      ],
    );
  }
}
//
// class AppTabbar extends StatelessWidget {
//   AppTabbar({
//     required this.tabs,
//     required this.tabController,
//     required this.onChange,
//     required this.selectedDay,
//     required this.currentTab,
//     super.key,
//   });
//
//   final List<Tab> tabs;
//   final TabController tabController;
//   final ValueNotifier<DateTime> selectedDay;
//   final HTab currentTab;
//   final Function(int) onChange;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           height: 35,
//           margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
//           decoration: BoxDecoration(
//             color: Theme.of(context).brightness == Brightness.dark
//                 ? Colors.black
//                 : Colors.white,
//             borderRadius: BorderRadius.circular(25.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Theme.of(context).brightness == Brightness.dark
//                     ? HexColor.fromHex('#FF9E99').withOpacity(0.8)
//                     : HexColor.fromHex('#9F2DBC').withOpacity(0.8),
//                 spreadRadius: 0.5,
//                 blurRadius: 3,
//                 offset: Offset(0, 0),
//               ),
//               BoxShadow(
//                 color: Theme.of(context).brightness == Brightness.dark
//                     ? HexColor.fromHex('#000000').withOpacity(0.25)
//                     : HexColor.fromHex('#00AFAA').withOpacity(0.05),
//                 spreadRadius: 5,
//                 blurRadius: 6,
//                 offset: Offset(10, 10),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(25.0),
//             child: TabBar(
//               controller: tabController,
//               tabs: tabs,
//
//               //   tabAlignment: TabAlignment.fill,
//               indicatorSize: TabBarIndicatorSize.tab,
//               overlayColor: MaterialStateProperty.resolveWith<Color?>(
//                 (Set<MaterialState> states) {
//                   return states.contains(MaterialState.focused)
//                       ? null
//                       : Colors.transparent;
//                 },
//               ),
//               indicatorColor: Colors.transparent,
//               indicatorWeight: 0,
//               indicator: BoxDecoration(
//                 color: Theme.of(context).brightness == Brightness.dark
//                     ? HexColor.fromHex('#FF9E99')
//                     : HexColor.fromHex('#FF6259'),
//               ),
//               labelColor: Theme.of(context).brightness == Brightness.dark
//                   ? HexColor.fromHex('#111B1A')
//                   : Colors.white,
//               unselectedLabelColor:
//                   Theme.of(context).brightness == Brightness.dark
//                       ? HexColor.fromHex('#FF9E99')
//                       : HexColor.fromHex('#FF6259'),
//               labelStyle: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16.sp,
//               ),
//               onTap: (int index) {
//                 onChange(index);
//               },
//             ),
//           ),
//         ),
//         ValueListenableBuilder(
//           valueListenable: selectedDay,
//           builder: (BuildContext context, DateTime value, Widget? child) {
//             return DayWeekMonth(
//               dateTime: selectedDay.value,
//               onPrevious: () {
//                 if (currentTab == HTab.day) {
//                   selectedDay.value = selectedDay.value
//                       .copyWith(day: selectedDay.value.day - 1);
//                 }
//                 if (currentTab == HTab.week) {
//                   selectedDay.value = selectedDay.value
//                       .copyWith(day: selectedDay.value.day - 7);
//                 }
//                 if (currentTab == HTab.month) {
//                   selectedDay.value = DateTime(
//                       selectedDay.value.year, selectedDay.value.month - 1, 1);
//                 }
//               },
//               onNext: () {
//                 if (currentTab == HTab.day) {
//                   selectedDay.value = selectedDay.value
//                       .copyWith(day: selectedDay.value.day + 1);
//                 }
//                 if (currentTab == HTab.week) {
//                   selectedDay.value = selectedDay.value
//                       .copyWith(day: selectedDay.value.day + 7);
//                 }
//                 if (currentTab == HTab.month) {
//                   selectedDay.value = DateTime(
//                       selectedDay.value.year, selectedDay.value.month + 1, 1);
//                 }
//               },
//               selectedDay: selectedDay,
//               currentTab: currentTab,
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
