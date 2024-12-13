import 'package:dio/dio.dart';
import 'package:health_gauge/repository/measurement/model/delete_estimate_result.dart';
import 'package:health_gauge/repository/measurement/model/estimate_result.dart';
import 'package:health_gauge/repository/measurement/model/get_measurement_detail_list_result.dart';
import 'package:health_gauge/repository/measurement/model/set_measurement_unit_result.dart';
import 'package:health_gauge/repository/measurement/request/add_measurement_request.dart';
import 'package:health_gauge/repository/measurement/request/get_measurement_detail_list_request.dart';
import 'package:health_gauge/repository/measurement/request/set_measurement_unit_request.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:retrofit/retrofit.dart';

part 'client_hr_monitoring.g.dart';

@RestApi()
abstract class HrMonitoringClient {
  factory HrMonitoringClient(Dio dio, {String baseUrl}) = _HrMonitoringClient;

}
