class DeviceConfigurationModel {
  num? hrMonitoringMode;
  num? hand;
  num? hrAlarmValue;
  num? distanceUnit;
  num? disconnectReminder;
  num? notDisturbStartHour;
  num? notDisturbSwitch;
  num? sedentaryReminderInterval;
  num? distanceTarget;
  num? sportGlobal;
  num? rssi;
  num? language;
  num? displayBrightness;
  num? sleepGoalsHour;
  num? sedentaryReminderEndMin1;
  num? sedentaryReminderEndMin2;
  num? antiLostRepeat;
  num? hrMonitoringInterval;
  num? height;
  num? age;
  num? sportsGoal;
  num? weight;
  num? sedentaryReminderStartHour1;
  num? notDisturbStartMin;
  num? sedentaryReminderEndHour1;
  num? notDisturbEndHour;
  num? sedentaryReminderRepeat;
  num? antiLostDelay;
  num? gender;
  num? timeMode;
  num? sedentaryReminderEndHour2;
  num? restScreenTime;
  num? hrAlarmSwitch;
  num? weightUnit;
  num? uploadReminder;
  num? sedentaryReminderStartHour2;
  num? sedentaryReminderStartMin1;
  num? antiLostDisconnectionDelay;
  num? raiseWristToBrightenTheScreen;
  num? notificationReminderSwitch;
  num? skinColor;
  num? temperatureUnit;
  num? notDisturbEndMin;
  num? notificationReminderSubSwitch1;
  num? calorieGoal;
  num? notificationReminderSubSwitch2;
  num? sedentaryReminderStartMin2;
  num? antiLostMode;


  DeviceConfigurationModel.fromMap(Map map){
    if(checkKey(map, 'keyGetUserConfiguration_hrMonitoringMode')){
      hrMonitoringMode = map['keyGetUserConfiguration_hrMonitoringMode'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_hand')){
      hand = map['keyGetUserConfiguration_hand'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_hrAlarmValue')){
      hrAlarmValue = map['keyGetUserConfiguration_hrAlarmValue'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_distanceUnit')){
      distanceUnit = map['keyGetUserConfiguration_distanceUnit'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_disconnectReminder')){
      disconnectReminder = map['keyGetUserConfiguration_disconnectReminder'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_notDisturbStartHour')){
      notDisturbStartHour = map['keyGetUserConfiguration_notDisturbStartHour'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_notDisturbSwitch')){
      notDisturbSwitch = map['keyGetUserConfiguration_notDisturbSwitch'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_sedentaryReminderInterval')){
      sedentaryReminderInterval = map['keyGetUserConfiguration_sedentaryReminderInterval'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_distanceTarget')){
      distanceTarget = map['keyGetUserConfiguration_distanceTarget'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_sportgobal')){
      sportGlobal = map['keyGetUserConfiguration_sportgobal'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_rssi')){
      rssi = map['keyGetUserConfiguration_rssi'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_language')){
      language = map['keyGetUserConfiguration_language'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_displayBrightness')){
      displayBrightness = map['keyGetUserConfiguration_displayBrightness'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_sleepGoalsHour')){
      sleepGoalsHour = map['keyGetUserConfiguration_sleepGoalsHour'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_sedentaryReminderEndMin1')){
      sedentaryReminderEndMin1 = map['keyGetUserConfiguration_sedentaryReminderEndMin1'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_sedentaryReminderEndMin2')){
      sedentaryReminderEndMin2 = map['keyGetUserConfiguration_sedentaryReminderEndMin2'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_antiLostRepeat')){
      antiLostRepeat = map['keyGetUserConfiguration_antiLostRepeat'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_hrMonitoringInterval')){
      hrMonitoringInterval = map['keyGetUserConfiguration_hrMonitoringInterval'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_height')){
      height = map['keyGetUserConfiguration_height'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_age')){
      age = map['keyGetUserConfiguration_age'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_sportsGoal')){
      sportsGoal = map['keyGetUserConfiguration_sportsGoal'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_weight')){
      weight = map['keyGetUserConfiguration_weight'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_sedentaryReminderStartHour1')){
      sedentaryReminderStartHour1 = map['keyGetUserConfiguration_sedentaryReminderStartHour1'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_notDisturbStartMin')){
      notDisturbStartMin = map['keyGetUserConfiguration_notDisturbStartMin'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_sedentaryReminderEndHour1')){
      sedentaryReminderEndHour1 = map['keyGetUserConfiguration_sedentaryReminderEndHour1'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_notDisturbEndHour')){
      notDisturbEndHour = map['keyGetUserConfiguration_notDisturbEndHour'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_sedentaryReminderRepeat')){
      sedentaryReminderRepeat = map['keyGetUserConfiguration_sedentaryReminderRepeat'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_antiLostDelay')){
      antiLostDelay = map['keyGetUserConfiguration_antiLostDelay'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_gender')){
      gender = map['keyGetUserConfiguration_gender'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_timeMode')){
      timeMode = map['keyGetUserConfiguration_timeMode'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_sedentaryReminderEndHour2')){
      sedentaryReminderEndHour2 = map['keyGetUserConfiguration_sedentaryReminderEndHour2'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_restScreenTime')){
      restScreenTime = map['keyGetUserConfiguration_restScreenTime'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_hrAlarmSwitch')){
      hrAlarmSwitch = map['keyGetUserConfiguration_hrAlarmSwitch'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_weightUnit')){
      weightUnit = map['keyGetUserConfiguration_weightUnit'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_uploadReminder')){
      uploadReminder = map['keyGetUserConfiguration_uploadReminder'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_sedentaryReminderStartHour2')){
      sedentaryReminderStartHour2 = map['keyGetUserConfiguration_sedentaryReminderStartHour2'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_sedentaryReminderStartMin1')){
      sedentaryReminderStartMin1 = map['keyGetUserConfiguration_sedentaryReminderStartMin1'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_antiLostDisconnectionDelay')){
      antiLostDisconnectionDelay = map['keyGetUserConfiguration_antiLostDisconnectionDelay'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_raiseWristToBrighenTheScreen')){
      raiseWristToBrightenTheScreen = map['keyGetUserConfiguration_raiseWristToBrighenTheScreen'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_notificationReminderSwitch')){
      notificationReminderSwitch = map['keyGetUserConfiguration_notificationReminderSwitch'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_skinColor')){
      skinColor = map['keyGetUserConfiguration_skinColor'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_temperatureUnit')){
      temperatureUnit = map['keyGetUserConfiguration_temperatureUnit'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_notDisturbEndMin')){
      notDisturbEndMin = map['keyGetUserConfiguration_notDisturbEndMin'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_notificationReminderSubSwitch1')){
      notificationReminderSubSwitch1 = map['keyGetUserConfiguration_notificationReminderSubSwitch1'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_calorieGoal')){
      calorieGoal = map['keyGetUserConfiguration_calorieGoal'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_notificationReminderSubSwitch2')){
      notificationReminderSubSwitch2 = map['keyGetUserConfiguration_notificationReminderSubSwitch2'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_sedentaryReminderStartMin2')){
      sedentaryReminderStartMin2 = map['keyGetUserConfiguration_sedentaryReminderStartMin2'];
    }

    if(checkKey(map, 'keyGetUserConfiguration_antiLostMode')){
      antiLostMode = map['keyGetUserConfiguration_antiLostMode'];
    }

  }

  bool checkKey(Map map, String key){
    if(map.containsKey(key)){
      return true;
    }
    return false;
  }
}