import 'package:dio/dio.dart';
import 'package:health_gauge/repository/dashboard/model/get_dashboard_data_result.dart';
import 'package:health_gauge/repository/dashboard/retrofit/dashboard_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class DashboardRepository {
  late DashboardClient _dashboardClient;

  DashboardRepository() {
    var dio = ServiceManager.get().getDioClient();
    _dashboardClient = DashboardClient(dio, baseUrl: Constants.baseUrl);
  }

  Future<ApiResponseWrapper<GetDashboardDataResult>> getPreferenceSettings(
      String userID) async {
    var response = ApiResponseWrapper<GetDashboardDataResult>();
    try {
      return response
        ..setData(await _dashboardClient.getPreferenceSettings(
            '${Constants.authToken}', userID));
    } on DioError catch (error, stacktrace) {
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
