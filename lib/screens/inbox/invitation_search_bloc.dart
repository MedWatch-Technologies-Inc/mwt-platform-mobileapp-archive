import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/contact_models/accept_reject_invitation_model.dart';
import 'package:health_gauge/repository/contact/contact_repository.dart';
import 'package:health_gauge/repository/contact/request/accept_reject_invitation_request.dart';

import 'inbox_events.dart' as events;
import 'inbox_states.dart';

class InvitationSearchBloc extends Bloc<events.InboxEvents, InboxState> {
  InvitationSearchBloc() : super(InitialSearchState());

  @override
  // TODO: implement initialState
  InboxState get initialState => InitialSearchState();

  @override
  Stream<InboxState> mapEventToState(events.InboxEvents event) async* {
    // TODO: implement mapEventToState

     if(event is events.AcceptRejectInvitation){
      try {
        var acceptRejectRequest = AcceptRejectInvitationRequest(
          contactID: event.contactId.toString(),
          isAccepted: event.isAccepted.toString(),
        );
        var request = await ContactRepository()
            .acceptOrRejectInvitation(acceptRejectRequest);
        if (request.hasData) {
          if (request.getData!.result!) {
            yield AcceptRejectInvitationSucessState(
                response: AcceptOrRejectInvitationModel(
                    result: request.getData!.result!,
                    response: request.getData!.response!,
                    message: request.getData!.message!));
          } else {
            yield SearchApiErrorState(null);
          }
        } else {
          yield SearchApiErrorState(null);
        }
        // var result = await AcceptOrRejectInvitation().callApi(event.contactId!, event.isAccepted!);
        // yield AcceptRejectInvitationSucessState(response: result!) ;
      }
      catch (e) {
        yield SearchApiErrorState(null);
      }
    }

  }


}