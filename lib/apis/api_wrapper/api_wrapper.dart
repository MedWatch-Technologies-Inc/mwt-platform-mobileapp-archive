import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_gauge/services/analytics/sentry_analytics.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:http/http.dart';

abstract class ApiCall {
  Future<Map<String, dynamic>> postData(String url, var body, {bool? isJson}) async {
    try {
      Map<String, String> map = {
        'Authorization': Constants.header['Authorization'] ?? '',
        'Content-Type': 'application/json',
      };

      if (isJson == null || !isJson) {
        if (body is Map) {
          if (body.length > 2) {
            map['Content-Type'] = 'application/json';
            body = jsonEncode(body);
          } else {
            map.remove('Content-Type');
          }
        } else if (body is String) {
          if (jsonDecode(body).length <= 2) {
            body = jsonDecode(body);
            map.remove('Content-Type');
          } else {
            map['Content-Type'] = 'application/json';
          }
        }

        if (body is Map) {
          body.keys.forEach((element) {
            body[element] = '${body[element]}';
          });
          map.remove('Content-Type');
        }

        if (body is Map) {
          map.remove('Content-Type');
        }
      }
      final response = await post(Uri.parse(url), headers: map, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      }
      else {
        SentryAnalytics().setContexts(
          event: 'Post_Data_Event',
          data: {
            'Status_Code': response.statusCode,
            'url': url,
            'UserId': globalUser?.userId ?? ''
          },
        );
        return Constants.resultInApi(
            'StatusCode postData ${response.statusCode}', true);
      }
    }
    catch (e) {
      debugPrint('Exception at postData $e');
      SentryAnalytics().setContexts(
        event: 'Exception_Event',
        data: {'url': url, 'error': e, 'UserId': globalUser?.userId ?? ''},
      );
      return Constants.resultInApi(e, true);
    }
  }

  Future<Map<String, dynamic>> getData(String url) async {
    try {
      final response = await get(Uri.parse(url), headers: Constants.header);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        SentryAnalytics().setContexts(
          event: 'Get_Data_Event',
          data: {
            'Status_Code': response.statusCode,
            'url': url,
            'UserId': globalUser?.userId ?? ''
          },
        );
        return Constants.resultInApi(
            'Status Code getData ${response.statusCode}', true);
      }
    }
    catch (e) {
      debugPrint('Exception at getData $e');
      SentryAnalytics().setContexts(
          event: 'Exception_Event',
          data: {'url': url, 'error': e, 'UserId': globalUser?.userId ?? ''});
      return Constants.resultInApi(e, true);
    }
  }


}


abstract class ApiGroupCall {
  Future<Map<String, dynamic>> postData(String url, var body) async {
    try {
      Map<String, String> map = {
        'Authorization': Constants.header['Authorization'] ?? '',
        'Content-Type': 'application/json',
      };
      if (body is Map) {
        if (body.length > 3) {
          map['Content-Type'] = 'application/json';
          body = jsonEncode(body);
        } else {
          map.remove('Content-Type');
        }
      } else if (body is String) {
        if (jsonDecode(body).length <= 3) {
          body = jsonDecode(body);
          map.remove('Content-Type');
        } else {
          map['Content-Type'] = 'application/json';
        }
      }
      if (body is Map) {
        body.keys.forEach((element) {
          body[element] = '${body[element]}';
        });
        map.remove('Content-Type');
      }
      if (body is Map) {
        map.remove('Content-Type');
      }
      final response = await post(Uri.parse(url), headers: map, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        SentryAnalytics().setContexts(event: 'Post_Data_Event', data: {
          'Status_Code': response.statusCode,
          'url': url,
          'UserId': globalUser?.userId ?? ''
        });
        return Constants.resultInApi(
            'Status code ApiGroupCall ${response.statusCode}', true);
      }
    }
    catch (e) {
      debugPrint('error $e');
      SentryAnalytics().setContexts(
          event: 'Exception_Event',
          data: {'url': url, 'error': e, 'UserId': globalUser?.userId ?? ''});
      return Constants.resultInApi(e, true);
    }
  }

  Future<Map<String, dynamic>> getData(String url) async {
    try {
      final response = await get(Uri.parse(url), headers: Constants.header);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        SentryAnalytics().setContexts(event: 'Get_Data_Event', data: {
          'Status_Code': response.statusCode,
          'url': url,
          'UserId': globalUser?.userId ?? ''
        });
        return Constants.resultInApi(
            'Status code getData ${response.statusCode}', true);
      }
    }
    catch (e) {
      debugPrint('Exception at getData $e');
      SentryAnalytics().setContexts(event: 'Exception_Event', data: {
        'url': url,
        'error': e,
        'UserId': globalUser?.userId ?? '',
      });
      return Constants.resultInApi(e, true);
    }
  }


}
