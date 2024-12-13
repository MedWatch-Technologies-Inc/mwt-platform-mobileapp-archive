import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../utils/concave_decoration.dart';
import '../../../../value/app_color.dart';
import '../../../../value/string_localization_support/string_localization.dart';
import '../../bloc/survey_bloc/survey_bloc.dart';
import '../../bloc/survey_bloc/survey_states.dart';
import '../../model/survey_detail.dart';

class TakeSurveyQuestionListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TakeSurveyQuestionListScreenState();
  }
}

class _TakeSurveyQuestionListScreenState
    extends State<TakeSurveyQuestionListScreen> {
  late SurveyBloc _surveyBloc;

  @override
  void initState() {
    _surveyBloc = BlocProvider.of<SurveyBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SurveyBloc, SurveyState>(
      bloc: _surveyBloc,
      listener: (BuildContext context, SurveyState state) {
        if (state is LoadSurveyDetailBySurveyIdState) {}
      },
      builder: (BuildContext context, SurveyState state) {
        if (state is LoadingSurveyState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LoadSurveyDetailBySurveyIdState) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      padding: EdgeInsets.only(top: 8.h),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.data.data.lstQuestion.length,
                      itemBuilder: (BuildContext context, index) {
                        if (state.data.data.lstQuestion[index].optionType
                                .trim() ==
                            StringLocalization.binary) {
                          return binaryQuestionCard(
                              state.data.data.lstQuestion[index]);
                        } else if (state.data.data.lstQuestion[index].optionType
                                .trim() ==
                            StringLocalization.multipleChoices) {
                          return multipleChoicesQuestionCard(
                              state.data.data.lstQuestion[index]);
                        } else if (state.data.data.lstQuestion[index].optionType
                                .trim() ==
                            StringLocalization.slider) {
                          return sliderQuestionCard(
                              state.data.data.lstQuestion[index]);
                        } else if (state.data.data.lstQuestion[index].optionType
                                .trim() ==
                            StringLocalization.multipleAnswer) {
                          return multipleAnswerQuestionCard(
                              state.data.data.lstQuestion[index]);
                        } else if (state.data.data.lstQuestion[index].optionType
                                .trim() ==
                            StringLocalization.note) {
                          return noteQuestionCard(
                              state.data.data.lstQuestion[index]);
                        } else {
                          return Container();
                        }
                      })
                ],
              ),
            ),
          );
          // return SurveyListView(surveysList,_surveyListScrollController);
        } else if (state is SurveyDetailErrorState) {
          return Center(
            child: Text(
                StringLocalization.of(context)
                    .getText(StringLocalization.somethingWentWrong),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                )),
          );
        }
        return Container();
      },
    );
  }

  binaryQuestionCard(LstQuestion question) {
    return Card(
      elevation: 0,
      child: Container(
          padding:
              EdgeInsets.only(left: 10.w, right: 10.w, top: 25.h, bottom: 25.h),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  question.questionDesc,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 17.sp),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
                      child: GestureDetector(
                        child: Container(
                          height: 40.h,
                          width: 70.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.h),
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex('#00AFAA')
                                  : HexColor.fromHex('#00AFAA')
                                      .withOpacity(0.8),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex('#D1D9E6')
                                          .withOpacity(0.1)
                                      : Colors.white,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  offset: Offset(-5.w, -5.h),
                                ),
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
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
                              key: Key('noButton'),
                              child: Text(
                                StringLocalization.of(context)
                                    .getText(StringLocalization.no)
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex('#111B1A')
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    width: 20.w,
                  ),
                  Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
                      child: GestureDetector(
                        child: Container(
                          height: 40.h,
                          width: 70.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.h),
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex('#00AFAA')
                                  : HexColor.fromHex('#00AFAA')
                                      .withOpacity(0.8),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex('#D1D9E6')
                                          .withOpacity(0.1)
                                      : Colors.white,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  offset: Offset(-5.w, -5.h),
                                ),
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
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
                              key: Key('yesButton'),
                              child: Text(
                                StringLocalization.of(context)
                                    .getText(StringLocalization.yes)
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex('#111B1A')
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              )
            ],
          )),
    );
  }

  multipleChoicesQuestionCard(LstQuestion question) {
    return Card(
      elevation: 0,
      child: Container(
          padding:
              EdgeInsets.only(left: 10.w, right: 10.w, top: 25.h, bottom: 25.h),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  question.questionDesc,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 17.sp),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: question.lstOptions!.length,
                  itemBuilder: (BuildContext context, index) {
                    return ListTile(
                      //leading: Text((index+1).toString()+"."),
                      title: Text(question.lstOptions![index].optionDesc),
                      trailing: IconButton(
                        icon: const Icon(Icons.radio_button_off),
                        color: HexColor.fromHex("#61CBC9"),
                        onPressed: () {},
                      ),
                    );
                  })
            ],
          )),
    );
  }

  multipleAnswerQuestionCard(LstQuestion question) {
    return Card(
      elevation: 0,
      child: Container(
          padding:
              EdgeInsets.only(left: 10.w, right: 10.w, top: 25.h, bottom: 25.h),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  question.questionDesc,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 17.sp),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: question.lstOptions!.length,
                  itemBuilder: (BuildContext context, index) {
                    return ListTile(
                      title: Text(question.lstOptions![index].optionDesc),
                      leading: IconButton(
                        icon: const Icon(Icons.check_box_outline_blank),
                        color: HexColor.fromHex("#61CBC9"),
                        onPressed: () {},
                      ),
                    );
                  })
            ],
          )),
    );
  }

  noteQuestionCard(LstQuestion question) {
    var maxLines = 7;
    return Card(
      elevation: 0,
      child: Container(
          padding:
              EdgeInsets.only(left: 10.w, right: 10.w, top: 25.h, bottom: 25.h),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  question.questionDesc,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 17.sp),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Container(
                  margin: EdgeInsets.all(12),
                  height: maxLines * 30.0.h,
//            color: Colors.white30,
                  child: TextField(
                    maxLines: 7,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Write Something About it...',
                      filled: true,
                    ),
                  )),
            ],
          )),
    );
  }

  sliderQuestionCard(LstQuestion question) {
    double _value = 40.0;
    var maxLines = 7;
    return Card(
      elevation: 0,
      child: Container(
          padding:
              EdgeInsets.only(left: 10.w, right: 10.w, top: 25.h, bottom: 25.h),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  question.questionDesc,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 17.sp),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              SfSlider(
                min: 0.0,
                max: 100.0,
                value: _value,
                interval: 20,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 1,
                onChanged: (dynamic value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
            ],
          )),
    );
  }
}
