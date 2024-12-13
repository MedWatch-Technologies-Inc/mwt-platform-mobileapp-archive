

import 'package:flutter/cupertino.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';

class SpeechTextModel with ChangeNotifier{
  String _speechText = "";
  bool _isListening = false;
  Offset _position = Offset(0.0, 250.0);
  bool showMic = preferences?.getBool(Constants.showMicKey) ?? false;
  bool get isListening => _isListening;

  set isListening(bool value) {
    _isListening = value;
    notifyListeners();
  }

  String get speechText => _speechText;

  set speechText(String value) {
    _speechText = value;
    notifyListeners();
  }

  Offset get position => _position;

  set position(Offset value){
    _position = value;
    notifyListeners();
  }

  void micOnOff(bool value) {
    showMic = value;
    preferences?.setBool(Constants.showMicKey, value);
    notifyListeners();
  }
}