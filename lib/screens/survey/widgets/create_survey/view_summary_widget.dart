import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_bloc.dart';
import 'package:health_gauge/widgets/loading_indicator_overlay.dart';
// import 'package:flutter_screenutil/size_extension.dart';

import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

import '../../../../utils/date_utils.dart';
import '../../../../value/app_color.dart';
import '../../../../value/string_localization_support/string_localization.dart';
import '../../../../widgets/gradient_button.dart';
import '../../bloc/survey_bloc/survey_events.dart';
import '../../bloc/survey_bloc/survey_states.dart';
import '../../model/create_survey_model.dart';

class ViewSummaryWidget extends StatefulWidget {
  const ViewSummaryWidget(
      {Key? key,
      required this.popScreen
      })
      : super(key: key);
 final Function popScreen;
  @override
  State<StatefulWidget> createState() {
    return _ViewSummaryWidgetState();
  }
}

class _ViewSummaryWidgetState extends State<ViewSummaryWidget> {
  CreateSurveyModel? survey;
  late DateFormat _dateFormatter;
  OverlayEntry? overlayEntry;
  @override
  void initState() {
    _dateFormatter = DateUtil().getDateFormatter(formatType: DateUtil.ddMMMMyyyy);
    _surveyBloc = BlocProvider.of<SurveyBloc>(context);
    survey = _surveyBloc.surveyModel;
    super.initState();
  }
  late SurveyBloc _surveyBloc;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(16.h),
      child: BlocListener<SurveyBloc,SurveyState>(
        listenWhen: (prevState,currState){
          return currState is LoadingSurveyState || currState is SurveyErrorState || currState is SurveyCreationSuccessState;
        },
        listener: (context,state){
          if(state is LoadingSurveyState){
            overlayEntry = showOverlay(context);
          }else if(state is SurveyErrorState){
            overlayEntry?.remove();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed creating survey.')));
            widget.popScreen();
          }else if(state is SurveyCreationSuccessState){
            overlayEntry?.remove();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Survey Created Successfully.')));
            widget.popScreen();
          }
        },
        child: Stack(
          children: [

          Container(
        margin:  EdgeInsets.only(left: 8.w, right: 8.w, top: 30.h, bottom: 45.h),
        child:
        ListView.builder(
                itemCount:survey!.lstQuestion!.length ,
                itemBuilder: (context,questionIndex){
                  LstQuestion question = survey!.lstQuestion![questionIndex];
                  return Container(
                   // height: question.lstOptions==null?140.h:question.lstOptions!.length>4?240.h:200.h,
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.symmetric(horizontal: 6,vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness ==
                            Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness ==
                                Brightness.dark
                                ? HexColor.fromHex('#D1D9E6')
                                .withOpacity(0.1)
                                : Colors.white,
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(-4, -4),
                          ),
                          BoxShadow(
                            color: Theme.of(context).brightness ==
                                Brightness.dark
                                ? Colors.black.withOpacity(0.75)
                                : HexColor.fromHex('#9F2DBC')
                                .withOpacity(0.15),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(4, 4),
                          ),
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                          child: Text('Q.${questionIndex+1} ${question.questionDesc}',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness ==
                                    Brightness.dark
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                              )),
                        ),
                        SizedBox(height: 5,),
                        Text('Option Type: ${question.optionType}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).brightness ==
                                  Brightness.dark
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                            )),
                        SizedBox(height: 5,),
                        Text('${StringLocalization.of(context).getText(StringLocalization.startDate)} : ${_dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_surveyBloc.surveyModel!.startDateTimeStamp!)))}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness ==
                                  Brightness.dark
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                            )),
                        SizedBox(height: 5,),
                        Text('${StringLocalization.of(context).getText(StringLocalization.endDate)} : ${_dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_surveyBloc.surveyModel!.endDateTimeStamp!)))}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness ==
                                  Brightness.dark
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                            )),
                        if(question.lstOptions!=null)...[
                          SizedBox(height: 5,),
                          Text('Options',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness ==
                                    Brightness.dark
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                              )),
                          SizedBox(height: 5,),
                          ListView.builder(
                            shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: question.lstOptions!.length,
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                              itemBuilder: (context,index){
                                return Text('${index+1} ) ${question.lstOptions![index].optionDesc}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? Colors.white.withOpacity(0.87)
                                          : HexColor.fromHex('#384341'),
                                    ));
                              }),
                        ]
                      ],
                    ),
                  );
                },
            )),
             Align(
                 alignment: Alignment.topCenter,
                 child: Text('${survey!.surveyName}',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness ==
                      Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                ))),
        Align(
          alignment: Alignment.bottomCenter,
          child: GradientButton(
              height: 40.h,
              width: MediaQuery.of(context).size.width,
              backgroundColor: HexColor.fromHex("#00AFAA"),
              borderRadius: 30,
              insideShadowColor: [
                Colors.white,
                HexColor.fromHex("#D1D9E6"),
              ],
              alignment: Alignment.center,
              text: StringLocalization.save,
              fontWeight: FontWeight.bold,
              fontsize: 16,
              onTapCallback: () {
                _surveyBloc.add(SaveSurveyEvent());

              },
            ))
          ],
        ),
      ),
    );
  }
}
