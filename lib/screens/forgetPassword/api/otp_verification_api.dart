import 'dart:convert';

import 'package:health_gauge/screens/forgetPassword/model/otp_verification_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:http/http.dart';

class OTPVerificationApi {
  Future<OTPVerificationModel> callApi(String url, Map strJson) async {
    try {
      // please comment these lines
      if (url.contains('app')) {
        url = url.replaceAll('app', 'qa');
      }
      // comment till here
      var response = await post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(strJson),
      );
      print(response);
      OTPVerificationModel passwordModel =
          OTPVerificationModel.fromJson(jsonDecode(response.body));
      return passwordModel;
    } catch (e) {
      print(e);
      return Constants.resultInApi(e, true);
    }
  }
}
