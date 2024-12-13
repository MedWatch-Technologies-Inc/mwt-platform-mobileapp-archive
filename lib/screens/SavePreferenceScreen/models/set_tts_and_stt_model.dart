import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SetTtsAndSttModel with ChangeNotifier {
  double? volume;
  double? pitch;
  double? rate;
  String? selectedLanguage;
  late List<double> volumeList = [];
  late List<double> pitchList = [];
  late List<double> rateList = [];
  List<LocaleName>? localeNames = [];
  List<dynamic>? voices = [];
  bool isLoading = true;
  dynamic? languages;
  FlutterTts? flutterTts;
  SpeechToText? _speech;
  LocaleName? currentLocale;
  dynamic? selectedVoice;
  dynamic? selectNewVoice;
  SharedPreferences? preferences;
  List<Map<String, String>> voiceOptions = [
    {'voiceName': 'Male', 'name': 'en-us-x-iom-network', 'locale': 'en-US'},
    {'voiceName': 'Female', 'name': 'en-us-x-iol-local', 'locale': 'en-US'}
  ];
  bool isEdit = false;

  SetTtsAndSttModel() {
    flutterTts = FlutterTts();
    volumeList = [
      for (double i = 0.0; i <= 1.0; i = i + 0.1)
        double.parse(i.toStringAsFixed(2))
    ];
    pitchList = [
      for (double i = 0.5; i <= 2.0; i = i + 0.1)
        double.parse(i.toStringAsFixed(2))
    ];
    rateList = [
      for (double i = 0.0; i <= 1.0; i = i + 0.1)
        double.parse(i.toStringAsFixed(2))
    ];
    volume = 0.5;
    pitch = 1;
    rate = 0.5;
    _speech = SpeechToText();
    loadPrePreference().then((value) {
      initSpeechState();
      _getLanguages();
      _getVoices();
    });
    Future.delayed(Duration(seconds: 2), () => loadPreferences());
  }

  Future _getLanguages() async {
    languages = await flutterTts?.getLanguages;
    if (languages != null) {
      if (selectedLanguage == null) selectedLanguage = 'en-US';
    }
  }

  Future _getVoices() async {
    voices = await flutterTts?.getVoices;
    if (voices != null) {
      if (selectedVoice == null) selectedVoice = voiceOptions[0];
    }
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await _speech?.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);
    if (hasSpeech ?? false) {
      localeNames = await _speech?.locales();
      var systemLocale = await _speech?.systemLocale();
      changeLocale(systemLocale!);
    }
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
  }

  void statusListener(String status) {
    // print('Received listener status: $status, listening: ${_speech.isListening}');
  }

  void changeVolume(double vol) {
    volume = vol;
    notifyListeners();
  }

  void changePitch(double p) {
    pitch = p;
    notifyListeners();
  }

  void changeRate(double r) {
    rate = r;
    notifyListeners();
  }

  void changeLanguage(String lang) {
    selectedLanguage = lang;
    notifyListeners();
  }

  void changeLocale(LocaleName name) {
    currentLocale = name;
    notifyListeners();
  }

  void changeVoice(dynamic voice) {
    selectedVoice = voice;
    notifyListeners();
  }

  void changeLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  void resetValues() async {
    changeLoading(true);
    changeVolume(0.5);
    changeRate(1.0);
    changePitch(1.0);
    changeLanguage(languages[0]);
    await _speech?.systemLocale().then((value) {
      print(value);
      changeLocale(value!);
    });
    changeVoice(voiceOptions[0]);
    savePreferences();
    changeLoading(false);
  }

  void savePreferences() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    preferences?.setDouble('volume', volume!);
    preferences?.setDouble('rate', rate!);
    // if(selectedVoice is Map){
    //   if(selectedVoice['voiceName'] == 'Male'){
    //     if(pitch > 1.2){
    //       pitch = 1;
    //     }
    //   }else{
    //     if(pitch < 1.2){
    //       pitch = 1.2;
    //     }
    //   }
    // }
    preferences?.setDouble('pitch', pitch!) ;
    preferences?.setString('language', selectedLanguage!);
    preferences?.setString('localeId', currentLocale!.localeId);
    preferences?.setString('voice', jsonEncode(selectedVoice));
  }

  Future<void> loadPrePreference() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    String lang = preferences?.getString('language') ?? '';
    var voic = preferences?.getString('voice') != null
        ? jsonDecode(preferences?.getString('voice') ?? '')
        : null;
    selectedLanguage = lang;
    selectedVoice = voic['name'] == 'en-us-x-iol-local' ? voiceOptions[1] : voiceOptions[0];
  }

  Future<void> loadPreferences() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    double vol = preferences?.getDouble('volume') ?? 0.0;
    double rt = preferences?.getDouble('rate') ?? 0.0;
    double pch = preferences?.getDouble('pitch') ?? 0.0;
    String lang = preferences?.getString('language') ?? '';
    String locale = preferences?.getString('localeId') ?? '';
    var voic = preferences?.getString('voice') != null
        ? jsonDecode(preferences?.getString('voice') ?? '')
        : null;

    if (vol != null) changeVolume(vol);
    if (rt != null) changeRate(rt);
    if (pch != null) changePitch(pch);
    if (lang != null) changeLanguage(lang);
    if (locale != null) {
      var name;
      for (var loc in localeNames!) {
        if (loc.localeId == locale) {
          name = loc;
          break;
        }
      }
      if (name != null) changeLocale(name);
    }
    if (voic != null) {
      var voi;
      for (var vc in voiceOptions) {
        if (voic['name'] == vc['name'] && voic['locale'] == vc['locale']) {
          voi = vc;
          break;
        }
      }
      if (voi != null) changeVoice(voi);
    }
    changeLoading(false);
  }
}
