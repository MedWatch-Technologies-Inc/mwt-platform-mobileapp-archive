import 'package:json_annotation/json_annotation.dart';

class HRRequest extends Object {
  String userID;
  num fromDatestamp;
  num toDatestamp;
  int pageIndex;
  int pageSize;
  List<int> ids;

  HRRequest({
    required this.userID,
    required this.fromDatestamp,
    required this.toDatestamp,
    required this.pageIndex,
    required this.pageSize,
    required this.ids,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userID,
      'FromDateStamp': fromDatestamp,
      'ToDateStamp': toDatestamp,
      'PageIndex': pageIndex,
      'PageSize': pageSize,
      'IDs': ids,
    };
  }
}
