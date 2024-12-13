
class WHistoryRequest {
  String userID;
  num pageIndex;
  num pageSize;
  List<int> ids;
  num fromDatestamp;
  num toDatestamp;

  WHistoryRequest({
    required this.userID,
    required this.pageIndex,
    required this.pageSize,
    required this.ids,
    required this.fromDatestamp,
    required this.toDatestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'PageIndex': pageIndex,
      'PageSize': pageSize,
      'IDs': ids,
      'FromDateStamp': fromDatestamp,
      'ToDateStamp': toDatestamp,
    };
  }
}
