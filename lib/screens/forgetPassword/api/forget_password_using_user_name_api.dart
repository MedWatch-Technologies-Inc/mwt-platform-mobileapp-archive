import 'dart:convert';

import 'package:health_gauge/screens/forgetPassword/model/forgot_password_using_user_name_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:http/http.dart';

class ForgetPasswordUsingUserNameApi {
  Future<ForgotPasswordUsingUserNameModel> callApi(
      String url, Map strJson) async {
    try {
      // please comment these lines
      if (url.contains('app')) {
        url = url.replaceAll('app', 'qa');
      }
      // comment till here
      // var response = await postData(url, strJson);
      var response = await post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(strJson),
      );
      print(response);
      ForgotPasswordUsingUserNameModel passwordModel =
          ForgotPasswordUsingUserNameModel.fromJson(jsonDecode(response.body));
      return passwordModel;
    } catch (e) {
      print(e);
      return Constants.resultInApi(e, true);
    }
  }
}
