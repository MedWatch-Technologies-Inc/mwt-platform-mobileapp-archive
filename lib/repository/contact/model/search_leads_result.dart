import 'package:json_annotation/json_annotation.dart';

part 'search_leads_result.g.dart';

@JsonSerializable()
class SearchLeadsResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<SearchLeadsData>? data;

  SearchLeadsResult({
    this.result,
    this.response,
    this.data,
  });

  factory SearchLeadsResult.fromJson(Map<String, dynamic> srcJson) =>
      _$SearchLeadsResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SearchLeadsResultToJson(this);
}

@JsonSerializable()
class SearchLeadsData extends Object {
  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'FirstName')
  String? firstName;

  @JsonKey(name: 'LastName')
  String? lastName;

  @JsonKey(name: 'Picture')
  String? picture;

  @JsonKey(name: 'Email')
  String? email;

  @JsonKey(name: 'Phone')
  String? phone;

  @JsonKey(name: 'UserName')
  String? userName;

  SearchLeadsData({
    this.userID,
    this.firstName,
    this.lastName,
    this.picture,
    this.email,
    this.phone,
    this.userName,
  });

  factory SearchLeadsData.fromJson(Map<String, dynamic> srcJson) =>
      _$SearchLeadsDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SearchLeadsDataToJson(this);
}
