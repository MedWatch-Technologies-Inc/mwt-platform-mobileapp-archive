import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:health_gauge/services/core_util/common_utils.dart';
import 'package:health_gauge/services/location/model/location_model.dart';

class CalculateActivityItems {
  /// Added by : Shahzad
  /// Added on : 29th April 2021
  /// this function calculates the elevation gain
  String getElevation(List<LocationAddressModel>? locData) {
    double elevation = 0;
    for (int i = 1; i < (locData?.length ?? 0); i++) {
      if ((locData?[i].altitude ?? 0) > (locData?[i - 1].altitude ?? 0)) {
        elevation =
            (locData?[i].altitude ?? 0) - (locData?[i - 1].altitude ?? 0);
      }
    }
    return elevation.toStringAsFixed(2);
  }

  /// Added by : Shahzad
  /// Added on : 29th April 2021
  /// this function calculates the total time taken
  getTimeTaken(int? endTime, int? startTime) {
    if ((endTime ?? 0) > 0 && (startTime ?? 0) > 0) {
      Duration timeTaken = DateTime.fromMillisecondsSinceEpoch(endTime ?? 0)
          .toUtc()
          .toLocal()
          .difference(DateTime.fromMillisecondsSinceEpoch(startTime ?? 0)
              .toUtc()
              .toLocal());
      var seconds = timeTaken.inSeconds;
      final days = seconds ~/ Duration.secondsPerDay;
      seconds -= days * Duration.secondsPerDay;
      final hours = seconds ~/ Duration.secondsPerHour;
      seconds -= hours * Duration.secondsPerHour;
      final minutes = seconds ~/ Duration.secondsPerMinute;
      seconds -= minutes * Duration.secondsPerMinute;

      final List<String> tokens = [];
      if (days != 0) {
        tokens.add('$days days');
      }
      if (tokens.isNotEmpty || hours != 0) {
        tokens.add('$hours hrs');
      }
      if (tokens.isNotEmpty || minutes != 0) {
        tokens.add('$minutes mins');
      }
      tokens.add('$seconds sec');

      return tokens.join(' ');
    }
    return '0 sec';
  }

  convertSecToTime(int sec) {
    var seconds = sec;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('$days');
      tokens.add(' days');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('$hours');
      tokens.add(' hours');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('$minutes');
      tokens.add(' mins');
    }
    tokens.add('$seconds');
    tokens.add(' secs');

    return tokens.join(' ');
  }

  convertSecToFormattedTime(int sec) {
    int totalSeconds = sec;
    int totalHours = totalSeconds ~/ 3600;
    int remainder = totalSeconds % 3600;
    int totalMinutes = remainder ~/ 60;
    int remainderS = remainder % 60;

    var formattedTime = '';
    if (totalHours <= 9) {
      formattedTime += '$totalHours';
    } else {
      formattedTime += '$totalHours';
    }
    if (formattedTime == '0') {
      formattedTime = '';
    } else {
      formattedTime += ':';
    }
    if (totalMinutes <= 9) {
      formattedTime += '$totalMinutes';
    } else {
      formattedTime += '$totalMinutes';
    }
    formattedTime += ':';
    if (remainderS <= 9) {
      formattedTime += '0$remainderS';
    } else {
      formattedTime += '$remainderS';
    }

    print('Formatted Time:${formattedTime}');

    return formattedTime;
  }

  /// Added by : Shahzad
  /// Added on : 29th April 2021
  /// this function calculates the average speed
  String getAvgSpeed(List<LocationAddressModel> locData) {
    double avgSpeed = 0;
    int speedCount = 0;
    for (int i = 0; i < locData.length; i++) {
      if ((locData[i].speed)! >= 0) {
        avgSpeed += locData[i].speed!;
        speedCount++;
      }
    }
    print('speed count ${speedCount}');
    print('speed count ${avgSpeed}');
    if (speedCount != 0) avgSpeed = avgSpeed / (speedCount);
    return avgSpeed.toStringAsFixed(2);
  }

  String getMaxSpeed(List<LocationAddressModel> data) {
    var maxSpeed = 0.0;
    for (var i = 0; i < data.length; i++) {
      if (data[i].speed != null && data[i].speed! > maxSpeed) {
        maxSpeed = data[i].speed!;
      }
    }
    return maxSpeed.toStringAsFixed(2);
  }

  String getSpeed(List<LocationAddressModel> locData) {
    // double speed = 0;
    // for (int i = 0; i < locData.length; i++) {
    //   if (locData[i].speed >= 0) {
    //     speed = locData[i].speed;
    //   }
    // }
    return locData.isEmpty
        ? 0.toStringAsFixed(2)
        : (locData.last.speed)! < 0
            ? 0.toStringAsFixed(2)
            : locData.last.speed!.toStringAsFixed(2);
  }

  /// Added by : Shahzad
  /// Added on : 29th April 2021
  /// this method calculates distance from polyline points in km.
  String getDistance(List<LocationAddressModel>? gpsList) {
    if (gpsList == null || gpsList.isEmpty) {
      return 0.toStringAsFixed(2);
    }
    double totalDistanceInMeter = 0.0;
    for (var i = 0; i < gpsList.length - 1; i++) {
      totalDistanceInMeter += Geolocator.distanceBetween(
        gpsList[i].latitude ?? 0,
        gpsList[i].longitude ?? 0,
        gpsList[i + 1].latitude ?? 0,
        gpsList[i + 1].longitude ?? 0,
      );
    }
    print('totalDistanceInMeter : $totalDistanceInMeter');
    return (totalDistanceInMeter / 1000).toPrecision(2).toString();
    return totalDistanceInMeter.toStringAsFixed(2);
  }

  /// Added by : Shahzad
  /// Added on : 29th April 2021
  /// this method calculates distance between two lat long point
  double calculateDistance(lat1, lon1, lat2, lon2) {
    const p = 0.017453292519943295;
    const c = cos;
    final a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
