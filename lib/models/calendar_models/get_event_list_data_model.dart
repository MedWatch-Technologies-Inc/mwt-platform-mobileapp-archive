class GetEventListDataModel {
  bool? result;
  int? response;
  List<CalendarData>? data;

  GetEventListDataModel({this.result, this.response, this.data});

  GetEventListDataModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    if (json['Data'] != null) {
      data = [];
      json['Data'].forEach((v) {
        data?.add(new CalendarData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Response'] = this.response;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CalendarData {
  String? timeZone;
  String? eventName;
  int? setRemindersID;
  String? info;
  int? fKUserID;
  String? start;
  String? end;
  String? startTime;
  String? endTime;
  String? showMassege;
  String? guest;
  String? firstName;
  String? lastName;
  String? tabName;
  bool? allDay;
  int? eventAutocompleteBox;
  bool? outOfTownemessagechecked;
  String? outTownMessage;
  int? outOfTownAccessSpecify;
  bool? taskRemainderTextboxchecked;
  String? taskDescription;
  int? appointmentSlotval;
  int? appointmentTimeSlotDuration;
  int? isSync = -1;
  int? isDeleted = 0;
  int? userId = -1;
  int? eventTagUserID=0;
  int? setReminderID =0;
  int? eventTypeID = 0;
  String? outOfTownName;
  int? isMessageSend;
  int? accessSpecifier;
  String? outofTownMessage;
  String? reminderName;
  int? remainderRepeat;
  int? fullDay;
  String? taskName;
  String? taskDecription;
  String? appointmentName;
  int? slotvalu;
  int? slotDuration;
  int? id;


  CalendarData(
      { this.timeZone,
        this.id,
  this.eventName,
  this.setRemindersID,
  this.info,
  this.fKUserID,
  this.start,
  this.end,
  this.startTime,
  this.endTime,
  this.showMassege,
  this.guest,
  this.firstName,
  this.lastName,
  this.tabName,
  this.allDay,
  this.eventAutocompleteBox,
  this.outOfTownemessagechecked,
  this.outTownMessage,
  this.outOfTownAccessSpecify,
  this.taskRemainderTextboxchecked,
  this.taskDescription,
  this.appointmentSlotval,
  this.appointmentTimeSlotDuration,
  this.isSync,
  this.isDeleted,
  this.userId,
  this.eventTagUserID,
  this.setReminderID,
  this.eventTypeID,
  this.outOfTownName,
  this.isMessageSend,
  this.accessSpecifier,
  this.outofTownMessage,
  this.reminderName,
  this.remainderRepeat,
  this.fullDay,
  this.taskName,
  this.taskDecription,
  this.appointmentName,
  this.slotvalu,
  this.slotDuration,});

  CalendarData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timeZone = json['TimeZone'];
    eventName = json['EventName'];
    setRemindersID = json['SetRemindersID'];
    info = json['Info'];
    fKUserID = json['FKUserID'];
    start = json['start'];
    end = json['end'];
    startTime = json['StartTime'];
    endTime = json['EndTime'];
    showMassege = json['ShowMassege'];
    guest = json['Guest'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    tabName = json['TabName'];
    allDay = json['allDay'];
    eventAutocompleteBox = json['EventAutocompleteBox'];
    outOfTownemessagechecked = json['OutOfTownemessagechecked'];
    outTownMessage = json['OutTownMessage'];
    outOfTownAccessSpecify = json['OutOfTownAccessSpecify'];
    taskRemainderTextboxchecked = json['TaskRemainderTextboxchecked'];
    taskDescription = json['TaskDescription'];
    appointmentSlotval = json['AppointmentSlotval'];
    appointmentTimeSlotDuration = json['AppointmentTimeSlotDuration'];
    isSync = json['IsSync'];
    isDeleted = json['IsDeleted'];
    userId = json['UserID'];
    eventTagUserID = json['EventTagUserID'];
    setReminderID = json['SetReminderID'];
    eventTypeID = json['EventTypeID'];
    outOfTownName = json['OutOfTownName'];
    isMessageSend = json['IsMessageSend'];
    accessSpecifier = json['AccessSpecifier'];
    outofTownMessage = json['OutofTownMessage'];
    reminderName = json['ReminderName'];
    remainderRepeat = json['RemainderRepeat'];
    fullDay = json['FullDay'];
    taskName = json['TaskName'];
    taskDecription = json['TaskDecription'];
    appointmentName = json['AppointmentName'];
    slotvalu = json['Slotvalu'];
    slotDuration = json['SlotDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['TimeZone'] = this.timeZone;
    data['EventName'] = this.eventName;
    data['SetRemindersID'] = this.setRemindersID;
    data['Info'] = this.info;
    data['FKUserID'] = this.fKUserID;
    data['start'] = this.start;
    data['end'] = this.end;
    data['StartTime'] = this.startTime;
    data['EndTime'] = this.endTime;
    data['ShowMassege'] = this.showMassege;
    data['Guest'] = this.guest;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['TabName'] = this.tabName;
    data['allDay'] = this.allDay;
    data['EventAutocompleteBox'] = this.eventAutocompleteBox;
    data['OutOfTownemessagechecked'] = this.outOfTownemessagechecked;
    data['OutTownMessage'] = this.outTownMessage;
    data['OutOfTownAccessSpecify'] = this.outOfTownAccessSpecify;
    data['TaskRemainderTextboxchecked'] = this.taskRemainderTextboxchecked;
    data['TaskDescription'] = this.taskDescription;
    data['AppointmentSlotval'] = this.appointmentSlotval;
    data['AppointmentTimeSlotDuration'] = this.appointmentTimeSlotDuration;
    data['IsSync'] = this.isSync;
    data['IsDeleted'] = this.isDeleted;
    data['UserID'] = this.userId;
    data['EventTagUserID'] = this.eventTagUserID;
    data['SetReminderID'] = this.setReminderID;
    data['EventTypeID'] = this.eventTypeID;
    data['OutOfTownName'] = this.outOfTownName;
    data['IsMessageSend'] = this.isMessageSend;
    data['AccessSpecifier'] = this.accessSpecifier;
    data['OutofTownMessage'] = this.outofTownMessage;
    data['ReminderName'] = this.reminderName;
    data['RemainderRepeat'] = this.remainderRepeat;
    data['FullDay'] = this.fullDay;
    data['TaskName'] = this.taskName;
    data['TaskDecription'] = this.taskDecription;
    data['AppointmentName'] = this.appointmentName;
    data['Slotvalu'] = this.slotvalu;
    data['SlotDuration'] = this.slotDuration;
    return data;
  }

  Map<String, dynamic> toJsonToInsertInDb() => {
    'id': this.id,
    'TimeZone' : this.timeZone,
    'EventName': this.eventName,
    'SetRemindersID' : this.setRemindersID,
    'Info' : this.info,
    'FKUserID' : this.fKUserID,
    'start' : this.start,
    'end' : this.end,
    'StartTime' : this.startTime,
    'EndTime' : this.endTime,
    'ShowMassege' : this.showMassege,
    'Guest' : this.guest,
    'FirstName' : this.firstName,
    'LastName' : this.lastName,
    'TabName' : this.tabName,
    'allDay' : this.allDay,
    'EventAutocompleteBox' : this.eventAutocompleteBox,
    'OutOfTownemessagechecked' : this.outOfTownemessagechecked,
    'OutTownMessage' : this.outTownMessage,
    'OutOfTownAccessSpecify' : this.outOfTownAccessSpecify,
    'TaskRemainderTextboxchecked' : this.taskRemainderTextboxchecked,
    'TaskDescription' : this.taskDescription,
    'AppointmentSlotval' : this.appointmentSlotval,
    'AppointmentTimeSlotDuration' : this.appointmentTimeSlotDuration,
    'IsSync' : this.isSync,
    'IsDeleted' : this.isDeleted,
    'UserID' : this.userId,
    'EventTagUserID' : this.eventTagUserID,
    'SetReminderID' : this.setReminderID,
    'EventTypeID' : this.eventTypeID,
    'OutOfTownName' : this.outOfTownName,
    'IsMessageSend' : this.isMessageSend,
    'AccessSpecifier' : this.accessSpecifier,
    'OutofTownMessage' : this.outofTownMessage,
    'ReminderName' : this.reminderName,
    'RemainderRepeat' : this.remainderRepeat,
    'FullDay' : this.fullDay,
    'TaskName' : this.taskName,
    'TaskDecription' : this.taskDecription,
    'AppointmentName' : this.appointmentName,
    'Slotvalu' : this.slotvalu,
    'SlotDuration' : this.slotDuration,
  };

      CalendarData.fromMap(Map map) {
        if(check('id', map)){
          id = map['id'];
        }
        if (check("TimeZone", map)) {
          timeZone = map["TimeZone"];
        }
        if (check("EventName", map)) {
          eventName = map["EventName"];
        }
        if (check("SetRemindersID", map)) {
          setRemindersID = map["SetRemindersID"];
        }
        if (check("Info", map)) {
          info = map["Info"];
        }
        if (check("FKUserID", map)) {
          fKUserID = map["FKUserID"];
        }
        if (check("start", map)) {
          start = map["start"];
        }
        if (check("end", map)) {
          end = map["end"];
        }
        if (check("StartTime", map)) {
          startTime = map["StartTime"];
        }
        if (check("EndTime", map)) {
          endTime = map["EndTime"];
        }
        if (check("ShowMassege", map)) {
          showMassege = map["ShowMassege"];
        }
        if (check("Guest", map)) {
          guest = map["Guest"];
        }
        if (check("FirstName", map)) {
          firstName = map["FirstName"];
        }
        if (check("LastName", map)) {
          lastName = map["LastName"];
        }
        if (check("TabName", map)) {
          tabName = map["TabName"];
        }
        if (check("allDay", map)) {
          allDay = map["allDay"];
        }
        if (check("EventAutocompleteBox", map)) {
          eventAutocompleteBox = map["PaEventAutocompleteBoxgeTo"];
        }

        if (check("OutOfTownemessagechecked", map)) {
          outOfTownemessagechecked = map["OutOfTownemessagechecked"];
        }

        if (check("OutTownMessage", map)) {
          outTownMessage = map["OutTownMessage"];
        }
        if (check("OutOfTownAccessSpecify", map)) {
          outOfTownAccessSpecify = map["OutOfTownAccessSpecify"];
        }
        if (check("TaskRemainderTextboxchecked", map)) {
          taskRemainderTextboxchecked = map["TaskRemainderTextboxchecked"];
        }
        if (check("TaskDescription", map)) {
          taskDescription = map["TaskDescription"];
        }
        if (check("AppointmentSlotval", map)) {
          appointmentSlotval = map["AppointmentSlotval"];
        }
        if (check("AppointmentTimeSlotDuration", map)) {
          appointmentTimeSlotDuration = map["AppointmentTimeSlotDuration"];
        }
        if (check("IsSync", map)) {
          isSync = map["IsSync"];
        }
        if (check("IsDeleted", map)) {
          isDeleted = map["IsDeleted"];
        }
        if (check("UserId", map)) {
          userId = map["UserId"];
        }
        if (check("EventTagUserID", map)) {
          eventTagUserID = map["EventTagUserID"];
        }
        if (check("SetReminderID", map)) {
          setReminderID = map["SetReminderID"];
        }
        if (check("EventTypeID", map)) {
          eventTypeID = map["EventTypeID"];
        }
        if (check("OutOfTownName", map)) {
          outOfTownName = map["OutOfTownName"];
        }
        if (check("IsMessageSend", map)) {
          isMessageSend = map["IsMessageSend"];
        }
        if (check("AccessSpecifier", map)) {
          accessSpecifier = map["AccessSpecifier"];
        }
        if (check("OutofTownMessage", map)) {
          outofTownMessage = map["OutofTownMessage"];
        }
        if (check("ReminderName", map)) {
          reminderName = map["ReminderName"];
        }
        if (check("RemainderRepeat", map)) {
          remainderRepeat = map["RemainderRepeat"];
        }
        if (check("FullDay", map)) {
          fullDay = map["FullDay"];
        }
        if (check("TaskName", map)) {
          taskName = map["TaskName"];
        }
        if (check("TaskDecription", map)) {
          taskDecription = map["TaskDecription"];
        }
        if (check("AppointmentName", map)) {
          appointmentName = map["AppointmentName"];
        }
        if (check("Slotvalu", map)) {
          slotvalu = map["Slotvalu"];
        }
        if (check("SlotDuration", map)) {
          slotDuration = map["SlotDuration"];
        }
      }

      check(String key, Map map) {
        if(map != null && map.containsKey(key) && map[key] != null){
          if(map[key] is String &&  map[key] == "null"){
            return false;
          }
          return true;
        }
        return false;
  }
}
