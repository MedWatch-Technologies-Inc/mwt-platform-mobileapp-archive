
class OTHistoryRequest extends Object {
  String userID;
  num fromDatestamp;
  num toDatestamp;
  int pageIndex;
  int pageSize;
  List<int> ids;

  OTHistoryRequest({
    required this.userID,
    required this.fromDatestamp,
    required this.toDatestamp,
    required this.pageIndex,
    required this.pageSize,
    required this.ids,
  });

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'FromDateStamp': fromDatestamp,
      'ToDateStamp': toDatestamp,
      'PageIndex': pageIndex,
      'PageSize': pageSize,
      'IDs': ids,
    };
  }
}
