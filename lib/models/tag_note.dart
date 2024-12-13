import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PassTagParams {
  String? date;
  String? time;
  double? value;
  String? note;
  String? unitSelectedType;

  PassTagParams(
      {this.unitSelectedType, this.time, this.value, this.date, this.note});
}

class TagNote {
  int? id;
  int? tagId;
  String? tagApiId;
  String? apiId;
  String? label;
  String? userId;
  String? date;
  String? time;
  double? value;
  String? note;
  int? isRemove;
  int? isSync;
  String? imageFiles;
  String? patchLocation;
  String shortDescription = '';

  String? unitSelectedType;

  // List unitSelectedType;

  int? tagType;

  String? createdDateTimeStamp;

  TagNote({
    this.id,
    this.tagId,
    this.tagApiId,
    this.label,
    this.userId,
    this.date,
    this.time,
    this.value,
    this.note,
    this.isRemove,
    this.unitSelectedType,
    this.isSync,
    this.imageFiles,
    this.patchLocation,
    this.createdDateTimeStamp,
    this.shortDescription = '',
  });

  TagNote.fromMap(map) {
    if (check('Id', map)) {
      id = map['Id'];
    }
    if (check('ID', map)) {
      apiId = map['ID'].toString();
    }
    if (check('FKTagLabelID', map)) {
      tagApiId = map['FKTagLabelID'].toString();
    }
    if (check('IdForApi', map)) {
      apiId = map['IdForApi'].toString();
    }
    if (check('IdForApi', map)) {
      tagApiId = map['TagIdForApi'].toString();
    }
    if (check('UserId', map)) {
      userId = map['UserId'];
    }
    if (check('TagId', map)) {
      tagId = map['TagId'];
    }
    if (check('Label', map)) {
      label = map['Label'];
    }
    if (check('TypeName', map)) {
      label = map['TypeName'];
    }
    if (check('Date', map)) {
      date = map['Date'];
    }
    if (check('Short_description', map)) {
      shortDescription = map['Short_description'];
    }
    if (check('CreatedDateTimeTimestamp', map)) {
      try {
        var number = int.tryParse(map['CreatedDateTimeTimestamp']);
        if(number == null){
          date = DateTime.parse(map['CreatedDateTimeTimestamp']).toString();
        }else{
          date = DateTime.fromMillisecondsSinceEpoch(
              int.parse(map['CreatedDateTimeTimestamp']))
              .toString();
        }
      } catch (e) {
        print(e);
      }
    }
    if (check('Time', map)) {
      time = map['Time'];
    }
    if (check('CreatedDateTimeTimestamp', map)) {
      try {
        var number = int.tryParse(map['CreatedDateTimeTimestamp']);
        if(number == null){
          var dateTime = DateTime.parse(map['CreatedDateTimeTimestamp']);
          var timeOfDay = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
          time = timeOfDay.toString();
        }else{
          var dateTime = DateTime.fromMillisecondsSinceEpoch(
              int.parse(map['CreatedDateTimeTimestamp']));
          var timeOfDay =
          TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
          time = timeOfDay.toString();
        }
      } catch (e) {
        print(e);
      }
    }
    if (check('Value', map)) {
      value = map['Value'];
    }
    if (check('TagValue', map)) {
      value = double.parse(map['TagValue'].toString());
    }
    if (check('Note', map)) {
      note = map['Note'];
    }
    if (check('isRemove', map)) {
      isRemove = map['isRemove'];
    }
    if (check('isSync', map)) {
      isSync = map['isSync'];
    }

    if (check('PatchLocation', map)) {
      patchLocation = map['PatchLocation'];
    }


    try {
      if (check('AttachFiles', map)) {
        imageFiles = '';
        // Future.forEach(map['AttachFiles'], (element) async {
        //   var url = Uri.parse(element.toString());
        //   await http.get(url).then((value) {
        //     final bytes = value.bodyBytes;
        //     imageFiles = imageFiles!+','+bytes.toString();
        //   });


      //  });
        if(map['AttachFiles'].runtimeType==String){
          imageFiles = map['AttachFiles'];
        }
        else {
          map['AttachFiles'].forEach((element) {
            //  print(element.toString());
            //  var url = Uri.parse(element.toString());
            //final bytes =  await NetworkAssetBundle(url).load(element.toString());
            // var bytes = await downloadImage(url,element);
            imageFiles = imageFiles! + element.toString() + ",";
          });
          if(imageFiles!=''){
            imageFiles = imageFiles?.substring(0, imageFiles!.length-1);
          }
        }
       // imageFiles = map['AttachFiles'];

        // if(imageFiles!=','){
        //   imageFiles = imageFiles?.substring(2, imageFiles?.length!);
        // }
        // var tempImage = map['AttachFiles'].toString();
        // var image = tempImage.split(',');
        // image.forEach((element) async {
        //   imageFiles = imageFiles! + element;
        // });
      }

      if (check('unitSelectedType', map)) {
        unitSelectedType = map['unitSelectedType'].toString();
      }
      if (check('UnitSelectedType', map)) {
        unitSelectedType = map['UnitSelectedType'].toString();
      }
    } catch (e) {
      print(e);
    }

    if (check('tagType', map)) {
      tagType = map['tagType'];
    }

    if (check('CreatedDateTimeTimestamp', map)) {
      createdDateTimeStamp = map['CreatedDateTimeTimestamp'];
    }
  }


  Future<String?> networkImageToBase64({required String imageUrl}) async {
    if(imageUrl.length>0){
      imageUrl = imageUrl.substring(1,imageUrl.length);
    }
    http.Response response = await http.get(Uri.parse(imageUrl));
    final List<int>? bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  Map<String, dynamic> toMap() {
    return {
      'UserId': userId,
      'TagId': tagId,
      'IdForApi': apiId,
      'TagIdForApi': tagApiId,
      'Label': label,
      'Date': date,
      'Time': time,
      'Value': value,
      'Note': note,
      'isRemove': isRemove ?? 0,
      'isSync': isSync ?? 0,
      'unitSelectedType': unitSelectedType ?? '1',
      'tagType': tagType ?? 0,
      'CreatedDateTimeTimestamp': createdDateTimeStamp,
      'AttachFiles': imageFiles,
      'PatchLocation': patchLocation ?? '',
      'Short_description': shortDescription
    };
  }

  bool check(String key, Map map) {
    if (map[key] != null) {
      if (map[key] is String && map[key] == 'null') {
        return false;
      }
      return true;
    }
    return false;
  }
}
