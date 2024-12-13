import 'package:geolocator/geolocator.dart';
import 'package:health_gauge/repository/activity_tracker/model/get_recognition_activity_list_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationAddressModel {
  String? savedName;
  String? locationName;
  String? locationAddress;
  String? locationFullAddress;
  @JsonKey(name: 'latitude')
  double? latitude;
  @JsonKey(name: 'longitude')
  double? longitude;
  String? notes;
  String? placesId;
  String? isoCountryCode;
  String? country;

  /// The altitude of the device in meters.
  ///
  /// The altitude is not available on all devices. In these cases the returned
  /// value is 0.0.
  @JsonKey(name: 'altitude')
  double? altitude = 0;

  /// The estimated horizontal accuracy of the position in meters.
  ///
  /// The accuracy is not available on all devices. In these cases the value is
  /// 0.0.
  @JsonKey(name: 'accuracy')
  double? accuracy = 0;

  /// The heading in which the device is traveling in degrees.
  ///
  /// The heading is not available on all devices. In these cases the value is
  /// 0.0.
  @JsonKey(name: 'heading')
  double? heading = 0;

  /// The speed at which the devices is traveling in meters per second over
  /// ground.
  ///
  /// The speed is not available on all devices. In these cases the value is
  /// 0.0.
  @JsonKey(name: 'speed')
  double? speed = 0;

  /// The estimated speed accuracy of this position, in meters per second.
  ///
  /// The speedAccuracy is not available on all devices. In these cases the
  /// value is 0.0.
  @JsonKey(name: 'speedAccuracy')
  double? speedAccuracy = 0;

  /// stores the time at which event occurs in milli seconds since epoch
  @JsonKey(name: 'time')
  double? time = 0;

  LocationAddressModel({
    this.savedName,
    this.locationName,
    this.locationAddress,
    this.locationFullAddress,
    this.latitude,
    this.longitude,
    this.notes,
    this.placesId,
    this.isoCountryCode,
    this.country,
    this.altitude = 0,
    this.accuracy = 0,
    this.heading = 0,
    this.speed = 0,
    this.speedAccuracy = 0,
    this.time = 0,
  });

  LocationAddressModel.fromPosition(Position position) {
    latitude = position.latitude;
    longitude = position.longitude;
    altitude = position.altitude;
    accuracy = position.accuracy;
    heading = position.heading;
    speed = position.speed;
    speedAccuracy = position.speedAccuracy;
    time = DateTime.now().millisecondsSinceEpoch.toDouble();
  }

  factory LocationAddressModel.fromJson(Map<String, dynamic> srcJson) =>
      _$LocationAddressModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LocationAddressModelToJson(this);

  static LocationAddressModel mapper(LocationData obj) {
    var model = LocationAddressModel();
    model
      ..speed = obj.speed!.toDouble()
      ..altitude = double.tryParse(obj.altitude!) ?? 0.0
      ..latitude = double.tryParse(obj.latitude!) ?? 0.0
      ..longitude = double.tryParse(obj.longitude!) ?? 0.0
      ..time = double.tryParse(obj.time!)
      ..accuracy = double.tryParse(obj.accuracy!)
      ..speedAccuracy = double.tryParse(obj.speedAccuracy!.toString());
    return model;
  }
// factory LocationAddressModel.fromMap(Map<String, dynamic> dataMap) {
//   return LocationAddressModel(
//     latitude: dataMap['latitude'],
//     longitude: dataMap['longitude'],
//     accuracy: dataMap['accuracy'] ?? 0.0,
//     altitude: dataMap['altitude'] ?? 0.0,
//     speed: dataMap['speed'] ?? 0.0,
//     speedAccuracy: dataMap['speed_accuracy'] ?? 0.0,
//     heading: dataMap['heading'] ?? 0.0,
//     time: dataMap['time'],
//   );
// }
//
// Map<String, dynamic> toJson() {
//   final data = <String, dynamic>{};
//   data['latitude'] = latitude;
//   data['longitude'] = longitude;
//   data['accuracy'] = accuracy;
//   data['altitude'] = altitude;
//   data['speed'] = speed;
//   data['speed_accuracy'] = speedAccuracy;
//   data['heading'] = heading;
//   data['time'] = time;
//   return data;
// }
}