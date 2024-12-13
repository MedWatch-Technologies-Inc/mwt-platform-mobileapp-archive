


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_events.dart';
import 'package:health_gauge/screens/survey/widgets/take_survey_pages/take_survey_question_list.dart';

import '../../../../value/app_color.dart';
import '../../../../value/string_localization_support/string_localization.dart';
import '../../../../widgets/text_utils.dart';
import '../../bloc/survey_bloc/survey_bloc.dart';
import '../../bloc/survey_bloc/survey_states.dart';

class TakeSurveyScreen extends StatefulWidget{
  final surveyName;
  final surveyId;
  TakeSurveyScreen(this.surveyName,this.surveyId);
  @override
  State<StatefulWidget> createState() {
   return _TakeSurveyScreenState();
  }

}

class _TakeSurveyScreenState extends State<TakeSurveyScreen>{

  late SurveyBloc _surveyBloc;

  @override
  void initState(){
    _surveyBloc = BlocProvider.of<SurveyBloc>(context);
    _surveyBloc.add(GetSurveyDetailBySurveyIDEvent(widget.surveyId));
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
                text: widget.surveyName??"",
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
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.check),
                  color: HexColor.fromHex("#61CBC9"),
                  tooltip: 'Show Snackbar',
                  onPressed: () {

                  },
                ),
              ],
            ),
          )),
         // body :TakeSurveyQuestionListScreen()
          body: BlocConsumer<SurveyBloc,SurveyState>(
            bloc: _surveyBloc,
            listener: (BuildContext context,SurveyState state){
              if(state is LoadSurveyDetailBySurveyIdState){

              }
            },
            builder: (BuildContext context,SurveyState state){
              if(state is LoadingSurveyState){
                return Center(child: CircularProgressIndicator(),);
              }
              else
              if(state is SurveyDetailEmptyState){
                return  Center(
                  child: Text(StringLocalization.of(context).getText(StringLocalization.noDataFound),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness ==
                          Brightness.dark
                          ? Colors.white.withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                    )),);
                // return SurveyListView(surveysList,_surveyListScrollController);
              }
              else
              if(state is LoadSurveyDetailBySurveyIdState){
                return TakeSurveyQuestionListScreen();
                // return SurveyListView(surveysList,_surveyListScrollController);
              }else if(state is SurveyDetailErrorState){
                return Center(child: Text(StringLocalization.of(context).getText(StringLocalization.somethingWentWrong),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness ==
                          Brightness.dark
                          ? Colors.white.withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                    )),);
              }
              return Container();
            },
          ),
    );
  }
}