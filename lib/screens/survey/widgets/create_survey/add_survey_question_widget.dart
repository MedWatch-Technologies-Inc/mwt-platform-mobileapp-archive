import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_events.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_states.dart';
import 'package:health_gauge/screens/survey/survey_ids.dart';
import 'package:health_gauge/utils/slider/flutter_slidable.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'package:health_gauge/widgets/gradient_button.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:provider/provider.dart';

import '../../bloc/survey_bloc/survey_bloc.dart';
import '../../model/create_survey_model.dart';
import 'question_form_widget.dart';

class AddSurveyQuestionWidget extends StatefulWidget {
  const AddSurveyQuestionWidget(
      {Key? key,})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddSurveyQuestionWidgetState();
  }
}

class _AddSurveyQuestionWidgetState extends State<AddSurveyQuestionWidget> {

  late SurveyBloc _surveyBloc;
  @override
  void initState() {
    _surveyBloc = BlocProvider.of<SurveyBloc>(context,listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: () {
                _surveyBloc.add(AddQuestionEvent(LstQuestion(questionDesc: '',optionType: SurveyOptionTypes.idBinary.name,questionTypeID: SurveyOptionTypes.idBinary.id)));
              },
              child: Container(
                margin: EdgeInsets.all(16.h),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                height: 60.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HexColor.fromHex("#1FB5AD")),
                child: TitleText(
                  text: "Add Question",
                  fontSize: 16.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BlocBuilder<SurveyBloc,SurveyState>(
                bloc: _surveyBloc,
                buildWhen: (SurveyState oldState,SurveyState currState){
                  return currState is AddedSurveyQuestionState
                      || currState is RemovedSurveyQuestionState
                      || currState is SavedSurveyQuestionDataState;
                },
              builder: (BuildContext context, SurveyState state) {
                return Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        LstQuestion model =
                        _surveyBloc.surveyModel!.lstQuestion![index];
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: InkWell(
                            onTap: () {
                              showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: MaterialLocalizations.of(context)
                                      .modalBarrierDismissLabel,
                                  barrierColor: Colors.black45,
                                  transitionDuration:
                                  const Duration(milliseconds: 200),
                                  pageBuilder: (BuildContext buildContext,
                                      Animation animation,
                                      Animation secondaryAnimation) {
                                    return QuestionFormWidget(
                                        questionIndex: index,);
                                  });
                            },
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                      Brightness.dark
                                      ? HexColor.fromHex("#111B1A")
                                      : AppColor.backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? HexColor.fromHex("#D1D9E6")
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
                                          : HexColor.fromHex("#9F2DBC")
                                          .withOpacity(0.15),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                      offset: Offset(4, 4),
                                    ),
                                  ]),
                              margin: EdgeInsets.fromLTRB(
                                  13,
                                  18,
                                  13,
                                  index == _surveyBloc.surveyModel!.lstQuestion!.length-1
                                      ? 18
                                      : 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                        Brightness.dark
                                        ? HexColor.fromHex("#111B1A")
                                        : AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                              ? HexColor.fromHex("#9F2DBC")
                                              .withOpacity(0.15)
                                              : HexColor.fromHex("#D1D9E6")
                                              .withOpacity(0.5),
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                              ? HexColor.fromHex("#9F2DBC")
                                              .withOpacity(0)
                                              : HexColor.fromHex("#FFDFDE")
                                              .withOpacity(0),
                                        ])),
                                child: ListTile(
                                  leading: Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: HexColor.fromHex("#61CBC9"),
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${model.optionType}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).brightness ==
                                            Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex("#384341")),
                                  ),
                                  title: Text(
                                    '${model.questionDesc!.isEmpty?'Question #$index':model.questionDesc}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).brightness ==
                                            Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex("#384341")),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () async {
                                _surveyBloc.add(RemoveQuestion(index));
                              },
                              topMargin: 25,
                              height: 70,
                              leftMargin: 13,
                              rightMargin: 13,
                            ),
                          ],
                        );
                      },
                      itemCount: _surveyBloc.surveyModel?.lstQuestion?.length??0),
                );
              }
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GradientButton(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.3,
                    backgroundColor: HexColor.fromHex("#00AFAA"),
                    borderRadius: 30,
                    insideShadowColor: [
                      Colors.white,
                      HexColor.fromHex("#D1D9E6"),
                    ],
                    alignment: Alignment.center,
                    text: StringLocalization.backText,
                    fontWeight: FontWeight.bold,
                    fontsize: 16,
                    onTapCallback: (){
                      _surveyBloc.add(MoveToSurveyNameScreenEvent());
                    },
                  ),
                  GradientButton(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.3,
                    backgroundColor: HexColor.fromHex("#00AFAA"),
                    borderRadius: 30,
                    insideShadowColor: [
                      Colors.white,
                      HexColor.fromHex("#D1D9E6"),
                    ],
                    alignment: Alignment.center,
                    text: StringLocalization.next,
                    fontWeight: FontWeight.bold,
                    fontsize: 16,
                    onTapCallback: ()  {
                      if(canMoveNext()) {
                        _surveyBloc.add(MoveToViewSurveySummeryScreenEvent());
                      }else{
                        Fluttertoast.showToast(msg: 'Empty Fields in question.',toastLength: Toast.LENGTH_SHORT);
                      }
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 10,)
          ],
        );
  }

  bool canMoveNext(){
    bool isValid = true;
    for(LstQuestion question in _surveyBloc.surveyModel!.lstQuestion!){
      if(!isQuestionDataValid(question)){
        isValid=false;
        break;
      }
    }
     return isValid;
  }

  bool isQuestionDataValid(LstQuestion question){
    if(question.questionDesc!=null && question.questionDesc!.isNotEmpty){
      if(question.questionTypeID != SurveyOptionTypes.idNote.id) {
        for (var options in question.lstOptions!) {
          if (options.optionDesc == null || options.optionDesc!.isEmpty) {
            return false;
          }
        }
      }
    }else{
      return false;
    }
    return true;
  }
}
