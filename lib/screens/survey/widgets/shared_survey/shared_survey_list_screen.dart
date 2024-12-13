import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_bloc.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_events.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_states.dart';
import 'package:health_gauge/screens/survey/widgets/surveys_list_view.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import '../../model/surveys.dart';


class SharedSurveyListWidget extends StatefulWidget {
  const SharedSurveyListWidget({Key? key,}):super(key: key);


  @override
  State<SharedSurveyListWidget> createState() => _SharedSurveyListWidgetState();
}

class _SharedSurveyListWidgetState extends State<SharedSurveyListWidget> {
  late SurveyBloc _surveyBloc;
  late ScrollController _surveyListScrollController;
  List<Data> surveysList = [];

  @override
  void initState() {
    super.initState();
    _surveyListScrollController = ScrollController();
    _surveyBloc = BlocProvider.of<SurveyBloc>(context);
    _surveyBloc.add(FetchSurveyListSharedWithMe());
    _surveyListScrollController.addListener(() {
      if(!(_surveyBloc.state is LoadingSurveyState)){
        if(_surveyListScrollController.position.pixels >= _surveyListScrollController.position.maxScrollExtent
            && (surveysList.isNotEmpty&&surveysList.length < surveysList.last.totalRecords!)
        ){
          _surveyBloc.add(FetchSurveyListSharedWithMe(pageNumber:surveysList.last.pageNumber!+1));
        }
      }
    });

  }

  @override
  void dispose() {
    _surveyListScrollController.dispose();
    super.dispose();
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
          return curr is SurveyErrorState || curr is LoadSurveyListSharedWithMeState || curr is LoadingSurveyState || curr is NoSurveyFoundState;
        },
        listener: (BuildContext context,SurveyState state){
          if(state is LoadSurveyListSharedWithMeState){
            if(state.data.data!=null) {
              surveysList.addAll(state.data.data!);
            }
          }
        },
        builder: (BuildContext context,SurveyState state){
          print("SurveyState_00 ${state.toString()}");
          if(state is LoadingSurveyState){
            return Center(child: CircularProgressIndicator(),);
          }else
          if(state is LoadSurveyListSharedWithMeState){
            return SurveyListView(surveysList,_surveyListScrollController);
          }else if(state is NoSurveyFoundState ){
            print("SurveyNoDataState");
            return Center(child: Text(StringLocalization.of(context).getText(StringLocalization.noDataFound),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness ==
                      Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                )),);
          }else if(state is SurveyErrorState){
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
        _surveyBloc.add(FetchSurveyListSharedWithMe());
        return Future.delayed(Duration(milliseconds: 100));
      },
    );
  }
}


