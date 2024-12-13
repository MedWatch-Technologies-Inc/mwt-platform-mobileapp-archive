import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';

class ChatAPI {
  static final ChatAPI _instance = ChatAPI._internal();

  factory ChatAPI() {
    return _instance;
  }

  ChatAPI._internal();

  final Dio _dio = Dio();

  Future<dynamic> postData(int receiverId, String receiverUsername,
      String message, String connectionId) async {
    Map params = {
      'receiverId': receiverId,
      'receiverUsername': receiverUsername,
      'message': message,
      'senderUserName': globalUser!.userName,
      'user_connectionid': connectionId
    };

    // print('Chat Send : ' + params.toString());
    print('Chat Send : ' + json.encode(params));
    print('Chat Send : ${Constants.baseUrl}AccessSend');
    try {
      var response = await _dio.post(
        '${Constants.baseUrl}AccessSend',
        data: json.encode(params),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print('Chat Send : ${response.statusCode}');
      print('Chat Send : ${response.toString()}');
      // print('Chat Send : ${json.decode(response.toString())}');

      if (response.statusCode == 200) {
        return json.decode(response.toString());
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }
}
