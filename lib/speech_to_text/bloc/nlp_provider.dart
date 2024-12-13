import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/speech_to_text/api/nlp_api_repository_contract.dart';
import 'package:health_gauge/speech_to_text/bloc/nlp_event.dart';
import 'package:health_gauge/speech_to_text/bloc/nlp_state.dart';
import 'package:health_gauge/speech_to_text/model/nlp_speech_event_model.dart';
import 'package:health_gauge/speech_to_text/nlp_manager.dart';
import 'package:health_gauge/speech_to_text/speech_text_util.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/string_extensions.dart';

class NlpEventBloc extends Bloc<NlpEvent, NlpEventState> {

  bool? isInternetAvailable;
  STTMODE _currentMode = STTMODE.NONE;
  final NlpApiRepositoryContract? _nlpApiRepositoryContract;
  SpeechTextUtil? _speechTextUtil;
  var _speechText = "";
  String language = 'en-US';
  SpeechTextUtil? _ttsUtil;
  var isLoading = false;
  bool isListenerOff = false;
  NlpEventBloc(this._nlpApiRepositoryContract)
      : assert(_nlpApiRepositoryContract != null), super(NlpEventEmptyState()) {
    loadPreference();
  /*  _speechTextUtil = SpeechTextUtil.init(
      callback: (text) {
        if(_currentMode == STTMODE.CONFIRM){
          _speechText = text;
        }else{
          print('**********************');
          print(text);
          print('**********************');
          sendSpeechTextToWidget(text);
          if(isListenerOff && _currentMode != STTMODE.NONE){
            getNlpSpeechEvent(text);
            isListenerOff = false;
          }
        }

      },
      listenerCallback: (status) {
        if(_currentMode == STTMODE.CONFIRM){
          if(_speechText.isNotEmptyNotNull()){
            add(UserConfirmationResultEvent(text: _speechText));
          }
        }else{
          if (_speechText.isNotEmptyNotNull() && !status) {
            isListenerOff = true;
            removeVoiceText();
          } else if (_speechText.isNotEmptyNotNull() && status) {
                  _speechText = "";
          } else {
            changeListeningStatus(status);
          }
        }

      },
    );*/
  }

  // @override
  // NlpEventState get initialState => NlpEventEmptyState();

  void getNlpSpeechEvent(String speechText) {
    isLoading = true;
    add(GetNlpEventFromText(speechText: speechText));
  }

  void startListening() {
    _currentMode = STTMODE.STT;
    add(StartListeningSpeechEvent());
  }

  void stopListening() {
    _currentMode = STTMODE.NONE;
    add(StopListeningSpeechEvent());
  }

  void closeSttListener() {
    _currentMode = STTMODE.NONE;
    _speechText = "";
    add(StopListeningSpeechEvent());
  }

  void sendSpeechTextToWidget(String text) {
    add(GetSpeechTextEvent(speechText: text));
  }

  void removeVoiceText() {
    Timer(Duration(milliseconds: 1200), () {
      add(RemoveSpeechTextEvent());
    });
  }

  void speakTTS({String? text}) {
    _currentMode = STTMODE.TTS;
    add(SpeakTTSEvent(text: text));
  }

  void askTtsConfirmtion({String? text}) {
    _currentMode = STTMODE.CONFIRM;
    add(AskTTSConfirmationEvent(text: text));
  }

  void changeListeningStatus(bool status) {
    add(SpeechListenerChangeEvent(isListening: status));
  }
  void getUserTtsConfirmation(){
    _currentMode = STTMODE.CONFIRM;
    add(UserConfirmationEvent());
  }

  void loadPreference() async{

    var lang = preferences?.getString('language');
    if(language != null) language = lang ?? '';
  }

