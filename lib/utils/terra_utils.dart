import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:health_gauge/models/terra_models/body_data.dart';
import 'package:health_gauge/models/terra_models/daily_data_models/daily_data.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:http/http.dart' as http;
import 'package:terra_flutter_bridge/terra_flutter_bridge.dart';

class TerraHealthUtils {
  factory TerraHealthUtils() {
    return _singleton;
  }

  static final TerraHealthUtils _singleton = TerraHealthUtils._internal();

  TerraHealthUtils._internal();

  final List<CustomPermission> _permission = [
    CustomPermission.bloodGlucose,
    CustomPermission.bloodGlucose,
    CustomPermission.steps,
    CustomPermission.heartRate,
    CustomPermission.sleepAnalysis,
    CustomPermission.bodyFat,
    CustomPermission.bodyTemperature,
    CustomPermission.height,
    CustomPermission.oxygenSaturation,
  ];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String _devId = 'health-gauge-dev-7cmHfsD1ot';

  String _apiKey =
      '18abc041b4e5e71c51811b4504f424d575fee72c10bf0987e204f62d33ebfba9';

  Connection get getPlatform =>
      Platform.isIOS ? Connection.appleHealth : Connection.googleFit;



  Future<void> initTerra(
      {required DateTime startDate, required DateTime endDate}) async {
    var userId = preferences?.getString(Constants.prefUserIdKeyInt);
    var client = await TerraFlutter.initTerra(_devId, userId ?? '');
    this.startDate = startDate;
    this.endDate = endDate;
    printTerraLog(data: [client?.success ?? false]);
    if (client?.success ?? false) {
      await _initPlatformHealthApp();
    }
  }

  Future<void> _initPlatformHealthApp() async {
    var token = await generateTerraAuthtoken();
    printTerraLog(data: [token]);
    if (token != null) {
      var connect =
          Platform.isIOS ? true : await TerraFlutter.isHealthConnectAvailable();
      if (connect) {
        var result = await TerraFlutter.initConnection(
            getPlatform, token, false, _permission);
        printTerraLog(data: [result?.success, result?.error]);
        if (result?.success ?? false) {
          getDailyData(startDate: startDate, endDate: endDate);
         /* getBodyData(startDate: startDate, endDate: endDate);
          getSleepData(startDate: startDate, endDate: endDate);*/
        }
      } else {}
    }
  }

  Future getDailyData(
      {required DateTime startDate, required DateTime endDate}) async {
    if (await _checkUser()) {
      var result = await TerraFlutter.getDaily(Connection.samsung, startDate, endDate,
          toWebhook: false);
      printTerraLog(
        data: [jsonEncode(result!.data)],
        tag: 'dailyDataModel :: $startDate : $endDate :: ',
      );
    /*  var dailyDataModel = DailyData.fromJson(result.data);
      printTerraLog(
        data: [dailyDataModel.toJson(), result.success, result.error],
        tag: 'dailyDataModel :: $startDate : $endDate :: ',
      );

      if (result.success ?? false) {}*/
    }
  }

  Future getSleepData(
      {required DateTime startDate, required DateTime endDate}) async {
    if (await _checkUser()) {
      var result = await TerraFlutter.getSleep(getPlatform, startDate, endDate,
          toWebhook: false);
      printTerraLog(
        data: [result?.data, result?.success, result?.error],
        tag: 'getSleepData :: $startDate : $endDate :: ',
      );
    }
  }

  Future getBodyData(
      {required DateTime startDate, required DateTime endDate}) async {
    if (await _checkUser()) {
      var result = await TerraFlutter.getBody(getPlatform, startDate, endDate,
          toWebhook: false);
      var bodyDataModel = BodyData.fromJson(result!.data);
      printTerraLog(
        data: [bodyDataModel.toJson(), result.success, result.error],
        tag: 'bodyDataModel :: $startDate : $endDate :: ',
      );
    }
  }

  Future<bool> _checkUser() async {
    var status = await TerraFlutter.getUserId(getPlatform);
    printTerraLog(data: [status?.success, status?.userId]);
    return status?.success ?? false;
  }

  Future<String?> generateTerraAuthtoken() async {
    var url = 'https://api.tryterra.co/v2/auth/generateAuthToken';
    var uri = Uri.parse(url);
    var headers = <String, String>{
      'content-type': 'application/json',
      'x-api-key': _apiKey,
      'Dev-Id': _devId,
    };
    var response = await http.post(uri, headers: headers);
    printTerraLog(data: [response.statusCode, response.body]);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['token'].toString();
    }
    return null;
  }

  printTerraLog({List<dynamic> data = const [], String tag = ''}) {
    log("Terra :: ${tag.isNotEmpty ? '$tag :: ' : ''}${data.join(" :: ")}");
  }
}
