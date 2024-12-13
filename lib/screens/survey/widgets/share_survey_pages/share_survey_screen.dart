import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart'
    as userContact;
import 'package:health_gauge/screens/survey/bloc/share_survey_bloc/share_survey_state.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';

import '../../../../utils/concave_decoration.dart';
import '../../../../value/app_color.dart';
import '../../../../value/string_localization_support/string_localization.dart';
import '../../../../widgets/text_utils.dart';
import '../../bloc/share_survey_bloc/share_survey_bloc.dart';
import '../../bloc/share_survey_bloc/share_survey_events.dart';
import '../../bloc/survey_bloc/survey_bloc.dart';
import '../../model/surveys.dart';

class ShareSurveyScreen extends StatefulWidget {
  final Data surveyDetail;
  ShareSurveyScreen(this.surveyDetail);
  @override
  State<StatefulWidget> createState() {
    return _ShareSurveyScreen();
  }
}

class _ShareSurveyScreen extends State<ShareSurveyScreen> {
  late ShareSurveyBloc surveyBloc;
  userContact.UserListModel? userList;
  bool isToCompressed = false;
  List<userContact.UserData>? contactData;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    surveyBloc = BlocProvider.of<ShareSurveyBloc>(context);
    surveyBloc.add(LoadingContactList(userId: int.parse(globalUser!.userId!)));
    contactData = [];
    super.initState();
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
                centerTitle: true,
                title: Body1AutoText(
                  text: StringLocalization.of(context)
                      .getText(StringLocalization.shareWithUser),
                  fontSize: 18,
                  color: HexColor.fromHex("62CBC9"),
                  fontWeight: FontWeight.bold,
                  align: TextAlign.center,
                  minFontSize: 14,
                  maxLine: 1,
                ),
                // title: FittedTitleText(
                //   text: StringLocalization.of(context)
                //       .getText(StringLocalization.surveyList),
                //   fontSize: 18,
                //   color: HexColor.fromHex("62CBC9"),
                //   fontWeight: FontWeight.bold,
                //   align: TextAlign.center,
                //   // maxLine: 1,
                // ),
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
                          "asset/leftArrow.png",
                          width: 13,
                          height: 22,
                        ),
                ),
              ),
            )),
        body: SingleChildScrollView(
            child: Column(children: [
          BlocListener(
            bloc: surveyBloc,
            listener: (BuildContext context, ShareSurveyState state) {
              print('BlocListener State : ${state.runtimeType}');
              if (state is LoadedContactList) {
                userList = state.response;
              }
              if (state is ShareSurveySucessState) {
                CustomSnackBar.buildSnackbar(
                    context, "Survey Shared Sucessfully", 3);
              }
              if (state is ShareSurveyErrorState) {
                CustomSnackBar.buildSnackbar(
                    context, "Something went wrong", 3);
              }
            },
            child: Container(),
          ),
          BlocBuilder(
            bloc: surveyBloc,
            builder: (BuildContext context, ShareSurveyState state) {
              if (state is LoadingShareSurveyState) {
                return Align(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(top: 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                          ),
                          child: Wrap(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: isToCompressed && contactData!.length > 2
                                    ? Wrap(
                                        children: <Widget>[
                                          Container(
                                            // height: 30.h,
                                            margin: EdgeInsets.only(
                                                bottom: 5.h, right: 5.w),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: Border.all(
                                                    color: AppColor.graydark),
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? AppColor
                                                        .darkBackgroundColor
                                                    : AppColor.backgroundColor),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                CircleAvatar(
                                                  // backgroundImage:
                                                  //     CachedNetworkImageProvider(
                                                  //         contactData[0]
                                                  //             .picture),
                                                  child: CachedNetworkImage(
                                                    imageUrl: contactData![0]
                                                            .picture ??
                                                        '',
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      width: 20.0.w,
                                                      height: 20.0.h,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            Image.asset(
                                                      "asset/m_profile_icon.png",
                                                      color: Colors.white,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      "asset/m_profile_icon.png",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  radius: 15,
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Text(
                                                  "${contactData![0].firstName} ${contactData![0].lastName}",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                              .withOpacity(0.87)
                                                          : AppColor
                                                              .darkBackgroundColor),
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                GestureDetector(
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 12,
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      contactData?.remove(
                                                          contactData?[0]);
                                                      userList?.data?.add(
                                                          contactData![0]);
                                                    });
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // height: 30.h,
                                            margin: EdgeInsets.only(
                                                bottom: 5.h, right: 5.w),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: Border.all(
                                                    color: AppColor.graydark),
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? AppColor
                                                        .darkBackgroundColor
                                                    : AppColor.backgroundColor),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                CircleAvatar(
                                                  child: CachedNetworkImage(
                                                    imageUrl: contactData![1]
                                                            .picture ??
                                                        '',
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      width: 50.0.w,
                                                      height: 50.0.h,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            Image.asset(
                                                      "asset/m_profile_icon.png",
                                                      color: Colors.white,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      "asset/m_profile_icon.png",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  radius: 15,
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Text(
                                                  "${contactData![1].firstName} ${contactData![1].lastName}",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                              .withOpacity(0.87)
                                                          : AppColor
                                                              .darkBackgroundColor),
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                GestureDetector(
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 12,
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      contactData?.remove(
                                                          contactData?[1]);
                                                      userList?.data?.add(
                                                          contactData![1]);
                                                    });
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                              ],
                                            ),
                                          ),
                                          CircleAvatar(
                                            backgroundColor: AppColor.green,
                                            child: GestureDetector(
                                              child: Text(
                                                '+${contactData!.length - 2}',
                                                style: TextStyle(
                                                    color: AppColor.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w800),
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
                                        children: contactData!.map((item) {
                                          return Container(
                                            // height: 30.h,
                                            margin: EdgeInsets.only(
                                                bottom: 5.h, right: 5.w),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: Border.all(
                                                    color: AppColor.graydark),
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? AppColor
                                                        .darkBackgroundColor
                                                    : AppColor.backgroundColor),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                CircleAvatar(
                                                  // backgroundImage:
                                                  //     CachedNetworkImageProvider(
                                                  //         item.picture),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        item.picture ?? '',
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      width: 20.0.w,
                                                      height: 20.0.h,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            Image.asset(
                                                      "asset/m_profile_icon.png",
                                                      color: Colors.white,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      "asset/m_profile_icon.png",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  radius: 15,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${item.firstName} ${item.lastName}",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                              .withOpacity(0.87)
                                                          : AppColor
                                                              .darkBackgroundColor),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                GestureDetector(
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 12,
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      contactData!.remove(item);
                                                      userList!.data!.add(item);
                                                    });
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 5,
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
                                    key: Key('enterTo'),
                                    child: suggestionTextField(
                                        hint: 'enterTo',
                                        maxLines: null,
                                        controller: searchController,
                                        padding: 15,
                                        keyboardType: TextInputType.text,
                                        dataList: contactData),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// Added by: Akhil
                      /// Added on: May/29/2020
                      /// button to expand to field to add cc
                    ],
                  ),
                );
              }
            },
          ),
          SizedBox(
            height: 30.h,
          ),
          Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              child: GestureDetector(
                onTap: () {
                  if (contactData!.isNotEmpty) {
                    surveyBloc.add(MakeShareSurveyEvent(
                        contactData: contactData,
                        surveyDetail: widget.surveyDetail));
                  }
                },
                child: Container(
                  height: 40.h,
                  width: 170.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.h),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#00AFAA')
                          : HexColor.fromHex('#00AFAA').withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                              : Colors.white,
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(-5.w, -5.h),
                        ),
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex('#D1D9E6'),
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
                          HexColor.fromHex('#D1D9E6'),
                        ]),
                    child: Center(
                      key: Key('shareButton'),
                      child: Text(
                        StringLocalization.of(context)
                            .getText(StringLocalization.shareWithUser)
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#111B1A')
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ))
        ])));
  }

  Widget suggestionTextField({
    String? hint,
    TextInputType? keyboardType,
    int? maxLines,
    TextEditingController? controller,
    double? padding,
    List<userContact.UserData>? dataList,
    FocusNode? node,
  }) {
    print('&&&&&&&&&&&&&&&&&&&&&&');
    print(dataList);
    print('&&&&&&&&&&&&&&&&&&&&&&&');
    return TypeAheadField(
      key: Key(hint!),
      hideOnEmpty: true,
      hideOnError: true,
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.numberWithOptions(),
        maxLines: maxLines ?? 1,
        focusNode: node,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: padding ?? 0.0),
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
        print('userList : $userList');
        print('userList data : ${userList?.data?.length}');
        if (userList == null || userList?.data?.length == 0) {
          surveyBloc
              .add(LoadingContactList(userId: int.parse(globalUser!.userId!)));
        }
        return getSearchedList(pattern);
      },
      itemBuilder: (context, userContact.UserData element) {
        return Container(
          key: Key('${element.firstName}'),
          // height: 56.h,
          margin: EdgeInsets.only(bottom: 16.h, left: 4.w, right: 4.w),
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : Colors.white,
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
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#9F2DBC').withOpacity(0.15)
                          : HexColor.fromHex('#D1D9E6').withOpacity(0.5),
                      Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#9F2DBC').withOpacity(0)
                          : HexColor.fromHex('#FFDFDE').withOpacity(0),
                    ])),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              CircleAvatar(
                // backgroundImage: NetworkImage(element.picture),
                child: CachedNetworkImage(
                  imageUrl: element.picture ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    width: 42.0.w,
                    height: 42.0.w,
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
              SizedBox(
                width: 16.w,
              ),
              SizedBox(
                height: 25.h,
                child: Body1AutoText(
                  text: '${element.firstName} ${element.lastName}',
                  maxLine: 1,
                  minFontSize: 8,
                ),
                // child: FittedTitleText(
                //   text: '${element.firstName} ${element.lastName}',
                //   // maxLine: 1,
                // ),
              ),
            ]),
          ),
        );
      },
      onSuggestionSelected: (userContact.UserData element) {
        setState(() {
          dataList?.add(element);
          userList?.data?.removeWhere((e) => element.id == e.id);
        });

        controller?.clear();
      },
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        elevation: 0.0,
      ),
    );
  }

  List<userContact.UserData> getSearchedList(String pattern) {
    print('Search Contact Query : $pattern');
    List<String> elements = pattern.split(',');
    if (pattern.isNotEmpty) {
      return userList?.data?.where((v) {
            return (v.firstName!
                    .toUpperCase()
                    .contains(elements.last.toUpperCase()) ||
                v.lastName!
                    .toUpperCase()
                    .contains(elements.last.toUpperCase()) ||
                '${v.firstName!.toUpperCase()} ${v.lastName!.toUpperCase()}'
                    .contains(elements.last.toUpperCase()));
          }).toList() ??
          [];
    }
    return [];
  }
}
