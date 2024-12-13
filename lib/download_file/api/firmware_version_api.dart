import 'dart:convert';

import 'package:health_gauge/apis/api_wrapper/api_wrapper.dart';
import 'package:health_gauge/download_file/model/firmware_version_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:http/http.dart';

class FirmwareVersionApi extends ApiCall {
  Future<FirmwareVersionModel> callApi(String url, var strJson) async {
    try {
      // please comment these lines
      if (url.contains('app')) {
        url = url.replaceAll('app', 'qa');
      }
      // comment till here
      // var response = await postData(url, strJson);
      var response = await post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Constants.header['Authorization']!,
        },
        body: jsonEncode(strJson),
      );
      print(response);
      return FirmwareVersionModel.fromJson(jsonDecode(response.body));
    } on Exception catch (e) {
      print(e);
      return Constants.resultInApi(e, true);
    }
  }
}
