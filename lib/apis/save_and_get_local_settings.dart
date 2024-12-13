import 'dart:convert';
import 'dart:io';

import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class SaveAndGetLocalSettings {
  savePreferencesInServer(String url, String userId) async {
    try {
      Map map = {};
      preferences?.getKeys().forEach((element) {
        map[element] = preferences?.get(element);
      });
      String path = await _localPath;
      final file = new File('$path/preferences.json');
      await file.writeAsString(jsonEncode(map));

      Map<String, String> header = {
        'Authorization': Constants.header['Authorization']??''
      };

      var request = MultipartRequest('POST', Uri.parse(url));
      request.fields['UserID'] = userId;
      request.headers.addAll(header);

      var pic = await MultipartFile.fromPath('File', file.path);
      request.files.add(pic);

      //posting the file
      var streamResponse = await request.send();

      //convert streamresponst to response object
      var response = await Response.fromStream(streamResponse);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  getPreferencesInServer(String url, String userId) async {
    try {
      Map<String, String> header = {
        'Authorization': Constants.header['Authorization']??'',
        'Content-Type': 'application/json',
      };
      Map map = {'UserID': userId};
      final response = await post(Uri.parse(url), headers: header, body: jsonEncode(map));
      if (response.statusCode == 200) {
        Map body = jsonDecode(response.body);
        if (body['Data'] != null) {
          Map data = body['Data'];
          String fileUrl = data['FileURL'];
          final downLoadFileResponse = await get(Uri.parse(fileUrl));
          Map json = jsonDecode(downLoadFileResponse.body);
          json.keys.forEach((element) {
            try {
              bool needToIgnoreKey =  (element == Constants.prefTokenKey) || (element == Constants.prefUserEmailKey) || (element == Constants.prefUserPasswordKey);
              if(!needToIgnoreKey) {
                var value = json[element];
                print('key $element value==== $value');
                if (value != null) {
                  if (value is String) {
                    preferences?.setString(element, value);
                  }
                  if (value is int) {
                    preferences?.setInt(element, value);
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
          return Constants.resultInApi(json, false);
        }
      }
    } on Exception catch (e) {
      print(e);
      return Constants.resultInApi(e, false);
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
