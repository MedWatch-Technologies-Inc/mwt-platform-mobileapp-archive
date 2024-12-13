import 'dart:convert';

import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:http/http.dart';

class SignUp {
  Future<Map> callApi(String url, Map strJson) async {
    try {
      final Response response = await post(Uri.parse(url), headers: Constants.header, body: jsonEncode(strJson));
      if (response.statusCode == 200) {
        Map body = jsonDecode(response.body);
        if (body.containsKey('Errors')) {
          return Constants.resultInApi(body['Errors'], true);
        } else {
          if (body.containsKey('Salt') && body['Salt'] != null) {
            Constants.authToken = '${body['Salt']}';
            Constants.header = {
              'Authorization': '${Constants.authToken}',
            'Content-Type': 'application/json',
          };

          preferences?.setString(Constants.prefTokenKey, Constants.authToken);
        }
        if (body.containsKey('Result') &&
            body['Result'] &&
            body.containsKey('Data') &&
            body['Data'] != null) {
          Map data = body['Data'];
          UserModel user = UserModel.fromMap(data);
          return Constants.resultInApi(user, false);
        } else if (body.containsKey('Message') && body['Message'] is String) {
          String message = body['Message'];
          return Constants.resultInApi(message, true);
        }
        return Constants.resultInApi('', true);
      }
      } else {
        return Constants.resultInApi('Statuscode ${response.statusCode}', true);
      }
    } on Exception catch (e) {
      print(e);
      return Constants.resultInApi(e, true);
    }
  }
}
