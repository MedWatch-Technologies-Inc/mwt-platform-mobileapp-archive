import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/tag_note_screen_model.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/utils/Strings.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class ProfileModel extends ChangeNotifier {
  /// Added by: Akhil
  /// Added on: April/05/2021
  /// this variable is responsible for indicating if profile is edited.
  bool? isEdit = false;

  /// Added by: Akhil
  /// Added on: April/05/2021
  /// this variable is responsible for indicating if profile photo should be reloaded.
  bool? profileImageChangeIndicator = false;

  bool? isLoadForLocalDb = true;

  String? userId;

  UserModel? user;

  AppImages? images = AppImages();
  String? gender = 'M';
  String? unit = Strings().imperial;
  DateTime? dateOfBirth = DateTime(1900);

  String? selectedColor;

  List? feetList = [1, 2, 3, 4, 5, 6, 7];
  List? inchList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  List? poundList = [];
  List? kilogramList = [];

  List? colorList = [
    '#85604B',
    '#9D7C69',
    '#B49380',
    '#CFAD9A',
    '#EBCDBC',
  ];

  TextEditingController researcherProfileTextEditController =
      TextEditingController(); // text controller for entering researcher password
  bool? isResearcherProfile = false; // to check whether profile is researcher or not
  bool? isRemove = false;

  final dbHelper = DatabaseHelper.instance;

  Uint8List? base64DecodedImage;
  String? profilePic;

  DeviceModel? connectedDevice;

  List<RadioModel>? genderList = [
    RadioModel(false, stringLocalization.getText(StringLocalization.male)),
    RadioModel(false, stringLocalization.getText(StringLocalization.female)),
    RadioModel(false, stringLocalization.getText(StringLocalization.others))
  ];

  List<RadioModel>? unitList = [
    RadioModel(false, stringLocalization.getText(StringLocalization.metric)),
    RadioModel(false, stringLocalization.getText(StringLocalization.imperial))
  ];

  // weight, height
  int? profileFeet = 5;
  int? profileInch = 0;
  int? profileCentimetre = 150;
  double? profilePound = 110;
  double? profileKg = 50;

  double? profileMaxPound = 110;
  double? profileMaxKg = 50;

  int? profileHeightUnit = preferences?.getInt(Constants.mHeightUnitKey) ?? 0;
  int? profileWeightUnit =
      preferences?.getInt(Constants.wightUnitKey) ?? UnitTypeEnum.metric.getValue();

  String? heightText = '';

  bool savingData = false;

  double get getProfileKG =>
      double.tryParse(profileKg.toString().contains('.')
          ? profileKg.toString().split('.').first
          : profileKg.toString()) ??
      50.0;

  double get getProfileMaxKG =>
      double.tryParse(profileMaxKg.toString().contains('.')
          ? profileMaxKg.toString().split('.').first
          : profileMaxKg.toString()) ??
      50.0;

  double get getProfilePound =>
      double.tryParse(profilePound.toString().contains('.')
          ? profilePound.toString().split('.').first
          : profilePound.toString()) ??
      110.0;

  double get getProfileMaxPound =>
      double.tryParse(profileMaxPound.toString().contains('.')
          ? profileMaxPound.toString().split('.').first
          : profileMaxPound.toString()) ??
      110.0;

  ProfileModel() {
    for (var i = 66; i < 441; i++) {
      poundList?.add(i);
    }
    for (var i = 30; i < 201; i++) {
      kilogramList?.add(i);
    }
    savingData = false;
  }

  /// Added by: Akhil
  /// Added on: April/05/2021
  /// this funciton is responsible for updating isEdit.
  void updateIsEdit(bool val) {
    if (isEdit != val) {
      isEdit = val;
      notifyListeners();
    }
  }

  /// Added by: Akhil
  /// Added on: April/05/2021
  /// this funciton is responsible for updating profileImageChangeIndicator.
  void updateProfileImageChangeIndicator() {
    profileImageChangeIndicator = !(profileImageChangeIndicator ?? false);
    notifyListeners();
  }

  void updateGender(String gender) {
    this.gender = gender;
    if (base64DecodedImage == null) // || user.picture.isNotEmpty)
    {
      updateProfileImageChangeIndicator();
    } else
      notifyListeners();
  }

  void updateIsResearcherProfile(bool isResearcherProfile) {
    this.isResearcherProfile = isResearcherProfile;
    notifyListeners();
  }

  void updateUnit(String unit) {
    this.unit = unit;
    notifyListeners();
  }

  void updateSelectedColor(String selectedColor) {
    this.selectedColor = selectedColor;
    notifyListeners();
  }

  void updateDOB(DateTime dateOfBirth) {
    this.dateOfBirth = dateOfBirth;
    notifyListeners();
  }

  void updateIsRemove(bool isRemove) {
    this.isRemove = isRemove;
    notifyListeners();
  }

  void updateImage(dynamic base64DecodedImage) {
    this.base64DecodedImage = base64DecodedImage;
    updateProfileImageChangeIndicator();
    // notifyListeners();
  }

  void updateConnectedDevice(DeviceModel connectedDevice) {
    this.connectedDevice = connectedDevice;
    notifyListeners();
  }

  void updateUser(UserModel user) {
    this.user = user;
    notifyListeners();
  }

  void updateProfileFeet(int profileFeet) {
    this.profileFeet = profileFeet;
    notifyListeners();
  }

  void updateProfileInch(int profileInch) {
    this.profileInch = profileInch;
    notifyListeners();
  }

  void updateProfileCentimetre(int profileCentimetre) {
    this.profileCentimetre = profileCentimetre;
    notifyListeners();
  }

  void updateProfilePound(double profilePound) {
    this.profilePound = profilePound;
    notifyListeners();
  }

  void updateProfileKg(double profileKg) {
    this.profileKg = profileKg;
    notifyListeners();
  }

  void updateProfileMaxPound(double profileMaxPound) {
    this.profileMaxPound = profileMaxPound;
    notifyListeners();
  }

  void updateProfileMaxKg(double profileMaxKg) {
    this.profileMaxKg = profileMaxKg;
    notifyListeners();
  }

  void updateIsLoadForLocalDb(bool isLoadForLocalDb) {
    this.isLoadForLocalDb = isLoadForLocalDb;
    notifyListeners();
  }

  void updateProfileWeightUnit(int profileWeightUnit) {
    this.profileWeightUnit = profileWeightUnit;
    notifyListeners();
  }

  void updateProfileHeightUnit(int profileHeightUnit) {
    this.profileHeightUnit = profileHeightUnit;
    notifyListeners();
  }

  void updateHeightText(String heightText) {
    this.heightText = heightText;
    notifyListeners();
  }

  void onClose() {
    weightUnit = profileWeightUnit ?? 1;
    heightUnit = profileHeightUnit ?? -1;
    feet = profileFeet ?? -1;
    inch = profileInch ?? -1;
    kg = profileKg ?? -1;
    pound = profilePound ?? -1;
    maxKg = profileMaxKg ?? -1;
    maxPound = profileMaxPound ?? -1;
    centimetre = profileCentimetre ?? -1;
  }
}
