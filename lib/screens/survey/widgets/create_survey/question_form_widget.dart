import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_events.dart';
import 'package:health_gauge/screens/survey/bloc/survey_bloc/survey_states.dart';
import 'package:health_gauge/screens/survey/model/create_survey_model.dart';
import 'package:health_gauge/screens/survey/survey_ids.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';

import 'package:health_gauge/widgets/text_utils.dart';
import '../../../../utils/slider/src/widgets/slidable.dart';
import '../../../../utils/slider/src/widgets/slidable_action_pane.dart';
import '../../../../utils/slider/src/widgets/slide_action.dart';
import '../../../../widgets/gradient_button.dart';
import '../../bloc/survey_bloc/survey_bloc.dart';

class QuestionFormWidget extends StatefulWidget {
  final int questionIndex;

  const QuestionFormWidget({
    Key? key,
    required this.questionIndex,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QuestionFormWidgetState();
  }
}

class _QuestionFormWidgetState extends State<QuestionFormWidget> {
  final _questionNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  LstQuestion? _originalQuestion;
  late SurveyBloc _surveyBloc;
  ///[prevQueId] is used to keep
  /// track of the question id's so
  /// that when the user select the
  /// same question type it can preserve its state.
  late int prevQueId;
  @override
  void initState() {
    super.initState();
    _surveyBloc = BlocProvider.of<SurveyBloc>(context);
    _originalQuestion =
        _surveyBloc.surveyModel!.lstQuestion![widget.questionIndex];
    prevQueId = _originalQuestion!.questionTypeID!;
    _questionNameController.text = _originalQuestion?.questionDesc ?? '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.5)
                      : HexColor.fromHex('#384341').withOpacity(0.2),
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
                      .getText(StringLocalization.addQuestion),
                  fontSize: 18,
                  color: HexColor.fromHex('62CBC9'),
                  fontWeight: FontWeight.bold,
                  align: TextAlign.center,
                  minFontSize: 14,
                  maxLine: 1,
                ),
                leading: IconButton(
                  padding: EdgeInsets.only(left: 10),
                  onPressed: () {
                    _surveyBloc.add(SaveQuestionDataEvent(widget.questionIndex, _originalQuestion!));
                    Navigator.pop(context);
                  },
                  icon: Theme.of(context).brightness == Brightness.dark
                      ? Image.asset(
                          'asset/dark_leftArrow.png',
                          width: 13,
                          height: 22,
                        )
                      : Image.asset(
                          'asset/leftArrow.png',
                          width: 13,
                          height: 22,
                        ),
                ),
              ),
            )),
        body: BlocBuilder<SurveyBloc, SurveyState>(
            bloc: _surveyBloc,
            buildWhen: (prevState, currState) {
              return currState is UpdatedSurveyQuestionState ;
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextFormField(
                        style: TextStyle(fontSize: 16.h),
                        controller: _questionNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter question';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _originalQuestion!.questionDesc = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Please enter here',
                          labelText: 'Question #${widget.questionIndex}',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: GradientButton(
                          height: 40,
                          width: double.maxFinite,
                          backgroundColor: HexColor.fromHex("#00AFAA"),
                          borderRadius: 30,
                          insideShadowColor: [
                            Colors.white,
                            HexColor.fromHex("#D1D9E6"),
                          ],
                          alignment: Alignment.center,
                          text: StringLocalization.of(context).getTextFromEnglish(
                              StringLocalization.changeQuestionType),
                          fontWeight: FontWeight.bold,
                          fontsize: 16,
                          onTapCallback: () {
                            questionsTypeDialog();
                          },
                        ),
                      ),
                      Expanded(child: getQuestionTypeWidgets(_originalQuestion!.questionTypeID!,prevQueId)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: GradientButton(
                          height: 40,
                          width: double.maxFinite,
                          backgroundColor: HexColor.fromHex("#00AFAA"),
                          borderRadius: 30,
                          insideShadowColor: [
                            Colors.white,
                            HexColor.fromHex("#D1D9E6"),
                          ],
                          alignment: Alignment.center,
                          text: StringLocalization.of(context).getTextFromEnglish(
                              StringLocalization.save),
                          fontWeight: FontWeight.bold,
                          fontsize: 16,
                          onTapCallback: () {
                            String message = validateTheData(_originalQuestion!);
                            if(message.isEmpty){
                              Navigator.pop(this.context);
                              _surveyBloc.add(SaveQuestionDataEvent(widget.questionIndex, _originalQuestion!));
                            }else{
                              Fluttertoast.showToast(msg: message,toastLength: Toast.LENGTH_SHORT);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
  String validateTheData(LstQuestion question){
    if(question.questionDesc!=null && question.questionDesc!.isNotEmpty){
      if(question.questionTypeID != SurveyOptionTypes.idNote.id) {
        for (var options in question.lstOptions!) {
          if (options.optionDesc == null || options.optionDesc!.isEmpty) {
            return 'Option desc can\'t be empty ';
          }
        }
      }
    }else{
      return 'Question desc can\'t be empty ';
    }
    return '';
  }

  void questionsTypeDialog() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(Duration(milliseconds: 100));
    Pair selectedRadio = Pair(
        _originalQuestion!.questionTypeID!, _originalQuestion!.optionType!);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return CustomChildDialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Choose Question Type'),
                  ...SurveyOptionTypes.optionTypes.map((element) {
                    return RadioListTile(
                        title: Text(element.name),
                        value: element.id,
                        groupValue: selectedRadio.id,
                        onChanged: (value) {
                          selectedRadio = element;
                          setState(() {});
                        });
                  }).toList(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: GradientButton(
                      height: 40.h,
                      width: 70.w,
                      backgroundColor: HexColor.fromHex("#00AFAA"),
                      borderRadius: 30,
                      insideShadowColor: [
                        Colors.white,
                        HexColor.fromHex("#D1D9E6"),
                      ],
                      alignment: Alignment.center,
                      text: StringLocalization.of(context)
                          .getTextFromEnglish(StringLocalization.ok),
                      fontWeight: FontWeight.bold,
                      fontsize: 16,
                      onTapCallback: () {
                        prevQueId = _originalQuestion!.questionTypeID!;
                        _originalQuestion!.questionTypeID = selectedRadio.id;
                        _originalQuestion!.optionType = selectedRadio.name;
                        _surveyBloc.add(EditQuestionEvent(
                            widget.questionIndex, _originalQuestion!));
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  Widget getQuestionTypeWidgets(int questionId,int prevQuestionId) {
    if (questionId == SurveyOptionTypes.idBinary.id) {
      if(prevQueId !=questionId || _originalQuestion?.lstOptions == null) {
        _originalQuestion!.lstOptions = [LstOptions(), LstOptions()];
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            maxLines: 1,
            controller: TextEditingController(text: _originalQuestion!.lstOptions![0].optionDesc),
            maxLength: 20,
            onChanged: (String text) {
              _originalQuestion!.lstOptions![0].optionDesc = text;
            },
            decoration: InputDecoration(
              constraints: BoxConstraints(maxHeight: 60),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor.fromHex("#00AFAA")),
                  borderRadius: BorderRadius.circular(10)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(10)),
              hintStyle: TextStyle(fontSize: 12),
              hintText: 'Yes',
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            maxLines: 1,
            maxLength: 20,
            controller: TextEditingController(text: _originalQuestion!.lstOptions![1].optionDesc),
            onChanged: (String text) {
              _originalQuestion!.lstOptions![1].optionDesc = text;
            },
            decoration: InputDecoration(
                constraints: BoxConstraints(maxHeight: 60),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor.fromHex("#00AFAA")),
                    borderRadius: BorderRadius.circular(10)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(10)),
                hintStyle: TextStyle(fontSize: 12),
                hintText: 'No'),
          ),
        ],
      );
    } else if (questionId == SurveyOptionTypes.idSlider.id) {
      if(prevQueId != questionId || _originalQuestion?.lstOptions == null) {
        _originalQuestion!.lstOptions =
        [LstOptions(), LstOptions(), LstOptions()];
      }
      return SliderWidget(options:_originalQuestion!.lstOptions!,);
    } else if (questionId == SurveyOptionTypes.idNote.id) {
      _originalQuestion!.lstOptions=null;
      return SizedBox.shrink();
    } else {
      if(prevQueId !=questionId || _originalQuestion?.lstOptions == null) {
        _originalQuestion!.lstOptions = [];
      }
      return MultipleChoiceWidget(options:_originalQuestion!.lstOptions!,);
    }
  }
}

class SliderWidget extends StatelessWidget {
  const SliderWidget({required this.options,Key? key}) : super(key: key);
  final List<LstOptions> options;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 5,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.4),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.outer)
              ],
              borderRadius: BorderRadius.circular(9)),
        ),
        SizedBox(
          height: 10,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VerticalDivider(
                color: Colors.black26,
                thickness: 1,
              ),
              VerticalDivider(
                color: Colors.black26,
                thickness: 1,
              ),
              VerticalDivider(
                color: Colors.black26,
                thickness: 1,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                maxLines: 1,
                controller: TextEditingController(text: options[0].optionDesc),
                onChanged: (String text) {
                  options[0].optionDesc = text;
                },
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 12),
                    constraints: BoxConstraints(maxWidth: 45),
                    hintText: 'Label 1'),
              ),
              TextField(
                maxLines: 1,
                controller: TextEditingController(text: options[1].optionDesc),
                onChanged: (String text) {
                  options[1].optionDesc = text;
                },
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    focusColor: Colors.grey,
                    hintStyle: TextStyle(fontSize: 12),
                    constraints: BoxConstraints(maxWidth: 45),
                    hintText: 'Label 2'),
              ),
              TextField(
                maxLines: 1,
                controller: TextEditingController(text: options[2].optionDesc),
                onChanged: (String text) {
                  options[2].optionDesc = text;
                },
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    helperMaxLines: 1,
                    hintStyle: TextStyle(fontSize: 12),
                    constraints: BoxConstraints(maxWidth: 45),
                    hintText: 'Label 3'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MultipleChoiceWidget extends StatefulWidget {
  final List<LstOptions> options;
  const MultipleChoiceWidget({required this.options,Key? key}) : super(key: key);
  @override
  State<MultipleChoiceWidget> createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    if(widget.options.isEmpty) {
      widget.options.add(LstOptions());
      widget.options.add(LstOptions());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 5),
        itemCount: widget.options.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index >= widget.options.length) {
            return Container(
              margin: EdgeInsets.only(left: 10, top: 5, bottom: 20),
              height: 50,
              child: TextButton(
                onPressed: () {
                  widget.options.add(LstOptions());
                  setState(() {});
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent+60);
                },
                 child: Text('Add More',),
              ),
            );
          }
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                  color:
                      Theme.of(context).brightness == Brightness.dark
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
              margin:
                  EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness ==
                            Brightness.dark
                        ? HexColor.fromHex('#111B1A')
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
                    child: Material(
                      color: Colors.transparent,
                      elevation: 2,
                      shadowColor: Colors.grey.withOpacity(0.1),
                      child: Icon(
                        Icons.radio_button_checked_sharp,
                        color: HexColor.fromHex("#00AFAA"),
                      ),
                    ),
                  ),
                  title: TextField(
                    maxLines: 1,
                    controller: TextEditingController(text: widget.options[index].optionDesc),
                    onChanged: (String text) {
                      widget.options[index].optionDesc = text;
                    },
                    decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 15),
                        hintText: 'Option ${index+1}'),
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
                  widget.options.removeAt(index);
                  setState(() {});
                },
                topMargin: 25,
                height: 70,
                leftMargin: 13,
                rightMargin: 13,
              ),
            ],
          );
        });
  }
}
