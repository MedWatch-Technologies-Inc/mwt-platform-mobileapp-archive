import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/contact_models/search_contact_list.dart';
import 'package:health_gauge/models/contact_models/send_invitation_model.dart';
import 'package:health_gauge/repository/contact/contact_repository.dart';
import 'package:health_gauge/repository/contact/request/search_contact_list_event_request.dart';
import 'package:health_gauge/repository/contact/request/send_invitation_event_request.dart';

import 'inbox_events.dart';
import 'inbox_states.dart';

class SearchContactToInviteBloc extends Bloc<InboxEvents, InboxState> {
  SearchContactToInviteBloc() : super(InitialSearchState());

  @override
  // TODO: implement initialState
  InboxState get initialState => InitialSearchState();
  @override
  Stream<InboxState> mapEventToState(InboxEvents event) async* {
    // TODO: implement mapEventToState

    if (event is SearchContactListEvent) {
      yield LoadingSearchState();
      try {
        var map = {
          'LoggedinUserID': '${event.userId}',
          'SearchText': '${event.Query}'
        };
        final estimatedResult =
            await ContactRepository().searchLeads(SearchContactListEventRequest(
          loggedInUserID: '${event.userId}',
          searchText: '${event.Query}',
        ));
        if (estimatedResult.hasData) {
          yield SearchContactListState(
              response: SearchContactList(
                  result: estimatedResult.getData!.result,
                  response: estimatedResult.getData!.response,
                  data: estimatedResult.getData!.data != null
                      ? estimatedResult.getData!.data!
                          .map((e) => SearchedUserData.fromJson(e.toJson()))
                          .toList()
                      : []));
        } else {
          yield SearchApiErrorState(null);
        }
        // var result = await SearchContact().callApi(event.userId!, event.Query!);
        // yield SearchContactListState(response: result!);
      } on Exception catch (e) {
        yield SearchApiErrorState(null);
      }
    } else if (event is SendInvitationEvent) {
      yield SendingInvitationState(
          index: event.index!, userId: event.inviteeUserId!);
      try {
        var map = {
          'LoggedinUserID': '${event.loggedInUserId}',
          'InviteeUserID': '${event.inviteeUserId}',
        };
        final estimatedResult =
            await ContactRepository().sendInvitation(SendInvitationEventRequest(
          loggedInUserID: '${event.loggedInUserId}',
          inviteeUserID: '${event.inviteeUserId}',
        ));
        if (estimatedResult.hasData) {
          yield SendInvitationSucessfulState(
              response: SendInvitationModel(
                response: estimatedResult.getData!.response,
                result: estimatedResult.getData!.result,
                message: estimatedResult.getData!.message,
              ),
              index: event.index!,
              userId: event.inviteeUserId!);
        } else {
          yield SearchApiErrorState(null);
        }
        // var result = await SendInvitation()
        //     .callApi(event.loggedInUserId!, event.inviteeUserId!);
        // yield SendInvitationSucessfulState(
        //     response: result!,
        //     index: event.index!,
        //     userId: event.inviteeUserId!);
      } on Exception catch (e) {
        yield SearchApiErrorState(null);
      }
    }
  }
}
