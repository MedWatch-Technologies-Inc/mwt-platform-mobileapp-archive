class ForgotPasswordUsingUserNameModel {
  bool? result;
  int? iD;
  String? phoneNumber;
  String? emailAddress;
  String? message;

  ForgotPasswordUsingUserNameModel(
      {this.result,
      this.iD,
      this.phoneNumber,
      this.emailAddress,
      this.message});

  ForgotPasswordUsingUserNameModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    iD = json['ID'];
    phoneNumber = json['PhoneNumber'];
    emailAddress = json['EmailAddress'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['ID'] = this.iD;
    data['PhoneNumber'] = this.phoneNumber;
    data['EmailAddress'] = this.emailAddress;
    data['Message'] = this.message;
    return data;
  }
}
