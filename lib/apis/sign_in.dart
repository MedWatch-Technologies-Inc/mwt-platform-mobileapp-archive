import 'dart:convert';

import 'package:health_gauge/apis/api_wrapper/api_wrapper.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/services/core_util/log_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:http/http.dart';

class SignIn extends ApiCall {
  Future<Map> callApi(String url, var strJson) async {
    var response;
    try {
      Map<String, String> headers = {};
      if (strJson == '{}') {
        strJson = '';
        headers['Authorization'] = Constants.header['Authorization'] ?? '';
      }
      response = await post(Uri.parse(url), headers: headers, body: strJson);
      // response = await post(url,body: strJson);
      // var response = jsonDecode(response1.body);
      response = jsonDecode(response.body);
      if (response.containsKey('Salt') && response['Salt'] != null) {
        Constants.authToken = '${response['Salt']}';
        Constants.header = {
          'Authorization': '${Constants.authToken}',
          'Content-Type': 'application/json',
        };

        preferences?.setString(Constants.prefTokenKey, Constants.authToken);
      }
      if (response.containsKey('Result') &&
          response['Result'] &&
          response.containsKey('Data') &&
          response['Data'] != null) {
        Map data = response['Data'];
        UserModel user = UserModel.fromMap(data);
        return Constants.resultInApi(user, false);
      } else if (response.containsKey('Message') &&
          response['Message'] is String) {
        String message = response['Message'];
        return Constants.resultInApi(message, true);
      }
      return Constants.resultInApi('', true);
    } on Exception catch (e) {
      LoggingService().info(
           'SingIn API',  'SignIn',error: e.toString());
      print(e);
      return Constants.resultInApi(e, true);
    }
  }
}
