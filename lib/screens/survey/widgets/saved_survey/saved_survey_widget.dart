import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../value/app_color.dart';
import '../../../../value/string_localization_support/string_localization.dart';
import '../../bloc/survey_bloc/survey_bloc.dart';
import '../../bloc/survey_bloc/survey_events.dart';
import '../../bloc/survey_bloc/survey_states.dart';
import '../../model/surveys.dart';
import '../surveys_list_view.dart';

class SavedSurveyWidget extends StatefulWidget {
  const SavedSurveyWidget({Key? key}) : super(key: key);

  @override
  State<SavedSurveyWidget> createState() => _SavedSurveyWidgetState();
}

class _SavedSurveyWidgetState extends State<SavedSurveyWidget> {
  late SurveyBloc _surveyBloc;
  late ScrollController _surveyListScrollController;
  List<Data> surveysList = [];

  @override
  void initState() {
    super.initState();
    _surveyListScrollController = ScrollController();
    _surveyBloc = BlocProvider.of<SurveyBloc>(context);
    _surveyBloc.add(FetchSurveyListByUserIdEvent());
    _surveyListScrollController.addListener(() {
      if(!(_surveyBloc.state is LoadingSurveyState)){
        if(_surveyListScrollController.position.pixels >= _surveyListScrollController.position.maxScrollExtent
            && (surveysList.isNotEmpty&&surveysList.length < surveysList.last.totalRecords!)
        ){
          _surveyBloc.add(FetchSurveyListByUserIdEvent(pageNumber:surveysList.last.pageNumber!+1));
        }
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: BlocConsumer<SurveyBloc,SurveyState>(
        bloc: _surveyBloc,
        buildWhen: (SurveyState prev,SurveyState curr){
          if(curr is LoadingSurveyState && surveysList.isNotEmpty){
            return false;
          }
          return curr is SurveyErrorState || curr is LoadSurveyListByUserIdState || curr is LoadingSurveyState || curr is NoSurveyFoundState;
        },
        listener: (BuildContext context,SurveyState state){
          if(state is LoadSurveyListByUserIdState){
            if(state.data.data!=null) {
              surveysList.addAll(state.data.data!);
            }
          }
        },
        builder: (BuildContext context,SurveyState state){

          print("survay_state_widget ${state.toString()}");
          if(state is LoadingSurveyState){
            return Center(child: CircularProgressIndicator(),);
          }else
          if(state is LoadSurveyListByUserIdState){
            return SurveyListView(surveysList,_surveyListScrollController,shouldFillSurveyOnTap: false,);
          }else if(state is NoSurveyFoundState){
            return Center(child: Text(StringLocalization.of(context).getText(StringLocalization.noDataFound),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness ==
                      Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                )),);
          } else if(state is SurveyErrorState){
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
      onRefresh: (){
        surveysList.clear();
        _surveyBloc.add(FetchSurveyListByUserIdEvent());
        return Future.delayed(Duration(milliseconds: 100));
      },
    );
  }
}
