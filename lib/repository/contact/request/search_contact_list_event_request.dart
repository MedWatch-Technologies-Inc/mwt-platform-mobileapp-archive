import 'package:json_annotation/json_annotation.dart';

part 'search_contact_list_event_request.g.dart';

@JsonSerializable()
class SearchContactListEventRequest extends Object {
  @JsonKey(name: 'LoggedinUserID')
  String? loggedInUserID;

  @JsonKey(name: 'SearchText')
  String? searchText;

  SearchContactListEventRequest({
    this.loggedInUserID,
    this.searchText,
  });

  factory SearchContactListEventRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$SearchContactListEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SearchContactListEventRequestToJson(this);
}
