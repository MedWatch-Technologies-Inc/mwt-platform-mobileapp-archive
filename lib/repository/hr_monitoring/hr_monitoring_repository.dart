

import 'package:dio/dio.dart';
import 'package:health_gauge/repository/hr_monitoring/request/add_hr_monitoring.dart';
import 'package:health_gauge/repository/hr_monitoring/retrofit/client_hr_monitoring.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';

class HrMonitoringRepository {
  late HrMonitoringClient _hrMonitoringClient;

  HrMonitoringRepository() {
    var dio = ServiceManager.get().getDioClient();
    _hrMonitoringClient = HrMonitoringClient(dio, baseUrl: Constants.baseUrl);
  }
}
