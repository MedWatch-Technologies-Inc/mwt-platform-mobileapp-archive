
import 'package:health_gauge/repository/auth/model/user_result.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:intl/intl.dart';

class UserModel {
  int? id = 0;
  String? userId = '';
  int? deviceId = 0;
  String? firstName = '';
  String? lastName = '';
  String? email = '';
  String? userName = '';
  String? picture = '';
  String? gender = '';
  String? height = '150';
  String? weight = '50';
  String? userRole = '';
  DateTime? dateOfBirth = new DateTime(1900);
  String? skinType = '';

  // int unit = 0;
  int? isSync = 1;
  bool? isResearcherProfile = false;
  int? isRemove = 0;
  String? maxWeight = '';
  bool? isConfirmedUser = false;
  int? userGroup = 0;
  int? userMeasurementTypeId = 1;
  String? deviceToken = '';
  int? weightUnit;
  int? heightUnit;

  UserModel({
    this.id,
    this.userId,
    this.deviceId,
    this.firstName,
    this.lastName,
    this.email,
    this.userName,
    this.picture,
    this.gender,
    this.height,
    this.weight,
    this.userRole,
    this.dateOfBirth,
    this.skinType,
    this.isSync,
    this.isResearcherProfile,
    this.maxWeight,
    this.isConfirmedUser,
    this.userGroup,
    this.userMeasurementTypeId,
    this.deviceToken,
    this.heightUnit,
    this.weightUnit
  });

  UserModel.fromMap(Map map) {
    if (check('id', map)) {
      id = map['id'];
    }
    if (check('UserID', map)) {
      userId = map['UserID'].toString();
    }
    if (check('UserId', map)) {
      userId = map['UserId'].toString();
    }
    if (check('Userid', map)) {
      userId = map['Userid'].toString();
    }
    if (check('DeviceID', map)) {
      deviceId = map['DeviceID'];
    }
    if (check('FirstName', map)) {
      firstName = map['FirstName'];
    }
    if (check('LastName', map)) {
      lastName = map['LastName'];
    }
    if (check('Email', map)) {
      email = map['Email'];
    }
    if (check('UserName', map)) {
      userName = map['UserName'];
    }
    if (check('Picture', map)) {
      picture = map['Picture'];
    }
    if (check('Profile', map)) {
      picture = map['Profile'];
    }
    if (check('Gender', map)) {
      gender = map['Gender'];
    }
    if (check('Height', map)) {
      height = map['Height'].toString();
    }
    if (check('Weight', map)) {
      weight = map['Weight'].toString();
    }
    if (check('InitialWeight', map)) {
      maxWeight = map['InitialWeight'].toString();
    }
    if (check('UserRole', map)) {
      userRole = map['UserRole'];
    }
   /* if (check('UnitNameID', map)) {
      unit = map['UnitNameID'];
    }

    if (check('Unit', map)) {
      unit = int.parse(map['Unit'].toString());
    }*/
    if (check('BirthDate', map)) {
      try {
        dateOfBirth = DateTime.parse(map['BirthDate']);
      } catch (e) {
        print(e);
      }
    }
    if (check('DateOfBirth', map)) {
      try {
        dateOfBirth = DateFormat(DateUtil.yyyyMMdd).parse(map['DateOfBirth']);
      } catch (e) {
        print(e);
      }
      // try {
      //   dateOfBirth = DateFormat('MMM dd yyyy').parse(map['DateOfBirth']);
      // } catch (e) {
      //   print(e);
      // }
    }

    if (check('SkinType', map)) {
      skinType = map['SkinType'];
    }
    if (check('IsSync', map)) {
      isSync = map['IsSync'];
    }
    if (check('IsRemove', map)) {
      isRemove = map['IsRemove'];
    }
    if (check('IsResearcherProfile', map) && map['IsResearcherProfile'] is int) {
      isResearcherProfile = map['IsResearcherProfile'] == 1 ? true : false;
    }
    if (check('IsResearcherProfile', map) && map['IsResearcherProfile'] is bool) {
      isResearcherProfile = map['IsResearcherProfile'];
    }
    if (check('IsConfirmed', map)&& map['IsConfirmed'] is int) {
      isConfirmedUser = map['IsConfirmed'] == 1 ? true : false ;
    }
    if (check('IsConfirmed', map) && map['IsConfirmed'] is bool) {
      isConfirmedUser = map['IsConfirmed'];
    }
    if (check('UserGroup', map)) {
      userGroup = map['UserGroup'];
    }
    if (check('UserMeasurementTypeID', map)) {
      userMeasurementTypeId = map['UserMeasurementTypeID'];
    }
    if (check('DeviceToken', map)) {
      deviceToken = map['DeviceToken'];
    }
    if (check('HeightUnit', map)) {
      heightUnit = map['HeightUnit'];
    }
    if (check('WeightUnit', map)) {
      weightUnit = map['WeightUnit'];
    }
  }

