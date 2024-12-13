import 'package:dio/dio.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/screens/survey/model/share_survey_response_model.dart';
import 'package:retrofit/http.dart';

import '../../../screens/survey/model/create_and_save_survey_response_model.dart';
import '../../../screens/survey/model/create_survey_model.dart';
import '../../../screens/survey/model/get_survey_request_body.dart';
import '../../../screens/survey/model/share_survey_with_contacts_request_body.dart';
import '../../../screens/survey/model/survey_detail.dart';
import '../../../screens/survey/model/surveys.dart';

part 'survey_client.g.dart';
@RestApi()
abstract class SurveyClient{

  factory SurveyClient(Dio dio, {String baseUrl}) = _SurveyClient;

  @POST(ApiConstants.createNewSurvey)
  Future<CreateAndSaveSurveyResponseModel> createSurvey(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() CreateSurveyModel createSurveyModel
      );

  @POST(ApiConstants.surveyListByUserID)
  Future<Surveys> getSurveyListByUserId(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Queries() Map<String,dynamic> queries
      );
  @POST(ApiConstants.surveySharedWithMe)
  Future<Surveys> getSurveyListSharedWithMe(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() GetSurveysRequestBody requestBody
      );
  @POST(ApiConstants.surveyDetailBySurveyID)
  Future<SurveyDetail> getSurveyDetailBySurveyID(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Queries() Map<String,dynamic> queries
      );

  @POST(ApiConstants.shareSurveyWithContacts)
  Future<ShareSurveyResponseModel> shareSurveyWithContacts(
      @Header(ApiConstants.headerAuthorization) String authToken,
      @Body() ShareSurveyWithContactsRequestBody requestBody
      );

}