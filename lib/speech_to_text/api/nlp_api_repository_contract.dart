

import 'package:health_gauge/speech_to_text/model/nlp_speech_event_model.dart';

abstract class NlpApiRepositoryContract{

  Future<NlpSpeechEventModel> getNlpSpeechEvent(String url, Map<String,String> speechText);

}