  // String toRawJson() => json.encode(toJson());
  //
  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'UserID': userId,
  //       'DeviceID': deviceId,
  //       'FirstName': firstName,
  //       'LastName': lastName,
  //       'Email': email,
  //       'UserName': userName,
  //       'Picture': picture,
  //       'Gender': gender,
  //       'Height': height,
  //       'Weight': weight,
  //       'UserRole': userRole,
  //       'DateOfBorth': dateOfBirth,
  //        'DateOfBirth': dateOfBirth,
  //       'SkinType': skinType,
  //       'IsResearcherProfile': isResearcherProfile,
  //       'InitialWeight': maxWeight,
  //       'IsConfirmed' : isConfirmedUser,
  //       'UserGroup' : userGroup,
  //   'UserMeasurementTypeID': userMeasurementTypeId,
  //     };

  Map<String, dynamic> toJsonForInsertUsingSignInOrSignUp() => {
        'UserID': userId.toString(),
        'Profile': picture,
        'UserName': userName,
        'FirstName': firstName,
        'LastName': lastName,
        'Gender': gender.toString(),
        // 'Unit': unit.toString(),
        'Height': height.toString(),
        'Weight': weight.toString(),
        'BirthDate': dateOfBirth.toString(),
        'SkinType': skinType,
        'IsSync': isSync,
        'IsRemove': isRemove ?? 0,
        'IsResearcherProfile': (isResearcherProfile ?? false) ? 1 : 0,
        'InitialWeight': maxWeight.toString(),
        'IsConfirmed': (isConfirmedUser ?? false) ? 1 : 0,
        'UserGroup': userGroup ?? -1,
        'UserMeasurementTypeID': userMeasurementTypeId,
        'HeightUnit' : heightUnit,
        'WeightUnit' : weightUnit
      };

