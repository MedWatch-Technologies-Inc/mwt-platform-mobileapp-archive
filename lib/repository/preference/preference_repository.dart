import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:health_gauge/repository/preference/model/get_preference_setting_result.dart';
import 'package:health_gauge/repository/preference/model/store_preference_setting_result.dart';
import 'package:health_gauge/repository/preference/request/get_preference_setting_request.dart';
import 'package:health_gauge/repository/preference/retrofit/preference_client.dart';
import 'package:health_gauge/services/api/api_response_wrapper.dart';
import 'package:health_gauge/services/api/app_exception.dart';
import 'package:health_gauge/services/api/service_manager.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:path_provider/path_provider.dart';

class PreferenceRepository {
  late PreferenceClient _preferenceClient;
  String? baseUrl;

  PreferenceRepository({String? baseUrl}) {
    var dio = ServiceManager.get().getDioClient();
    _preferenceClient = PreferenceClient(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  Future<ApiResponseWrapper<GetPreferenceSettingResult>> getPreferenceSettings(
      GetPreferenceSettingRequest request) async {
    var response = ApiResponseWrapper<GetPreferenceSettingResult>();
    try {
      var prefResponse =
          await _preferenceClient.getPreferenceSettings('${Constants.authToken}', request);
      if (prefResponse.result ?? false) {
        var downloadClient = ServiceManager.get().getDioClient();
        var downloadFileResponse = await downloadClient.get(prefResponse.data!.fileURL!);
        Map json = {};
        if (downloadFileResponse.data is String) {
          json = jsonDecode(downloadFileResponse.data);
        } else {
          json = jsonDecode(jsonEncode(downloadFileResponse.data));
        }
        json.keys.forEach((element) {
          try {
            var needToIgnoreKey = (element == Constants.prefTokenKey) ||
                (element == Constants.prefUserEmailKey) ||
                (element == Constants.prefUserPasswordKey) ||
                (element == Constants.connectedDeviceAddressPrefKey);
            if (!needToIgnoreKey) {
              var value = json[element];
              if (value != null) {
                if (value is String) {
                  preferences?.setString(element, value);
                }
                if (value is int) {
                  if (element == Constants.wightUnitKey) {
                    if (value == 1) {
                      value = 0;
                    } else {
                      value = 1;
                    }
                    preferences?.setInt(element, value);
                  } else if (element == Constants.mHeightUnitKey) {
                    if (value == 1) {
                      value = 0;
                    } else {
                      value = 1;
                    }
                    preferences?.setInt(element, value);
                  } else {
                    preferences?.setInt(element, value);
                  }
                }
                if (value is double) {
                  preferences?.setDouble(element, value);
                }
                if (value is bool) {
                  preferences?.setBool(element, value);
                }
                if (value is List) {
                  preferences?.setStringList(element, value.map((e) => '$e').toList());
                }
              }
            }
          } on Exception catch (e) {
            print(e);
          }
        });
      }
      return response..setData(prefResponse);
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

  Future<ApiResponseWrapper<StorePreferenceSettingResult>> storePreferenceSettings(
      String userId) async {
    var response = ApiResponseWrapper<StorePreferenceSettingResult>();
    try {
      var map = {};
      preferences?.getKeys().forEach((element) {
        if (element == Constants.measurementType) {
          map[element] = 1;
        }/* else if (element == Constants.wightUnitKey) {
          map[element] = preferences?.get(element);
          if (map[element] == 1) {
            map[element] = 2;
          } else {
            map[element] = 1;
          }
        } */else if (element == Constants.mHeightUnitKey) {
          map[element] = preferences?.get(element);

          if (map[element] == 1) {
            map[element] = 2;
          } else {
            map[element] = 1;
          }
        } else {
          map[element] = preferences?.get(element);
        }
      });
      var path = await _localPath;
      final file = File('$path/preferences.json');
      await file.writeAsString(jsonEncode(map));
      print(jsonEncode(map));
      return response
        ..setData(await _preferenceClient.storePreferenceSettings(
            '${Constants.authToken}', userId, DateTime.now().millisecondsSinceEpoch, file));
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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
