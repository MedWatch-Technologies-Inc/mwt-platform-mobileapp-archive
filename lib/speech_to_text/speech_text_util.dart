import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechTextUtil {
//Text to speech variables
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  int resultListened = 0;
  List<LocaleName> _localeNames = [];
  SpeechToText? _speech;
  dynamic? voice;

  Function? _OnSpeechTextCallback;
  Function? _OnSpeechListeningStatusCallback;
  Function? _OnTTSCompletionCallback;

  //Speech to text variables
  FlutterTts? flutterTts;
  dynamic? languages;
  String language = 'en-US';
  double volume = 0.5;
  double pitch = 1;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String newVoiceText = '';

  //  TtsState ttsState = TtsState.stopped;

  //  get isPlaying => ttsState == TtsState.playing;
  //  get isStopped => ttsState == TtsState.stopped;
  //  get isPaused => ttsState == TtsState.paused;
  //  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => Platform.isIOS;
  bool get isAndroid => Platform.isAndroid;
  void loadPreferences() async {

    double vol = preferences?.getDouble('volume') ?? 0.0;
    double rt = preferences?.getDouble('rate') ?? 0.0;
    double pch = preferences?.getDouble('pitch') ?? 0.0;
    String lang = preferences?.getString('language') ?? '';
    String locale = preferences?.getString('localeId') ?? '';
    var voic = preferences?.getString('voice') != null
        ? jsonDecode(preferences?.getString('voice') ?? '')
        : null;

    if (vol != null) volume = vol;
    if (rt != null) rate = rt;
    if (pch != null) pitch = pch;
    if (lang != null) language = lang;
    if (locale != null) _currentLocaleId = locale;
    if (voic != null) voice = voic;
  }

  Future getVoices() async {
    var voices = await flutterTts?.getVoices;
    List<Map<String, String>> voiceOptions = [
      {'voiceName': 'Male', 'name': 'en-us-x-iom-network', 'locale': 'en-US'},
      {'voiceName': 'Female', 'name': 'en-us-x-iol-local', 'locale': 'en-US'}
    ];
    if (voice == null) {
      // for(var i=0;i<voiceOptions.length;i++){
      //   if(voices[i]['locale'] == 'en-US'){
      //     voice = voices[i];
      //
      //     preferences?.setString('voice', jsonEncode(voice));
      //     break;
      //   }
      // }
      voice = voiceOptions[1];
      preferences?.setString('voice', jsonEncode(voice));

    }
  }

  SpeechTextUtil.init(
      {required Function(String) callback, required Function(bool) listenerCallback}) {
    _speech = _speech ?? SpeechToText();
    _OnSpeechTextCallback = callback;
    _OnSpeechListeningStatusCallback = listenerCallback;
    initSpeechState();
    loadPreferences();
    initTts();
    getVoices();
  }

  SpeechTextUtil.initTTS({required Function(bool) onTTSCompletionCallback}) {
    _OnTTSCompletionCallback = onTTSCompletionCallback;
    initTts();
  }

//   SpeechTextUtil.initHandler({Function(bool) onTTSCompletionCallback, Function(String) callback}){
//     _OnTTSCompletionCallback = onTTSCompletionCallback;
//     _OnSpeechTextCallback = callback;
//     initTts();
// }

  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await _speech?.initialize(
          onError: errorListener, onStatus: statusListener, debugLogging: true);
      if (hasSpeech ?? false) {
        var systemLocale = await _speech?.systemLocale();
        _currentLocaleId = systemLocale!.localeId;
        loadPreferences();
      }
      _hasSpeech = hasSpeech ?? false;
    } catch (e) {
      print(e.toString());
    }
  }

  initTts() {
    flutterTts = flutterTts ?? FlutterTts();
    if (isAndroid) {
      _getEngines();
    }

    flutterTts?.setStartHandler(() {
      print("Playing");
      // ttsState = TtsState.playing;
    });

    flutterTts?.setCompletionHandler(() {
      print("Complete");
      if (_OnTTSCompletionCallback != null) _OnTTSCompletionCallback!(true);
      // ttsState = TtsState.stopped;
    });

    flutterTts?.setCancelHandler(() {
      print("Cancel");
      // ttsState = TtsState.stopped;
    });

    if (isIOS) {
      flutterTts?.setPauseHandler(() {
        print("Paused");
        // ttsState = TtsState.paused;
      });

      flutterTts?.setContinueHandler(() {
        print("Continued");
        // ttsState = TtsState.continued;
      });
    }

    flutterTts?.setErrorHandler((msg) {
      print("error: $msg");
      // ttsState = TtsState.stopped;
    });
  }

  Future<void> startListening() async {
    if (!_hasSpeech || _speech!.isListening) {
    } else {
      lastWords = '';
      lastError = '';
      _speech?.listen(
          onResult: resultListener,
          listenFor: Duration(seconds: 6),
          pauseFor: Duration(milliseconds: 3500),
          partialResults: true,
          localeId: _currentLocaleId,
          onSoundLevelChange: soundLevelListener,
          cancelOnError: true,
          listenMode: ListenMode.confirmation);
    }
  }

  Future<void> stopListening() async {
    if (_speech!.isListening) {
      _speech?.stop();
      level = 0.0;
    }
  }

  Future<void> cancelListening() async {
    _speech?.cancel();
    level = 0.0;
  }

  void resultListener(SpeechRecognitionResult result) {
    ++resultListened;
    print('Result listener $resultListened');
    lastWords = '${result.recognizedWords}';
    _OnSpeechTextCallback!(lastWords);
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    this.level = level;
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${_speech?.isListening}");
    lastError = '${error.errorMsg} - ${error.permanent}';
  }

  void statusListener(String status) {
    // print('Received listener status: $status, listening: ${_speech.isListening}');
    _OnSpeechListeningStatusCallback!(_speech?.isListening);
    lastStatus = '$status';
  }

  Future _getEngines() async {
    var engines = await flutterTts?.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print(engine);
      }
    }
  }

  Future speak() async {
    loadPreferences();
    await flutterTts?.setVolume(volume);
    await flutterTts?.setSpeechRate(rate);
    await flutterTts?.setPitch(pitch);
    if (voice != null) {
      flutterTts?.setVoice({"name": voice['name'], "locale": voice['locale']});
    }
    if (isIOS) {
      await flutterTts?.setSharedInstance(true);
      await flutterTts?.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers
      ]);
    }

    if (newVoiceText != null) {
      if (newVoiceText.isNotEmpty) {
        await flutterTts?.awaitSpeakCompletion(true);
        await flutterTts?.speak(newVoiceText);
      }
    }
  }

  Future stop() async {
    var result = await flutterTts?.stop();
    if (result == 1) {
      print('Stop');
    }
    // {ttsState = TtsState.stopped;}
  }

  Future pause() async {
    var result = await flutterTts?.pause();
    if (result == 1) {
      print('Pause');
    }
    // { ttsState = TtsState.paused;}
  }

  void setLanguageForTts(String selectedLanguage) {
    flutterTts?.setLanguage(language);
    if (isAndroid) {
      flutterTts?.isLanguageInstalled(language)
          .then((value) => isCurrentLanguageInstalled = (value as bool));
    }
  }

  Future<void> setAwaitSpeakCompletion(bool flag) async {
    await flutterTts?.awaitSpeakCompletion(flag);
  }
}
