import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'text_utils.dart';

class DayWeekMonthTab extends StatefulWidget {
  final int currentIndex;
  final String date;
  final GestureTapCallback onTapDay;
  final GestureTapCallback onTapWeek;
  final GestureTapCallback onTapMonth;
  final GestureTapCallback onTapPreviousDate;
  final GestureTapCallback onTapNextDate;
  final GestureTapCallback onTapCalendar;

  DayWeekMonthTab(
      {
      required this.currentIndex,
      required this.onTapDay,
      required this.onTapWeek,
      required this.onTapMonth,
      required this.onTapPreviousDate,
      required this.onTapNextDate,
      required this.onTapCalendar,
        required this.date
      });

  @override
  State<DayWeekMonthTab> createState() => _DayWeekMonthTabState();
}

class _DayWeekMonthTabState extends State<DayWeekMonthTab> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return Column(
      children: [
        Container(
          height: 35.h,
          margin: EdgeInsets.only(left: 33.w, right: 33.w, top: 21.h),
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
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
              borderRadius: BorderRadius.all(Radius.circular(40.h))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: InkWell(
                    child: Container(
                      height: 35.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.h),
                          topLeft: Radius.circular(40.h),
                        ),
                        gradient: widget.currentIndex == 0
                            ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex('#FF9E99')
                                      : HexColor.fromHex('#FF6259'),
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex('#FF9E99')
                                      : HexColor.fromHex('#FF6259'),
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex('#FF9E99')
                                      : HexColor.fromHex('#FF6259'),
                                ],
                              )
                            : LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#111B1A')
                                            .withOpacity(0.05)
                                        : HexColor.fromHex('#FFDFDE')
                                            .withOpacity(0.2),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#111B1A')
                                        : HexColor.fromHex('#FFDFDE')
                                            .withOpacity(0.7),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#111B1A')
                                        : HexColor.fromHex('#FFDFDE')
                                            .withOpacity(0.7),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#111B1A')
                                        : HexColor.fromHex('#FFDFDE')
                                            .withOpacity(0.2),
                                  ]),
                      ),
                      child: Center(
                        key: Key('weightGraphDay'),
                        child: Body1AutoText(
                          text: StringLocalization.of(context)
                              .getText(StringLocalization.day),
                          color: widget.currentIndex == 0
                              ? Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#111B1A')
                                  : Colors.white
                              : Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#FF9E99')
                                  : HexColor.fromHex('#FF6259'),
                          align: TextAlign.center,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    onTap: widget.onTapDay,
                ),
              ),
              widget.currentIndex == 2
                  ? Container(
                      width: 2.w,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black54
                          : Colors.white,
                    )
                  : Container(),
              Expanded(
                child: InkWell(
                    child: Container(
                        height: 35.h,
                        decoration: BoxDecoration(
                          gradient: widget.currentIndex == 1
                              ? LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#FF9E99')
                                        : HexColor.fromHex('#FF6259'),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#FF9E99')
                                        : HexColor.fromHex('#FF6259'),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#FF9E99')
                                        : HexColor.fromHex('#FF6259'),
                                  ],
                                )
                              : LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                              .withOpacity(0.05)
                                          : HexColor.fromHex('#FFDFDE')
                                              .withOpacity(0.2),
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                          : HexColor.fromHex('#FFDFDE')
                                              .withOpacity(0.7),
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                          : HexColor.fromHex('#FFDFDE')
                                              .withOpacity(0.7),
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                          : HexColor.fromHex('#FFDFDE')
                                              .withOpacity(0.2),
                                    ]),
                        ),
                        child: Center(
                          key: Key('weightGraphWeek'),
                          child: Body1AutoText(
                            text: StringLocalization.of(context)
                                .getText(StringLocalization.week),
                            color: widget.currentIndex == 1
                                ? Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? HexColor.fromHex('#111B1A')
                                    : Colors.white
                                : Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? HexColor.fromHex('#FF9E99')
                                    : HexColor.fromHex('#FF6259'),
                            align: TextAlign.center,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        )),
                    onTap: widget.onTapWeek,
                ),
              ),
              widget.currentIndex == 0
                  ? Container(
                      width: 2.w,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black54
                          : Colors.white,
                    )
                  : Container(),
              Expanded(
                child: InkWell(
                    child: Container(
                        height: 35.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(40.h),
                            topRight: Radius.circular(40.h),
                          ),
                          gradient: widget.currentIndex == 2
                              ? LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#FF9E99')
                                        : HexColor.fromHex('#FF6259'),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#FF9E99')
                                        : HexColor.fromHex('#FF6259'),
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? HexColor.fromHex('#FF9E99')
                                        : HexColor.fromHex('#FF6259'),
                                  ],
                                )
                              : LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                              .withOpacity(0.05)
                                          : HexColor.fromHex('#FFDFDE')
                                              .withOpacity(0.2),
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                          : HexColor.fromHex('#FFDFDE')
                                              .withOpacity(0.7),
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                          : HexColor.fromHex('#FFDFDE')
                                              .withOpacity(0.7),
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                          : HexColor.fromHex('#FFDFDE')
                                              .withOpacity(0.2),
                                    ]),
                        ),
                        child: Center(
                          key: Key('weightGraphMonth'),
                          child: Body1AutoText(
                            text: StringLocalization.of(context)
                                .getText(StringLocalization.month),
                            color: widget.currentIndex == 2
                                ? Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? HexColor.fromHex('#111B1A')
                                    : Colors.white
                                : Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? HexColor.fromHex('#FF9E99')
                                    : HexColor.fromHex('#FF6259'),
                            align: TextAlign.center,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        )),
                    onTap: widget.onTapMonth,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
                key: Key('weightGraphDayBackIcon'),
                icon: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'asset/dark_left.png'
                        : 'asset/left.png'),
                onPressed: widget.onTapPreviousDate,
            ),
            Container(
              width: widget.currentIndex == 1
                  ? 200.w
                  : widget.currentIndex == 0
                      ? 80.w
                      : 120.w,
              child: Center(
                  child: Body1AutoText(
                text: widget.date,
                minFontSize: 8,
                fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
              )
                  // child: AutoSizeText(
                  //   selectedValueText(),
                  //   style: TextStyle(
                  //     fontSize: 16.sp,
                  //   ),
                  //   minFontSize: 8,
                  //   maxLines: 1,
                  // ),
                  ),
            ),
            nextBtn(context),
            InkWell(
                key: Key('weightScreenCalendarIcon'),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'asset/dark_calendar_icon.png'
                      : 'asset/calendar_icon.png',
                ),
                onTap: widget.onTapCalendar,
            ),
          ],
        )
      ],
    );
  }

  IconButton nextBtn(BuildContext context) {
    return IconButton(
        key: Key('weightGraphDayNextIcon'),
        icon: Image.asset(Theme.of(context).brightness == Brightness.dark
            ? 'asset/dark_right.png'
            : 'asset/right.png'),
        onPressed: widget.onTapNextDate,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
