import 'package:dio/dio.dart';
import 'package:health_gauge/repository/calendar/model/calendar_event_data_result.dart';
import 'package:health_gauge/repository/calendar/model/delete_event_by_event_id_result.dart';
import 'package:health_gauge/repository/calendar/model/get_event_detail_by_user_id_and_event_id_result.dart';
import 'package:health_gauge/repository/calendar/model/get_event_list_by_user_id_result.dart';
import 'package:health_gauge/repository/calendar/request/calendar_event_data_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'calendar_client.g.dart';

@RestApi()
abstract class CalendarClient {
  factory CalendarClient(Dio dio, {String baseUrl}) = _CalendarClient;

  @POST(ApiConstants.getEventListByUserID)
  Future<GetEventListByUserIdResult> getEventListByUserID(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.userID) int userID,
  );

  @POST(ApiConstants.calendarEventData)
  Future<CalendarEventDataResult> calendarEventData(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Body() CalendarEventDataRequest request,
  );

  @POST(ApiConstants.getEventDetailsByUserIDAndEventID)
  Future<GetEventDetailByUserIdAndEventIdResult>
      getEventDetailsByUserIDAndEventID(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.userID) int userId,
    @Query(ApiConstants.eventId) int eventId,
  );

  @POST(ApiConstants.deleteEventByEventID)
  Future<DeleteEventByEventIdResult> deleteEventByEventID(
    @Header(ApiConstants.headerAuthorization) String authToken,
    @Query(ApiConstants.eventId) String eventId,
  );
}
