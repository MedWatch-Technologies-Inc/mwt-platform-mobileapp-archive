import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/survey/bloc/survey_home_bloc/survey_home_events.dart';
import 'package:health_gauge/screens/survey/bloc/survey_home_bloc/survey_home_states.dart';
import 'package:health_gauge/screens/survey/widgets/saved_survey/saved_survey_widget.dart';
import 'package:health_gauge/screens/survey/widgets/shared_survey/shared_survey_list_screen.dart';
import '../../../utils/constants.dart';
import '../../../value/app_color.dart';
import '../../../value/string_localization_support/string_localization.dart';
import '../../../widgets/text_utils.dart';
import '../../Library_changes/widgets/libraryDrawerItems.dart';
import '../bloc/survey_home_bloc/survey_home_bloc.dart';
import 'create_survey/add_survey_screen.dart';

class SurveyHomeScreen extends StatefulWidget {
  const SurveyHomeScreen({Key? key}) : super(key: key);

  @override
  _SurveyHomeScreenState createState() => _SurveyHomeScreenState();
}

class _SurveyHomeScreenState extends State<SurveyHomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late SurveyHomeBloc _surveyHomeBloc;

  @override
  void initState() {
    _surveyHomeBloc = BlocProvider.of<SurveyHomeBloc>(context);
    _surveyHomeBloc.add(MoveToSavedSurveyEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SurveyHomeBloc,SurveyHomeStates>(
      bloc: _surveyHomeBloc,
      listener: (BuildContext context,SurveyHomeStates state){
        if(state is ChangeHomeScreenWidget && state.screenName==StringLocalization.create){
          Constants.navigatePush(AddSurveyScreen(), context);
          _surveyHomeBloc.add(MoveToSavedSurveyEvent());
        }
      },
      buildWhen: (SurveyHomeStates prevState,SurveyHomeStates currState){
        //Build only when shared and saved survey screen is required.
        return (currState is  ChangeHomeScreenWidget &&
            (currState.screenName == StringLocalization.sharedSurvey
                ||currState.screenName == StringLocalization.savedSurvey));
      },
      builder: (BuildContext context,SurveyHomeStates state){
        return SafeArea(
          child: Scaffold(
              endDrawer: Container(
                  width: 220.w,
                  child: Drawer(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColor.darkBackgroundColor
                          : AppColor.backgroundColor,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                _surveyHomeBloc.add(MoveToCreateSurveyEvent());
                                Navigator.pop(context);
                              },
                              child: LibraryDrawerItems(
                                  title: StringLocalization.create,
                                  icon: Icons.insert_drive_file,
                                  iconPath: 'asset/inbox_icon.png',
                                  selectedItem:StringLocalization.of(context).getText((state as ChangeHomeScreenWidget).screenName))),
                          GestureDetector(
                              onTap: () {
                                _surveyHomeBloc.add(MoveToSharedSurveyEvent());
                                Navigator.pop(context);
                              },
                              child: LibraryDrawerItems(
                                  icon: Icons.share,
                                  title: StringLocalization.sharedSurvey,
                                  iconPath: 'asset/sent.png',
                                  selectedItem: StringLocalization.of(context).getText((state).screenName))),
                          GestureDetector(
                              onTap: () {
                                _surveyHomeBloc.add(MoveToSavedSurveyEvent());
                                Navigator.pop(context);
                              },
                              child: LibraryDrawerItems(
                                  icon: Icons.save,
                                  title: StringLocalization.savedSurvey,
                                  iconPath: 'asset/draft.png',
                                  selectedItem: StringLocalization.of(context).getText((state).screenName))),
                        ],
                      ),
                    ),
                  )),
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
                            .getText((state as ChangeHomeScreenWidget).screenName),
                        fontSize: 18,
                        color: HexColor.fromHex("62CBC9"),
                        fontWeight: FontWeight.bold,
                        align: TextAlign.center,
                        minFontSize: 14,
                        maxLine: 1,
                      ),
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
                        Builder(
                            builder: (context) {
                              return IconButton(
                                padding: EdgeInsets.only(right: 15),
                                icon: Theme.of(context).brightness == Brightness.dark
                                    ? Image.asset(
                                  "asset/dark_dots.png",
                                  width: 33,
                                  height: 28,
                                )
                                    : Image.asset(
                                  'asset/dots.png',
                                  width: 33,
                                  height: 28,
                                ),
                                onPressed: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                              );
                            }
                        )
                      ],
                    ),
                  )),
              body:getBodyWidget(state)
          ),
        );

      },);

  }
  Widget getBodyWidget(SurveyHomeStates state){
    if(state is ChangeHomeScreenWidget){
      if(state.screenName == StringLocalization.sharedSurvey){
        return SharedSurveyListWidget();
      }else{
        return SavedSurveyWidget();
      }
    }
    return Container();
  }
}
