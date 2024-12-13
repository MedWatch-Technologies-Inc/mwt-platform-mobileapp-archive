import 'package:equatable/equatable.dart';

abstract class NlpEvent extends Equatable {
  const NlpEvent();
}

class GetNlpEventFromText extends NlpEvent {
final String? speechText;
const GetNlpEventFromText({this.speechText});
@override
List<Object> get props => [];
}

class GetSpeechTextEvent extends NlpEvent {
  final String? speechText;
  const GetSpeechTextEvent({this.speechText});
  @override
  List<Object> get props => [];
}


class StartListeningSpeechEvent extends NlpEvent{

  @override
  List<Object> get props => [];

}

class SpeechListenerChangeEvent extends NlpEvent{
  final bool? isListening;
  const SpeechListenerChangeEvent({this.isListening});

  @override
  List<Object> get props => [isListening ?? false];

}

class StopListeningSpeechEvent extends NlpEvent{

  @override
  List<Object> get props => [];

}

class RemoveSpeechTextEvent extends NlpEvent{

  @override
  List<Object> get props => [];

}

class SpeakTTSEvent extends NlpEvent{
  final String? text;
  final String? type;
  SpeakTTSEvent({this.type,this.text});

  @override
  List<Object> get props => [];
}

class AskTTSConfirmationEvent extends NlpEvent{
  final String? text;
  AskTTSConfirmationEvent({this.text});

  @override
  List<Object> get props => [];
}

class UserConfirmationEvent extends NlpEvent{
  final String? text;
  UserConfirmationEvent({this.text});
  @override
  List<Object> get props => [];

}

class UserConfirmationNewEvent extends NlpEvent{
  final String? text;
  UserConfirmationNewEvent({this.text});
  @override
  List<Object> get props => [];

}

class UserConfirmationResultEvent extends NlpEvent{
  final String? text;
  UserConfirmationResultEvent({this.text});
  @override
  List<Object> get props => [text ?? ''];

}