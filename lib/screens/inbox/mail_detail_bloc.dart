import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/repository/mail/mail_repository.dart';
import 'package:health_gauge/repository/mail/request/get_message_detail_event_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/utils/constants.dart';

import 'mail_detail_events.dart';
import 'mail_detail_states.dart';

class MailDetailBloc extends Bloc<MailDetailEvents, MailDetailState> {
//  final draftsRepo =EmailData();
  bool? isInternetAvailable;

  MailDetailBloc() : super(MessageDetailLoadingState());

  @override
  Stream<MailDetailState> mapEventToState(MailDetailEvents event) async* {
    if (event is GetMessageDetailEvent) {
      try {
        isInternetAvailable = await Constants.isInternetAvailable();
        if (isInternetAvailable ?? false) {
          var userMessage = <String, dynamic>{
            'MessageID': event.messageId.toString(),
            'LogedInEmailID': event.logedInEmailID
          };
          print(event.messageId);
          final result = await MailRepository()
              .getMessageDetailByMessageId(GetMessageDetailEventRequest(
            messageID: event.messageId,
            loggedInEmailID: event.logedInEmailID,
          ));
          if (result.hasData) {
            if (result.getData!.data == null) {
              yield MessageDetailEmptyState();
            } else {
              yield MessageDetailSuccessState(result.getData!);
            }
          } else {
            yield MessageDetailErrorState('error something');
          }
//           String url = Constants.inboxBaseUrl + "GetMessagedetlsByMessageid";
//           final MessageDetailListModel messageDetailListModel =
//               await GetMessageDetail().callApi(url, userMessage);
//           print("getting data again 1");
//           if (messageDetailListModel.data == null) {
//             yield MessageDetailEmptyState();
//           } else {
// //          yield MessageDetailListSuccessState(messageDetailListModel);
//             print("getting data again 2");
//             yield MessageDetailSuccessState(messageDetailListModel);
//             print("yielding data again 3");
//           }
        } else {
          yield MessageDetailErrorState('Please connect to internet');
        }
      } catch (e) {
        yield MessageDetailErrorState(e.toString());
      }
    }
  }
}
