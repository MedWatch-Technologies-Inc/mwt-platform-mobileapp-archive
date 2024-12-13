import 'package:health_gauge/screens/map_screen/model/activity_model.dart';

class WorkoutModel {
  String? name;
  String? userImage;
  String? image;
  DateTime? date;
  String? place;
  String? title;
  String? pace;
  String? avgPace;
  String? calorie;
  String? distance;
  String? duration;
  String? maxPace;
  int? likes;
  int? commentLength;
  ActivityModel? activityModel;
  int? unit;

  WorkoutModel(
      {this.name,
      this.userImage,
      this.image,
      this.date,
      this.place,
      this.title,
      this.pace,
      this.avgPace,
      this.calorie,
      this.distance,
      this.likes,
      this.commentLength,
      this.activityModel,
      this.duration,
      this.maxPace,
      this.unit});
}
