import 'package:flutter/material.dart';
import 'package:health_gauge/models/tag.dart';

class NlpOptions{
  String? optionString;
  Tag? tag;

  NlpOptions({this.optionString,this.tag});
}

class NlpTagOptionModel with ChangeNotifier{
  List<NlpOptions> optionList = [];
  bool showList = false;
  List<Tag> tagList = [];

  void changeVisibility(bool v){
    showList = v;
    notifyListeners();
  }

  void fillTagList(List<Tag> tags){
    tagList = tags;
    optionList = [
      NlpOptions(optionString:'I have stress.', tag: tagList[0]),
      NlpOptions(optionString:'I am tired today',tag: tagList[1] ),
      NlpOptions(optionString:'I have high blood glucose', tag: tagList[2]),
      NlpOptions(optionString:'I exercised today', tag: tagList[3]),
      NlpOptions(optionString:'My temperature is 30 degree celsius today.', tag: tagList[4]),
      NlpOptions(optionString:'I took a pill today', tag: tagList[5]),
      NlpOptions(optionString:'I have symptoms of covid 19', tag: tagList[6]),
      NlpOptions(optionString:'I have a smoke today', tag: tagList[7]),
      NlpOptions(optionString:'I have alcohol today', tag: tagList[8]),
    ];
  }
}