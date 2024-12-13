// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationAddressModel _$LocationAddressModelFromJson(Map json) =>
    LocationAddressModel(
      savedName: json['savedName'] as String?,
      locationName: json['locationName'] as String?,
      locationAddress: json['locationAddress'] as String?,
      locationFullAddress: json['locationFullAddress'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      placesId: json['placesId'] as String?,
      isoCountryCode: json['isoCountryCode'] as String?,
      country: json['country'] as String?,
      altitude: (json['altitude'] as num?)?.toDouble() ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0,
      heading: (json['heading'] as num?)?.toDouble() ?? 0,
      speed: (json['speed'] as num?)?.toDouble() ?? 0,
      speedAccuracy: (json['speedAccuracy'] as num?)?.toDouble() ?? 0,
      time: (json['time'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$LocationAddressModelToJson(
        LocationAddressModel instance) =>
    <String, dynamic>{
      'savedName': instance.savedName,
      'locationName': instance.locationName,
      'locationAddress': instance.locationAddress,
      'locationFullAddress': instance.locationFullAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
      'placesId': instance.placesId,
      'isoCountryCode': instance.isoCountryCode,
      'country': instance.country,
      'altitude': instance.altitude,
      'accuracy': instance.accuracy,
      'heading': instance.heading,
      'speed': instance.speed,
      'speedAccuracy': instance.speedAccuracy,
      'time': instance.time,
    };
