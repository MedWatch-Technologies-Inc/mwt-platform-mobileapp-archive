
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/models/contact_models/accept_reject_invitation_model.dart';
import 'package:health_gauge/models/contact_models/pending_invitation_model.dart';
import 'package:health_gauge/repository/contact/contact_repository.dart';
import 'package:health_gauge/repository/contact/request/accept_reject_invitation_request.dart';
import 'package:health_gauge/repository/contact/request/get_invitation_request.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';

import 'inbox_events.dart' as events;
import 'inbox_states.dart';

/// Added by: Akhil
/// Added on: July/02/2020
/// This is the Bloc class for the pending invitation feature which is used to handle the api calls.
class InvitationBloc extends Bloc<events.InboxEvents, InboxState> {
  final dbHelper = DatabaseHelper.instance;

  InvitationBloc() : super(InitialSearchState());

  @override
  // TODO: implement initialState
  InboxState get initialState => InitialSearchState();

  @override

  /// Added by: Akhil
  /// Added on: July/02/2020
  /// This function is used for mapping event to state i.e. yielding different states for particular event
  /// @paramete : event - particular event is defined for particular api hit
  Stream<InboxState> mapEventToState(events.InboxEvents event) async* {
    // TODO: implement mapEventToState

    if (event is events.GetInvitations) {
      /// Added by: Akhil
      /// Added on: June/29/2020
      /// This is the event for getting list of pending invitations from api and local database
      yield LoadingSearchState();
      dbHelper.database;
      var dbResult = await dbHelper.getInvitationList(event.userId!);
      yield LoadedInvitations(
          response: PendingInvitationModel(
              invitationList: dbResult,
              response: 200,
              result: true,
              isFromDb: true));
      try {
        var isInternet = await Constants.isInternetAvailable();
        if (isInternet) {
          // var result = await GetPendingInvitationList().callApi(event.userId!);
          var map = {
            'LoggedinUserID': event.userId,
            'SearchKey': '',
            'IDs': [],
          };
          final estimatedResult = await ContactRepository()
              .getPendingInvitationList(GetInvitationRequest(
            loggedInUserId: event.userId,
            iDs: [],
            pageIndex: '',
          ));
          if (estimatedResult.hasData) {
            var result = PendingInvitationModel(
                response: estimatedResult.getData!.response,
                result: estimatedResult.getData!.result,
                invitationList: estimatedResult.getData!.data != null
                    ? estimatedResult.getData!.data!
                        .map((e) => InvitationList.fromJson(e.toJson()))
                        .toList()
                    : [],
                isFromDb: false);
            if (dbResult.isEmpty) {
              for (var i = 0; i < result.invitationList!.length; i++) {
                result.invitationList![i].userId = event.userId;
                await dbHelper.insertInvitationData(
                    result.invitationList![i].toJsonToInsertInDb(-1));
              }
            } else {
              for (var j = 0; j < result.invitationList!.length; j++) {
                var isInList = false;
                for (var i = 0; i < dbResult.length; i++) {
                  if (dbResult[i].contactID ==
                      result.invitationList![j].contactID) {
                    isInList = true;
                    break;
                  }
                }
                if (!isInList) {
                  result.invitationList![j].userId = event.userId;
                  await dbHelper.insertInvitationData(
                      result.invitationList![j].toJsonToInsertInDb(-1));
                }
              }
            }
          } else {
            yield SearchApiErrorState(null);
          }
        }
        dbResult = await dbHelper.getInvitationList(event.userId!);
        yield LoadedInvitations(
            response: PendingInvitationModel(
                invitationList: dbResult,
                response: 200,
                result: true,
                isFromDb: false));
      }  on Exception catch (e) {
        yield SearchApiErrorState(null);
      }
    }

    /// Added by: Akhil
    /// Added on: July/02/2020
    /// This is the event for accepting or rejecting the invitation
    else if (event is events.AcceptRejectInvitation) {
      dbHelper.database;
      dbHelper.updateInvitation(event.contactId!, event.isAccepted! ? 1 : 0);
      var isInternet = await Constants.isInternetAvailable();
      if (isInternet) {
        try {
          var map = {
            'ContactID': '${event.contactId!}',
            'IsAccepted': '${event.isAccepted!}',
          };
          final estimatedResult = await ContactRepository()
              .acceptOrRejectInvitation(AcceptRejectInvitationRequest(
            contactID: '${event.contactId!}',
            isAccepted: '${event.isAccepted!}',
          ));
          if (estimatedResult.hasData) {
            if (estimatedResult.getData!.result ?? false) {
              dbHelper.deleteContact(event.contactId!);
            }
            yield AcceptRejectInvitationSucessState(
                response: AcceptOrRejectInvitationModel(
              result: estimatedResult.getData!.result,
              response: estimatedResult.getData!.response,
              message: estimatedResult.getData!.message,
            ));
          } else {
            yield SearchApiErrorState(null);
          }
          // var result = await AcceptOrRejectInvitation().callApi(
          //     event.contactId!, event.isAccepted!);
          // if (result!.result ?? false)
          //   dbHelper.deleteContact(event.contactId!);
          // yield AcceptRejectInvitationSucessState(response: result);
        }  on Exception catch (e) {
          yield SearchApiErrorState(null);
        }
      } else {
        yield AcceptRejectInvitationSucessState(
            response: AcceptOrRejectInvitationModel(
                result: true,
                response: 200,
                message:
                    'You are currently offline ,the action will be performed when you are online'));
      }
    }
  }
}
