import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isSearchOpen = false;
  AppImages images = AppImages();

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
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
              centerTitle: true,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              //set value for title of appbar
              leading: IconButton(
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Theme.of(context).brightness == Brightness.dark
                    ? Image.asset(
                  images.leftArrowDark,
                        width: 13,
                        height: 22,
                      )
                    : Image.asset(
                  images.leftArrowLight,
                        width: 13,
                        height: 22,
                      ),
              ),
              title: Body1AutoText(
                text: 'Notifications',
                color: HexColor.fromHex('62CBC9'),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                align: TextAlign.center,
              ),
              actions: <Widget>[
                ///Added by Akhil
                ///Added on Aug/20/2020
                ///hit api for markAsReadByMessageID or emptyTrashMessage
//          currentfeatureIndex == mailAddFeature[0]
//              ? IconButton(
//                  icon: Icon(Icons.markunread_mailbox),
//                  onPressed: () {
//                    //   markAsRead();
//                  },
//                )
//              :

                //toggle between isSearchOpen
                isSearchOpen
                    ? IconButton(
                        // padding: EdgeInsets.only(right: 15),
                        icon: Theme.of(context).brightness == Brightness.dark
                            ? Image.asset(
                          images.darkClose,
                                width: 33,
                                height: 33,
                              )
                            : Image.asset(
                          images.lightClose,
                                width: 33,
                                height: 33,
                              ),
                        onPressed: () {
                          setState(() {
                            isSearchOpen = false;
                          });
                        },
                      )
                    : IconButton(
                        //padding: EdgeInsets.only(right: 15),
                        icon: Theme.of(context).brightness == Brightness.dark
                            ? Image.asset(
                          images.searchDark,
                                width: 33,
                                height: 33,
                              )
                            : Image.asset(
                          images.searchLight,
                                width: 33,
                                height: 33,
                              ),
                        onPressed: () {
                          setState(() {
                            isSearchOpen = true;
                          });
                        },
                      ),
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isSearchOpen
                  ? Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColor.darkBackgroundColor
                          : AppColor.backgroundColor,
                      padding:
                          EdgeInsets.only(top: 16.h, left: 13.w, right: 13.w),
                      child: Container(
                        height: 42.h,
                        decoration: ConcaveDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            depression: 7,
                            colors: [
                              Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#000000').withOpacity(0.8)
                                  : HexColor.fromHex('#D1D9E6'),
                              Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                  : Colors.white,
                            ]),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: TextField(
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? HexColor.fromHex('#FFFFFF')
                                        .withOpacity(0.87)
                                    : HexColor.fromHex('#384341')),
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: StringLocalization.of(context)
                                    .getText(StringLocalization.search),
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
                      ))
                  : Container(),
              Container(
                margin: EdgeInsets.only(left: 34.w, right: 40.w, top: 13.h),
                child: Text(
                  'New',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.87)
                          : HexColor.fromHex('#384341')),
                ),
              ),
              NotificationItem(false, false),
              NotificationItem(true, false),
              Container(
                margin: EdgeInsets.only(left: 34.w, right: 40.w, top: 13.h),
                child: Text(
                  'Earlier',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.87)
                          : HexColor.fromHex('#384341')),
                ),
              ),
              NotificationItem(false, true),
              NotificationItem(true, true),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final bool isALike;
  final bool isEarlier;

  NotificationItem(this.isALike, this.isEarlier, {Key? key}) : super(key: key);

  final AppImages images = AppImages();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 13.w, right: 13.w, top: 13.h),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkBackgroundColor
                : AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                    : Colors.white.withOpacity(0.7),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(-4, -4),
              ),
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.75)
                    : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(4, 4),
              ),
            ]),
        child: Container(
          decoration: isEarlier
              ? BoxDecoration()
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#9F2DBC').withOpacity(0.15)
                            : HexColor.fromHex('#D1D9E6'),
                        Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#9F2DBC').withOpacity(0)
                            : HexColor.fromHex('#FFDFDE').withOpacity(0.1),
                      ])),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 14.w,
              ),
              Container(
                  margin: EdgeInsets.only(top: 12.h, bottom: 24.h),
                  child: Image.asset(
                    images.commentIcon,
                    width: 43.w,
                    height: 43.w,
                  )),
              SizedBox(
                width: 12.w,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 12.h),
                            child: RichText(
                              maxLines: 2,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Zohreh Valiary',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex('#384341'))),
                                TextSpan(
                                    text: isALike
                                        ? ' liked your post'
                                        : ' commented on your Evening run activity',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex('#384341')))
                              ]),
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 8.h, right: 7.w),
                            child: Image.asset(
                              isALike
                                  ? images.thumbsUpIconNotify
                                  : images.commentIcon,
                              width: 26.w,
                              height: 26.w,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1d . ',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex('#384341')),
                        ),
                        isALike
                            ? Container()
                            : Expanded(
                                child: Text(
                                  '"lasjldkfjlsjflsjdflsjfdljslfdjldjflsjflsdjflsjdfljdldfadlfjldfjlsdjlfjsdlff"',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white.withOpacity(0.87)
                                          : HexColor.fromHex('#384341')),
                                ),
                              ),
                        SizedBox(
                          width: 24.w,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
