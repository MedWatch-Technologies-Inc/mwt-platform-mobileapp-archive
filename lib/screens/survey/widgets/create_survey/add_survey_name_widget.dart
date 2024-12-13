import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_events.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_states.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/CustomCalendar/date_picker_dialog.dart';
import 'package:health_gauge/widgets/gradient_button.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

import '../../../../utils/date_utils.dart';
import '../../bloc/survey_bloc/survey_bloc.dart';

class AddSurveyNameWidget extends StatefulWidget {
  final Function OnCancelTap;

  const AddSurveyNameWidget(
      {Key? key, required this.OnCancelTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddSurveyNameWidgetState();
  }
}

class _AddSurveyNameWidgetState extends State<AddSurveyNameWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController addInfoController = TextEditingController();
  late SurveyBloc _surveyBloc;
  final DateTime _currDateTime = DateTime.now();
  late DateFormat _dateFormatter;
  @override
  void initState() {
    super.initState();
    _dateFormatter = DateUtil().getDateFormatter(formatType: DateUtil.ddMMMMyyyy);
    _surveyBloc = BlocProvider.of<SurveyBloc>(context,listen: false);
    addInfoController.text = _surveyBloc.surveyModel?.surveyName??'';
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical:16.h),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            height: 60.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: HexColor.fromHex("#1FB5AD")),
            child: TitleText(
                text: 'Add Survey Name',
                fontSize: 16.h,
                fontWeight: FontWeight.bold),
          ),
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(vertical:15.h),
              child: TextFormField(
                style: TextStyle(fontSize: 18.h),
                controller: addInfoController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter name';
                  }
                  FocusScope.of(context).unfocus();
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Please enter here",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
            ),
          ),
          BlocBuilder<SurveyBloc,SurveyState>(
            bloc: _surveyBloc,
            buildWhen: (prevState,currState){
              return currState is UpdatedSurveyStartDateState
                  || currState is UpdatedSurveyEndDateState;
            },
            builder: (BuildContext context,SurveyState state){
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('${StringLocalization.of(context).getText(StringLocalization.startDate)}',
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness ==
                                    Brightness.dark
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                              )),
                        ),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                                onTap: ()async{
                                  DateTime? startDateTime = await showCustomDatePicker(context: context, initialDate: _currDateTime, firstDate: _currDateTime, lastDate: _currDateTime.add(Duration(days: 365*2)), getDatabaseDataFrom: '');
                                  if(startDateTime!=null){
                                    startDateTime = DateTime(startDateTime.year,startDateTime.month,startDateTime.day);
                                    int? endDate = int.tryParse(_surveyBloc.surveyModel?.endDateTimeStamp??'');
                                    if(endDate!=null && DateTime.fromMillisecondsSinceEpoch(endDate).isBefore(startDateTime)){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('End date should be after start date.')));
                                    }else {
                                      _surveyBloc.add(
                                          UpdateSurveyStartDateEvent(
                                              startDateTime));
                                    }
                                  }
                                },
                                child: _surveyBloc.surveyModel?.startDateTimeStamp == null?Icon(Icons.calendar_today,size: 20.h,):
                                Text('${_dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_surveyBloc.surveyModel!.startDateTimeStamp!)))}',
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? Colors.white.withOpacity(0.87)
                                          : HexColor.fromHex('#384341'),
                                    )),)),
                        Expanded(
                            flex: 1,
                            child: _surveyBloc.surveyModel?.startDateTimeStamp == null?Icon(Icons.error_outline,color: Colors.redAccent,size: 16):Icon(Icons.check,color: Colors.green,size: 16,)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('${StringLocalization.of(context).getText(StringLocalization.endDate)}',
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness ==
                                    Brightness.dark
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                              )),
                        ),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                                onTap: ()async{
                                  DateTime? endDateTime = await showCustomDatePicker(context: context, initialDate: _currDateTime, firstDate: _currDateTime, lastDate: _currDateTime.add(Duration(days: 365*2)), getDatabaseDataFrom: '');
                                  if(endDateTime!=null){
                                    endDateTime = DateTime(endDateTime.year,endDateTime.month,endDateTime.day,23,59,59);
                                    int? startDate = int.tryParse(_surveyBloc.surveyModel?.startDateTimeStamp??'');
                                    if(startDate!=null && DateTime.fromMillisecondsSinceEpoch(startDate).isAfter(endDateTime)){
                                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('End date should be after start date.')));
                                    }else {
                                      _surveyBloc.add(UpdateSurveyEndDateEvent(
                                          endDateTime));
                                    }
                                  }
                                },
                                child: _surveyBloc.surveyModel?.endDateTimeStamp == null?Icon(Icons.calendar_today,size: 20.h,):
                                Text('${_dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_surveyBloc.surveyModel!.endDateTimeStamp!)))}',
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? Colors.white.withOpacity(0.87)
                                          : HexColor.fromHex('#384341'),
                                    )),)),
                        Expanded(
                            flex: 1,
                            child: _surveyBloc.surveyModel?.endDateTimeStamp == null?Icon(Icons.error_outline,color: Colors.redAccent,size: 16):Icon(Icons.check,color: Colors.green,size: 16,)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
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
                  text: StringLocalization.cancel,
                  fontWeight: FontWeight.bold,
                  fontsize: 16,
                  onTapCallback: (){widget.OnCancelTap();},
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
                  onTapCallback: () {
                    if (_formKey.currentState!.validate())
                      {
                        _surveyBloc.add(SetSurveyName(addInfoController.value.text));
                        if(_surveyBloc.surveyModel?.startDateTimeStamp==null ||_surveyBloc.surveyModel?.endDateTimeStamp==null ){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select start and end date.')));
                        }else{
                          _surveyBloc.add(MoveToAddSurveyQuestionScreenEvent());
                        }

                      }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
