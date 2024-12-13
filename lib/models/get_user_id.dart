class GetUserID {
  bool? result;
  String? message;

  GetUserID({this.result, this.message});

  GetUserID.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Message'] = this.message;
    return data;
  }
}