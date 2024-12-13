import 'package:dio/dio.dart';
import 'package:health_gauge/repository/survey/retrofit/survey_client.dart';
import 'package:health_gauge/screens/survey/model/get_survey_request_body.dart';
import 'package:health_gauge/screens/survey/model/share_survey_with_contacts_request_body.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/utils/constants.dart';

import '../../screens/survey/model/create_and_save_survey_response_model.dart';
import '../../screens/survey/model/create_survey_model.dart';
import '../../screens/survey/model/share_survey_response_model.dart';
import '../../screens/survey/model/survey_detail.dart';
import '../../screens/survey/model/surveys.dart';
import '../../services/api/app_exception.dart';
import '../../services/api/service_manager.dart';
import '../../services/logging/logging_service.dart';
import '../../utils/gloabals.dart';

class SurveyRepository{
  late SurveyClient _surveyClient;
  SurveyRepository(){
    var dio = ServiceManager.get().getDioClient();
    _surveyClient = SurveyClient(dio,baseUrl: Constants.baseUrl);
  }

  Future<ApiResponseWrapper<CreateAndSaveSurveyResponseModel>> createSurvey(CreateSurveyModel createSurveyModel)async{
    final response = ApiResponseWrapper<CreateAndSaveSurveyResponseModel>();
    try {
      CreateAndSaveSurveyResponseModel responseModel = await _surveyClient
          .createSurvey(Constants.authToken, createSurveyModel);
      return response..setData(responseModel);
    }on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<Surveys>> getSurveyListByUserId(int pageNumber)async{
    final response = ApiResponseWrapper<Surveys>();
    try {
      Map<String,dynamic> queries = {
        Constants.kUserId:int.parse(globalUser!.userId!),
        Constants.kPageNumber:pageNumber,
        Constants.kPageSize:10
      };

      print("GetSurveyListByUserID_body ${queries}   ==> token ${Constants.authToken}");

      Surveys responseModel = await _surveyClient.getSurveyListByUserId(Constants.authToken,queries);

      return response..setData(responseModel);
    }on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }
  Future<ApiResponseWrapper<Surveys>> getSurveySharedWithMe(int pageNumber)async{
    final response = ApiResponseWrapper<Surveys>();
    try {
      Map<String,dynamic> body = {
        Constants.kUserId:int.parse(globalUser!.userId!),
        Constants.kPageIndex:pageNumber,
        Constants.kPageSize:10,
        Constants.kFromDateStamp:null,
        Constants.kToDateStamp:null,
      };
      GetSurveysRequestBody requestBody = GetSurveysRequestBody.fromJson(body);
      Surveys responseModel = await _surveyClient
          .getSurveyListSharedWithMe(Constants.authToken,requestBody);
      return response..setData(responseModel);
    }on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }


  Future<ApiResponseWrapper<SurveyDetail>> getSurveyDetailBySurveyID(int surveyId)async{
    final response = ApiResponseWrapper<SurveyDetail>();
    try {
      Map<String,dynamic> queries = {
        Constants.kUserId:int.parse(globalUser!.userId!),
        Constants.surveyId:surveyId
      };
      print(queries.toString());
      var responseModel = await _surveyClient.getSurveyDetailBySurveyID(Constants.authToken, queries);
      return response..setData(responseModel);
    }on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }

  Future<ApiResponseWrapper<ShareSurveyResponseModel>> shareSurveyWithContacts(map)async{
    final response = ApiResponseWrapper<ShareSurveyResponseModel>();
    try {
      Map<String,dynamic> body = map;
       ShareSurveyWithContactsRequestBody requestBody = ShareSurveyWithContactsRequestBody.fromJson(body);
      ShareSurveyResponseModel responseModel = await _surveyClient
          .shareSurveyWithContacts(Constants.authToken,requestBody);
      return response..setData(responseModel);
      return response..setData(responseModel);
    }on DioError catch (error, stacktrace) {
      LoggingService().printLog(tag: 'Dio error', message: error.toString());
      LoggingService().printLog(tag: 'Dio error', message: stacktrace.toString());
      return response..setException(ExceptionHandler(error));
    } on Exception catch (exception, stacktrace) {
      LoggingService().printLog(tag: 'Api exception', message: exception.toString());
      LoggingService().printLog(tag: 'Api exception', message: stacktrace.toString());
      return response..setException(ExceptionHandler(exception));
    }
  }



}