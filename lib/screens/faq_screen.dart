import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  TextEditingController _searchController = TextEditingController();
  final scrollDirection = Axis.vertical;
  List<String> questionList = [];


  @override
  void initState() {
    // TODO: implement initState
    getQuestionList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : HexColor.fromHex("#EEF1F1"),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.5)
                      : HexColor.fromHex("#384341").withOpacity(0.2),
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
                          "asset/dark_leftArrow.png",
                          width: 13,
                          height: 22,
                        )
                      : Image.asset(
                          "asset/leftArrow.png",
                          width: 13,
                          height: 22,
                        ),
                ),
                title: Text(
                  "FAQ",
                  style: TextStyle(
                      color: HexColor.fromHex("#62CBC9"),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
            )),
        body: Container(
          child: Column(children: [
            searchTextField(context),
            Expanded(
              child: ListView.builder(
                  scrollDirection: scrollDirection,
                  padding: const EdgeInsets.all(20),
                  itemCount: questionList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(questionList[index],
                         style: TextStyle(
                           fontSize: 16.sp,
                           color: HexColor.fromHex("#384341")
                         ),),
                    );
                  }),
            )
          ]),
        ));
  }

  Widget searchTextField(BuildContext context) {
    return Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : AppColor.backgroundColor,
        padding: EdgeInsets.only(top: 16.h, left: 33.w, right: 33.w),
        child: Container(
          height: 56.h,
          decoration: ConcaveDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.h)),
              depression: 7,
              colors: [
                Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex("#000000").withOpacity(0.8)
                    : HexColor.fromHex("#D1D9E6"),
                Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                    : Colors.white,
              ]),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Center(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex("#FFFFFF").withOpacity(0.87)
                      : HexColor.fromHex("#384341")),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex("#FFFFFF").withOpacity(0.38)
                        : HexColor.fromHex("#7F8D8C"),
                  )),
              onSubmitted: (value) {},
            ),
          ),
        ));
  }

  getQuestionList(){
    questionList = [
    "I can not sign up.",
    "How can I change my profile information ?",
    "I have an apple device and can’t see my bracelet in the bluetooth page ?",
    "I can not disconnect my device.",
    "How can I check if my bracelet is connected to my phone?",
    "What is a good measurement ?",
    "How can I calibrate my bracelet ?",
    ] ;
  }
}
