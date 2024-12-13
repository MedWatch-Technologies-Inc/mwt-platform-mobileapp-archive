import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';

abstract class MailDetailEvents extends Equatable {
  const MailDetailEvents();
}

class GetMessageDetailEvent extends MailDetailEvents{
  final int messageId;
  final String logedInEmailID;
  const GetMessageDetailEvent({required this.messageId,required this.logedInEmailID});
  @override
  List<Object> get props => [];
}