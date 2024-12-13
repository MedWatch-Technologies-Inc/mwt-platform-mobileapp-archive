import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/speech_to_text/model/nlp_speech_event_model.dart';
//import 'package:provider/provider.dart';

import 'package:health_gauge/speech_to_text/model/nlp_tag_option_model.dart';
import 'tag.dart';


class TagListScreenModel extends ChangeNotifier{

  late List<Tag> tagList;

  TagListScreenModel(){
    tagList = [];
  }

  bool isLoading = true;

  void changeLoading(bool value){
    isLoading = value;
    notifyListeners();
  }

  void removeTag(Tag tag, bool mounted){
        tagList.remove(tag);
        if (mounted) notifyListeners();
  }
}