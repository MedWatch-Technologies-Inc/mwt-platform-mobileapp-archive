import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_bloc.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_states.dart';
import 'package:health_gauge/screens/survey/widgets/create_survey/add_survey_name_widget.dart';
import 'package:health_gauge/screens/survey/widgets/create_survey/add_survey_question_widget.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'package:health_gauge/widgets/text_utils.dart';

import '../../bloc/survey_bloc/survey_events.dart';
import '../../model/create_survey_model.dart';
import '../../survey_ids.dart';
import 'view_summary_widget.dart';

class AddSurveyScreen extends StatefulWidget {
  const AddSurveyScreen({Key? key}) : super(key: key);

  @override
  _AddSurveyScreenState createState() => _AddSurveyScreenState();
}

class _AddSurveyScreenState extends State<AddSurveyScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PageController? _pageController;
  Map<String, dynamic> surveyMapInfo = Map();
  int currentIndex = 0;
  late SurveyBloc _surveyBloc;
  @override
  void initState() {
    super.initState();
    _surveyBloc = BlocProvider.of<SurveyBloc>(context);
    _surveyBloc.surveyModel = CreateSurveyModel();
    _surveyBloc.add(AddQuestionEvent(LstQuestion(questionDesc: '',optionType: SurveyOptionTypes.idBinary.name,questionTypeID: SurveyOptionTypes.idBinary.id)));
    _pageController = PageController();
  }

  @override
  void dispose() {
    _surveyBloc.surveyModel=null;
    _pageController!.dispose();
    super.dispose();
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
                    .getText(StringLocalization.addSurvey),
                fontSize: 18,
                color: HexColor.fromHex("62CBC9"),
                fontWeight: FontWeight.bold,
                align: TextAlign.center,
                minFontSize: 14,
                maxLine: 1,
              ),
              leading: IconButton(
                padding: EdgeInsets.only(left: 10),
                onPressed: onCancelTapCallback,
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
            ),
          )),
      body: BlocListener<SurveyBloc,SurveyState>(
        bloc: _surveyBloc,
        listener: (BuildContext context,SurveyState surveyState){
          if(surveyState is MoveToSurveyNameScreenState){
            changePage(0);
          }else if(surveyState is MoveToAddSurveyQuestionScreenState){
            changePage(1);
          }else if(surveyState is MoveToViewSurveySummeryScreenState){
            changePage(2);
          }
        },
        listenWhen: (prevState,currState){
          return currState is CreateSurveyNavigationState;
        },
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: _onPageViewChange,
          children: [
            AddSurveyNameWidget(
              OnCancelTap: onCancelTapCallback,
            ),
            AddSurveyQuestionWidget(),
            ViewSummaryWidget(popScreen: (){
              if(Navigator.canPop(context)){
                Navigator.pop(context);
              }
            },),
          ],
        ),
      ),
    );
  }

  void changePage(int index) {
    if (_pageController!.hasClients) {
      _pageController!.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void onAddSurveyNameCallback(String name) {
    surveyMapInfo['surveyName'] = name;
    _surveyBloc.add(SetSurveyName(name));
    changePage(currentIndex + 1);
  }


  void onCancelTapCallback() {
    switch (_pageController!.page?.ceil()) {
      case 0:
        if(Navigator.canPop(context)){
          Navigator.pop(context);
        }
        break;
      case 1:
        changePage(0);
        break;
      case 2:
        changePage(1);
        break;
    }
  }

  void _onPageViewChange(int value) {
    currentIndex = value;
  }
}
