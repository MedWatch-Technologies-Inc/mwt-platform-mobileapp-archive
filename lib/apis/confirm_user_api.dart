
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_gauge/apis/api_wrapper/api_wrapper.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:http/http.dart';

class ConfirmUser extends ApiCall {
  Future<Map> callApi(String url, String strJson) async {
    var response;
    try {
      final result = await post(Uri.parse(url),
          headers: Constants.header, body: jsonEncode(strJson));
      if (result.statusCode == 200) {
        response = jsonDecode(result.body);
      } else {
        return Constants.resultInApi(
            'Status code ${response.statusCode}', true);
      }

      if (response['Result'] == true && response['Message'] is String) {
        return Constants.resultInApi(response['Message'], false);
      } else if (response['Message'] is String) {
        String message = response['Message'];
        return Constants.resultInApi(message, true);
      }
      return Constants.resultInApi('', true);
    } catch (e) {
      LoggingService().info(
           'Confirm user API',  'API',error: e.toString());
      debugPrint('Exception at ConfirmUser $e');
      return Constants.resultInApi(e, true);
    }
  }
}
