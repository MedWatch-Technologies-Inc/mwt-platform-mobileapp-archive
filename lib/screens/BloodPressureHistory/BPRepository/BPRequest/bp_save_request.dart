class BPSaveRequest {
  int userID;
  List<BPRequestItem> bpData;

  BPSaveRequest({
    required this.userID,
    required this.bpData,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userID,
      'bpData': bpData.map((e) => e.toJson()).toList(),
    };
  }
}

class BPRequestItem {
  String date;
  int sys;
  int dias;

  BPRequestItem({
    required this.date,
    required this.sys,
    required this.dias,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'sys': sys,
      'dia': dias,
    };
  }
}