  @override
  Stream<NlpEventState> mapEventToState(NlpEvent event) async* {
    if (event is GetNlpEventFromText) {
      try {
        var text = event.speechText;
        Map<String, String> mapRequest = {"Input": text ?? '',
          "Transaction_ID": "12345",
          "User_ID": globalUser != null && globalUser?.userId != null ? globalUser!.userId! : '',
          "Timestamp": DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
        };
        isInternetAvailable = await Constants.isInternetAvailable();
        if ((isInternetAvailable ?? false) && text!.trim().isNotEmpty && _currentMode != STTMODE.NONE) {
          _speechText = "";
          String url = Constants.nlpApiUrl;
          final NlpSpeechEventModel nlpSpeechEventModel =
              await _nlpApiRepositoryContract!.getNlpSpeechEvent(
                  url, mapRequest);
          if (nlpSpeechEventModel.operation == null) {
            yield NlpEventEmptyState();
          } else {
            NlpManager manager =
                await NlpManager.initialHandling(nlpSpeechEventModel);
            isLoading = false;
            if(_currentMode != STTMODE.NONE){
              yield NlpEventSpeechDataSuccessState(
                  manager.nlpBlocModel!, manager.nlpIntent!);
            }else{
              add(RemoveSpeechTextEvent());
              yield NlpEventEmptyState();
            }
          }
        }
      } on Exception {
        yield NlpEventApiErrorState('Something went wrong, try again');
      }
    }

    if (event is StartListeningSpeechEvent) {
      try {
        add(RemoveSpeechTextEvent());
        await _speechTextUtil?.startListening();
        yield NlpStartListeningState();
      } on Exception {
        yield NlpEventEmptyState();
      }
    }

    if (event is GetSpeechTextEvent) {
      try {
        var speech = event.speechText;
        _speechText = speech ?? '';
        yield NlpSpeechTextState(speech!);
      } on Exception {
        yield NlpEventEmptyState();
      }
    }

    if (event is StopListeningSpeechEvent) {
      try {
        _speechText = "";
        await _speechTextUtil?.stopListening();
        add(RemoveSpeechTextEvent());
        yield NlpEventEmptyState();
      } on Exception {
        yield NlpEventEmptyState();
      }
    }

    if (event is SpeechListenerChangeEvent) {
      try {
        yield NlpEventSpeechListenerState(event.isListening);
      } catch (e) {
        yield NlpEventEmptyState();
      }
    }

    if (event is RemoveSpeechTextEvent) {
      try {
        _speechText = "";
        yield NlpEventRemoveSpeechTextState();
      } on Exception {
        yield NlpEventRemoveSpeechTextState();
      }
    }

    if (event is SpeakTTSEvent) {
      if(_ttsUtil == null){
        _ttsUtil = SpeechTextUtil.initTTS(onTTSCompletionCallback: (status){
          if (status) {
            print('**************');
            print(status);
            print('**************');
            // yield NlpSpeakFinishedState(status);
          }
        });
      }
      _ttsUtil?.newVoiceText = event.text ?? '';
      _ttsUtil?.setLanguageForTts(language);
      await _ttsUtil?.speak();
      _ttsUtil = null;
      add(RemoveSpeechTextEvent());
    }
    if (event is AskTTSConfirmationEvent) {
      if(_ttsUtil == null) {
        _ttsUtil = SpeechTextUtil.initTTS(onTTSCompletionCallback: (status) {
          if (status) {
            print(status);
            if(_currentMode == STTMODE.CONFIRM) getUserTtsConfirmation();
        }
      });}
      _ttsUtil?.newVoiceText = event.text ?? '';
      _ttsUtil?.setLanguageForTts(language);
      _ttsUtil?.setAwaitSpeakCompletion(true);
      await _ttsUtil?.speak();
    }
    if (event is UserConfirmationEvent) {
      add(StartListeningSpeechEvent());
      yield NlpSpeakFinishedState(true);
    }

    if(event is UserConfirmationResultEvent){
        var confirmationText = event.text;
        speakTTS(text : "You said ${event.text}");
        _currentMode = STTMODE.NONE;
        _speechText = "";
        yield TTSConfirmationSuccessState(confirmationText!);
    }

  }
}


enum STTMODE{
  TTS, STT, CONFIRM, NONE
}