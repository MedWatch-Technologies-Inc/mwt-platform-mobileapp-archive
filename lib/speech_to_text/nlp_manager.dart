import 'package:flutter/cupertino.dart';

import 'model/nlp_bloc_model.dart';
import 'model/nlp_speech_event_model.dart';

class NlpManager{

  NlpSpeechEventModel? nlpSpeechEventModel;
  NlpBlocModel? nlpBlocModel;
  NlpOperation? nlpIntent;
  
  NlpManager._init();

  static Future<NlpManager> initialHandling(
      NlpSpeechEventModel nlpSpeechModel) async {
    var manager = NlpManager._init();
    if (nlpSpeechModel != null) {
      manager._intentHandling(nlpSpeechModel);
      manager.nlpSpeechEventModel = nlpSpeechModel;
    }
    return manager;
  }


  void _intentHandling(NlpSpeechEventModel model) {
    if(model.operation!.toLowerCase() == "tag"){
      nlpIntent = NlpOperation.TAG;
      nlpBlocModel = NlpBlocModel(goToTag: true,operationModel: model);
    }
  }


}

enum NlpOperation{
  TAG,MEASUREMENT
}