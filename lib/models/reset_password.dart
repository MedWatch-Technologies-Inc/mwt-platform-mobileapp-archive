class ResetPassword {
  bool? result;
  int? iD;
  String? message;

  ResetPassword({this.result, this.iD, this.message});

  ResetPassword.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    iD = json['ID'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['ID'] = this.iD;
    data['Message'] = this.message;
    return data;
  }
}