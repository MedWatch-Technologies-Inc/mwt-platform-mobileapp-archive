
import 'package:health_gauge/repository/calendar/model/get_event_list_by_user_id_result.dart';
import 'package:health_gauge/services/logging/logging_service.dart';

import '../../../../repository/calendar/model/get_event_detail_by_user_id_and_event_id_result.dart';

class AccessGetCalendarEventModel {
  bool? result;
  int? response;
  List<Data>? data;

  AccessGetCalendarEventModel({this.result, this.response, this.data});

  // AccessGetCalendarEventModel.fromJson(Map<String, dynamic> json) {
  //   result = json['Result'];
  //   response = json['Response'];
  //   if (json['Data'] != null) {
  //     data = [];
  //     if (json['Data'] is List) {
  //       json['Data'].forEach((v) {
  //         data?.add(Data.fromJson(v));
  //       });
  //     } else {
  //       data?.add(Data.fromJson(json['Data']));
  //     }
  //   }
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['Result'] = result;
  //   data['Response'] = response;
  //   if (this.data != null) {
  //     data['Data'] = this.data?.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }

  static AccessGetCalendarEventModel mapper(GetEventListByUserIdResult obj) {
    var model = AccessGetCalendarEventModel();
    model
      ..result = obj.result
      ..response = obj.response
      ..data = obj.data != null
          ? List<Data>.from(obj.data!.map((e) => Data()
            ..startTime = e.startTime
            ..start = e.start
            ..end = e.end
            ..endTime = e.endTime
            ..setRemindersID = e.setRemindersID
            ..info = e.info
            ..url = e.url
            ..location = e.location
            ..fKUserID = e.fKUserID
            ..title = e.title
            ..invitedIds = e.invitedIds
            ..startDateTimeStamp = e.startDateTimeStamp
            ..endDateTimeStamp = e.endDateTimeStamp
            ))
          : null;
    return model;
  }
}

class Data {
  String? title;
  String? location;
  String? url;
  List? invitedIds;
  int? setRemindersID;
  String? info;
  int? fKUserID;
  String? start;
  String? end;
  String? startTime;
  String? endTime;
  String? showMassege;
  String? notes;
  bool? allDay;
  String? color;
  String? startDateTimeStamp;
  String? endDateTimeStamp;

  Data(
      {this.title,
      this.location,
      this.url,
      this.invitedIds,
      this.setRemindersID,
      this.info,
      this.fKUserID,
      this.start,
      this.end,
      this.startTime,
      this.endTime,
      this.showMassege,
      this.allDay,
      this.notes,
        this.startDateTimeStamp,
        this.endDateTimeStamp});

    // static Data mapper(GetEventListByUserIdData obj){
    //   var model = Data();
    //   model
    //     ..title = obj.title
    //     ..location = obj.location
    //     ..url = obj.url
    //     ..invitedIds = obj.invitedIds
    //     ..setRemindersID = obj.setRemindersID
    //     ..info = obj.info
    //     ..fKUserID = obj.fKUserID
    //     ..start = obj.start
    //     ..end = obj.end
    //     ..startTime = obj.startTime
    //     ..endTime = obj.endTime
    //     ..notes = obj.notes;
    //
    //   return model;
    // }

//   Data.fromJson(Map<String, dynamic> map) {
//     try {
//       if (check('title', map) || check('information', map)) {
//         if (map.containsKey('title')) {
//           title = map['title'];
//         } else if (map.containsKey('information')) {
//           title = map['information'];
//         }
//       }
//       if (check('location', map)) {
//         location = map['location'];
//       }
//       if (check('url', map)) {
//         url = map['url'];
//       }
//       if (check('InvitedIds', map)) {
//         invitedIds = map['InvitedIds'];
//       }
//       if (check('SetRemindersID', map)) {
//         setRemindersID = map['SetRemindersID'];
//       }
//       if (check('Info', map)) {
//         info = map['Info'];
//       }
//       if (check('FKUserID', map)) {
//         fKUserID = map['FKUserID'];
//       }
//       if (check('start', map)) {
//         start = map['start'];
//       }
//       if (check('end', map)) {
//         end = map['end'];
//       }
//       if (check('StartTime', map)) {
//         startTime = map['StartTime'];
//       }
//       if (check('EndTime', map)) {
//         endTime = map['EndTime'];
//       }
//       if (check('ShowMassege', map)) {
//         showMassege = map['ShowMassege'];
//       }
//       if (check('allDay', map)) {
//         allDay = map['allDay'];
//       }
//       if (check('Notes', map)) {
//         notes = map['Notes'];
//       }
//       if (check('Color', map)) {
//         color = map['Color'];
//       }
//     } on Exception catch (e) {
//       LogUtil().printLog(
//           message: e.toString(), tag: 'Issue in AccessGetCalendarEventModel');
//     }
//   }
// //    title = json['title'];
// //    location = json['location'];
// //    url = json['url'];
// //    inviteid = json['inviteid'];
// //    setRemindersID = json['SetRemindersID'];
// //    info = json['Info'];
// //    fKUserID = json['FKUserID'];
// //    start = json['start'];
// //    end = json['end'];
// //    startTime = json['StartTime'];
// //    endTime = json['EndTime'];
// //    showMassege = json['ShowMassege'];
//
//   bool check(String key, Map map) {
//     if (map != null && map.containsKey(key) && map[key] != null) {
//       if (map[key] is String && map[key] == 'null') {
//         return false;
//       }
//       return true;
//     }
//     return false;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['title'] = title;
//     data['location'] = location;
//     data['url'] = url;
//     data['InvitedIds'] = invitedIds;
//     data['SetRemindersID'] = setRemindersID;
//     data['Info'] = info;
//     data['FKUserID'] = fKUserID;
//     data['start'] = start;
//     data['end'] = end;
//     data['StartTime'] = startTime;
//     data['EndTime'] = endTime;
//     data['ShowMassege'] = showMassege;
//     data['Color'] = color;
//     return data;
//   }
}