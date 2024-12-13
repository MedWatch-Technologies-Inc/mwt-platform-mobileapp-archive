import 'dart:typed_data';

class WorkoutImageModel {
  Uint8List? image;
  String? description;
  DateTime? time;

  WorkoutImageModel({this.image, this.description, this.time});
}
