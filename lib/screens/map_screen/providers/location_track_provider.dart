import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_gauge/screens/map_screen/model/heart_rate_model.dart';
import 'package:health_gauge/screens/map_screen/model/image_model.dart';
import 'package:health_gauge/screens/map_screen/model/workout_image_model.dart';
import 'package:health_gauge/screens/map_screen/parser/upload_images.dart';
import 'package:health_gauge/screens/map_screen/providers/save_activity_screen_model.dart';
import 'package:health_gauge/services/location/location_service_manager.dart';
import 'package:health_gauge/services/location/model/location_model.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/calculate_activity_items.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class LocationTrackProvider extends ChangeNotifier {
  DateTime? _startTime;
  DateTime? _endTime;
  List<LocationAddressModel>? _locationList = [];
  List<LocationAddressModel>? tempLocationList = [];
  List<LocationAddressModel>? _locationListForFirebase = [];
  List<ActivityEvent>? _activityEventList = [];
  List<HeartRateModel> heartRate = [];
  bool? isBottomSheet = false;
  List? ActivitiesList = [];
  CalculateActivityItems? activityItems = new CalculateActivityItems();
  LocationAddressModel? lastLocation;
  double distance = 0;
  double avgSpeed = 0;
  LocationAddressModel? oldLocation;

  // Activity Recognition variable
  ActivityEvent? lastEvent;
  bool? activityStillCount = false;

  ImageModel? _mapImage;
  List<ImageModel>? _listOfImages;

  double? _activityIntensity = 0;
  String? _typeTitle = '';
  String? title = preferences!.getString(Constants.prefActivityTitle) ?? 'Walk';

  int countTime = 0;
  bool _isStarted = false;
  bool _isPause = false;
  bool _isShowTimer = false;

  Timer? timer;
  StreamSubscription<LocationAddressModel>? locationDataStream;
  StreamSubscription<ActivityEvent>? activityStream;
  StreamSubscription<LocationAddressModel>? streamLocationDataModel;

  ImageModel? get mapImage => _mapImage;

  double last5LatAvg = 0;
  double last5LongAvg = 0;
  double last5speedAvg = 0;
  double last5altitudeAvg = 0;
  double last5LatSum = 0;
  double last5LongSum = 0;
  double last5speedSum = 0;
  double last5altitudeSum = 0;

  int rollingAverage = 5;

  bool manuallyPause = false;
  Timer? speedTimer;
  Timer? manuallyPauseTimer;

  XFile? imageFile;
  File? imageFiles;
  Uint8List? base64DecodedImage;
  List<Uint8List>? activityImagesList = [];
  List<WorkoutImageModel>? activityImageModelList = [];
  List<WorkoutImageModel>? activityImageModelOldList = [];
  bool speedOver35 = false;

  TabModel? workoutType;

  void updateImage(File croppedFile) {
    imageFiles = croppedFile;
    base64DecodedImage = imageFiles!.readAsBytesSync();
    activityImagesList!.add(base64DecodedImage!);
    activityImageModelList!
        .add(WorkoutImageModel(image: base64DecodedImage, description: '', time: DateTime.now()));
    activityImageModelOldList!
        .add(WorkoutImageModel(image: base64DecodedImage, description: '', time: DateTime.now()));
    notifyListeners();
  }

  set mapImage(ImageModel? value) {
    _mapImage = value;
    notifyListeners();
  }

  List<ImageModel> get listOfImages => _listOfImages!;

  set listOfImages(List<ImageModel> value) {
    _listOfImages = value;
    notifyListeners();
  }

  bool get isShowTimer => _isShowTimer;

  set isShowTimer(bool value) {
    _isShowTimer = value;
    notifyListeners();
  }

  bool get isPause => _isPause;

  set isPause(bool value) {
    _isPause = value;
    notifyListeners();
  }

  String get typeTitle => _typeTitle!;

  bool get isStarted => _isStarted;

  set isStarted(bool value) {
    _isStarted = value;
    notifyListeners();
  }

  set typeTitle(String value) {
    _typeTitle = value;
    notifyListeners();
  }

  double get activityIntensity => _activityIntensity!;

  set activityIntensity(double value) {
    _activityIntensity = value;
    notifyListeners();
  }

  DateTime? get startTime => _startTime;

  List<LocationAddressModel> get locationListForFirebase => _locationListForFirebase!;

  set locationListForFirebase(List<LocationAddressModel> value) {
    _locationListForFirebase = value;
    notifyListeners();
  }

  set startTime(DateTime? value) {
    _startTime = value;
    notifyListeners();
  }

  DateTime get endTime => _endTime ?? DateTime.now();

  List<ActivityEvent> get activityEventList => _activityEventList!;

  set endTime(DateTime value) {
    _endTime = value;
    notifyListeners();
  }

  List<LocationAddressModel> get locationList => _locationList!;

  set locationList(List<LocationAddressModel> value) {
    _locationList = value;
    notifyListeners();
  }

  void disposeStream() {
    locationDataStream?.cancel();
    // activityStream?.cancel();
  }

  double averageSpeed() {
    if (countTime == 0) return 0;
    return distance / (countTime / 3600);
  }

  // 1. if event speed is zero then start the timer.(5 Seconds)
  // 2.

  void manualTimer() {
    manuallyPauseTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      manuallyPause = false;
      isPause = false;
      activityStillCount = false;
      // countTimer();
      timer.cancel();
    });
  }

  void countTimer() {
    if (!timer!.isActive) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (isPause) {
          timer.cancel();
          notifyListeners();
        } else {
          updateTimeCount(1);
        }
      });
    }
  }

  void sendNotification({required String title, String? body}) {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    FlutterLocalNotificationsPlugin().initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: (data) async {
        print('ON CLICK $data'); // ignore: avoid_print
      },
      onDidReceiveNotificationResponse: (data) async {
        print('ON CLICK $data'); // ignore: avoid_print
      },
    );
    FlutterLocalNotificationsPlugin().show(
      1,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'location_notification',
          'Location',
          channelDescription: 'Location',
          enableVibration: false,
          playSound: false,
          importance: Importance.low,
        ),
        iOS: DarwinNotificationDetails(
          presentSound: false,
          presentAlert: false,
          presentBadge: false,
        ),
      ),
    );
  }

  void trackLocationAndBuild(GoogleMapController controller) async {
    try {
      locationDataStream = LocationServiceManager.currentLocationStream.listen(
        (event) {
          print('startTracking ${event.latitude.toString()}');
          LoggingService().debugPrintLog(tag: 'latitude :', message: event.latitude.toString());
          LoggingService().debugPrintLog(tag: 'longitude :', message: event.longitude.toString());
          LoggingService().debugPrintLog(tag: 'speed :', message: event.speed.toString());
          bool? autoPause = preferences?.getBool('enableAutoPause') ?? false;
          double distInMeter = 1;
          double filterDistance = 1;
          if (lastLocation != null) {
            distInMeter = geo.Geolocator.distanceBetween(lastLocation!.latitude!,
                lastLocation!.longitude!, event.latitude!, event.longitude!);
          }
          lastLocation = event;
          if (distInMeter >= 100) {
            sendNotification(
              title:
                  '${workoutType?.title ?? 'Run'} : ${activityItems!.convertSecToFormattedTime(countTime).toString()} : ${double.parse(activityItems!.getDistance(locationList))} km',
              body: isPause ? 'Stopped' : null,
            );
          }
          if (workoutType != null && workoutType!.code != 0x03 && (event.speed ?? 0) > 35) {
            if (!speedOver35) {
              lastLocation = event;
              tempLocationList!.add(event);
              locationListForFirebase.add(event);
              locationList.add(event);
              speedOver35 = true;
            }
            activityStillCount = true;
            isPause = true;
            if (timer!.isActive) {
              timer!.cancel();
            }
          }
          if (autoPause && distInMeter < filterDistance) {
            if (!isPause) {
              if (locationList.isNotEmpty) {
                var lastEvent = locationList.last;
                //lastEvent.speed = 0;
                locationList.add(lastEvent);
              }
              if (speedTimer != null && !speedTimer!.isActive) {
                startSpeedTimer();
              } else if (speedTimer == null) {
                startSpeedTimer();
              }
            }
            notifyListeners();
          } else if (manuallyPause) {
            if (manuallyPauseTimer != null && !manuallyPauseTimer!.isActive) {
              manualTimer();
            } else if (manuallyPauseTimer == null) {
              manualTimer();
            }
          } else {
            if (speedTimer != null && speedTimer!.isActive) {
              speedTimer!.cancel();
            }
            isPause = false;
            activityStillCount = false;
            countTimer();

            var currentSpeed = ((event.speed ?? 0) < 0 ? 0 : (event.speed ?? 0));
            if (isStarted && !isPause) {
              if (currentSpeed.round() >= 10) {
                if (!speedOver35) {
                  lastLocation = event;
                  tempLocationList!.add(event);
                  locationListForFirebase.add(event);
                  locationList.add(event);
                  speedOver35 = true;
                }
                activityStillCount = true;
                isPause = true;
                if (timer!.isActive) {
                  timer!.cancel();
                }
              } else {
                speedOver35 = false;
                lastLocation = event;
                tempLocationList!.add(event);
                locationListForFirebase.add(event);
                //    event.time = DateTime.now().millisecondsSinceEpoch.toDouble();
                setLocationDataInList(event);
                // saveDataInFirebase();
                if (locationList.isNotEmpty) {
                  try {
                    controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(locationList.last.latitude!, locationList.last.longitude!),
                          zoom: 18),
                    ));
                    /*controller.move(
                      LatLng(locationList.last.latitude!,
                          locationList.last.longitude!),
                      18,
                    );*/
                  } catch (e) {
                    print(e);
                  }
                }
              }
              notifyListeners();
            }
          }
          // }
        },
      );
      // try {
      //   if (Platform.isAndroid) {
      //     var androidInfo = await DeviceInfoPlugin().androidInfo;
      //     var sdkInt = androidInfo.version.sdkInt;
      //     if (sdkInt <= 28) {
      //       runActivityRecognition();
      //     } else {
      //       if (await Permission.activityRecognition.request().isGranted) {
      //         runActivityRecognition();
      //       } else {
      //         print("Activity Recognition Permission denied");
      //       }
      //     }
      //   } else {
      //     runActivityRecognition();
      //   }
      // } catch (e) {
      //   print('permission handling exception');
      // }
    } catch (e) {
      print('Exception at trackLocationAndBuild $e');
    }
  }

  void startSpeedTimer() {
    speedTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      isPause = true;
      activityStillCount = true;
      timer.cancel();
    });
  }

  void setLocationDataInList(LocationAddressModel model) {
    if (tempLocationList != null && tempLocationList!.isNotEmpty && tempLocationList!.length < 5) {
      locationList.add(model);
    } else if (tempLocationList != null &&
        tempLocationList!.isNotEmpty &&
        tempLocationList!.length >= 5) {
      if (tempLocationList!.length == rollingAverage) {
        for (var i = 0; i < rollingAverage; i++) {
          var lastIndex = tempLocationList!.length - 1;

          tempLocationList![lastIndex].time = model.time!;
          last5LatSum += tempLocationList![i].latitude!;
          last5LongSum += tempLocationList![i].longitude!;
          last5speedSum += tempLocationList![i].speed!;
          last5altitudeSum += tempLocationList![i].altitude!;
        }
        last5speedAvg = approxRollingAverage(last5speedAvg, last5speedSum, rollingAverage);
        last5LongAvg = approxRollingAverage(last5LongAvg, last5LongSum, rollingAverage);
        last5LatAvg = approxRollingAverage(last5LatAvg, last5LatSum, rollingAverage);
        last5altitudeAvg = approxRollingAverage(last5altitudeAvg, last5altitudeSum, rollingAverage);
        locationList.add(LocationAddressModel(
            latitude: last5LatAvg,
            longitude: last5LongAvg,
            speed: last5speedAvg,
            altitude: last5altitudeAvg,
            time: DateTime.now().millisecondsSinceEpoch.toDouble()));
      } else if (tempLocationList!.length > rollingAverage) {
        // remove last item sum and add current index item value
        var lastIndex = (tempLocationList!.length - 1) - rollingAverage;
        var currIndex = tempLocationList!.length - 1;

        last5LatSum -= tempLocationList![lastIndex].latitude!;
        last5LongSum -= tempLocationList![lastIndex].longitude!;
        last5speedSum -= tempLocationList![lastIndex].speed!;
        last5altitudeSum -= tempLocationList![lastIndex].altitude!;
        last5speedSum += tempLocationList![currIndex].speed!;
        last5LongSum += tempLocationList![currIndex].longitude!;
        last5LatSum += tempLocationList![currIndex].latitude!;
        last5altitudeSum += tempLocationList![currIndex].altitude!;
        last5speedAvg = approxRollingAverage(last5speedAvg, last5speedSum, rollingAverage);
        last5LongAvg = approxRollingAverage(last5LongAvg, last5LongSum, rollingAverage);
        last5LatAvg = approxRollingAverage(last5LatAvg, last5LatSum, rollingAverage);
        last5altitudeAvg = approxRollingAverage(last5altitudeAvg, last5altitudeSum, rollingAverage);
        locationList.add(LocationAddressModel(
            latitude: last5LatAvg,
            longitude: last5LongAvg,
            speed: last5speedAvg,
            altitude: last5altitudeAvg,
            time: DateTime.now().millisecondsSinceEpoch.toDouble()));
      }
    }
  }

  double approxRollingAverage(double avg, double newSum, int no) {
    return newSum / no;
    // avg -= avg /no;
    // avg += newSum / no;
    //
    // return avg;
  }

  void runActivityRecognition() {
    activityStream =
        ActivityRecognition().activityStream(runForegroundService: false).listen((event) {
      print(event.type);
      _activityEventList!.add(event);
      ActivitiesList!.add(event.type);
      ActivitiesList!.add(event.confidence);
      bool? autoPause = preferences?.getBool('enableAutoPause') ?? false;
      if (autoPause &&
          (event.type == ActivityType.STILL ||
              event.type == ActivityType.IN_VEHICLE ||
              event.type == ActivityType.UNKNOWN) &&
          event.confidence >= 75) {
        activityStillCount = true;
        isPause = true;
        if (timer!.isActive) {
          timer!.cancel();
        }
      } else if (event.type == ActivityType.ON_FOOT && event.confidence >= 80) {
        activityStillCount = false;
        isPause = false;
        if (!timer!.isActive) {
          timer = Timer.periodic(Duration(seconds: 1), (timer) {
            if (isPause) {
              timer.cancel();
            } else {
              updateTimeCount(1);
            }
          });
        }
      } else {
        activityStillCount = false;
        isPause = false;
        if (!timer!.isActive) {
          timer = Timer.periodic(Duration(seconds: 1), (timer) {
            if (isPause) {
              timer.cancel();
              notifyListeners();
            } else {
              updateTimeCount(1);
            }
          });
        }
      }

      notifyListeners();
    });
  }

  void cancelTimer() {
    timer!.cancel();
    notifyListeners();
  }

  Map<String, dynamic> getModelForApiCall(
    String activityTitle,
    String desc,
    String? type,
    List<ImageModel>? imageList,
    int? totalTime,
  ) {
    List mapLst = locationList.map((e) {
      return {
        'latitude': e.latitude,
        'longitude': e.longitude,
        'accuracy': e.accuracy,
        'altitude': e.altitude,
        'speed': e.speed,
        'speedAccuracy': e.speedAccuracy,
        'heading': e.heading,
        'time': e.time,
      };
    }).toList();
    List heartRateList = heartRate.map((e) {
      return {
        'hr': e.hr,
        'timeStamp': e.timeStamp!.toDouble(),
        'elevation': e.elevation,
        'locationData': {
          'latitude': e.locationData!.latitude,
          'longitude': e.locationData!.longitude,
          'accuracy': e.locationData!.accuracy,
          'altitude': e.locationData!.altitude,
          'speed': e.locationData!.speed,
          'speedAccuracy': e.locationData!.speedAccuracy,
          'heading': e.locationData!.heading,
          'time': e.locationData!.time,
        },
        'speed': e.speed,
      };
    }).toList();
    var userId = preferences!.getString(Constants.prefUserIdKeyInt);
    var name = preferences!.getString(Constants.prefUserName);
    if (startTime != null) {
      var dateTime = DateFormat(DateUtil.yyyyMMddHHmmss).format(startTime!);

      var map = <String, dynamic>{
        'Id': dateTime,
        'type': type,
        'title': activityTitle,
        'desc': desc,
        'userId': userId,
        'locationData': mapLst,
        'startTimeString': dateTime,
        'imageList': imageList?.map((e) => e.toJson()).toList() ?? [],
        'activityIntensity': activityIntensity,
        'typeTitle': typeTitle,
        'name': name,
        'startTime': startTime!.millisecondsSinceEpoch,
        'endTime': endTime.millisecondsSinceEpoch,
        'totalTime': totalTime,
        'heartRate': heartRateList,
      };
      return map;
    }
    return {};
  }

  Future saveDataInFirebase(
      [activityTitle, desc, type, List<ImageModel>? imageList, int? totalTime]) async {
    List mapLst = locationList.map((e) {
      return {
        'latitude': e.latitude,
        'longitude': e.longitude,
        'accuracy': e.accuracy,
        'altitude': e.altitude,
        'speed': e.speed,
        'speedAccuracy': e.speedAccuracy,
        'heading': e.heading,
        'time': e.time,
      };
    }).toList();

    var userId = preferences!.getString(Constants.prefUserIdKeyInt);
    var name = preferences!.getString(Constants.prefUserName);
    if (startTime != null) {
      var collectionDate = DateFormat(DateUtil.yyyyMMdd).format(startTime!);
      var dateTime = DateFormat(DateUtil.yyyyMMddHHmmss).format(startTime!);

      var map = <String, dynamic>{
        'Id': dateTime,
        'type': type,
        'title': activityTitle,
        'desc': desc,
        'userId': userId,
        'locationData': mapLst,
        'startTimeString': dateTime,
        'imageList': imageList?.map((e) => e.toJson()).toList() ?? [],
        'activityIntensity': activityIntensity,
        'typeTitle': typeTitle,
        'name': name,
        'startTime': startTime!.millisecondsSinceEpoch,
        'endTime': endTime.millisecondsSinceEpoch,
        'totalTime': totalTime,
        'heartRate': heartRate.map((e) => e.toJson()).toList(),
      };

      return FirebaseFirestore.instance.collection('$userId').doc('$dateTime').set(map);
    }
  }

  // getAndSetActiveActivity() async {
  //   try {
  //     String? userId = preferences!.getString(Constants.prefUserIdKeyInt);
  //     FirebaseFirestore.instance
  //         .collection('$userId')
  //         .where('endTime', isNull: true)
  //         .get()
  //         .then((value) {
  //       if ((value.docs.length) > 0) {
  //         var map = value.docs.first.data();
  //         if (map['startTime'] != null && map['startTime'] is num) {
  //           startTime =
  //               DateTime.fromMillisecondsSinceEpoch(map['startTime']).toUtc();
  //         }
  //         if (map['endTime'] != null && map['endTime'] is num) {
  //           endTime =
  //               DateTime.fromMillisecondsSinceEpoch(map['endTime']).toUtc();
  //         } else {
  //           isStarted = true;
  //         }
  //         if (map['locationData'] != null && map['locationData'] is List) {
  //           List list = map['locationData'];
  //           locationList = list.map((e) {
  //             Map<String, double> map = {
  //               'latitude': e['latitude'],
  //               'longitude': e['longitude'],
  //               'accuracy': e['accuracy'],
  //               'altitude': e['altitude'],
  //               'speed': e['speed'],
  //               'speed_accuracy': e['speed_accuracy'],
  //               'heading': e['heading'],
  //               'time': e['time'],
  //             };
  //             return LocationAddressModel.fromMap(map);
  //           }).toList();
  //         }
  //         // trackLocationAndBuild();
  //       }
  //     }).catchError((onError) {
  //       print('Exception at getAndSetActiveActivity $onError');
  //     });
  //   } catch (e) {
  //     print('Exception at getAndSetActiveActivity $e');
  //   }
  // }

  discardActivity() async {
    var userId = preferences!.getString(Constants.prefUserIdKeyInt);
    if (startTime != null) {
      var collectionDate = DateFormat(DateUtil.yyyyMMdd).format(startTime!);
      var dateTime = DateFormat(DateUtil.yyyyMMddHHmmss).format(startTime!);

      FirebaseFirestore.instance.collection('$userId').doc('$dateTime').delete().then((value) {
        print('deleted');
      }).catchError((onError) {
        print('Exception while storing firebase $onError');
      });
    }
  }

  updateTitle(String currentTitle) {
    title = currentTitle;
    preferences!.setString(Constants.prefActivityTitle, currentTitle);
    notifyListeners();
  }

  void updateStartActivity(bool value) {
    isShowTimer = value;
    notifyListeners();
  }

  void updateTimeCount(int timeCount) {
    countTime += timeCount;
    notifyListeners();
  }

  Future uploadImages(List<ImageModel> listOfFiles) async {
    var imageModelMapList = [];
    imageModelMapList = listOfFiles.map((e) {
      var element = e.toJson();
      element.remove('ID');
      return element;
    }).toList();
    //imageModelMapList = listOfFiles.map((element) => element.toJson()).toList();
    var map = <String, dynamic>{
      'FKUserID': preferences!.getString(Constants.prefUserIdKeyInt),
      'Files': imageModelMapList,
    };
    final result = await UploadImages().callApi(Constants.imageUploadURl, map);
    if (!result['isError']) {
      return result['value'];
    }
    return Future.value();
  }
}