  // UserModel.fromJson(Map map) {
  //   if (check('id', map)) {
  //     id = map['id'];
  //   }
  //   if (check('UserID', map)) {
  //     userId = map['UserID'].toString();
  //   }
  //   if (check('UserId', map)) {
  //     userId = map['UserId'].toString();
  //   }
  //   if (check('Userid', map)) {
  //     userId = map['Userid'].toString();
  //   }
  //   if (check('DeviceID', map)) {
  //     deviceId = map['DeviceID'];
  //   }
  //   if (check('FirstName', map)) {
  //     firstName = map['FirstName'];
  //   }
  //   if (check('LastName', map)) {
  //     lastName = map['LastName'];
  //   }
  //   if (check('Email', map)) {
  //     email = map['Email'];
  //   }
  //   if (check('UserName', map)) {
  //     userName = map['UserName'];
  //   }
  //   if (check('Picture', map)) {
  //     picture = map['Picture'];
  //   }
  //   if (check('Profile', map)) {
  //     picture = map['Profile'];
  //   }
  //   if (check('Gender', map)) {
  //     gender = map['Gender'];
  //   }
  //   if (check('Height', map)) {
  //     height = map['Height'].toString();
  //   }
  //   if (check('Weight', map)) {
  //     weight = map['Weight'].toString();
  //   }
  //   if (check('InitialWeight', map)) {
  //     maxWeight = map['InitialWeight'].toString();
  //     // map['InitialWeight'].toString()=='0.0'? maxWeight='1.0':maxWeight = map['InitialWeight'].toString();
  //   }
  //   if (check('UserRole', map)) {
  //     userRole = map['UserRole'];
  //   }
  //   /* if (check('UnitNameID', map)) {
  //     unit = map['UnitNameID'];
  //   }
  //
  //   if (check('Unit', map)) {
  //     unit = int.parse(map['Unit'].toString());
  //   }*/
  //   if (check('BirthDate', map)) {
  //     try {
  //       dateOfBirth = DateTime.parse(map['BirthDate']);
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  //   if (check('DateOfBirth', map)) {
  //     try {
  //       dateOfBirth = DateFormat(DateUtil.yyyyMMdd).parse(map['DateOfBirth']);
  //     } catch (e) {
  //       print(e);
  //     }
  //     // try {
  //     //   dateOfBirth = DateFormat('MMM dd yyyy').parse(map['DateOfBirth']);
  //     // } catch (e) {
  //     //   print(e);
  //     // }
  //   }
  //
  //   if (check('SkinType', map)) {
  //     skinType = map['SkinType'];
  //   }
  //   if (check('IsSync', map)) {
  //     isSync = map['IsSync'];
  //   }
  //   if (check('IsRemove', map)) {
  //     isRemove = map['IsRemove'];
  //   }
  //   if (check('IsResearcherProfile', map) &&
  //       map['IsResearcherProfile'] is int) {
  //     isResearcherProfile = map['IsResearcherProfile'] == 1 ? true : false;
  //   }
  //   if (check('IsResearcherProfile', map) &&
  //       map['IsResearcherProfile'] is bool) {
  //     isResearcherProfile = map['IsResearcherProfile'];
  //   }
  //   if (check('IsConfirmed', map) && map['IsConfirmed'] is int) {
  //     isConfirmedUser = map['IsConfirmed'] == 1 ? true : false;
  //   }
  //   if (check('IsConfirmed', map) && map['IsConfirmed'] is bool) {
  //     isConfirmedUser = map['IsConfirmed'];
  //   }
  //   if (check('UserGroup', map)) {
  //     userGroup = map['UserGroup'];
  //   }
  //   if (check('UserMeasurementTypeID', map)) {
  //     userMeasurementTypeId = map['UserMeasurementTypeID'];
  //   }
  //   if (check('DeviceToken', map)) {
  //     deviceToken = map['DeviceToken'];
  //   }
  // }
  //
  bool check(String key, Map map) {
    if (map[key] != null) {
      if (map[key] is String && map[key]?.toString().toLowerCase() == 'null') {
        return false;
      }
      return true;
    }
    return false;
  }

  static UserModel mapper(UserResult obj) {
    var model = UserModel();
    model
      ..deviceToken = obj.deviceToken
      ..userMeasurementTypeId = obj.userMeasurementTypeID
      ..userId = obj.userID.toString()
      ..id = obj.id
      ..userName = obj.userName
      ..email = obj.email
      ..weight = obj.weight
      ..height = obj.height
      ..gender = obj.gender
      ..dateOfBirth = DateFormat(DateUtil.yyyyMMdd).parse((obj.dateOfBirth != null && obj.dateOfBirth!.isNotEmpty ) ? obj.dateOfBirth! : DateTime.now().toString())
      ..isResearcherProfile = obj.isResearcherProfile
      ..deviceId = obj.deviceID
      ..maxWeight = obj.initialWeight.toString()
      ..firstName = obj.firstName
      ..lastName = obj.lastName
      ..picture = obj.picture
      ..skinType = obj.skinType
      ..userGroup = obj.userGroup
      ..isConfirmedUser = obj.isConfirmed
      ..weightUnit = obj.weightUnit
      ..heightUnit = obj.heightUnit;

    return model;
  }
}
