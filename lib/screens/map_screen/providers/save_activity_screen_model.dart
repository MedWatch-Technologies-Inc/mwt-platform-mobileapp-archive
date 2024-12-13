import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:health_gauge/screens/map_screen/model/workout_image_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:image_picker/image_picker.dart';

class SaveActivityScreenModel extends ChangeNotifier {
  double? value = 0;
  double? min = 0;
  double? max = 10;
  int? precision = 10;
  String? selectedActivity =
      preferences!.getString(Constants.prefActivityTitle) ?? "Walk";
  List<Uint8List>? activityImagesList = [];
  List<WorkoutImageModel>? activityImageModelList = [];
  List<WorkoutImageModel>? activityImageModelOldList = [];
  bool? isImageEditing = false;
  bool? isEditActivityImage = false;
  PickedFile? imageFile;
  File? imageFiles;
  Uint8List? base64DecodedImage;
  bool? errorTitle = false;
  int? currentSelectedActivityIndex = 0;
  int? currentShareOptionIndex = 0;

  /*List<TabModel> activityOptions = [
    TabModel(title: 'Run',image: 'asset/running_icon.png'),
    TabModel(title: 'Tennis',image: "asset/Sport/tennisBall_icon.png",),
    TabModel(title: 'Dumbbell',image: "asset/Sport/dumbbell_icon.png", ),
    TabModel(title: 'Football',image: "asset/Sport/football_icon.png",),
    TabModel(title: 'PingPong',image: "asset/Sport/pingpong_icon.png",),
    TabModel(title: 'Skating',image: "asset/Sport/skating_icon.png",),
    TabModel(title: 'Baseball',image: "asset/Sport/baseball_icon.png",),
    TabModel(title: 'Soccer',image: "asset/Sport/soccer_icon.png",),
    TabModel(title: 'Hockey',image: "asset/Sport/hockey_icon.png",),
    TabModel(title: 'Skiing',image: "asset/Sport/skiing_icon.png",),
    TabModel(title: 'Swimming',image: "asset/Sport/swimming_icon.png",),
    TabModel(title: 'Golf',image: "asset/Sport/golf_icon.png",),
    TabModel(title: 'Walking',image: "asset/Sport/walking_icon.png",),
    TabModel(title: 'Volleyball',image: "asset/Sport/volleyball_icon.png",),
    TabModel(title: 'Basketball',image: "asset/Sport/basketball_icon.png",),
    TabModel(title: 'Ice-Skating',image: 'asset/Sport/ice_skating_icon.png'),
    TabModel(title: 'Biking',image: "asset/Sport/biking_icon.png",),
    TabModel(title: 'Boxing',image: "asset/Sport/boxing_icon.png",),
    TabModel(title: 'Hiking',image: "asset/Sport/hiking_icon.png",),
  ];*/
  List<TabModel> activityOptions = [
    TabModel(
        title: 'Walking', image: 'asset/Sport/walking_icon.png', code: 0x08),
    TabModel(title: 'Running', image: 'asset/running_icon.png', code: 0x01),
    TabModel(
        title: 'Swimming', image: 'asset/Sport/swimming_icon.png', code: 0x02),
    TabModel(
        title: 'Mountaineering',
        image: 'asset/Sport/hiking_icon.png',
        code: 0x0B),
    TabModel(
        title: 'Cycling', image: 'asset/Sport/biking_icon.png', code: 0x03),
    TabModel(
        title: 'Fitness', image: 'asset/Sport/dumbbell_icon.png', code: 0x04),
    TabModel(title: 'Rope', image: 'asset/Sport/rope.png', code: 0x06),
    TabModel(
        title: 'Tennis', image: 'asset/Sport/tennisBall_icon.png', code: 0x0C),
    TabModel(
        title: 'Badminton', image: 'asset/Sport/tennis_icon.png', code: 0x09),
    TabModel(
        title: 'Football', image: 'asset/Sport/football_icon.png', code: 0x0A),
    TabModel(
        title: 'Basketball',
        image: 'asset/Sport/basketball_icon.png',
        code: 0x07),
  ];
  List<TabModel> shareOptions = [
    TabModel(title: 'Friends', image: 'asset/mapScreenActivity/friends.png'),
    TabModel(title: 'EveryOne', image: 'asset/mapScreenActivity/globe.png'),
    TabModel(title: 'Only Me', image: 'asset/mapScreenActivity/lock.png'),
  ];

  void updateActivityIndex(int index) {
    currentSelectedActivityIndex = index;
    notifyListeners();
  }

  void updateShareIndex(int index) {
    currentShareOptionIndex = index;
    notifyListeners();
  }

  void onChange(double selectedValue) {
    value = selectedValue;
    notifyListeners();
  }

  void updateSelectedType(String value) {
    selectedActivity = value;
    notifyListeners();
  }

  void imageEditing() {
    isImageEditing = true;
    notifyListeners();
  }

  void imageNotEditing() {
    isImageEditing = false;
    notifyListeners();
  }

  void removeImage(int index) {
    activityImagesList!.removeAt(index);
    activityImageModelList!.removeAt(index);
    activityImageModelOldList!.removeAt(index);
    if (activityImagesList!.isEmpty) {
      isEditable();
    }
    notifyListeners();
  }

  void isEditable() {
    isEditActivityImage = false;
    notifyListeners();
  }

  void updateImage(File croppedFile) {
    imageFiles = croppedFile;
    base64DecodedImage = imageFiles!.readAsBytesSync();
    activityImagesList!.add(base64DecodedImage!);
    activityImageModelList!.add(WorkoutImageModel(
        image: base64DecodedImage, description: '', time: DateTime.now()));
    activityImageModelOldList!.add(WorkoutImageModel(
        image: base64DecodedImage, description: '', time: DateTime.now()));
    notifyListeners();
  }

  void isTitleError(bool error) {
    errorTitle = error;
    notifyListeners();
  }
}

class TabModel {
  String? title;
  String? image;
  int? code;

  TabModel({this.title, this.image, this.code});
}
