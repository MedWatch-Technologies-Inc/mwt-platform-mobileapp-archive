// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_and_update_shared_with_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveAndUpdateSharedWithRequest _$SaveAndUpdateSharedWithRequestFromJson(
        Map json) =>
    SaveAndUpdateSharedWithRequest(
      sharedMessage: json['SharedMessage'] as String?,
      userID: json['UserID'] as int?,
      fKLirabaryID: json['FKLirabaryID'] as int?,
      fKSharedUserID: (json['FKSharedUserID'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      accessspicefire: json['Accessspicefire'] as int?,
      savedAccessID: (json['SavedAccessID'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      savedAccessChanged: (json['SavedAccessChanged'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      sharedDateTimeStamp: json['SharedDateTimeStamp'] as int?,
    );

Map<String, dynamic> _$SaveAndUpdateSharedWithRequestToJson(
        SaveAndUpdateSharedWithRequest instance) =>
    <String, dynamic>{
      'SharedMessage': instance.sharedMessage,
      'UserID': instance.userID,
      'FKLirabaryID': instance.fKLirabaryID,
      'FKSharedUserID': instance.fKSharedUserID,
      'Accessspicefire': instance.accessspicefire,
      'SavedAccessID': instance.savedAccessID,
      'SavedAccessChanged': instance.savedAccessChanged,
      'SharedDateTimeStamp': instance.sharedDateTimeStamp,
    };
