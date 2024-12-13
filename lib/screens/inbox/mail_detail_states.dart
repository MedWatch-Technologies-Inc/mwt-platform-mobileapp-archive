import 'package:equatable/equatable.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';

abstract class MailDetailState extends Equatable {
  const MailDetailState();
}

class MessageDetailSuccessState extends MailDetailState{
  final MessageDetailListModel messageDetailListModel;
  const MessageDetailSuccessState(this.messageDetailListModel);
  @override
  List<Object> get props => [messageDetailListModel];
}

class MessageDetailErrorState extends MailDetailState{
  final message;
  const MessageDetailErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class MessageDetailLoadingState extends MailDetailState{
  @override
  List<Object> get props => [];
}

class MessageDetailEmptyState extends MailDetailState{
  @override
  List<Object> get props => [];
}