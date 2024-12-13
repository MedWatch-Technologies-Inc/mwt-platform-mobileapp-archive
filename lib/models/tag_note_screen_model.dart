import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/models/covid_19_tag_type_model.dart';
import 'package:health_gauge/models/tag.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:image_picker/image_picker.dart';

// import 'home/home_screeen.dart';

class TagNoteScreenModel extends ChangeNotifier {
  bool writingNotes = false;
  bool isImageEditing = false;
  bool isEditTageImage = false;
  bool isShowLoadingScreen = true;
  bool isEdit = false;
  PickedFile? imageFile;
  double? selectedValue;
  String? base64Image;
  bool isGraphExist = false;
  DateTime? date;
  List<Uint8List> tagImagesList = [];
  List<String> tagImagesListString = [];
  String imageList = '';
  List<String> splitImages = [];

  int? customRadioIndex;
  List<Covid19TagTypeModel>? customRadioList;
  Color? customRadioColor;
  String? customRadioUnitText;
  List<Covid19TagTypeModel>? list;
  int? index;
  List<Covid19TagTypeModel>? covidList;
  Color? color;
  String? unitText;
  String unitSelectedType = '1';
  List unitSelectedTypeList = [];
  bool isLoading = true;
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  Uint8List? base64DecodedImage;
  List<Tag> tagList = [];
  String? userId;
  Tag? tag = Tag();
  double value = 0;
  double min = 0;
  double max = 10;
  int precision = 10;
  double minPicker = 0;
  double maxPicker = 1;
  double percisionPicker = 1;
  List listPicker = [];
  File? imageFiles;

  List<RadioModel> bloodGlucoseList = [
    RadioModel(false, 'mmol/L'),
    RadioModel(false, 'mg/dL')
  ];
  List<RadioModel> exerciseList = [
    RadioModel(false, stringLocalization.getText(StringLocalization.walking)),
    RadioModel(false, stringLocalization.getText(StringLocalization.hiking)),
    RadioModel(false, stringLocalization.getText(StringLocalization.running)),
    RadioModel(false, stringLocalization.getText(StringLocalization.biking)),
  ];
  List<RadioModel> temperatureList = [
    RadioModel(false, stringLocalization.getText(StringLocalization.celsius)),
    RadioModel(
        false, stringLocalization.getText(StringLocalization.fahrenheit)),
  ];
  List getValueListOfSelectedType(List values) {
    List list = [];
    try {
      list = values.map((element) {
        double mMol = element;
        if (unitSelectedType == '2') {
          if (tag?.tagType == TagType.bloodGlucose.value) {
            mMol = element * 18;
          } else if (tag?.tagType == TagType.temperature.value) {
            mMol = element;
          }
        }
        return double.parse(mMol.toStringAsFixed(2));
      }).toList();
    } catch (e) {
      print(e);
    }
    return list;
  }

  void isWriting() {
    writingNotes = true;
    notifyListeners();
  }

  void changeListPicker(double lp) {
    selectedValue = lp;
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

  void checkListNull(int index) {
    if (list != null) {
      list?[index].isSelected = !(list?[index].isSelected??false);
    } else {
      unitSelectedType = (index + 1).toString();
    }

    selectedValue ??= 0;
    if (unitSelectedType == '2') {
      if (tag?.tagType == TagType.bloodGlucose.value) {
        selectedValue = ((selectedValue! * 18).truncateToDouble());
      } else if (tag?.tagType == TagType.temperature.value) {
        selectedValue = double.parse(((selectedValue! * (9 / 5)) + 32).toStringAsFixed(1));
      }
    } else {
      if (tag?.tagType == TagType.bloodGlucose.value) {
        selectedValue = double.parse((selectedValue! / 18).toStringAsFixed(1));
        print(selectedValue);
      } else if (tag?.tagType == TagType.temperature.value) {
        selectedValue = double.parse(((selectedValue! - 32) * 5 / 9).toStringAsFixed(1));
      }
    }
    notifyListeners();
  }

  void isEditable() {
    isEditTageImage = false;
    notifyListeners();
  }

  void selectedTimes(time) {
    selectedTime = time;
    notifyListeners();
  }

  void selectedDates(date) {
    selectedDate = date;
    notifyListeners();
  }

  void updateIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void onChange(double selectedValue) {
    value = selectedValue;
    notifyListeners();
  }

  void updateIsLoadingScreen(bool value) {
    isShowLoadingScreen = value;
    notifyListeners();
  }

  void updateIsEdit(bool value) {
    isEdit = value;
    notifyListeners();
  }

  void updateImage(File croppedFile) {
    imageFiles = croppedFile;
    base64DecodedImage = imageFiles?.readAsBytesSync()??Uint8List.fromList([]);
    tagImagesList.add(base64DecodedImage!);

    notifyListeners();
  }

  void removeImage(int index) {
    tagImagesList.removeAt(index);
    if (tagImagesList.isEmpty) {
      isEditable();
    }
    notifyListeners();
  }

  void removeImageString(int index) {
    tagImagesListString.removeAt(index);
    if (tagImagesListString.isEmpty) {
      isEditable();
    }
    notifyListeners();
  }

  String convertImageToList(List tagImagesList,List tagImagesListString) {
    tagImagesList.forEach((element) {
      base64Image = base64Encode(element);
      imageList = imageList + base64Image! + ',';
     // imageList = imageList + element! + ',';
    });
    tagImagesListString.forEach((element) {
       imageList = imageList + element! + ',';
    });

    return imageList;
  }

  List<String> convertImageToListAPI(List tagImagesList, List tagImagesListString) {
    var temp = <String>[];

    for (var i = 0; i < tagImagesList.length; i++) {
      base64Image = base64Encode(tagImagesList[i]);
      temp.add(base64Image!);
    }
    for (var i = 0; i < tagImagesListString.length; i++) {
      temp.add(tagImagesListString[i]!);
    }
    return temp;
  }
}

class RadioModel {
  bool isSelected;
  final String text;

  RadioModel(this.isSelected, this.text);
}
