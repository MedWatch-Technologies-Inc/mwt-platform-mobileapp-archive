import 'package:json_annotation/json_annotation.dart';

part 'access_history_with_two_user_result.g.dart';

@JsonSerializable()
class AccessHistoryWithTwoUserResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<AccessHistoryWithTwoUserData>? data;

  AccessHistoryWithTwoUserResult({
    this.result,
    this.response,
    this.data,
  });

  factory AccessHistoryWithTwoUserResult.fromJson(
      Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$AccessHistoryWithTwoUserResultFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$AccessHistoryWithTwoUserResultToJson(this);
}

@JsonSerializable()
class AccessHistoryWithTwoUserData extends Object {
  @JsonKey(name: 'MessageId')
  int? messageId;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'DateSent')
  String? dateSent;

  @JsonKey(name: 'DateSentString')
  String? dateSentString;

  @JsonKey(name: 'FromUsername')
  String? fromUsername;

  @JsonKey(name: 'ToUsername')
  String? toUsername;

  @JsonKey(name: 'fromUserId')
  int? fromUserId;

  @JsonKey(name: 'toUserId')
  int? toUserId;

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'isSent')
  int? isSent = 1;

  @JsonKey(name: 'timestamp')
  int? timestamp;

  AccessHistoryWithTwoUserData({
    this.messageId,
    this.message,
    this.dateSent,
    this.dateSentString,
    this.fromUsername,
    this.toUsername,
    this.id,
    this.toUserId,
    this.fromUserId,
    this.timestamp,
    this.isSent,
  });

  factory AccessHistoryWithTwoUserData.fromJson(Map<String, dynamic> srcJson) =>
      _$AccessHistoryWithTwoUserDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccessHistoryWithTwoUserDataToJson(this);

  Map<String, dynamic> toJsonToInsertInDb() => {
        'id': id,
        'FromUserId': fromUserId,
        'ToUserId': toUserId,
        'Message': message,
        'DateSent': dateSent,
        'FromUserName': fromUsername,
        'ToUserName': toUsername,
        'IsSent': isSent,
      };

  AccessHistoryWithTwoUserData.fromMap(Map map) {
    try {
      if (check('id', map)) {
        id = map['id'];
      }
      if (check('ToUserId', map)) {
        toUserId = map['ToUserId'];
      }
      if (check('FromUserId', map)) {
        fromUserId = map['FromUserId'];
      }
      if (check('Message', map)) {
        message = map['Message'];
      }
      if (check('DateSent', map)) {
        dateSent = map['DateSent'];
      }
      if (check('FromUserName', map)) {
        fromUsername = map['FromUserName'];
      }
      if (check('ToUserName', map)) {
        toUsername = map['ToUserName'];
      }
      if (check('IsSent', map)) {
        isSent = map['IsSent'] ?? 1;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  bool check(String key, Map? map) {
    if (map != null && map.containsKey(key) && map[key] != null) {
      if (map[key] is String && map[key] == 'null') {
        return false;
      }
      return true;
    }
    return false;
  }
}
