import 'package:flutter/material.dart';
import 'package:health_gauge/screens/survey/widgets/share_survey_pages/share_survey_screen.dart';
import 'package:health_gauge/screens/survey/widgets/take_survey_pages/take_survey_screen.dart';
import 'package:intl/intl.dart';
import '../../../utils/constants.dart';
import '../../../utils/slider/src/widgets/slidable.dart';
import '../../../utils/slider/src/widgets/slidable_action_pane.dart';
import '../../../utils/slider/src/widgets/slide_action.dart';
import '../../../value/app_color.dart';
import '../../../value/string_localization_support/string_localization.dart';
import '../../../widgets/custom_snackbar.dart';
import '../model/surveys.dart';
import '../../../utils/date_utils.dart';
import 'package:clipboard/clipboard.dart';
class SurveyListView extends StatelessWidget{
  SurveyListView(this.surveysList,this._surveyListScrollController,{this.shouldFillSurveyOnTap=true}){
    _slidableController = SlidableController();
  }
 final DateFormat _dateFormatter = DateUtil().getDateFormatter(formatType:DateUtil.yyyyMMdd);
  final ScrollController _surveyListScrollController;
  final List<Data> surveysList;
  late SlidableController _slidableController;
  bool shouldFillSurveyOnTap;
  @override
  Widget build(BuildContext context) {
    if(surveysList.isEmpty){
      return SizedBox.shrink();
    }
    return ListView.builder(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        controller: _surveyListScrollController,
        itemCount: surveysList.length<surveysList.last.totalRecords!?surveysList.length+1:surveysList.length,
        itemBuilder: (BuildContext context,int index){
          if(index>=surveysList.length){
            return Align(child: CircularProgressIndicator(),);
          }
          return GestureDetector(
              onTap: shouldFillSurveyOnTap?() {
                Constants.navigatePush(TakeSurveyScreen(surveysList[index].surveyName,surveysList[index].surveyID), context);
              }:null,
              child: Slidable(
                closeOnScroll: true,
                controller: _slidableController,
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                secondaryActions: <Widget>[
                  IconSlideAction(
                    color: HexColor.fromHex('#FF6259'),
                    onTap: () {

                    },
                    height: 70,
                    topMargin: 16,
                    iconWidget: Text(
                      StringLocalization.of(context)
                          .getText(StringLocalization.delete),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.backgroundColor,
                      ),
                    ),
                    rightMargin: 13,
                    leftMargin: 0,
                  )
                ],
                child: Container(
                  height: 70,
                  margin:
                  EdgeInsets.only(left: 13, right: 13, top: 16),
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
                  child: ListTile(
                    title: Text('${surveysList[index].surveyName}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness ==
                              Brightness.dark
                              ? Colors.white.withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                        )),
                    subtitle: Text('Created At: ${ _dateFormatter.format(DateTime.parse(surveysList[index].createdDatetime))}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness ==
                              Brightness.dark
                              ? Colors.white.withOpacity(0.87)
                              : HexColor.fromHex("#384341"),
                        )),
                    trailing: PopupMenuButton(
                      onSelected: (value){
                        if(value==0){
                          Constants.navigatePush(ShareSurveyScreen(surveysList[index]), context);
                        }
                        print('value  $value');
                      },
                      itemBuilder: (BuildContext context){
                        return [
                         // PopupMenuItem(child: Text('Not answered yet')),
                          PopupMenuItem(
                            enabled: !(surveysList[index].physicalUrl==null || surveysList[index].physicalUrl==''),
                            child: Text('Get link'),
                          onTap: (){
                            if(surveysList[index].physicalUrl!=null || surveysList[index].physicalUrl!='') {
                              FlutterClipboard.copy(
                                  surveysList[index].physicalUrl!).then((
                                  value) =>
                                  print('copied'));
                              CustomSnackBar.buildSnackbar(
                                  context, "Added to Clipboard", 2);
                            }
                            },
                          ),
                          PopupMenuItem(child: Text('Share with people'),
                          value: 0,
                          onTap: () {
                            print("hee");


                          },),
                         // PopupMenuItem(child: Text('Edit survey')),
                         // PopupMenuItem(child: Text('Copy survey')),
                        ];
                      },
                    ),
                  ),
                ),
              ));
        });

  }

}