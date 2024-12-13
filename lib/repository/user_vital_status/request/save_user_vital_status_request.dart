import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:json_annotation/json_annotation.dart';

part 'save_user_vital_status_request.g.dart';

@JsonSerializable()
class SaveUserVitalStatusRequest {
  @JsonKey(name: 'Oxygen')
  num? oxygen;

  @JsonKey(name: 'HRV')
  num? HRV;

  @JsonKey(name: 'CVRR')
  num? cvrrValue;

  @JsonKey(name: 'HeartRate')
  num? heartValue;

  @JsonKey(name: 'CreatedDateTime')
  String? date;

  @JsonKey(name: 'Temperature')
  num? temperature;

  @JsonKey(name: 'FKUserID')
  String? userId;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  SaveUserVitalStatusRequest({
    this.userId,
    this.oxygen,
    this.HRV,
    this.cvrrValue,
    this.heartValue,
    this.date,
    this.temperature,
    this.createdDateTimeStamp,
  });

  factory SaveUserVitalStatusRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$SaveUserVitalStatusRequestFromJson(srcJson);

  Map<String, dynamic> toJson() {
    var map = _$SaveUserVitalStatusRequestToJson(this);
    map['FKUserID'] = preferences!.getString(Constants.prefUserIdKeyInt);
    return map;
  }
// SaveUserVitalStatusRequest.fromMap(Map map) {
//   if (check('oxygen', map)) {
//     oxygen = map['oxygen'];
//   }
//   if (check('HRV', map)) {
//     HRV = map['HRV'];
//   }
//   if (check('cvrrValue', map)) {
//     cvrrValue = map['cvrrValue'];
//   }
//   if(check('tempInt',map)){
//     tempInt = map['tempInt'];
//   }
//   if(check('tempDouble',map)){
//     tempDouble = map['tempDouble'];
//   }
//   if(check('heartValue',map)){
//     heartValue = map['heartValue'];
//   }
//   if(check('stepValue',map)){
//     stepValue = map['stepValue'];
//   }
//   if(check('DBPValue',map)){
//     DBPValue = map['DBPValue'];
//   }
//   if(check('startTime',map)){
//     startTime = map['startTime'];
//   }
//   if(check('SBPValue',map)){
//     SBPValue = map['SBPValue'];
//   }
//   if(check('respiratoryRateValue',map)){
//     respiratoryRateValue = map['respiratoryRateValue'];
//   }
//   if(check('date',map)){
//     date = map['date'];
//   }
//
//   if (check('Temperature', map)) {
//     temperature = map['Temperature'];
//   }
// }
//
// SaveUserVitalStatusRequest.fromMapForAPI(Map map) {
//   if (check('StatusID', map)) {
//     idForApi = map['StatusID'];
//   }
//   if (check('Temperature', map)) {
//     temperature = map['Temperature'];
//   }
//   if (check('Oxygen', map)) {
//     oxygen = map['Oxygen'];
//   }
//   if (check('CVRR', map)) {
//     cvrrValue = map['CVRR'];
//   }
//   if (check('HRV', map)) {
//     HRV = map['HRV'];
//   }
//   if (check('HeartRate', map)) {
//     heartValue = map['HeartRate'];
//   }
//
//   if (check('CreatedDateTime', map)) {
//     date = map['CreatedDateTime'];
//   }
// }
//
// SaveUserVitalStatusRequest.fromJson(Map map) {
//   if (check('StatusID', map)) {
//     idForApi = map['StatusID'];
//   }
//   if (check('Temperature', map)) {
//     temperature = map['Temperature'];
//   }
//   if (check('Oxygen', map)) {
//     oxygen = map['Oxygen'];
//   }
//   if (check('CVRR', map)) {
//     cvrrValue = map['CVRR'];
//   }
//   if (check('HRV', map)) {
//     HRV = map['HRV'];
//   }
//   if (check('HeartRate', map)) {
//     heartValue = map['HeartRate'];
//   }
//
//   if (check('CreatedDateTime', map)) {
//     date = map['CreatedDateTime'];
//   }
// }
//
// SaveUserVitalStatusRequest.fromMapForDb(Map map) {
//   if (map['id'] is int) {
//     id = map['id'];
//   }
//   if (map['HRV'] is num) {
//     HRV = map['HRV'];
//   }
//   if(map['HeartRate'] is num){
//     heartValue = map['HeartRate'];
//   }
//   if(map['Temperature'] is num){
//     temperature = map['Temperature'];
//   }
//   if(map['date'] is String){
//     date = map['date'];
//   }
//   if(map['CVRR'] is num){
//     cvrrValue = map['CVRR'];
//   }
//   if(map['Oxygen'] is num){
//     oxygen = map['Oxygen'];
//   }
// }
//
// Map<String, dynamic> toMap() {
//   try {
//     if(date?.isNotEmpty??false) {
//       final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
//       date = formatter.format(DateTime.parse(date!));
//     }
//   } catch (e) {
//     print('Exception at toMap $e');
//   }
//   if(tempInt == null && temperature != null){
//     var list = temperature?.toString().split('.');
//     if ((list?.length ?? 0) >= 2) {
//       tempInt = num.parse(list!.first);
//       tempDouble = num.parse(list.first);
//     }
//   }
//   return {
//     'HRV': HRV,
//     'HeartRate': heartValue,
//     'Temperature': num.parse('$tempInt.$tempDouble'),
//     'date': date,
//     'CVRR': cvrrValue,
//     'Oxygen': oxygen,
//     'IdForApi': idForApi,
//   };
// }
//
// Map<String, dynamic> toMapForAPI() {
//   try {
//     if(date?.isNotEmpty??false){
//       final formatter = DateFormat('yyyy-MM-dd HH:mm');
//       date = formatter.format(DateTime.parse(date!));
//     }
//   } catch (e) {
//     print('Exception at toMap $e');
//   }
//   temperature = num.parse('${tempInt??0}.${tempDouble??0}');
//   return {
//     'FKUserID': preferences!.getString(Constants.prefUserIdKeyInt),
//     'Temperature': num.parse('$temperature'),
//     'HRV': HRV,
//     'HeartRate': heartValue,
//     'CreatedDateTime': date,
//     'CVRR': cvrrValue,
//     'Oxygen': oxygen,
//   };
// }
//
// Map<String, dynamic> toJson() {
//   try {
//     if (date?.isNotEmpty ?? false) {
//       final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
//       date = formatter.format(DateTime.parse(date!));
//     }
//   } catch (e) {
//     print('Exception at toMap $e');
//   }
//   temperature = num.parse('${tempInt ?? 0}.${tempDouble ?? 0}');
//   return {
//     'FKUserID': preferences!.getString(Constants.prefUserIdKeyInt),
//     'Temperature': num.parse('$temperature'),
//     'HRV': HRV,
//     'HeartRate': heartValue,
//     'CreatedDateTime': date,
//     'CVRR': cvrrValue,
//     'Oxygen': oxygen,
//   };
// }
//
// bool check(String key, Map map) {
//   if (map[key] != null) {
//     if (map[key] is String && map[key] == 'null') {
//       return false;
//     }
//     return true;
//   }
//   return false;
// }
}
