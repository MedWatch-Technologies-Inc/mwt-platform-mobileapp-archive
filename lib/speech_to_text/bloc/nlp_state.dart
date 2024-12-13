

import 'package:equatable/equatable.dart';
import 'package:health_gauge/speech_to_text/model/nlp_bloc_model.dart';
import 'package:health_gauge/speech_to_text/model/nlp_speech_event_model.dart';
import 'package:health_gauge/speech_to_text/nlp_manager.dart';

abstract class NlpEventState extends Equatable{
  const NlpEventState();
}

class NlpEventSpeechDataSuccessState extends NlpEventState{
  final NlpBlocModel nlpBlocModel;
  final NlpOperation nlpIntent;

  const NlpEventSpeechDataSuccessState(this.nlpBlocModel, this.nlpIntent);

  @override
  List<Object> get props=>[nlpBlocModel,nlpIntent];
}

class NlpEventErrorState extends NlpEventState{
  final message;
  const NlpEventErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class NlpEventLoadingState extends NlpEventState{
  const NlpEventLoadingState();

  @override
  List<Object> get props => [];
}

class NlpEventEmptyState extends NlpEventState{
  const NlpEventEmptyState();

  @override
  List<Object> get props => [];
}

class NlpEventSpeechListenerState extends NlpEventState{
  final isListening;
  const NlpEventSpeechListenerState(this.isListening);

  @override
  List<Object> get props => [isListening];
}

class NlpStartListeningState extends NlpEventState{
  const NlpStartListeningState();

  @override
  List<Object> get props => [];
}

class NlpEventRemoveSpeechTextState extends NlpEventState{
  const NlpEventRemoveSpeechTextState();

  @override
  List<Object> get props => [];
}



class NlpEventApiErrorState extends NlpEventState {
  final String error ;
  const NlpEventApiErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class NlpSpeechTextState extends NlpEventState {
  final String text ;
  const NlpSpeechTextState(this.text);

  @override
  List<Object> get props => [text];
}

class NlpSpeakFinishedState extends NlpEventState{
  final bool status;

  NlpSpeakFinishedState(this.status);
  @override
  // TODO: implement props
  List<Object> get props => [status];

}

class TTSConfirmationSuccessState extends NlpEventState{
  final String text;

  TTSConfirmationSuccessState(this.text);
  @override
  // TODO: implement props
  List<Object> get props => [text];

}

