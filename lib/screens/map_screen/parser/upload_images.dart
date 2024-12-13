import 'dart:convert';

import 'package:health_gauge/apis/api_wrapper/api_wrapper.dart';
import 'package:health_gauge/screens/map_screen/model/image_model.dart';
import 'package:health_gauge/utils/constants.dart';

class UploadImages extends ApiCall{
  Future callApi(String url, Map map) async {
    try {
      final result = await postData(Uri.encodeFull(url), jsonEncode(map),isJson: true);
      if(result['Result'] is bool && result['Result']) {
        List data = result['Data'];
        var images = data.map((e) => ImageModel.fromJson(e)).toList();
        return Constants.resultInApi(images, false);
      }
    } catch (e) {
      print('Exception at UploadImages $e');
      return Constants.resultInApi(e.toString(), true);
    }
  }
}