import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_bloc.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_event.dart';
import 'package:health_gauge/screens/Library/library_bloc/library_state.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:flutter/services.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';

class LinkSharePage extends StatefulWidget {
  final int? userId;
  final int? libraryId;
  final String? url;

  LinkSharePage({this.userId, this.libraryId, this.url});

  @override
  _LinkSharePageState createState() => _LinkSharePageState();
}

class _LinkSharePageState extends State<LinkSharePage> {
  List<String> _dropDownList = [
    "Restricted",
    "Company Ltd.",
    "Anyone with the link"
  ];
  String _selectedListValue = 'Restricted';

  Map<String, int> mapSpecifier = {
    'Restricted': 1,
    'Company Ltd': 2,
    'Anyone with the link': 3
  };
  LibraryBloc? libraryBloc;
  TextEditingController? _textEditingController;
  bool openKeyboardUserId = false;
  FocusNode linkFocusNode = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController(text: widget.url);
    libraryBloc = BlocProvider.of<LibraryBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          // title: Text('Share Link'),
          title: Text('Share Link',
              style: TextStyle(
                  fontSize: 18,
                  color: HexColor.fromHex("62CBC9"),
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
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
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
              : AppColor.backgroundColor,
          padding: EdgeInsets.only(top: 20.h, left: 10.h, right: 10.h),
          child: Column(
            children: [
              BlocListener(
                bloc: libraryBloc,
                listener: (context, state) {
                  if (state is LinkAccessChangedState) {}
                },
                child: Container(),
              ),
//               Card(
//                   margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
//                   child: TextField(
//                     controller: _textEditingController,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 18,
//                     ),
//                     decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                         border: InputBorder.none,
//                         focusedBorder: InputBorder.none,
//                         enabledBorder: InputBorder.none,
//                         errorBorder: InputBorder.none,
//                         disabledBorder: InputBorder.none,
//                         hintText: '',
//                         hintStyle: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 18,
// //                color: AppColor.graydark,
//                         )),
//                     onSubmitted: (value) {},
//                   )),
              Container(
                // height: 49.h,
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex("#111B1A")
                        : AppColor.backgroundColor,
                    borderRadius: BorderRadius.circular(10.h),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                            : Colors.white,
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(-5.w, -5.h),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.75)
                            : HexColor.fromHex("#D1D9E6"),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(5.w, 5.h),
                      ),
                    ]),
                child: GestureDetector(
                  onTap: () {
                    // userIdFocusNode.requestFocus();
                    // openKeyboardUserId = true;
                    // openKeyboardPasswd = false;
                    linkFocusNode.unfocus();
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    decoration: openKeyboardUserId
                        ? ConcaveDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.h)),
                            depression: 7,
                            colors: [
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black.withOpacity(0.5)
                                    : HexColor.fromHex("#D1D9E6"),
                                Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex("#D1D9E6")
                                        .withOpacity(0.07)
                                    : Colors.white,
                              ])
                        : BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.h)),
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex("#111B1A")
                                    : AppColor.backgroundColor,
                          ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: IgnorePointer(
                            ignoring: false,
                            child: TextFormField(
                              showCursor: true,
                              readOnly: true,
                              // textAlignVertical: TextAlignVertical.center,
                              autofocus: openKeyboardUserId,
                              focusNode: linkFocusNode,
                              // autovalidate: autoValidate,
                              controller: _textEditingController,
                              style: TextStyle(fontSize: 16.0),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                // hintText: errorId
                                //     ? StringLocalization.of(context)
                                //     .getText(StringLocalization.emptyUserId)
                                //     : StringLocalization.of(context).getText(
                                //     StringLocalization.hintForUserId),
                                // hintStyle: TextStyle(
                                //     color: errorId
                                //         ? HexColor.fromHex("FF6259")
                                //         : HexColor.fromHex("7F8D8C"))
                              ),
//                          validator: (value) {
//                            if (value.isEmpty) {
//                              return StringLocalization.of(context)
//                                  .getText(StringLocalization.emptyUserId);
//                            }
//                            return null;
//                          },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {
                                // openKeyboardPasswd = true;
                                // openKeyboardUserId = false;
                                // errorPaswd = false;
                                // FocusScope.of(context)
                                //     .requestFocus(passwordFocusNode);
                                // setState(() {});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex("#111B1A")
                    : AppColor.backgroundColor,
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 20.h, bottom: 15.h),
                child: GestureDetector(
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.h),
                        color: HexColor.fromHex("#00AFAA"),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                                : Colors.white,
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: Offset(-5.w, -5.h),
                          ),
                          BoxShadow(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black.withOpacity(0.75)
                                    : HexColor.fromHex("#D1D9E6"),
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: Offset(5.w, 5.h),
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
                            HexColor.fromHex("#D1D9E6"),
                          ]),
                      child: Center(
                        child: Text(
                          'Copy Link',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex("#111B1A")
                                    : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                     Clipboard.setData(
                        ClipboardData(text: _textEditingController!.text)).then((value){
                       CustomSnackBar.buildSnackbar(context, 'Copied link', 3);
                     });
                    // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Copied link')));
                  },
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     Clipboard.setData(
              //         ClipboardData(text: _textEditingController.text));
              //     // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Copied link')));
              //     CustomSnackBar.buildSnackbar(context, 'Copied link', 3);
              //   },
              //   child: Container(
              //     height: 40,
              //     margin: EdgeInsets.only(left: 15, right: 15),
              //     width: MediaQuery.of(context).size.width,
              //     decoration: BoxDecoration(
              //         color: HexColor.fromHex("62CBC9"),
              //         borderRadius: BorderRadius.circular(20)),
              //     child: Center(
              //       child: Text(
              //         'Copy Link',
              //         style: TextStyle(
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    'Link Access',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  DropdownButton(
                    value: _selectedListValue,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedListValue = newValue.toString();
                        print(_selectedListValue);
                        linkFocusNode.unfocus();
                      });
                      libraryBloc!.add(LibraryChangeLinkAccessSpecifier(
                        userId: widget.userId,
                        accessSpecifier: _selectedListValue == 'Restricted'
                            ? 1
                            : _selectedListValue == 'Company Ltd.'
                                ? 2
                                : 3,
                        libraryId: widget.libraryId,
                      ));
                    },
                    items: _dropDownList.map((item) {
                      return DropdownMenuItem(
                        child: new Text(item, style: TextStyle(fontSize: 16)),
                        value: item,
                      );
                    }).toList(),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

// Container(
// width: MediaQuery.of(context).size.width,
// height: MediaQuery.of(context).size.height,
// child: Column(
// children: [
// Container(
// width: MediaQuery.of(context).size.width,
// child: Row(
// children: [
// TextField(
//
// ),
// ],
// ),
// ),
// InkWell(
// onTap: (){
//
// },
// child: Center(
// child: Text('Copy Link'),
// ),
// ),
// Row(
// children: [
// Text('Link Access'),
// DropdownButton(
// value: _selectedListValue,
// onChanged: (newValue) {
// setState(() {
// _selectedListValue = newValue;
// print(_selectedListValue);
// });
// },
// items: _dropDownList.map((item) {
// return DropdownMenuItem(
// child: new Text(item, style: TextStyle(fontSize: 18)),
// value: item,
// );
// }).toList(),
// ),
// ],
// )
// ],
// ),
// ),
