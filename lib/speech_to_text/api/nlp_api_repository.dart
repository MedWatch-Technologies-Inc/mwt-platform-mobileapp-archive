
import 'dart:convert';
import 'dart:io';

import 'package:health_gauge/speech_to_text/api/nlp_api_repository_contract.dart';
import 'package:health_gauge/speech_to_text/model/nlp_speech_event_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:http/http.dart';

class NlpApiRepository extends NlpApiRepositoryContract{

  @override
  Future<NlpSpeechEventModel> getNlpSpeechEvent(String url, Map<String,String> jsonData) async {
    try{
      Constants.header["Content-Type"] = "application/json";
    dynamic request = JsonEncoder().convert(jsonData);
      final Response response = await post(Uri.parse(url), headers: Constants.header, body:request);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        NlpSpeechEventModel eventDataModel  = NlpSpeechEventModel.fromJson(data);
        return eventDataModel;
      } else {
        return NlpSpeechEventModel();
      }
    }catch(e){
      print(e);
      return NlpSpeechEventModel();
    }

  }

}