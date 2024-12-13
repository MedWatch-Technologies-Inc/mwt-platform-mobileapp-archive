import 'dart:io';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/models/alarm_models/alarm_model.dart';
import 'package:health_gauge/models/bp_model.dart';
import 'package:health_gauge/models/calendar_models/get_event_list_data_model.dart';
import 'package:health_gauge/models/contact_models/pending_invitation_model.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/models/health_kit_or_google_fit_model.dart';
import 'package:health_gauge/models/inbox_models/message_list_model.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/models/offline_api_request.dart';
import 'package:health_gauge/models/reminder_model.dart';
import 'package:health_gauge/models/tag.dart';
import 'package:health_gauge/models/tag_note.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/repository/blood_pressure_monitor/model/get_bp_data_response.dart';
import 'package:health_gauge/repository/blood_pressure_monitor/request/save_bp_data_request.dart';
import 'package:health_gauge/repository/heart_rate_monitor/model/get_hr_data_response.dart';
import 'package:health_gauge/repository/heart_rate_monitor/request/save_hr_data_request.dart';
import 'package:health_gauge/screens/chat/models/access_chatted_with_model.dart';
import 'package:health_gauge/screens/chat/models/access_group_chat_history_model.dart';
import 'package:health_gauge/screens/chat/models/access_history_with_two_user_model.dart';
import 'package:health_gauge/screens/map_screen/model/hr_model.dart';
import 'package:health_gauge/screens/tag/model/tag_label.dart';
import 'package:health_gauge/screens/tag/model/tag_record_detail.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/utils/db_table_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_table_name_and_fields.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/json_serializable_utils.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = 'HealthDB.db';
  static final _databaseVersion = 54;
  static int oldVersionOfDb = 54;

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    String path;
    if (Platform.isAndroid) {
      var documentsDirectory = await getApplicationDocumentsDirectory();
      path = join(documentsDirectory.path, _databaseName);
      print('database_dirPath ${documentsDirectory.path}');
    } else {
      var databasesPath = await getDatabasesPath();
      path = join(databasesPath, _databaseName);
    }

    return await openDatabase(
      path,
      version: _databaseVersion,
      // password: Constants.databasePassword,
      onCreate: (Database db, int version) {
        createTables(db, version);
      },
      onUpgrade: (Database db, int oldVersion, int version) {
        oldVersionOfDb = oldVersion;
        createTables(db, version);
        updateTable(db, oldVersion);
      },
      onDowngrade: (Database db, int oldVersion, int version) {
        oldVersionOfDb = oldVersion;
        createTables(db, version);
        updateTable(db, oldVersion);
      },
    );
  }

  // SQL code to create the database table
  Future createTables(Database db, int version) async {
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Sport (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, date TEXT, step INTEGER, calories REAL, distance REAL, user_Id TEXT, completion TEXT, data TEXT, IdForApi INTEGER, IsSync INTEGER, CreatedDateTimeStamp TEXT)');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'Sport\') $e');
    }
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Sleep (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, date TEXT, sleepAllTime TEXT, deepTime TEXT, lightTime TEXT, allTime TEXT, stayUpTime TEXT, user_Id TEXT, data TEXT, wakInCount TEXT, IdForApi INTEGER,IsSync INTEGER, CreateDateTimeStamp TEXT)');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'Sleep\') $e');
    }
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Measurement (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, approxSBP INTEGER, approxDBP INTEGER, approxHr INTEGER, hrv INTEGER, BG REAL, Uncertainty INTEGER, BG1 REAL, Unit TEXT, Unit1 TEXT, Class TEXT, ecgValue REAL, ppgValue REAL, user_Id TEXT, date TEXT, ecg TEXT, ppg TEXT, tHr INTEGER, tSBP INTEGER, tDBP INTEGER,aiSBP INTEGER, aiDBP INTEGER,isForHourlyHR INTEGER,isForTimeBasedPpg INTEGER,IsCalibration INTEGER,isForTraining INTEGER,isForOscillometric INTEGER,isSavedFromOscillometric INTEGER,isFromCamera INTEGER, IdForApi INTEGER, IsSync INTEGER , DeviceType TEXT)');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'Measurement\') $e');
    }
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS TagNote (Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, IdForApi TEXT,TagIdForApi TEXT, TagId INTEGER, Label TEXT,UserId TEXT, Date TEXT,  Time TEXT, Value REAL, Note TEXT, PatchLocation TEXT, isRemove INTEGER, isSync INTEGER, unitSelectedType TEXT,tagType INTEGER,AttachFiles TEXT,CreatedDateTimeTimestamp TEXT, Short_description TEXT)');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'TagNote\') $e');
    }
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS User (UserId TEXT, Profile TEXT, UserName TEXT, FirstName TEXT, LastName TEXT, Gender TEXT, Unit TEXT, Height TEXT, Weight TEXT, BirthDate TEXT, SkinType TEXT, IsRemove INTEGER, IsSync INTEGER, IsResearcherProfile INTEGER , InitialWeight TEXT , IsConfirmed INTEGER , UserGroup INTEGER, UserMeasurementTypeID INTEGER,HeightUnit INTEGER, WeightUnit INTEGER )');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'User\') $e');
    }
    //  await db.execute("CREATE TABLE IF NOT EXISTS 'Email' ('Id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'UserId' INTEGER, 'MessageID' INTEGER, 'SenderUserID' INTEGER, 'ReceiverUserID' INTEGER,'FkMessageTypeID' INTEGER, 'MessageTypeName' INTEGER,  'MessageFrom' TEXT, 'MessageTo' TEXT, 'MessageCc' TEXT, 'MessageSubject' TEXT,'MessageBody' TEXT,'CreatedDateTime' TEXT,'IsViewed' INTEGER,'IsDeleted' INTEGER,'TotalRecords' INTEGER,'PageFrom' INTEGER,'PageTo' INTEGER,'UserEmailTo' TEXT,'UserEmailCc' TEXT,'LoginUserID' INTEGER,'LoginUserEmail' TEXT,'SenderUserName' TEXT,'ReceiverUserName' TEXT,'MessageType' INTEGER,'IsSync' INTEGER,'RequestType' TEXT,'FileExtension' TEXT,'UserFile' TEXT,'MsgResponseTypeID' INTEGER,'MessageTree' TEXT,'Lstemilto' TEXT,'LstemilCc' TEXT,'FileAttachments' TEXT,'AttachmentFiles' TEXT,'Filesids' INTEGER,'MessageCreatedDateTime' TEXT,'MsgResponseType' INTEGER,'ReplyMessageID' INTEGER,'FKReplyTypeID' INTEGER,'FKMessageID' INTEGER,'FKMessageID' INTEGER,'MessageReturnIDs' INTEGER,'UserNameCc' TEXT,'ReplyMessageTo' TEXT,'ReplyMessageCount' INTEGER,'ParentGUIID' TEXT,'LastInboxMessageID' INTEGER,'UnreadMessageCount' INTEGER)");
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Email (Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,UserId INTEGER, MessageID INTEGER, SenderUserID INTEGER, ReceiverUserID INTEGER,FkMessageTypeID INTEGER, MessageTypeName INTEGER,  MessageFrom TEXT, MessageTo TEXT, MessageCc TEXT, MessageSubject TEXT,MessageBody TEXT,CreatedDateTime TEXT,IsViewed INTEGER,IsDeleted INTEGER,TotalRecords INTEGER,PageFrom INTEGER,PageTo INTEGER,UserEmailTo TEXT,UserEmailCc TEXT,LoginUserID INTEGER,LoginUserEmail TEXT,SenderUserName TEXT,ReceiverUserName TEXT,MessageType INTEGER,IsSync INTEGER,MsgResponseTypeID INTEGER,FileExtension TEXT,UserFile TEXT,Lstemilto TEXT,LstemilCc TEXT,FileAttachments TEXT,AttachmentFiles TEXT,Filesids INTEGER,MessageCreatedDateTime TEXT,MsgResponseType INTEGER,ReplyMessageID INTEGER,FKReplyTypeID INTEGER,FKMessageID INTEGER,MessageReturnIDs INTEGER,UserNameCc TEXT,ReplyMessageTo TEXT,ReplyMessageCount INTEGER,ParentGUIID TEXT,LastInboxMessageID INTEGER,UnreadMessageCount INTEGER,IsViewedSync INTEGER, RecivarPicture TEXT, SenderPicture TEXT, TotalInboxMessageCount INTEGER, TotalSendboxMessageCount INTEGER,TotalTrashMessageCount INTEGER, CreatedDateTimeStamp TEXT)');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'Email\') $e');
    }
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Reminder (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,UserId TEXT, reminderType INTEGER, startTime TEXT, endTime TEXT, interval TEXT,days TEXT, label TEXT,  description TEXT, imageBase64 TEXT, isNotification INTEGER, isDefault INTEGER,isEnable INTEGER,isRemove INTEGER,isSync INTEGER, secondStartTime TEXT,  secondEndTime TEXT)');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'Reminder\') $e');
    }

    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Contacts (Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,ContactID INTEGER, FKSenderUserID INTEGER , FKReceiverUserID INTEGER ,Username TEXT,FirstName TEXT , LastName TEXT, SenderFirstName TEXT, SenderLastName TEXT, SenderEmail TEXT, SenderPhone TEXT, SenderPicture TEXT, ReceiverFirstName TEXT, ReceiverLastName TEXT, ReceiverEmail TEXT, ReceiverPhone TEXT, ReceiverPicture TEXT, Email TEXT, Phone TEXT, Picture TEXT, IsDeleted INTEGER, ContactGuid INTEGER, IsAccepted INTEGER, IsRejected INTEGER, CreatedDatetime TEXT, CreatedDatetimeString TEXT, PageNumber INTEGER , PageSize INTEGER, TotalRecords INTEGER, IsSync INTEGER)');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'Contacts\') $e');
    }
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Invitation(ContactID INTEGER, SenderUserID INTEGER , SenderFirstName TEXT , SenderLastName TEXT , SenderEmail TEXT , SenderPhone TEXT , SenderPicture TEXT , IsAccepted INTEGER , IsSync INTEGER ,UserId INTEGER)');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'Invitation\') $e');
    }
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Alarm (id INTEGER ,UserId TEXT, alarmTime TEXT, days TEXT, label TEXT, isRepeatEnable INTEGER , isAlarmEnable INTEGER)');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'Alarm\') $e');
    }
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${DatabaseTableNameAndFields.TagTable} (${DatabaseTableNameAndFields.TagId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ${DatabaseTableNameAndFields.TagIdForApi} TEXT, ${DatabaseTableNameAndFields.UserIdTag} TEXT,${DatabaseTableNameAndFields.UnitInTag} TEXT, ${DatabaseTableNameAndFields.IconInTag} TEXT, ${DatabaseTableNameAndFields.LabelInTag} TEXT, ${DatabaseTableNameAndFields.MinInTag} REAL, ${DatabaseTableNameAndFields.MaxInTag} REAL, ${DatabaseTableNameAndFields.DefaultTag} REAL, ${DatabaseTableNameAndFields.PrecisionTag} REAL, ${DatabaseTableNameAndFields.IsRemoveTag} INTEGER,${DatabaseTableNameAndFields.IsDefaultTag} INTEGER, ${DatabaseTableNameAndFields.TagType} INTEGER, ${DatabaseTableNameAndFields.isSyncTag} INTEGER, ${DatabaseTableNameAndFields.isAutoLoad} INTEGER, keyword TEXT)');
    } catch (e) {
      debugPrint(
          'Exception in db helper class (CREATE TABLE IF NOT EXISTS ${DatabaseTableNameAndFields.TagTable}) $e');
    }
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${DatabaseTableNameAndFields.GraphTypeTable}(${DatabaseTableNameAndFields.GraphTypeId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ${DatabaseTableNameAndFields.GraphTypeName} TEXT, ${DatabaseTableNameAndFields.GraphTypeFieldName} TEXT , ${DatabaseTableNameAndFields.GraphTypeTableName} TEXT, ${DatabaseTableNameAndFields.GraphTypeColor} TEXT,${DatabaseTableNameAndFields.GraphTypeImage} TEXT, ${DatabaseTableNameAndFields.UserId} TEXT )');
    } catch (e) {
      debugPrint(
          'Exception in db helper class (CREATE TABLE IF NOT EXISTS ${DatabaseTableNameAndFields.GraphTypeTable}) $e');
    }
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS WeightScaleData(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, UserID TEXT, WeightSum REAL   , Muscle REAL, Moisture REAL,BoneMass REAL, BMR REAL, ProteinRate REAL , PhysicalAge REAL, VisceralFat REAL , SubcutaneousFat REAL, StandardWeight REAL , WeightControl REAL, FatMass REAL, WeightWithoutFat REAL, MuscleMass REAL, ProteinMass REAL, FatLevel INTEGER, BMI REAL, FatRate REAL, Date TEXT, IdForApi INTEGER, isSync INTEGER)');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS HealthKitOrGoogleFitTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, user_id TEXT , typeName TEXT , value REAL , startTime TEXT , endTime TEXT ,isSync INTEGER, valueId TEXT, IdForApi INTEGER, UNIQUE(user_id, valueId) )');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Chat(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, UserId TEXT , ReceiverId TEXT , MsgType INTEGER, MsgTime TEXT ,isSync INTEGER, GroupId Text)');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Temperature(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, UserId TEXT , Temperature REAL, Oxygen REAL, CVRR REAL, HRV REAL, HeartRate REAL, date TEXT, IdForApi INTEGER, timestamp INTEGER)');
      await db.execute('ALTER TABLE Temperature ADD unique_index(UserId, date) UNIQUE');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS offlineAPIRequests(oarId INTEGER PRIMARY KEY AUTOINCREMENT,reqData TEXT,url TEXT,contentType TEXT)');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Calendar(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, UserId INTEGER, SetRemindersID INTEGER, Info TEXT, FKUserID INTEGER, start TEXT, end TEXT, StartTime TEXT, EndTime TEXT, ShowMassege TEXT, Guest TEXT, FirstName TEXT, LastName TEXT, TabName TEXT, allDay INTEGER, EventAutocompleteBox INTEGER, OutOfTownemessagechecked INTEGER, OutTownMessage TEXT, OutOfTownAccessSpecify INTEGER, TaskRemainderTextboxchecked INTEGER, TaskDescription TEXT, AppointmentSlotval INTEGER, AppointmentTimeSlotDuration INTEGER, IsDeleted INTEGER, IsSync INTEGER, TimeZone TEXT, EventName TEXT, EventTagUserID INTEGER, SetReminderID INTEGER, EventTypeID INTEGER, OutOfTownName TEXT, OutofTownMessage TEXT, ReminderName TEXT, TaskName TEXT, TaskDecription TEXT, AppointmentName TEXT, IsMessageSend INTEGER, AccessSpecifier INTEGER, Slotvalu INTEGER, SlotDuration INTEGER, RemainderRepeat INTEGER, FullDay INTEGER)');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ChatList(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ToUserId INTEGER, IsGroup INTEGER, Members TEXT, FromUserId INTEGER, userName TEXT, FromFirstName TEXT, FromLastName TEXT, GroupName TEXT)');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS BloodPressure(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, userId TEXT , bloodSBP REAL, bloodDBP REAL, date INTEGER, idForApi INTEGER)');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

//    try {
//      await db.execute(
//          "CREATE TABLE IF NOT EXISTS 'GroupChat' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'date' TEXT, 'GroupName' INTEGER, 'calories' REAL, 'distance' REAL, 'user_Id' TEXT, 'completion' TEXT, 'data' TEXT, 'IdForApi' INTEGER, 'IsSync' INTEGER)");
//    } catch (e) {
//      debugPrint('Exception in db helper class $e');
//    }
//
//    try {
//      await db.execute(
//          "CREATE TABLE IF NOT EXISTS 'Sport' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'date' TEXT, 'step' INTEGER, 'calories' REAL, 'distance' REAL, 'user_Id' TEXT, 'completion' TEXT, 'data' TEXT, 'IdForApi' INTEGER, 'IsSync' INTEGER)");
//    } catch (e) {
//      debugPrint('Exception in db helper class $e');
//    }

    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ChatDetail(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,Message TEXT, DateSent TEXT, FromUserName TEXT, ToUserName Text, FromUserId INTEGER, ToUserId INTEGER, IsSent INTEGER)');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    // CREATE GROUPCHATLIST
    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS GroupChatDetail(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, Message TEXT, FromUserName TEXT, DateSent TEXT, GroupName TEXT,MessageId INTEGER, IsSent INTEGER)');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS HrMonitoringTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, userId TEXT, date INTEGER, approxHr INTEGER, idForApi INTEGER, ZoneID INTEGER)');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS TagLabel (ID INTEGER PRIMARY KEY  NOT NULL, LabelName TEXT,MinRange REAL, MaxRange REAL, DefaultValue REAL ,PrecisionDigit REAL, TotalRecords INTEGER,  PageNumber INTEGER, PageSize INTEGER, UnitName TEXT, ImageName TEXT,UserID INTEGER, FKTagLabelTypeID INTEGER, Suggestion TEXT, CreatedDateTime TEXT,CreatedDateTimeStamp TEXT,IsAutoLoad INTEGER, Short_description TEXT)');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'TagLabel\') $e');
    }

    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS HRZone (ID INTEGER PRIMARY KEY  NOT NULL, Zone TEXT, ZoneName TEXT ,MinHR REAL, MaxHR REAL, MinAge REAL, MaxAge REAL, TrackEnable INTEGER, UserId INTEGER, IntensityLevel TEXT, max_hr_value REAL, min_hr_value REAL)');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'HRZone\') $e');
    }

    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS HRZoneHistory (ID INTEGER PRIMARY KEY  NOT NULL, Zone TEXT, ZoneName TEXT ,MinHR REAL, MaxHR REAL, MinAge REAL, MaxAge REAL, TrackEnable INTEGER, UserId INTEGER,  HR INTEGER, TimeStamp INTEGER)');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'HRZoneHistory\') $e');
    }

    //  try {
    //   await db.execute(
    //       'CREATE TABLE IF NOT EXISTS HRZoneHistory (id INTEGER PRIMARY KEY  NOT NULL, hr INTEGER, zoneName TEXT ,minHeartRate REAL, maxHeartRate REAL, timeStamp INTEGER, UserId INTEGER)');
    // } catch (e) {
    //   debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'HRZoneHistory\') $e');
    // }

    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS TagRecord (ID INTEGER PRIMARY KEY  NOT NULL, FKTagLabelID INTEGER,TagValue REAL, Note TEXT, FKUserID INTEGER ,TypeName TEXT, CreatedDateTime TEXT,  CreatedDateTimeTimestamp TEXT, UnitSelectedType TEXT, TagImage TEXT, TagLabelName TEXT,AttachFiles TEXT, Date TEXT, Time TEXT, FKTagLabelTypeID REAL,Location TEXT,Short_description TEXT)');
    } catch (e) {
      debugPrint('Exception in db helper class (CREATE TABLE IF NOT EXISTS \'TagRecord\') $e');
    }

    try {
      var helper = DBTableHelper();
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${helper.bp.table}(${helper.bp.columnID} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ${helper.bp.columnUID} TEXT , ${helper.bp.columnDate} INTEGER, ${helper.bp.columnSys} REAL, ${helper.bp.columnDia} REAL)');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    try {
      var helper = DBTableHelper();
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${helper.m.table}(${helper.m.columnID} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ${helper.m.columnUID} TEXT, ${helper.m.columnTID} TEXT , ${helper.m.columnData} TEXT, ${helper.m.columnTimestamp} INTEGER, ${helper.m.columnSBP} TEXT, ${helper.m.columnDBP} TEXT, ${helper.m.columnDate} TEXT)');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    try {
      var helper = DBTableHelper();
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${helper.t.table}(${helper.t.columnID} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ${helper.t.columnFKUserID} INTEGER, ${helper.t.columnTagLabelID} INTEGER , ${helper.t.columnTagValue} REAL, ${helper.t.columnNote} TEXT, ${helper.t.columnTypeName} TEXT, ${helper.t.columnCreatedDateTime} TEXT, ${helper.t.columnCreatedDateTimeTimestamp} INTEGER,${helper.t.columnUnitSelectedType} TEXT, ${helper.t.columnTagImage} TEXT, ${helper.t.columnTagLabelName} TEXT, ${helper.t.columnAttachFiles} TEXT)');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    try {
      var helper = DBTableHelper();
      await db.execute(
          'CREATE TABLE IF NOT EXISTS ${helper.w.table}(${helper.w.columnID} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ${helper.w.columnUID} INTEGER, ${helper.w.columnWeightSum} REAL, ${helper.w.columnBMI} REAL, ${helper.w.columnFatRate} REAL, ${helper.w.columnMuscle} REAL, ${helper.w.columnMoisture} REAL, ${helper.w.columnBoneMass} REAL, ${helper.w.columnSubcutaneousFat} REAL, ${helper.w.columnBMR} REAL, ${helper.w.columnProteinRate} REAL, ${helper.w.columnVisceralFat} REAL, ${helper.w.columnPhysicalAge} REAL, ${helper.w.columnStandardWeight} REAL, ${helper.w.columnWeightControl} REAL, ${helper.w.columnFatMass} REAL, ${helper.w.columnWeightWithoutFat} REAL, ${helper.w.columnMuscleMass} REAL, ${helper.w.columnProteinMass} REAL, ${helper.w.columnFatLevel} REAL, ${helper.w.columnCreatedDateTime} REAL, ${helper.w.columnCreatedDateTimeStamp} INTEGER, ${helper.w.columnIsActive} REAL, ${helper.w.columnIsDelete} REAL, ${helper.w.columnWeightUnit} REAL)');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    addUNIQUEInTable(db, 'HealthKitOrGoogleFitTable', ['user_id', 'valueId']);
    return Future.value();
  }

  Future updateTable(Database db, int version) async {
    await updateSportTable(db);
    await updateSleepTable(db);
    await updateMeasurementTable(db);
    await updateTagNote(db);
    await updateEmail(db);
    await updateReminder(db);
    await updateContactTable(db);
    await updateInvitationTable(db);
    await updateAlarmTable(db);
    await updateUserTable(db);
    await tagTable(db);
    await graphTable(db);
    await updateWeighScaleTable(db);
    await updateHealthKitOrGoogleFitTable(db);
    await updateCalendarTable(db);
    await updateTemperatureTable(db);
    await updateSportForE80(db);
    await updateSleepForE80(db);
    await updateBloodPressureTable(db);
    await updateHrMonitoringTable(db);
    await updateHrZoneTable(db);

    /*
    //region user table
    try {
      if(version<_databaseVersion) {
        db.rawQuery('ALTER TABLE User ADD IsDefault INTEGER);
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    //endregion

    //region tag note
    try {
      if(version<_databaseVersion) {
        db.rawQuery("ALTER TABLE TagNote ADD TagIdForApi TEXT");
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    try {
      db.rawQuery("ALTER TABLE TagNote UPDATE Value REAL");
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    //endregion

    //region measurement table
    try {
      if(version<_databaseVersion) {
        db.rawQuery('ALTER TABLE Measurement ADD IdForApi INTEGER');
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    try {
      if(version<_databaseVersion) {
        db.rawQuery('ALTER TABLE Measurement ADD aiSBP INTEGER, aiDBP INTEGER,');
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    //endregion

    //region sport table
    try {
      if(version<_databaseVersion) {
        db.rawQuery('ALTER TABLE Sport ADD IdForApi INTEGER');
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    //endregion

    //region sleep table
    try {
      if(version<_databaseVersion) {
        db.rawQuery('ALTER TABLE Sleep ADD IdForApi INTEGER');
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    //endregion

    // region hourly hear rate
    try {
      if(version<_databaseVersion) {
        await db.rawQuery('ALTER TABLE Measurement ADD isForHourlyHR INTEGER');
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    //endregion

    try {
      await db.execute("CREATE TABLE IF NOT EXISTS 'Invitation'('ContactID' INTEGER, 'SenderUserID' INTEGER , 'SenderFirstName' TEXT , 'SenderLastName' TEXT , 'SenderEmail' TEXT , 'SenderPhone' TEXT , 'SenderPicture' TEXT , 'IsAccepted' INTEGER , 'IsSync' INTEGER ,'UserId' INTEGER ) ");
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    await createUpdateTableForBluetoothDevices(db, version);
    await createUpdateTableForGraphType(db, version);
    await createUpdateTableForTag(db, version);
*/
    return Future.value();
  }

  Future<void> updateHealthKitOrGoogleFitTable(Database db) async {
    try {
      await addColumnIfNotExist(
          db, 'HealthKitOrGoogleFitTable', 'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'HealthKitOrGoogleFitTable', 'user_id TEXT');
      await addColumnIfNotExist(db, 'HealthKitOrGoogleFitTable', 'typeName TEXT');
      await addColumnIfNotExist(db, 'HealthKitOrGoogleFitTable', 'value REAL');
      await addColumnIfNotExist(db, 'HealthKitOrGoogleFitTable', 'startTime TEXT');
      await addColumnIfNotExist(db, 'HealthKitOrGoogleFitTable', 'endTime TEXT');
      await addColumnIfNotExist(db, 'HealthKitOrGoogleFitTable', 'isSync INTEGER');
      await addColumnIfNotExist(db, 'HealthKitOrGoogleFitTable', 'valueId TEXT');
      await addColumnIfNotExist(db, 'HealthKitOrGoogleFitTable', 'IdForApi INTEGER');
      addUNIQUEInTable(db, 'HealthKitOrGoogleFitTable', ['user_id', 'valueId']);
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<void> updateTemperatureTable(Database db) async {
    try {
      await addColumnIfNotExist(db, 'Temperature', 'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'Temperature', 'UserId TEXT');
      await addColumnIfNotExist(db, 'Temperature', 'Temperature REAL');
      await addColumnIfNotExist(db, 'Temperature', 'Oxygen REAL');
      await addColumnIfNotExist(db, 'Temperature', 'CVRR REAL');
      await addColumnIfNotExist(db, 'Temperature', 'HRV REAL');
      await addColumnIfNotExist(db, 'Temperature', 'HeartRate REAL');
      await addColumnIfNotExist(db, 'Temperature', 'date TEXT');
      await addColumnIfNotExist(db, 'Temperature', 'IdForApi INTEGER');
    } catch (e) {
      debugPrint('Exception in db helper class (updateTemperatureTable) $e');
    }
  }

  Future<void> updateUserTable(Database db) async {
    try {
      await addColumnIfNotExist(db, 'User', 'UserId TEXT');
      await addColumnIfNotExist(db, 'User', 'Profile TEXT');
      await addColumnIfNotExist(db, 'User', 'UserName TEXT');
      await addColumnIfNotExist(db, 'User', 'FirstName TEXT');
      await addColumnIfNotExist(db, 'User', 'LastName TEXT');
      await addColumnIfNotExist(db, 'User', 'Gender TEXT');
      await addColumnIfNotExist(db, 'User', 'Unit TEXT');
      await addColumnIfNotExist(db, 'User', 'Height TEXT');
      await addColumnIfNotExist(db, 'User', 'Weight TEXT');
      await addColumnIfNotExist(db, 'User', 'BirthDate TEXT');
      await addColumnIfNotExist(db, 'User', 'SkinType TEXT');
      await addColumnIfNotExist(db, 'User', 'IsRemove INTEGER');
      await addColumnIfNotExist(db, 'User', "IsSync' INTEGER");
      await addColumnIfNotExist(db, 'User', 'IsConfirmed INTEGER');
      await addColumnIfNotExist(db, 'User', 'UserGroup INTEGER');
      await addColumnIfNotExist(db, 'User', 'UserMeasurementTypeID INTEGER');
      await addColumnIfNotExist(db, 'User', 'HeightUnit INTEGER');
      await addColumnIfNotExist(db, 'User', 'WeightUnit INTEGER');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future tagTable(Database db) async {
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        '${DatabaseTableNameAndFields.TagId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        '${DatabaseTableNameAndFields.IconInTag} TEXT');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        '${DatabaseTableNameAndFields.LabelInTag} TEXT');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        '${DatabaseTableNameAndFields.MinInTag} REAL');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        '${DatabaseTableNameAndFields.MaxInTag} REAL');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        '${DatabaseTableNameAndFields.DefaultTag} REAL');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        '${DatabaseTableNameAndFields.PrecisionTag} REAL');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        '${DatabaseTableNameAndFields.IsRemoveTag} INTEGER');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        '${DatabaseTableNameAndFields.IsDefaultTag} INTEGER');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        '${DatabaseTableNameAndFields.TagType} INTEGER');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        '${DatabaseTableNameAndFields.isSyncTag} INTEGER');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        '${DatabaseTableNameAndFields.isAutoLoad} INTEGER');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        '${DatabaseTableNameAndFields.TagIdForApi} TEXT');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}',
        ' ${DatabaseTableNameAndFields.UserIdTag} TEXT');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.TagTable}', 'keyword TEXT');
  }

  Future graphTable(Database db) async {
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.GraphTypeTable}',
        '${DatabaseTableNameAndFields.GraphTypeId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.GraphTypeTable}',
        '${DatabaseTableNameAndFields.GraphTypeName} TEXT');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.GraphTypeTable}',
        '${DatabaseTableNameAndFields.GraphTypeFieldName} TEXT');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.GraphTypeTable}',
        '${DatabaseTableNameAndFields.GraphTypeTableName} TEXT');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.GraphTypeTable}',
        '${DatabaseTableNameAndFields.GraphTypeColor} TEXT');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.GraphTypeTable}',
        '${DatabaseTableNameAndFields.GraphTypeImage} TEXT');
    await addColumnIfNotExist(db, '${DatabaseTableNameAndFields.GraphTypeTable}',
        '${DatabaseTableNameAndFields.UserId} TEXT');
  }

  Future updateWeighScaleTable(Database db) async {
    await addColumnIfNotExist(
        db, 'WeightScaleData', 'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
    await addColumnIfNotExist(db, 'WeightScaleData', 'UserID');
    await addColumnIfNotExist(db, 'WeightScaleData', 'WeightSum');
    await addColumnIfNotExist(db, 'WeightScaleData', 'Muscle');
    await addColumnIfNotExist(db, 'WeightScaleData', 'Moisture');
    await addColumnIfNotExist(db, 'WeightScaleData', 'BoneMass');
    await addColumnIfNotExist(db, 'WeightScaleData', 'BMR');
    await addColumnIfNotExist(db, 'WeightScaleData', 'ProteinRate');
    await addColumnIfNotExist(db, 'WeightScaleData', 'PhysicalAge');
    await addColumnIfNotExist(db, 'WeightScaleData', 'VisceralFat');
    await addColumnIfNotExist(db, 'WeightScaleData', 'SubcutaneousFat');
    await addColumnIfNotExist(db, 'WeightScaleData', 'StandardWeight');
    await addColumnIfNotExist(db, 'WeightScaleData', 'WeightControl');
    await addColumnIfNotExist(db, 'WeightScaleData', 'FatMass');
    await addColumnIfNotExist(db, 'WeightScaleData', 'WeightWithoutFat');
    await addColumnIfNotExist(db, 'WeightScaleData', 'MuscleMass');
    await addColumnIfNotExist(db, 'WeightScaleData', 'ProteinMass');
    await addColumnIfNotExist(db, 'WeightScaleData', 'FatLevel');
    await addColumnIfNotExist(db, 'WeightScaleData', 'BMI');
    await addColumnIfNotExist(db, 'WeightScaleData', 'FatRate');
    await addColumnIfNotExist(db, 'WeightScaleData', 'Date');
    await addColumnIfNotExist(db, 'WeightScaleData', 'IdForApi');
    await addColumnIfNotExist(db, 'WeightScaleData', 'isSync');
  }

  Future<void> updateAlarmTable(Database db) async {
    try {
      await addColumnIfNotExist(db, 'Alarm', 'id INTEGER');
      await addColumnIfNotExist(db, 'Alarm', 'UserId TEXT');
      await addColumnIfNotExist(db, 'Alarm', 'alarmTime TEXT');
      await addColumnIfNotExist(db, 'Alarm', 'days TEXT');
      await addColumnIfNotExist(db, 'Alarm', 'label TEXT');
      await addColumnIfNotExist(db, 'Alarm', 'isRepeatEnable INTEGER');
      await addColumnIfNotExist(db, 'Alarm', 'isAlarmEnable INTEGER');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<void> updateInvitationTable(Database db) async {
    try {
      await addColumnIfNotExist(db, 'Invitation', 'Contact INTEGER');
      await addColumnIfNotExist(db, 'Invitation', ' SenderUserID INTEGER ');
      await addColumnIfNotExist(db, 'Invitation', ' SenderFirstName TEXT ');
      await addColumnIfNotExist(db, 'Invitation', ' SenderLastName TEXT ');
      await addColumnIfNotExist(db, 'Invitation', ' SenderEmail TEXT ');
      await addColumnIfNotExist(db, 'Invitation', ' SenderPhone TEXT ');
      await addColumnIfNotExist(db, 'Invitation', ' SenderPicture TEXT ');
      await addColumnIfNotExist(db, 'Invitation', ' IsAccepted INTEGER ');
      await addColumnIfNotExist(db, 'Invitation', ' IsSync INTEGER ');
      await addColumnIfNotExist(db, 'Invitation', 'UserId INTEGER');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<void> updateContactTable(Database db) async {
    try {
      await addColumnIfNotExist(db, 'Contacts', 'Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'Contacts', 'ContactID INTEGER');
      await addColumnIfNotExist(db, 'Contacts', ' FKSenderUserID INTEGER ');
      await addColumnIfNotExist(db, 'Contacts', ' FKReceiverUserID INTEGER ');
      await addColumnIfNotExist(db, 'Contacts', 'FirstName TEXT ');
      await addColumnIfNotExist(db, 'Contacts', ' LastName TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' SenderFirstName TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' SenderLastName TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' SenderEmail TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' SenderPhone TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' SenderPicture TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' ReceiverFirstName TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' ReceiverLastName TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' ReceiverEmail TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' ReceiverPhone TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' ReceiverPicture TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' Email TEXT, Phone TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' Picture TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' IsDeleted INTEGER,');
      await addColumnIfNotExist(db, 'Contacts', 'ContactGuid INTEGER,');
      await addColumnIfNotExist(db, 'Contacts', 'IsAccepted INTEGER,');
      await addColumnIfNotExist(db, 'Contacts', 'IsRejected INTEGER');
      await addColumnIfNotExist(db, 'Contacts', ' CreatedDatetime TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' CreatedDatetimeString TEXT');
      await addColumnIfNotExist(db, 'Contacts', ' PageNumber INTEGER ');
      await addColumnIfNotExist(db, 'Contacts', ' PageSize INTEGER');
      await addColumnIfNotExist(db, 'Contacts', ' TotalRecords INTEGER');
      await addColumnIfNotExist(db, 'Contacts', ' IsSync INTEGER');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<void> updateReminder(Database db) async {
    try {
      await addColumnIfNotExist(db, 'Reminder', 'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'Reminder', 'UserId TEXT');
      await addColumnIfNotExist(db, 'Reminder', 'reminderType INTEGER');
      await addColumnIfNotExist(db, 'Reminder', ' startTime TEXT');
      await addColumnIfNotExist(db, 'Reminder', ' endTime TEXT');
      await addColumnIfNotExist(db, 'Reminder', ' interval TEXT');
      await addColumnIfNotExist(db, 'Reminder', 'days TEXT');
      await addColumnIfNotExist(db, 'Reminder', ' label TEXT');
      await addColumnIfNotExist(db, 'Reminder', '  description TEXT');
      await addColumnIfNotExist(db, 'Reminder', ' imageBase64 TEXT');
      await addColumnIfNotExist(db, 'Reminder', ' isNotification INTEGER');
      await addColumnIfNotExist(db, 'Reminder', ' isDefault INTEGER');
      await addColumnIfNotExist(db, 'Reminder', 'isEnable INTEGER');
      await addColumnIfNotExist(db, 'Reminder', 'isRemove INTEGER');
      await addColumnIfNotExist(db, 'Reminder', 'isSync INTEGER');
      await addColumnIfNotExist(db, 'Reminder', 'secondStartTime TEXT');
      await addColumnIfNotExist(db, 'Reminder', 'secondEndTime TEXT');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<void> updateEmail(Database db) async {
    try {
      await addColumnIfNotExist(db, 'Email', 'Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'Email', 'UserId INTEGER, ');
      await addColumnIfNotExist(db, 'Email', 'MessageID INTEGER, ');
      await addColumnIfNotExist(db, 'Email', 'SenderUserID INTEGER, ');
      await addColumnIfNotExist(db, 'Email', 'ReceiverUserID INTEGER,');
      await addColumnIfNotExist(db, 'Email', 'FkMessageTypeID INTEGER, ');
      await addColumnIfNotExist(db, 'Email', 'MessageTypeName INTEGER,  ');
      await addColumnIfNotExist(db, 'Email', 'MessageFrom TEXT, ');
      await addColumnIfNotExist(db, 'Email', 'MessageTo TEXT, ');
      await addColumnIfNotExist(db, 'Email', 'MessageCc TEXT, ');
      await addColumnIfNotExist(db, 'Email', 'MessageSubject TEXT,');
      await addColumnIfNotExist(db, 'Email', 'MessageBody TEXT,');
      await addColumnIfNotExist(db, 'Email', 'CreatedDateTime TEXT,');
      await addColumnIfNotExist(db, 'Email', 'IsViewed INTEGER,');
      await addColumnIfNotExist(db, 'Email', 'IsDeleted INTEGER,');
      await addColumnIfNotExist(db, 'Email', 'TotalRecords INTEGER,');
      await addColumnIfNotExist(db, 'Email', 'PageFrom INTEGER,');
      await addColumnIfNotExist(db, 'Email', 'PageTo INTEGER,');
      await addColumnIfNotExist(db, 'Email', 'UserEmailTo TEXT,');
      await addColumnIfNotExist(db, 'Email', 'UserEmailCc TEXT,');
      await addColumnIfNotExist(db, 'Email', 'LoginUserID INTEGER,');
      await addColumnIfNotExist(db, 'Email', 'LoginUserEmail TEXT,');
      await addColumnIfNotExist(db, 'Email', 'SenderUserName TEXT,');
      await addColumnIfNotExist(db, 'Email', 'ReceiverUserName TEXT,');
      await addColumnIfNotExist(db, 'Email', 'MessageType INTEGER,');
      await addColumnIfNotExist(db, 'Email', 'IsSync INTEGER,');
      await addColumnIfNotExist(db, 'Email', 'FileExtension TEXT,');
      await addColumnIfNotExist(db, 'Email', 'UserFile TEXT,');
      await addColumnIfNotExist(db, 'Email', 'MsgResponseTypeID INTEGER');
      await addColumnIfNotExist(db, 'Email', 'CreatedDateTimeStamp TEXT');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<void> updateTagNote(Database db) async {
    try {
      await addColumnIfNotExist(db, 'TagNote', 'Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'TagNote', 'IdForApi TEXT');
      await addColumnIfNotExist(db, 'TagNote', 'TagIdForApi TEXT');
      await addColumnIfNotExist(db, 'TagNote', 'TagId INTEGER');
      await addColumnIfNotExist(db, 'TagNote', 'Label TEXT');
      await addColumnIfNotExist(db, 'TagNote', 'UserId TEXT');
      await addColumnIfNotExist(db, 'TagNote', 'Date TEXT');
      await addColumnIfNotExist(db, 'TagNote', 'Time TEXT');
      await addColumnIfNotExist(db, 'TagNote', 'Value REAL');
      await addColumnIfNotExist(db, 'TagNote', 'Note TEXT');
      await addColumnIfNotExist(db, 'TagNote', 'PatchLocation TEXT');
      await addColumnIfNotExist(db, 'TagNote', 'isRemove INTEGER');
      await addColumnIfNotExist(db, 'TagNote', ' isSync INTEGER');
      await addColumnIfNotExist(db, 'TagNote', ' unitSelectedType TEXT');
      await addColumnIfNotExist(db, 'TagNote', ' tagType INTEGER');
      await addColumnIfNotExist(db, 'TagNote', ' ImageList TEXT');
      await addColumnIfNotExist(db, 'TagNote', 'CreatedDateTimeTimestamp TEXT');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<void> updateSleepTable(Database db) async {
    try {
      await addColumnIfNotExist(db, 'Sleep', 'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'Sleep', 'date TEXT');
      await addColumnIfNotExist(db, 'Sleep', 'sleepAllTime TEXT');
      await addColumnIfNotExist(db, 'Sleep', 'deepTime TEXT');
      await addColumnIfNotExist(db, 'Sleep', 'lightTime TEXT');
      await addColumnIfNotExist(db, 'Sleep', 'allTime TEXT');
      await addColumnIfNotExist(db, 'Sleep', 'stayUpTime TEXT');
      await addColumnIfNotExist(db, 'Sleep', 'user_Id TEXT');
      await addColumnIfNotExist(db, 'Sleep', 'data TEXT');
      await addColumnIfNotExist(db, 'Sleep', 'wakInCount TEXT');
      await addColumnIfNotExist(db, 'Sleep', 'IdForApi INTEGER');
      await addColumnIfNotExist(db, 'Sleep', 'IsSync INTEGER');
      await addColumnIfNotExist(db, 'Sleep', 'CreateDateTimeStamp TEXT');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<void> updateSportTable(Database db) async {
    try {
      await addColumnIfNotExist(db, 'Sport', 'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'Sport', 'date TEXT');
      await addColumnIfNotExist(db, 'Sport', 'step INTEGER');
      await addColumnIfNotExist(db, 'Sport', 'calories REAL');
      await addColumnIfNotExist(db, 'Sport', 'distance REAL');
      await addColumnIfNotExist(db, 'Sport', 'user_Id TEXT');
      await addColumnIfNotExist(db, 'Sport', 'completion TEXT');
      await addColumnIfNotExist(db, 'Sport', 'data TEXT');
      await addColumnIfNotExist(db, 'Sport', 'IdForApi INTEGER');
      await addColumnIfNotExist(db, 'Sport', 'IsSync INTEGER');
      await addColumnIfNotExist(db, 'Sport', 'CreatedDateTimeStamp TEXT');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<void> updateCalendarTable(Database db) async {
    try {
      await addColumnIfNotExist(db, 'Calendar', 'UserId INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'SetRemindersID INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'Info TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'FKUserID INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'start TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'end TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'StartTime TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'EndTime TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'ShowMassege TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'Guest TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'FirstName TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'LastName TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'TabName TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'allDay INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'EventAutocompleteBox INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'OutOfTownemessagechecked INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'OutTownMessage TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'OutOfTownAccessSpecify INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'TaskRemainderTextboxchecked INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'TaskDescription TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'AppointmentSlotval INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'AppointmentTimeSlotDuration INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'IsDeleted INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'IsSync INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'TimeZone TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'EventName TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'EventTagUserID INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'SetReminderID INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'EventTypeID INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'OutOfTownName TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'OutofTownMessage TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'ReminderName TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'TaskName TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'TaskDecription TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'AppointmentName TEXT');
      await addColumnIfNotExist(db, 'Calendar', 'IsMessageSend INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'AccessSpecifier INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'Slotvalu INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'SlotDuration INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'RemainderRepeat INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'FullDay INTEGER');
      await addColumnIfNotExist(db, 'Calendar', 'FullDay INTEGER');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<void> updateSportForE80(Database db) async {
    try {
      await addColumnIfNotExist(
          db, 'SportDataForE80', 'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'SportDataForE80', 'sportEndTime Text');
      await addColumnIfNotExist(db, 'SportDataForE80', 'sportStartTime TEXT');
      await addColumnIfNotExist(db, 'SportDataForE80', 'sportDistance REAL');
      await addColumnIfNotExist(db, 'SportDataForE80', 'sportStep INTEGER');
      await addColumnIfNotExist(db, 'SportDataForE80', 'IdForApi INTEGER');
      await addColumnIfNotExist(db, 'SportDataForE80', 'UserId TEXT');
    } catch (e) {
      debugPrint('Exception in db helper class updateSportForE80 $e');
    }
  }

  Future<void> updateSleepForE80(Database db) async {
    try {
      await addColumnIfNotExist(
          db, 'SleepDataForE80', 'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'SleepDataForE80', 'startTime TEXT');
      await addColumnIfNotExist(db, 'SleepDataForE80', 'endTime TEXT');
      await addColumnIfNotExist(db, 'SleepDataForE80', 'deepSleepTotal REAL');
      await addColumnIfNotExist(db, 'SleepDataForE80', 'lightSleepTotal REAL');
      await addColumnIfNotExist(db, 'SleepDataForE80', 'deepSleepCount REAL');
      await addColumnIfNotExist(db, 'SleepDataForE80', 'lightSleepCount REAL');
      await addColumnIfNotExist(db, 'SleepDataForE80', 'sleepData TEXT');
      await addColumnIfNotExist(db, 'SleepDataForE80', 'UserId TEXT');
      await addColumnIfNotExist(db, 'SleepDataForE80', 'IdForApi INTEGER');
    } catch (e) {
      debugPrint('Exception in db helper class updateSportForE80 $e');
    }
  }

  Future<void> updateBloodPressureTable(Database db) async {
    try {
      await addColumnIfNotExist(db, 'Temperature', 'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'BloodPressure', 'userId TEXT');
      await addColumnIfNotExist(db, 'BloodPressure', 'bloodSBP REAL');
      await addColumnIfNotExist(db, 'BloodPressure', 'bloodDBP REAL');
      await addColumnIfNotExist(db, 'BloodPressure', 'date TEXT');
      await addColumnIfNotExist(db, 'BloodPressure', 'idForApi INTEGER');
    } catch (e) {
      debugPrint('Exception in db helper class (updateTemperatureTable) $e');
    }
  }

  Future<void> updateHrMonitoringTable(Database db) async {
    try {
      await addColumnIfNotExist(
          db, 'HrMonitoringTable', 'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'HrMonitoringTable', 'userId TEXT');
      await addColumnIfNotExist(db, 'HrMonitoringTable', 'idForApi INTEGER');
      await addColumnIfNotExist(db, 'HrMonitoringTable', 'date TEXT');
      await addColumnIfNotExist(db, 'HrMonitoringTable', 'approxHr INTEGER');
      await addColumnIfNotExist(db, 'HrMonitoringTable', 'ZoneID INTEGER');
    } catch (e) {
      debugPrint('Exception in db helper class (update HrMonitoringTable) $e');
    }
  }

  Future<void> updateHrZoneTable(Database db) async {
    try {
      await addColumnIfNotExist(db, 'HRZone', 'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'HRZone', 'max_hr_value REAL');
      await addColumnIfNotExist(db, 'HRZone', 'min_hr_value REAL');
    } catch (e) {
      debugPrint('Exception in db helper class (update HRZone) $e');
    }
  }

  Future addColumnIfNotExist(Database db, String tableName, String fieldNameWithType) async {
    try {
      var a = await db.execute('ALTER TABLE $tableName Add $fieldNameWithType');
      return a;
    } catch (e) {
      debugPrint('Error while update $fieldNameWithType in $tableName = $e');
      return Future.value('Error while update $fieldNameWithType in $tableName = $e');
    }
  }

  Future addUNIQUEInTable(Database db, String tableName, List listOfFields) async {
    try {
      var query = 'create unique index unique_name on $tableName(';
      query += listOfFields.join(',');
      query += ')';
      var a = await db.execute(query);
      return a;
    } catch (e) {
      return Future.value('Error while update $tableName in $listOfFields = $e');
    }
  }

  Future<bool> checkIfTable(String name) async {
    var db = await instance.database;
    var result =
        await db.rawQuery('SELECT name FROM sqlite_master WHERE type=\'table\' AND name=\'$name\'');
    print('checkIfTable :: Table List :: $result');
    return result.isNotEmpty;
  }

  Future<int> insertUser(Map<String, dynamic> raw, String userId) async {
    preferences!.setInt(Constants.wightUnitKey, raw['WeightUnit']);
    var value = 0;
    var db = await instance.database;
    try {
      await db.rawQuery('SELECT IsRemove from User');
    } catch (e) {
      await db.rawQuery('ALTER TABLE User ADD IsRemove INTEGER');
      debugPrint('Exception in db helper class $e');
    }
    var isExist = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM User WHERE UserId = $userId'));
    if (isExist != null && isExist != 0) {
      value = await db.update('User', raw, where: 'UserId = ?', whereArgs: [userId]);
    } else {
      value = await db.insert('User', raw);
    }
    return value;
  }

  Future<UserModel?> getUser(String userId) async {
    UserModel? userModel;
    var db = await instance.database;
    List list = await db.rawQuery('SELECT * FROM User WHERE UserId = $userId');
    if (list.isNotEmpty) {
      userModel = UserModel.fromMap(list.last);
    }
    return userModel;
  }

  //get list of activity(sport)
  Future<List<MotionInfoModel>> getActivityData(String userId) async {
    var activityDataList = <MotionInfoModel>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery('SELECT * FROM Sport WHERE user_Id = $userId');
      activityDataList = list.map((e) => MotionInfoModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return activityDataList;
  }

  Future<List<MotionInfoModel>> getUnSyncActivityData(String userId) async {
    var activityDataList = <MotionInfoModel>[];
    try {
      var db = await instance.database;
      List list =
          await db.rawQuery('SELECT * FROM Sport WHERE user_Id = $userId AND idForApi is NULL');
      activityDataList = list.map((e) => MotionInfoModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return activityDataList;
  }

  Future<List<MotionInfoModel>> getActivityDataDateWise(
      String startDate, String endDate, String userId) async {
    var activityDataList = <MotionInfoModel>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery(
          'select * from Sport where user_Id = $userId and date between \'$startDate\' and \'$endDate\' GROUP BY date ORDER BY date DESC');
      activityDataList = list.map((e) => MotionInfoModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return activityDataList;
  }

  Future<List<MotionInfoModel>> getLatestActivityData(String userId) async {
    var activityData = <MotionInfoModel>[];
    try {
      var db = await instance.database;
      List list = await db
          .rawQuery('SELECT * FROM Sport WHERE user_Id = $userId ORDER BY date DESC LIMIT 1');
      activityData = list.map((e) => MotionInfoModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return activityData;
  }

  Future<List<SleepInfoModel>> getSleepData(String userId) async {
    var seepDataList = <SleepInfoModel>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery('SELECT * FROM Sleep WHERE user_Id = $userId');
      seepDataList = list.map((e) => SleepInfoModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return seepDataList;
  }

  Future<List<SleepInfoModel>> getUnSyncSleepData(String userId) async {
    var seepDataList = <SleepInfoModel>[];
    try {
      var db = await instance.database;
      List list =
          await db.rawQuery('SELECT * FROM Sleep WHERE user_Id = $userId AND idForApi is NULL');
      seepDataList = list.map((e) => SleepInfoModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return seepDataList;
  }

  Future<List<SleepInfoModel>> getSleepDataDateWise(
      String startDate, String endDate, String userId) async {
    var seepDataList = <SleepInfoModel>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery(
          'select * from Sleep where user_Id = $userId and date between \'$startDate\' and \'$endDate\' GROUP BY date ORDER BY date DESC');
      seepDataList = list.map((e) => SleepInfoModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return seepDataList;
  }

  Future<List<SleepInfoModel>> getLastRecordedSleep(String userId) async {
    var seepDataList = <SleepInfoModel>[];
    try {
      var db = await instance.database;
      List list = await db
          .rawQuery('select * from Sleep where user_Id = $userId ORDER BY date DESC LIMIT 1');
      seepDataList = list.map((e) => SleepInfoModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return seepDataList;
  }

  Future<List<SleepInfoModel>> getSleepForCalendar(
      String userId, DateTime startDate, DateTime endDate, int offset) async {
    var strFirst = DateFormat(DateUtil.yyyyMMdd).format(startDate);
    var strLast = DateFormat(DateUtil.yyyyMMdd).format(endDate);
    var seepDataList = <SleepInfoModel>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery(
          'select * from Sleep where user_Id = $userId and date between \'$strFirst\' and \'$strLast\' GROUP BY date ORDER BY date DESC LIMIT 100 OFFSET $offset');
      seepDataList = list.map((e) => SleepInfoModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return seepDataList;
  }

  Future<int> insertActivityData(Map<String, dynamic> row) async {
    try {
      var db = await instance.database;
      var existTid = Sqflite.firstIntValue(await db.rawQuery(
              'SELECT id FROM Sport where user_Id = ${row['user_Id']} and date = \'${row["date"]}\'')) ??
          0;
      if ((existTid != 0) || (row.containsKey('id') && row['id'] != null)) {
        int? id = row['id'];
        if (id == null) {
          id = existTid;
        }
        await db.update('Sport', row, where: 'id = ?', whereArgs: [id]);
        return existTid;
      }
      return await db.insert('Sport', row);
    } catch (e) {
      debugPrint('Exception in db helper class getSleepDataDateWise $e');
    }
    return -1;
  }

  Future<int> insertSleepData(Map<String, dynamic> row) async {
    var db = await instance.database;
    if (row.containsKey('id') && row['id'] != null) {
      int id = row['id'];
      return await db.update('Sleep', row, where: 'id = ?', whereArgs: [id]);
    }
    return await db.insert('Sleep', row);
  }

  Future insertWeightMeasurementDataFromApi(
      List<WeightMeasurementModel> list, String userId) async {
    var result;
    var db = await instance.database;
    list.forEach((WeightMeasurementModel model) async {
      var map = model.toJson();
      map['UserID'] = userId;
      var isExist = Sqflite.firstIntValue(await db.rawQuery(
              'SELECT id FROM WeightScaleData WHERE UserID = $userId AND IdForApi = ${map['IdForApi']}')) ??
          0;
      if (isExist != 0) {
        map.remove('id');
        result = await db.update('WeightScaleData', map, where: 'id = ?', whereArgs: [isExist]);
      } else {
        result = await db.insert('WeightScaleData', map);
      }
    });
    return result;
  }

  Future insertMotionDataFromApi(List<MotionInfoModel> list, String userId) async {
    var result;
    var db = await instance.database;
    list.forEach((MotionInfoModel model) async {
      var map = model.toMap();
      map['user_Id'] = userId;
      var isExist = Sqflite.firstIntValue(await db.rawQuery(
              'SELECT id FROM Sport WHERE user_Id = $userId AND IdForApi = ${map['IdForApi']}')) ??
          0;
      if (isExist != 0) {
        result = await db.update('Sport', map, where: 'id = ?', whereArgs: [isExist]);
      } else {
        result = await db.insert('Sport', map);
      }
    });
    return result;
  }

  Future insertSleepDataFromApi(List<SleepInfoModel> list, String userId) async {
    var result;
    try {
      var db = await instance.database;
      list.forEach((SleepInfoModel model) async {
        var map = model.toMap();
        map['user_Id'] = userId;
        var isExist = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT id FROM Sleep WHERE user_Id = $userId AND IdForApi = ${map['IdForApi']}')) ??
            0;
        if (isExist != 0) {
          result = await db.update('Sleep', map, where: 'id = ?', whereArgs: [isExist]);
        } else {
          result = await db.insert('Sleep', map);
        }
      });
    } catch (e) {
      debugPrint('Exception at insertSleepDataFromApi $e');
    }
    return result;
  }

  //region measurement

  Future checkMeasurementIsAlreadyPosted(String userId, int id) async {
    var db = await instance.database;
    var existTid = Sqflite.firstIntValue(await db
            .rawQuery('SELECT IdForApi FROM Measurement where user_Id = $userId and id = $id')) ??
        -1;
    return existTid > -1;
  }

  Future insertMeasurementData(Map<String, dynamic> map, String userId) async {
    var result = -1;
    try {
      var db = await instance.database;
      if (map['id'] != null) {
        result = await db.update('Measurement', map, where: 'id = ?', whereArgs: [map['id']]);
        result = map['id'];
        print('insertMeasurementDataFromApi_update ${map['BG']}');
      } else if (map['isForHourlyHR'] == 1) {
        var existTid = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT id FROM Measurement where user_Id = $userId and date = \'${map['date']}\'')) ??
            -1;
        if (existTid > -1) {
          return existTid;
        }
        result = await db.insert('Measurement', map);
        print('insertMeasurementDataFromApi_909 ${map['date']}');
      } else {
        result = await db.insert('Measurement', map);
        print('insertMeasurementDataFromApi_909111 ${map['date']}');
      }
    } catch (e) {
      debugPrint('Exception in db helper class insertMeasurementData $e');
    }
    // await deleteDuplicateMeasurement();
    return result;
  }

  Future deleteDuplicateMeasurement() async {
    try {
      var query =
          'DELETE FROM Measurement WHERE (id, user_Id, date) NOT IN(SELECT id, user_Id, date FROM Measurement GROUP BY date)';
      var db = await instance.database;
      final result = await db.rawQuery(query);
      return result;
    } on Exception catch (e) {
      LoggingService().debugPrintLog(message: e.toString());
    }
  }

  Future insertMeasurementDataFromApi(List<MeasurementHistoryModel> list, String userId) async {
    var result;
    try {
      var db = await instance.database;
      for (var i = 0; i < list.length; i++) {
        var model = list.elementAt(i);
        var map = model.toMapDB();
        map['user_Id'] = userId;
        var isExist = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT id FROM Measurement WHERE user_Id = $userId AND IdForApi = ${map['IdForApi']}')) ??
            -1;
        print(
            'insertMeasurementDataFromApi_90909 ${model.date}  ${model.id}  ${model.idForApi}  $isExist');
        if (isExist > -1) {
          map.remove('id');
          result = await db.update('Measurement', map, where: 'id = ?', whereArgs: [isExist]);
        } else {
          result = await db.insert('Measurement', map);
        }
      }
    } catch (e) {
      print(e);
    }

    // await deleteDuplicateMeasurement();
    return result;
  }

  Future updateSyncInMeasurement(int id, {int? apiId}) async {
    var db = await instance.database;
    var result;
    if (apiId != null) {
      result =
          await db.rawQuery('update Measurement set IsSync = 1 , IdForApi = $apiId where id = $id');
    } else {
      result = await db.rawQuery('update Measurement set IsSync = 1 where id = $id');
    }
    return result;
  }

  Future<List<MeasurementHistoryModel>> getAllMeasurementHistory(String userId) async {
    var modelList = <MeasurementHistoryModel>[];
    try {
      var query = 'select * from Measurement where user_Id = $userId';
      var db = await instance.database;
      List list = await db.rawQuery(query);
      modelList = list.map((e) => MeasurementHistoryModel.fromMap(e)).toList();
      return modelList;
    } catch (e) {
      debugPrint('Exception at getAllMeasurementHistory $e');
      return modelList;
    }
  }

  Future getMeasurementIds(String userId) async {
    var db = await instance.database;
    List list = await db.rawQuery(
        'SELECT IdForApi FROM Measurement WHERE user_Id = $userId and IdForApi IS NOT NULL ');
    var lst = list.map((map) => map['IdForApi']).toList();
    return lst;
  }

  Future<List<MeasurementHistoryModel>> getMeasurementHistoryData(
      String userId, String startDate, String endDate,
      {List? ids, int? limit}) async {
    var query =
        'select * from Measurement where user_Id = $userId and isForHourlyHR != 1 and isForTimeBasedPpg != 1 and date between \'$startDate\' and \'$endDate\' GROUP BY date ORDER BY date DESC';
    if (ids != null && limit != null) {
      /*ids.forEach((element) {
        if (element != null) {
          query += ' and id != $element';
        }
      });*/
      // if(ids.length > 0 && ids.length >=3){
      //   query.replaceRange(ids.length-3, ids.length, "");
      // }
      query += ' LIMIT $limit OFFSET ${ids.length}';
    }
    print('getHistory_query $query');
    var modelList = <MeasurementHistoryModel>[];
    var db = await instance.database;
    List list = await db.rawQuery(query);

    print('getHistory_query_size ${list.length}');
    modelList = list.map((e) => MeasurementHistoryModel.fromMap(e)).toList();
    for (var element in modelList) {
      print('gethistory_data ${element.date}');
    }

    return modelList;
  }

  Future<List<MeasurementHistoryModel>> getMeasurementHistoryDataForBpGraph(
    String userId,
    String startDate,
    String endDate,
  ) async {
    var query =
        'select approxSBP, approxDBP, date from Measurement where user_Id = $userId and isForHourlyHR != 1 and isForTimeBasedPpg != 1 and approxSBP IS NOT NULL and approxDBP IS NOT NULL and approxSBP != 0 and approxDBP != 0 and date between \'$startDate\' and \'$endDate\'';
    var modelList = <MeasurementHistoryModel>[];
    var db = await instance.database;
    List list = await db.rawQuery(query);
    modelList = list.map((e) => MeasurementHistoryModel.fromMap(e)).toList();
    return modelList;
  }

  Future<List<MeasurementHistoryModel>> getMeasurementHistoryForCalendar(
      String userId, DateTime startDate, DateTime endDate, int offset) async {
    var strFirst = DateFormat(DateUtil.yyyyMMdd).format(startDate);
    var strLast = DateFormat(DateUtil.yyyyMMdd).format(endDate);
    var query =
        'select DISTINCT date from Measurement where user_Id = $userId and isForHourlyHR != 1 and isForTimeBasedPpg != 1 and approxSBP IS NOT NULL and approxDBP IS NOT NULL and approxSBP != 0 and approxDBP != 0 and date between \'$strFirst\' and \'$strLast\' LIMIT 100 OFFSET $offset';
    var modelList = <MeasurementHistoryModel>[];
    var db = await instance.database;
    List list = await db.rawQuery(query);
    modelList = list.map((e) => MeasurementHistoryModel.fromMap(e)).toList();
    return modelList;
  }

  Future<List<MeasurementHistoryModel>> getHrData(
    String userId,
    String startDate,
    String endDate,
  ) async {
    var query =
        'select approxHr, date from Measurement where user_Id = $userId and approxHr IS NOT NULL and approxHR != 0 and date IS NOT NULL and date between \'$startDate\' and \'$endDate\'';
    var modelList = <MeasurementHistoryModel>[];
    var db = await instance.database;
    List list = await db.rawQuery(query);
    debugPrint('$list');
    modelList = list.map((e) => MeasurementHistoryModel.fromMap(e)).toList();
    return modelList;
  }

  Future<List<HeartRateModel>> getMeasurementDataForWorkout(
      String userId, String startDate, String endDate) async {
    var db = await instance.database;
    var ecgInfoReadingModelList = <HeartRateModel>[];
    List list = await db.rawQuery(
        'SELECT approxHr,date FROM Measurement WHERE user_Id = $userId and date between \'$startDate\' and \'$endDate\'');
    ecgInfoReadingModelList = list.map((e) => HeartRateModel.fromMap(e)).toList();
    return ecgInfoReadingModelList;
  }

  //this method returns last measurement of user
  Future<List<MeasurementHistoryModel>> getUnSyncMeasurementData(String userId) async {
    var ecgInfoReadingModelList = <MeasurementHistoryModel>[];
    var db = await instance.database;
    List list = await db.rawQuery(
        'SELECT * FROM Measurement WHERE user_Id = $userId AND IdForApi is NULL AND isForHourlyHR != 1');
    ecgInfoReadingModelList = list.map((e) => MeasurementHistoryModel.fromMap(e)).toList();
    return ecgInfoReadingModelList;
  }

  Future deleteMeasurementHistory(int id) async {
    try {
      var db = await instance.database;
      var result = await db.delete('Measurement', where: 'id = ?', whereArgs: [id]);
      return result;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<List<MeasurementHistoryModel>> getLastSavedMeasurementData(String userId) async {
    var ecgInfoReadingModelList = <MeasurementHistoryModel>[];
    var db = await instance.database;
    List list = await db.rawQuery(
        'SELECT * FROM Measurement WHERE user_Id = $userId  GROUP BY date ORDER BY date DESC LIMIT 1');
    ecgInfoReadingModelList = list.map((e) => MeasurementHistoryModel.fromMap(e)).toList();
    return ecgInfoReadingModelList;
  }

  Future getHeartRateData(String userId, String startDate, String endDate, List ids) async {
    try {
      var query =
          'select * from Measurement where user_Id = $userId and date between \'$startDate\' and \'$endDate\'';
      /*for (var i = 0; i < ids.length; i++) {
        var element = ids[i];
        if (element != null) {
          query += ' and id != $element';
        }
      }*/
      query += ' GROUP BY date ORDER BY date DESC LIMIT 20 OFFSET ${ids.length}';
      print('query $query');
      // query += ' GROUP BY date ORDER BY date DESC';
      var db = await database;
      var list = [];
      try {
        list = await db.rawQuery(query);
      } catch (e) {
        print(e);
      }
      print(list);
      return list.map((e) => MeasurementHistoryModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception at getHRTableData $e');
      return [];
    }
  }

  Future<List<MeasurementHistoryModel>> getHeartRateForCalendar(
      String userId, DateTime startDate, DateTime endDate, int offset) async {
    var strFirst = DateFormat(DateUtil.yyyyMMdd).format(startDate);
    var strLast = DateFormat(DateUtil.yyyyMMdd).format(endDate);
    //var query =
    //    'select DISTINCT date from Measurement where user_Id = $userId and approxHr IS NOT NULL and approxHR != 0 and date IS NOT NULL and date between \'$strFirst\' and \'$strLast\'';
    var query =
        'select DISTINCT date from HrMonitoringTable where userId = $userId and approxHr IS NOT NULL and approxHR != 0 and date IS NOT NULL and date between \'$strFirst\' and \'$strLast\' LIMIT 100 OFFSET $offset';
    var modelList = <MeasurementHistoryModel>[];
    var db = await instance.database;
    List list = await db.rawQuery(query);
    modelList = list.map((e) => MeasurementHistoryModel.fromMap(e)).toList();
    return modelList;
  }

  Future<void> updateMeasurementTable(Database db) async {
    try {
      await addColumnIfNotExist(db, 'Measurement', 'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL');
      await addColumnIfNotExist(db, 'Measurement', 'approxSBP INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'approxDBP INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'approxHr INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'hrv INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'BG REAL');
      await addColumnIfNotExist(db, 'Measurement', 'Uncertainty INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'BG1 REAL');
      await addColumnIfNotExist(db, 'Measurement', 'Unit TEXT');
      await addColumnIfNotExist(db, 'Measurement', 'Unit1 TEXT');
      await addColumnIfNotExist(db, 'Measurement', 'Class TEXT');
      await addColumnIfNotExist(db, 'Measurement', 'ecgValue REAL');
      await addColumnIfNotExist(db, 'Measurement', 'ppgValue REAL');
      await addColumnIfNotExist(db, 'Measurement', 'user_Id TEXT');
      await addColumnIfNotExist(db, 'Measurement', 'date TEXT');
      await addColumnIfNotExist(db, 'Measurement', ' ecg TEXT');
      await addColumnIfNotExist(db, 'Measurement', 'ppg TEXT');
      await addColumnIfNotExist(db, 'Measurement', 'tHr INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'tSBP INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'tDBP INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'aiSBP INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'aiDBP INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'isForHourlyHR INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'isForTimeBasedPpg INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'IsCalibration INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'isForTraining INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'isFromCamera INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'isForOscillometric INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'IdForApi INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'IsSync INTEGER');
      await addColumnIfNotExist(db, 'Measurement', 'DeviceType TEXT');
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  //endregion

  Future<List> getWeightDataHistory(
      String userId, String startDate, String endDate, String fieldName, String tableName) async {
    var db = await instance.database;
    List list = await db.rawQuery(
        'select $fieldName,Date from $tableName where UserId = $userId and date between \'$startDate\' and \'$endDate\'');
    return list;
  }

  Future<List> getItemDataHistory(
    String userId,
    String startDate,
    String endDate,
    String fieldName,
    String tableName,
  ) async {
    var db = await instance.database;
    var list = [];
    if (tableName == 'Temperature') {
      list = await db.rawQuery(
          'select DISTINCT $fieldName, date from $tableName where UserId = $userId and date between \'$startDate\' and \'$endDate\'');
    } else if (tableName == 'HrMonitoringTable') {
      var sDate = DateTime.parse(startDate).millisecondsSinceEpoch;
      var eDate = DateTime.parse(endDate).millisecondsSinceEpoch;
      print('TableDataDate :: $startDate :: $endDate');
      print('TableDataDate :: $sDate :: $eDate');
      list = await db.rawQuery(
          'select DISTINCT $fieldName, date from $tableName where userId = $userId and date between \'$sDate\' and \'$eDate\'');
    } else if (tableName == DBTableHelper().m.table) {
      list = await db.rawQuery(
          'select DISTINCT $fieldName, date from $tableName where userID = $userId and date between \'$startDate\' and \'$endDate\'');
    } else {
      list = await db.rawQuery(
          'select DISTINCT $fieldName, date from $tableName where user_Id = $userId and date between \'$startDate\' and \'$endDate\'');
    }
    print(list.length);
    return list;
  }

  Future<int?> insertTag(Map<String, dynamic> row) async {
    var db = await instance.database;
    try {
      if (row['TagType'] is int &&
          (tagByValue(row['TagType']) != TagType.exercise &&
              tagByValue(row['TagType']) != TagType.health)) {
        var isExist = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT Id FROM Tag WHERE UserId = ${row['UserId']} AND TagType = ${row['TagType']}')) ??
            0;
        if (isExist != 0) {
          return await db.update('Tag', row, where: 'Id = ?', whereArgs: [isExist]);
        }
      }
      if (row.containsKey('Id') && row['Id'] != null) {
        int id = row['Id'];
        return await db.update('Tag', row, where: 'Id = ?', whereArgs: [id]);
      }
      return await db.insert('Tag', row);
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  ///TODO:: TagRecord
  Future<void> insertTagRecord(List<TagRecordDetail> tagRecordList) async {
    var db = await instance.database;
    if (tagRecordList.isNotEmpty) {
      for (var element in tagRecordList) {
        var map = element.toJson();
        await db.insert('TagRecord', map, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  ///TODO:: Tag Label
  Future<int> deleteTagLabel(int userID, int tagID) async {
    var db = await instance.database;
    return await db.delete('TagLabel', where: 'UserId = ? AND ID = ?', whereArgs: [userID, tagID]);
  }

  Future<TagLabel?> fetchTagLabelByID(int userID, int tagID) async {
    var db = await instance.database;
    var response =
        await db.query('TagLabel', where: 'UserId = ? AND ID = ?', whereArgs: [userID, tagID]);
    if (response.isNotEmpty) {
      Map<String, dynamic> tagMap = response.first;
      return TagLabel.fromJson(tagMap);
    }
    return null;
  }

  Future<List<TagLabel>> fetchTagLabel(String userID) async {
    var db = await instance.database;
    var response = await db.query('TagLabel', where: 'UserId = ?', whereArgs: [userID]);
    if (response.isNotEmpty) {
      return response.map(TagLabel.fromJson).toList();
    }
    return [];
  }

  Future insertTagLabel(List<TagLabel> tagList, String userID) async {
    var db = await instance.database;
    if (tagList.isNotEmpty) {
      for (var element in tagList) {
        var map = element.toJson();
        map['UserId'] = userID;
        await db.insert('TagLabel', map, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  Future updateTagLabel(List<TagLabel> tagList, String userID) async {
    var db = await instance.database;
    if (tagList.isNotEmpty) {
      for (var element in tagList) {
        var map = element.toJson();
        map['UserId'] = userID;
        await db.update(
          'TagLabel',
          map,
          where: 'UserId = ? AND ID = ?',
          whereArgs: [userID, element.iD],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

// HR Zone

  Future<int> deleteHRZone(int userID, int hrZoneID) async {
    var db = await instance.database;
    return await db.delete('HRZone', where: 'UserId = ? AND ID = ?', whereArgs: [userID, hrZoneID]);
  }

  Future<int> deleteHRZoneData(int userID) async {
    var db = await instance.database;
    return await db.delete('HRZone', where: 'UserId = ?', whereArgs: [userID]);
  }



//-----
  Future insertTagFromApi(List<Tag> listOfMap, String userId) async {
    try {
      var db = await instance.database;
      if (listOfMap.isNotEmpty) {
        listOfMap.forEach((tag) async {
          var map = tag.toMap();
          map['UserId'] = userId;
          var isExist = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT Id FROM Tag WHERE UserId = $userId AND IdForApi = ${map['IdForApi']}')) ??
              0;
          if (isExist != 0) {
            await db.update('Tag', map, where: 'Id = ?', whereArgs: [isExist]);
          } else {
            await db.insert('Tag', map);
          }
        });
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return Future.value();
  }

  Future getTagIds(String userId) async {
    var db = await instance.database;
    List list = await db
        .rawQuery('SELECT IdForApi FROM tag WHERE UserId = $userId AND IdForApi IS NOT NULL');
    var lst = list.map((map) => map['IdForApi']).toList();
    return lst;
  }

  Future getTagNoteIds(String userId) async {
    var db = await instance.database;
    List list = await db.rawQuery('SELECT IdForApi FROM TagNote WHERE UserId = $userId');
    var lst = list.map((map) => map['IdForApi']).toList();
    return lst;
  }

  Future getSportIds(String userId) async {
    var db = await instance.database;
    List list = await db.rawQuery('SELECT IdForApi FROM Sport WHERE user_Id = $userId');
    var lst = list.map((map) => map['IdForApi']).toList();
    return lst;
  }

  Future getSleepIds(String userId) async {
    var db = await instance.database;
    List list = await db.rawQuery('SELECT IdForApi FROM Sleep WHERE user_Id = $userId');
    var lst = list.map((map) => map['IdForApi']).toList();
    return lst;
  }

  Future<int> removeTag(int tagId, String userId) async {
    var db = await instance.database;
    var result = await db.rawUpdate('UPDATE Tag SET IsRemove = 1 WHERE Id = $tagId');
    return result;
  }

  Future<int> removeTagWithSync(int tagId, int isSync, String userId) async {
    var db = await instance.database;
    var result =
        await db.rawUpdate('UPDATE Tag SET IsRemove = 1, isSync = $isSync WHERE Id = "$tagId"');
    return result;
  }

  Future<List<Tag>> getTagList(String userId) async {
    var tagList = <Tag>[];
    try {
      var db = await instance.database;
      var version = await db.getVersion();
      if (version < Constants.dbVersion) {
        try {
          await db.rawQuery('ALTER TABLE User ADD IsDefault INTEGER');
        } catch (e) {
          debugPrint('Exception in db helper class $e');
        }
      }
      List list = await db.rawQuery('SELECT * FROM Tag WHERE IsRemove = 0 AND UserId = $userId');
      if (list != null) {
        for (var i = 0; i < list.length; i++) {
          Tag tag = await new Tag().fromMap(list[i]);
          if (tag != null) {
            tagList.add(tag);
          }
        }
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return tagList;
  }

  Future<List<Tag>> getAutoLoadTagList(String userId) async {
    var tagList = <Tag>[];
    try {
      var db = await instance.database;
      var version = await db.getVersion();
      if (version < Constants.dbVersion) {
        try {
          await db.rawQuery('ALTER TABLE User ADD IsDefault INTEGER');
        } catch (e) {
          debugPrint('Exception in db helper class $e');
        }
      }
      List list = await db
          .rawQuery('SELECT * FROM Tag WHERE IsRemove = 0 AND UserId = $userId AND IsAutoLoad = 1');

      for (var i = 0; i < list.length; i++) {
        Tag tag = await new Tag().fromMap(list[i]);
        if (tag != null) {
          tagList.add(tag);
        }
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return tagList;
  }

  Future<List<Tag>> getDefaultTagList(String userId) async {
    var tagList = <Tag>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery('SELECT * FROM Tag WHERE IsDefault = 1 AND UserId = $userId');

      for (var i = 0; i < list.length; i++) {
        Tag tag = await Tag().fromMap(list[i]);
        tagList.add(tag);
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return tagList;
  }

  Future<List<Tag>> getUnSyncTagList(String userId) async {
    var tagList = <Tag>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery(
          'SELECT * FROM Tag WHERE IsRemove = 0 AND idForApi is NULL AND UserId = $userId AND IsDefault != 1');
      for (var i = 0; i < list.length; i++) {
        Tag tag = await new Tag().fromMap(list[i]);
        if (tag != null) {
          tagList.add(tag);
        }
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return tagList;
  }

  Future<List<Tag>> getUnSyncRemoveTagList(String userId) async {
    var tagList = <Tag>[];
    try {
      var db = await instance.database;
      List list = await db
          .rawQuery('SELECT * FROM Tag WHERE IsRemove = 1 AND isSync = 0 AND UserId = $userId');
      for (var i = 0; i < list.length; i++) {
        Tag tag = await new Tag().fromMap(list[i]);
        if (tag != null) {
          tagList.add(tag);
        }
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return tagList;
  }

  Future<List<Tag>> getAllTagList(String userId) async {
    var tagList = <Tag>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery('SELECT * FROM Tag WHERE UserId = $userId');
      for (var i = 0; i < list.length; i++) {
        Tag tag = await new Tag().fromMap(list[i]);
        tagList.add(tag);
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return tagList;
  }

  Future<Tag?> getTagById(int tagId, {String? apiId, String? label}) async {
    Tag? tag;
    try {
      var db = await instance.database;
      var list = [];
      var l = await db.rawQuery('SELECT * FROM Tag');
      if (label != null) {
        list = await db.rawQuery('SELECT * FROM Tag WHERE Label = "$label"');
      } else if (apiId != null && apiId.isNotEmpty && apiId.toLowerCase() != 'null') {
        list = await db.rawQuery('SELECT * FROM Tag WHERE idForApi = $apiId');
      } else {
        list = await db.rawQuery('SELECT * FROM Tag WHERE Id = $tagId');
      }
      var tagList = <Tag>[];
      for (var i = 0; i < list.length; i++) {
        Tag tag = await Tag().fromMap(list[i]);
        tagList.add(tag);
      }
      if (tagList.isNotEmpty) {
        tag = tagList.first;
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return tag;
  }

  Future updateTag(int tagId, int userId, String keyword) async {
    try {
      debugPrint(keyword);
      var db = await instance.database;
      var result = await db
          .rawQuery('Update Tag set keyword = $keyword where Id = $tagId AND UserId = $userId');
      return result;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future deleteTagNoteDetail(int tagId) async {
    try {
      var db = await instance.database;
      var result = await db.rawQuery('Update TagNote set IsRemove = 1 where Id = $tagId');
      return result;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<List<TagNote>> getUnSyncDeletedNotes(String userId) async {
    try {
      var notes = <TagNote>[];
      var db = await instance.database;
      var result =
          await db.rawQuery('Select * from TagNote where IsRemove = 1 And UserId = $userId');
      notes = result.map((e) => TagNote.fromMap(e)).toList();
      return notes;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return [];
  }

  Future<int> insertTagNote(Map<String, dynamic> row, {bool? updateLabel}) async {
    var db = await instance.database;
    if (updateLabel != null && updateLabel) {
      String tagId = row['IdForApi'];
      return await db.update('TagNote', row, where: 'IdForApi = $tagId');
    } else if (row.containsKey('Id') && row['Id'] != null) {
      int id = row['Id'];
      return await db.update('TagNote', row, where: 'Id = ?', whereArgs: [id]);
    }

    return await db.insert('TagNote', row);
  }

  Future insertTagNoteFromApi(List<TagNote> listOfMap, String userId) async {
    try {
      var db = await instance.database;
      if (listOfMap != null && listOfMap.isNotEmpty) {
        var tempImages;
        String tempImage;

        for (var k = 0; k < listOfMap.length; k++) {
          print(listOfMap[k].toString());
//          String base64Images = "";
//          if(listOfMap[k].imageFiles.startsWith("[https:")){
//
//            if(listOfMap[k].imageFiles!=null&& listOfMap[k].imageFiles.length>0){
//              listOfMap[k].imageFiles=listOfMap[k].imageFiles.substring(1,listOfMap[k].imageFiles.length-1);
//             tempImages  = listOfMap[k].imageFiles.split(" ");
//
//              // tagNote.imageFiles="";
//             for(int i = 0; i < tempImages.length; i++){
//               tempImage = tempImages[i];
//               var bytes;
//               try {
//                 http.Response result = await http.get(tempImage);
//                  bytes = base64Encode(result.bodyBytes);
//
//               } catch(e){
//                 debugPrint("error in converting url image to base64 in database $e");
//               }
//               if (bytes != null)
//                 base64Images = "$base64Images$bytes,";
//             }
//            }
//          }

          var map = listOfMap[k].toMap();

//          if(listOfMap[k].imageFiles != "[]"){
//            map['AttachFiles'] = base64Images;
//          }

          // debugPrint(map['imageFiles']);
          map['UserId'] = userId;
          var isExist = Sqflite.firstIntValue(await db.rawQuery(
                  'SELECT Id FROM TagNote WHERE UserId = $userId AND IdForApi = ${map['IdForApi']}')) ??
              0;
          if (isExist != 0) {
            await db.update('TagNote', map, where: 'Id = ?', whereArgs: [isExist]);
          } else {
            await db.insert('TagNote', map);
          }
        }
      }
    } catch (e) {
      debugPrint('Exception in inserting tag note from API class $e');
    }
    return Future.value();
  }

  Future<List<TagNote>> getTagNoteForCalendar(
      String userId, DateTime startDate, DateTime endDate, int offset) async {
    var strFirst = DateFormat(DateUtil.yyyyMMdd).format(startDate);
    var strLast = DateFormat(DateUtil.yyyyMMdd).format(endDate);
    var tagNoteList = <TagNote>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery(
          'SELECT * FROM TagNote WHERE IsRemove = 0 AND UserId = $userId And Date Between \'$strFirst\' And \'$strLast\' GROUP BY date ORDER BY Date DESC LIMIT 100 OFFSET $offset');
      tagNoteList = list.map((e) => TagNote.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class getTagNoteList $e');
    }
    return tagNoteList;
  }

  Future<List<TagNote>> getTagNoteList(String startDate, String endDate, String userId) async {
    var tagNoteList = <TagNote>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery(
          'SELECT * FROM TagNote WHERE IsRemove = 0 AND UserId = $userId And Date Between \'$startDate\' And \'$endDate\' ORDER BY Date DESC');
      print(list.toString());
      tagNoteList = list.map((e) => TagNote.fromMap(e)).toList();
    } catch (e) {
      debugPrint('$e');
      debugPrint('Exception in db helper class getTagNoteList $e');
    }
    return tagNoteList;
  }

  Future<List<TagNote>> getTagNoteListForUpdate(
    String id,
    String userId,
  ) async {
    var tagNoteList = <TagNote>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery(
          'SELECT * FROM TagNote WHERE IsRemove = 0 AND UserId = $userId And TagIdForApi = $id GROUP BY date ORDER BY Date DESC');
      tagNoteList = list.map((e) => TagNote.fromMap(e)).toList();
    } catch (e) {
      debugPrint('$e');
      debugPrint('Exception in db helper class getTagNoteList $e');
    }
    return tagNoteList;
  }

  Future<List> getTagNoteListForParticularTag(
      String startDate, String endDate, String userId, String fieldName) async {
    var db = await instance.database;
    List list = await db.rawQuery(
        'SELECT Value,Date FROM TagNote WHERE IsRemove = 0 AND UserId = $userId And Label = \'$fieldName\' AND Date Between \'$startDate\' And \'$endDate\' ORDER BY Id DESC');
    return list;
  }

  Future<List<TagNote>> getUnSyncTagNoteList(String userId) async {
    var tagNoteList = <TagNote>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery(
          'SELECT * FROM TagNote WHERE IsRemove = 0 AND idForApi is NULL AND UserId = $userId');
      tagNoteList = list.map((e) => TagNote.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return tagNoteList;
  }

  Future deleteTagNote(int id) async {
    try {
      var db = await instance.database;
      return await db.delete('TagNote', where: 'Id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<List<InboxData>> getEmailList(int messageType, int userId) async {
    var messageList = <InboxData>[];
    try {
      var db = await instance.database;
      List list = await db
          .rawQuery('SELECT * FROM Email WHERE MessageType = $messageType AND UserId = $userId');
      messageList = list.map((e) => InboxData.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return messageList;
  }

  Future<List<InboxData>> getLocalEmailList(int messageType, int userId) async {
    var messageList = <InboxData>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery(
          'SELECT * FROM Email WHERE MessageType = $messageType AND UserId = $userId AND IsSync = 0');
      messageList = list.map((e) => InboxData.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return messageList;
  }

  Future insertEmailData(Map<String, dynamic> map) async {
    var db = await instance.database;
    var result = await db.insert('Email', map);
    return result;
  }

  Future updateEmailData(Map<String, dynamic> map, String parentGUIID) async {
    var db = await instance.database;
    var result = await db.update('Email', map, where: 'ParentGUIID = ?', whereArgs: [parentGUIID]);
    return result;
  }

  Future updateSyncForEmail(int id) async {
    var db = await instance.database;
    var result = await db.rawQuery('update Email set IsSync = 1 where MessageId = $id');
    return result;
  }

  Future updateMessageTypeForEmail(Map<String, dynamic> row, int messageId) async {
    var db = await instance.database;
    return await db.update('Email', row, where: 'MessageID = ?', whereArgs: [messageId]);
  }

  Future updateDrafts(Map<String, dynamic> row, int id) async {
    var db = await instance.database;
    var result = await db.update('Email', row, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<int> deleteEmailRow(int id) async {
    var db = await instance.database;
    return await db.delete('Email', where: 'Id = ?', whereArgs: [id]);
  }

  Future<int> deleteEmailRowFromMessageId(int messageId) async {
    var db = await instance.database;
    return await db.delete('Email', where: 'MessageID = ?', whereArgs: [messageId]);
  }

  Future insertUpdateReminder(Map<String, dynamic> map) async {
    var db = await instance.database;
    var a = await db.execute(
        'CREATE TABLE IF NOT EXISTS Reminder (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,UserId TEXT, startTime TEXT, endTime TEXT, interval TEXT,days TEXT, label TEXT,  description TEXT, imageBase64 TEXT, isNotification INTEGER, isDefault INTEGER,isEnable INTEGER,isRemove INTEGER,isSync INTEGER)');
    if (map.containsKey('id') && map['id'] != null) {
      int id = map['id'];
      return await db.update('Reminder', map, where: 'id = ?', whereArgs: [id]);
    }
    var result = await db.insert('Reminder', map);
    return result;
  }

  Future getAllReminder(String userId) async {
    var db = await instance.database;
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Reminder (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,UserId TEXT, startTime TEXT, endTime TEXT, interval TEXT,days TEXT, label TEXT,  description TEXT, imageBase64 TEXT, isNotification INTEGER, isDefault INTEGER,isEnable INTEGER,isRemove INTEGER,isSync INTEGER)');
    var reminderList = <ReminderModel>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery('SELECT * FROM Reminder WHERE UserId = $userId');
      reminderList = list.map((e) => ReminderModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return reminderList;
  }

  Future getReminderList(String userId) async {
    var db = await instance.database;
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Reminder (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,UserId INTEGER, startTime TEXT, endTime TEXT, interval TEXT,days TEXT, label TEXT,  description TEXT, imageBase64 TEXT, isNotification INTEGER, isDefault INTEGER,isEnable INTEGER,isRemove INTEGER,isSync INTEGER)');
    var reminderList = <ReminderModel>[];
    try {
      var db = await instance.database;
      List list =
          await db.rawQuery('SELECT * FROM Reminder WHERE UserId = $userId AND isRemove != 1');
      reminderList = list.map((e) => ReminderModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return reminderList;
  }

  Future<List<ReminderModel>> getPpgRemainder(String userId) async {
    var db = await instance.database;
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Reminder (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,UserId INTEGER, startTime TEXT, endTime TEXT, interval TEXT,days TEXT, label TEXT,  description TEXT, imageBase64 TEXT, isNotification INTEGER, isDefault INTEGER,isEnable INTEGER,isRemove INTEGER,isSync INTEGER)');
    var reminderList = <ReminderModel>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery(
          'SELECT * FROM Reminder WHERE UserId = $userId AND isRemove != 1 AND label = \'PPG\'');
      reminderList = list.map((e) => ReminderModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return reminderList;
  }

  Future insertContactsData(Map<String, dynamic> map) async {
    try {
      var db = await instance.database;
      var result = await db.insert('Contacts', map);
      print("insertContactsData");
      print(result);
      return result;
    } catch (e) {
      debugPrint('Exception at insertContactsData $e');
    }
  }

  Future<List<UserData>> getContactsList(int userId) async {
    var contactList = <UserData>[];
    try {
      var db = await instance.database;

      List list = await db
          .rawQuery('SELECT * FROM Contacts WHERE  FKSenderUserID = $userId  AND IsDeleted != 1 ');
      contactList = list.map((e) => UserData.fromMap(e)).toList();

      print(contactList.toList().toString());
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return contactList;
  }

  Future getContactsIds(String userId) async {
    var db = await instance.database;
    List list = await db
        .rawQuery('SELECT * FROM Contacts WHERE FKSenderUserID = $userId AND IsDeleted != 1 ');
    var lst = list.map((map) => map['ContactID']).toList();
    return lst;
  }

  Future<int> updateContactData(int id, Map<String, dynamic> map) async {
    var db = await instance.database;
    var resu = await db.update('Contacts', map, where: 'id=?', whereArgs: [id]);
    print("updateContactData");
    print(resu);
    return resu;
  }

  Future<int> deleteContact(int id) async {
    var db = await instance.database;
    return await db.delete('Contacts', where: 'Id = ?', whereArgs: [id]);
  }

  Future updateContact(int id, int isDeleted) async {
    var db = await instance.database;
    var result = await db.rawQuery('update Contacts set IsDeleted = $isDeleted where Id = $id');
    return result;
  }

  Future<List<UserData>> getLocalDeletedContacts(int userId) async {
    var contactList = <UserData>[];
    try {
      var db = await instance.database;
      List list = await db
          .rawQuery('SELECT * FROM Contacts WHERE FKSenderUserID = $userId AND IsDeleted = 1');
      contactList = list.map((e) => UserData.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return contactList;
  }

  Future<List<InvitationList>> getInvitationList(int userId) async {
    var invitationList = <InvitationList>[];
    try {
      var db = await instance.database;
      List list =
          await db.rawQuery('SELECT * FROM Invitation WHERE UserId = $userId AND IsAccepted = -1');
      invitationList = list.map((e) => InvitationList.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return invitationList;
  }

  Future insertInvitationData(Map<String, dynamic> map) async {
    var db = await instance.database;
    var result = await db.insert('Invitation', map);
    return result;
  }

  Future updateInvitation(int contactId, int isAccepted) async {
    var db = await instance.database;
    var result = await db
        .rawQuery('update Invitation set IsAccepted = $isAccepted where ContactID = $contactId');
    return result;
  }

  Future<int> deleteInvitation(int contactId) async {
    var db = await instance.database;
    return await db.delete('Invitation', where: 'ContactID = ?', whereArgs: [contactId]);
  }

  Future<List<InvitationList>> getOfflineAcceptedOrRejectedInvitationList(int userId) async {
    var invitationList = <InvitationList>[];
    try {
      var db = await instance.database;
      List list =
          await db.rawQuery('SELECT * FROM Invitation WHERE UserId = $userId AND IsAccepted != -1');
      invitationList = list.map((e) => InvitationList.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return invitationList;
  }

  Future getAlarmList(String userId) async {
    var db = await instance.database;
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Alarm (id INTEGER ,UserId TEXT, alarmTime TEXT, days TEXT, label TEXT, isRepeatEnable INTEGER , isAlarmEnable INTEGER)');
    var alarmList = <AlarmModel>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery('SELECT * FROM Alarm WHERE UserId = $userId');
      alarmList = list.map((e) => AlarmModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return alarmList;
  }

  Future updateAlarm(Map<String, dynamic> map) async {
    if (map.containsKey('previousAlarmTime')) {
      map.remove('previousAlarmTime');
    }
    var db = await instance.database;
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Alarm (id INTEGER ,UserId TEXT, alarmTime TEXT, days TEXT, label TEXT, isRepeatEnable INTEGER , isAlarmEnable INTEGER)');
    int id = map['id'];
    return await db.update('Alarm', map, where: 'id = ?', whereArgs: [id]);
  }

  Future insertAlarm(Map<String, dynamic> map) async {
    if (map.containsKey('previousAlarmTime')) {
      map.remove('previousAlarmTime');
    }
    var db = await instance.database;
    await db.execute(
        'CREATE TABLE IF NOT EXISTS Alarm (id INTEGER ,UserId TEXT, alarmTime TEXT, days TEXT, label TEXT, isRepeatEnable INTEGER , isAlarmEnable INTEGER)');
    var result = await db.insert('Alarm', map);
    return result;
  }

  /// Added by: chandresh
  /// Added at: 22-07-2020
  /// validate form by key
  //region insert/update graph item type (like step, hr, deep sleep)
  Future insertUpdateGraphTypeTable(Map<String, dynamic> map) async {
    try {
      var db = await instance.database;
      if (map.containsKey('${DatabaseTableNameAndFields.GraphTypeId}') &&
          map['${DatabaseTableNameAndFields.GraphTypeId}'] != null) {
        int id = map['${DatabaseTableNameAndFields.GraphTypeId}'];
        return await db.update('${DatabaseTableNameAndFields.GraphTypeTable}', map,
            where: '${DatabaseTableNameAndFields.GraphTypeId} = ?', whereArgs: [id]);
      } else if (map.containsKey('${DatabaseTableNameAndFields.GraphTypeId}')) {
        map.remove('${DatabaseTableNameAndFields.GraphTypeId}');
      }
      var result = await db.insert('${DatabaseTableNameAndFields.GraphTypeTable}', map);
      debugPrint('Graph Item $result');
      return result;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return Future.value();
  }

  Future removeGraphType(String fieldName, String tableName, String userId) async {
    try {
      var db = await instance.database;
      var result = await db.delete('${DatabaseTableNameAndFields.GraphTypeTable}',
          where: 'FieldName = ? AND TableName = ? AND UserId = ?',
          whereArgs: [fieldName, tableName, userId]);
      return result;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return Future.value();
  }

  /// Added by: chandresh
  /// Added at: 22-07-2020
  /// validate form by key
  // get graph item type list (like step, hr, deep sleep)
  Future getGraphTypeList(String userId) async {
    try {
      var db = await instance.database;
      List result = await db.rawQuery(
          'SELECT * FROM ${DatabaseTableNameAndFields.GraphTypeTable} WHERE ${DatabaseTableNameAndFields.UserId}');
      var graphTypeList = result.map((e) => GraphTypeModel.fromMap(e)).toList();
      return graphTypeList;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return [];
  }

  Future updateMessageTypeForAllEmail(int msgType) async {
    var db = await instance.database;
    return await db.rawQuery('update Email set MessageType = 0 where MessageType = $msgType');
  }

  Future deleteMailByMessageType(int msgType) async {
    var db = await instance.database;
    return await db.delete('Email', where: 'MessageType = ?', whereArgs: [msgType]);
  }

  Future updateMarkAsRead(int isViewedSync) async {
    var db = await instance.database;
    return await db
        .rawQuery('update Email set IsViewedSync = 1 where IsViewedSync = $isViewedSync');
  }

  Future insertUpdateWeightData(Map<String, dynamic> map) async {
    var result;
    try {
      var db = await instance.database;

      if (map.containsKey('id') && map['id'] != null) {
        result = await db.update('WeightScaleData', map, where: 'id = ?', whereArgs: [map['id']]);
        result = map['id'];
        print("Wight update");
      } else {
        print("Wight insert");
        result = await db.insert('WeightScaleData', map);
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return result;
  }

  Future<List<WeightMeasurementModel>>? getWeightData(
      String? userId, String? startDate, String? endDate) async {
    try {
      var modelList = <WeightMeasurementModel>[];
      var db = await instance.database;
      List? list;
      try {
        list = await db.rawQuery(
            'select * from WeightScaleData where UserID = $userId and Date between \'$startDate\' and \'$endDate\' GROUP BY Date ORDER BY Date DESC');
      } catch (e) {
        print(e);
      }
      if (list != null) {
        modelList = list.map((e) => WeightMeasurementModel.fromMapForLocalDataBase(e)).toList();
      }

      return modelList;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
      return [];
    }
  }

  Future<List<WeightMeasurementModel>> getWeightDataForCalendar(
      String userId, DateTime startDate, DateTime endDate, int offset) async {
    var strFirst = DateFormat(DateUtil.yyyyMMdd).format(startDate);
    var strLast = DateFormat(DateUtil.yyyyMMdd).format(endDate);
    try {
      var modelList = <WeightMeasurementModel>[];
      var db = await instance.database;
      List list = await db.rawQuery(
          'select * from WeightScaleData where UserID = $userId and Date between \'$strFirst\' and \'$strLast\' GROUP BY Date ORDER BY Date DESC LIMIT 100 OFFSET $offset');
      modelList = list.map((e) => WeightMeasurementModel.fromMapForLocalDataBase(e)).toList();
      return modelList;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
      return [];
    }
  }

  Future<List<WeightMeasurementModel>> getWeightDataOfDay(String userId) async {
    var modelList = <WeightMeasurementModel>[];
    var db = await instance.database;
    List list = await db.rawQuery(
        'select * from WeightScaleData where UserID = $userId GROUP BY Date ORDER BY Date DESC');
    modelList = list.map((e) => WeightMeasurementModel.fromMapForLocalDataBase(e)).toList();
    return modelList;
  }

  Future<List<WeightMeasurementModel>> getUnSyncWeightMeasurementData(String userId) async {
    var weightList = <WeightMeasurementModel>[];
    var db = await instance.database;
    List list = await db
        .rawQuery('SELECT * FROM WeightScaleData WHERE UserID = $userId AND IdForApi is NULL');
    weightList = list.map((e) => WeightMeasurementModel.fromMapForLocalDataBase(e)).toList();
    return weightList;
  }

  Future getWeightMeasurementIds(String userId) async {
    var db = await instance.database;
    List list = await db.rawQuery('SELECT IdForApi FROM WeightScaleData WHERE UserID = $userId');
    var lst = list.map((map) => map['IdForApi']).toList();
    return lst;
  }

  Future insertHealthKitOrGoogleFitData(Map<String, dynamic> map) async {
    var result;
    try {
      var db = await instance.database;

      if (map.containsKey('id') && map['id'] != null) {
        result = await db
            .update('HealthKitOrGoogleFitTable', map, where: 'id = ?', whereArgs: [map['id']]);
        result = map['id'];
      } else {
        result = await db.insert('HealthKitOrGoogleFitTable', map);
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return result;
  }

  Future<List<HealthKitOrGoogleFitModel>> getHealthKitOrGoogleFitData(
      String userId, String fieldName, String startDate, String endDate,
      {List? ids, int? limit}) async {
    var modelList = <HealthKitOrGoogleFitModel>[];
    List list;
    try {
      var db = await instance.database;
      List<Map> listDemo = await db.rawQuery('SELECT * FROM HealthKitOrGoogleFitTable');
      print('DataBase:- $listDemo');
      if (startDate == '') {
        var query =
            "select * from HealthKitOrGoogleFitTable where user_id = $userId And typeName = '$fieldName'";
        if (ids != null && limit != null) {
          /*
          ids.forEach((element) {
            if (element != null) {
              query += ' and id != $element';
            }
          });
          */

          query += 'ORDER BY startTime DESC LIMIT $limit OFFSET ${ids.length}';
        }
        list = await db.rawQuery(query);
      } else {
        list = await db.rawQuery(
            'SELECT * FROM HealthKitOrGoogleFitTable WHERE  user_id = $userId And startTime between \'$startDate\' And \'$endDate\'  ORDER BY id DESC');
      }
      modelList = list.map((e) => HealthKitOrGoogleFitModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return modelList;
  }

  Future<List?> getHealthKitOrGoogleFitDataForGraph(
      String startDate, String endDate, String userId, String fieldName) async {
    try {
      var db = await instance.database;
      List list = await db.rawQuery(
          "SELECT value,startTime FROM HealthKitOrGoogleFitTable WHERE  user_id = $userId And typeName = '$fieldName' And startTime between \'$startDate\' And \'$endDate\'  ORDER BY id DESC");
      return list;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<List<WeightMeasurementModel>> getLastSavedWeightData(String userId) async {
    try {
      var modelList = <WeightMeasurementModel>[];
      var db = await instance.database;
      List list = await db.rawQuery(
          'select * from WeightScaleData where UserID = $userId GROUP BY date ORDER BY date DESC LIMIT 1');
      modelList = list.map((e) => WeightMeasurementModel.fromMapForLocalDataBase(e)).toList();
      return modelList;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
      return [];
    }
  }

  Future<List<TempModel>> getLastSavedTempOxygenData(String userId) async {
    try {
      var modelList = <TempModel>[];
      var db = await instance.database;
      List list = await db.rawQuery(
          'select* from Temperature where UserId = $userId And Temperature IS NOT NULL And Oxygen IS NOT NULL ORDER BY date DESC LIMIT 1');
      modelList = list.map((e) => TempModel.fromMapForDb(e)).toList();
      return modelList;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
      return [];
    }
  }

  Future<List<WeightMeasurementModel>> getLastWeightData(String userId, String date) async {
    try {
      var modelList = <WeightMeasurementModel>[];
      var db = await instance.database;
      try {
        List list = await db.rawQuery(
            'select * from WeightScaleData where UserID = $userId And Date < \'$date\'  GROUP BY date ORDER BY date DESC LIMIT 1');
        if (list.isEmpty) {
          modelList = [];
        } else {
          modelList = list.map((e) => WeightMeasurementModel.fromMapForLocalDataBase(e)).toList();
        }
      } catch (e) {
        debugPrint('Exception at getLastWeightData $e');
      }

      return modelList;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
      return [];
    }
  }

  /// Calendar - Added on 20th Jan 2021
  ///Added by Shahzad
  Future getCalendarList(int userId) async {
    var eventList = <CalendarData>[];
    try {
      var db = await instance.database;
      List list =
          await db.rawQuery('SELECT * FROM Calendar WHERE UserId = $userId AND IsDeleted = 0');
      eventList = list.map((e) => CalendarData.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return eventList;
  }

  Future getCalendarDeletedList(int userId) async {
    var eventList = <CalendarData>[];
    try {
      var db = await instance.database;
      List list =
          await db.rawQuery('SELECT * FROM Calendar WHERE UserId = $userId AND IsDeleted = 1');
      eventList = list.map((e) => CalendarData.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return eventList;
  }

  Future getCalendarSyncList(int userId) async {
    var eventList = <CalendarData>[];
    try {
      var db = await instance.database;
      List list = await db.rawQuery('SELECT * FROM Calendar WHERE UserId = $userId AND IsSync = 0');
      eventList = list.map((e) => CalendarData.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return eventList;
  }

  Future insertCalendarData(Map<String, dynamic> map) async {
    var db = await instance.database;
    var result;
    try {
      result = await db.insert('Calendar', map);
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return result;
  }

  //update the Calendar isSync for online
  Future updateCalendarSyncByEventID(int userId, eventID) async {
    var db = await instance.database;
    return await db.rawQuery(
        'update Calendar set IsSync = 1 where UserId = $userId AND IsSync = 0 AND EventID = $eventID');
  }

  Future updateCalendarSync(int userId) async {
    var db = await instance.database;
    return await db.rawQuery(
        'update Calendar set IsSync = 1 where UserId = $userId AND IsSync = 0 AND IsDeleted = 0');
  }

  Future updateCalendarIsSync(int userId, int eventId) async {
    var db = await instance.database;
    return await db.rawQuery(
        'update Calendar set IsDeleted = 1, IsSync = 0 where UserId = $userId And SetRemindersID = $eventId');
  }

  Future<int> deleteCalendarEvent(int userId, int eventID) async {
    var db = await instance.database;
    return await db.delete('Calendar',
        where: 'UserId = ? AND SetRemindersID = ?', whereArgs: [userId, eventID]);
  }

  Future<List<CalendarData>> getCalendarListByUserIdEventId(int userId, int eventId) async {
    var db = await instance.database;
    var eventList = <CalendarData>[];
    try {
      List list = await db.rawQuery(
          'SELECT * FROM Calendar WHERE UserId = $userId AND IsSync = 1 And SetRemindersID = $eventId');
      eventList = list.map((e) => CalendarData.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }

    return eventList;
  }

  Future<int> deleteCalendarById(int id) async {
    var db = await instance.database;
    return await db.delete('Calendar', where: 'id = ? ', whereArgs: [id]);
  }

  Future updateSetRemindersID(int id, int userId, int eventId) async {
    var db = await instance.database;
    return await db.rawQuery(
        'update Calendar set SetRemindersID = $eventId, IsSync = 1 where UserId = $userId AND id = $id');
  }

  Future<List<ChatUserData>> getChatList(int? userId) async {
    var userData = <ChatUserData>[];
    try {
      var db = await instance.database;
      var result = await db.rawQuery('Select * from ChatList where ToUserId = $userId');
      userData = result.map((e) => ChatUserData.fromMap(e)).toList();
      return userData;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return userData;
  }

  Future insertChatList(Map<String, dynamic> map) async {
    try {
      var db = await instance.database;
      var result = await db.insert('ChatList', map);
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future<int?> insertChatDetail(Map<String, dynamic> map) async {
    try {
      var db = await instance.database;
      var result = await db.insert('ChatDetail', map);
      return result;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
  }

  Future updateChatDetail(Map<String, dynamic> map) async {
    try {
      var db = await instance.database;
      var result = await db.update('ChatDetail', map, where: 'id=?', whereArgs: [map['id']]);
    } catch (e) {
      debugPrint('Exception in updateChatDetail $e');
    }
  }

  Future<List<ChatMessageData>> getChatDetail(int? fromUserId, int? toUserId) async {
    var userData = <ChatMessageData>[];
    try {
      var db = await instance.database;

      var selectedTime = preferences?.getInt('backupTime');
      var result = await db.rawQuery(
          'Select * from ChatDetail where ToUserId = $toUserId AND FromUserId = $fromUserId');
      userData = result.map((e) => ChatMessageData.fromMap(e)).toList();
      var day = DateTime.now();
      var tDay = DateTime(day.year, day.month, day.day + 1);
      if (selectedTime == 0) {
        var deadline = DateTime(tDay.year, tDay.month, tDay.day - 8);
        userData.removeWhere((element) => DateTime.parse(element.dateSent).isBefore(deadline));
      } else if (selectedTime == 1) {
        var deadline = DateTime(tDay.year, tDay.month, tDay.day - 8);
        userData.removeWhere((element) => DateTime.parse(element.dateSent).isBefore(deadline));
      } else {
        var deadline = DateTime(tDay.year, tDay.month - 1, tDay.day);
        userData.removeWhere((element) => DateTime.parse(element.dateSent).isBefore(deadline));
      }
      return userData;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return userData;
  }

  // todo get unsent messages

  Future getUnsentMessageIds(String groupName) async {
    var db = await instance.database;
    List list = await db.rawQuery('SELECT * FROM GroupChatDetailGroupChatDetail WHERE IsSent = 0');
    // List lst = list.map((map) => map["IdForApi"]).toList();
    return list;
  }

  // Future<List<Data>> getGroupList(String userName) async {
  //   try {
  //     var db = await instance.database;
  //     List<Map<String,dynamic>> groupName = await db.rawQuery(
  //         'SELECT GroupName FROM GroupChatDetail WHERE FromUserName = "$userName"');
  //     List groupNames = groupName.map((map) => map["GroupName"]).toList();
  //     return groupNames;
  //   } catch (e) {
  //     debugPrint('exception in getGroupList:$e');
  //     return null;
  //   }
  // }

  Future updateGroupList(String userName) async {
    try {
      var db = await instance.database;
      var result =
          db.rawQuery('update GroupChatDetail set IsSent = 1 where FromUserName = "$userName"');
      return result;
    } catch (e) {
      debugPrint('exception in updateGroupList:$e');
      return null;
    }
  }

  Future<int> insertGroupChatDetail(Map<String, dynamic> map) async {
    try {
      var db = await instance.database;
      var result = await db.insert('GroupChatDetail', map);
      return result;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
      return -1;
    }
  }

  Future updateGroupChatDetail(Map<String, dynamic> map) async {
    try {
      var db = await instance.database;
      var result = await db.update('GroupChatDetail', map, where: 'id=?', whereArgs: [map['id']]);
      return result;
    } catch (e) {
      debugPrint('Exception in updateGroupChatDetail $e');
    }
  }

  Future<List<GroupChatMessageData>> getGroupChatDetail(String groupName) async {
    var userData = <GroupChatMessageData>[];
    try {
      var db = await instance.database;

      var selectedTime = preferences?.getInt('backupTime');
      var result = await db.rawQuery(
          'Select * from GroupChatDetail where GroupName = "$groupName" order by DateSent');
      var dbSize = await db.rawQuery('SELECT COUNT(*) FROM GroupChatDetail');
      debugPrint('Database Size : $dbSize');
      userData = result.map((e) => GroupChatMessageData.fromMap(e)).toList();
      var day = DateTime.now();
      var tDay = DateTime(day.year, day.month, day.day + 1);
      if (selectedTime == 0) {
        var deadline = DateTime(tDay.year, tDay.month, tDay.day - 8);
        userData.removeWhere(
            (element) => DateTime.tryParse(element.dateSent ?? '')?.isBefore(deadline) ?? false);
      } else if (selectedTime == 1) {
        //todo check value of archive days
        var deadline = DateTime(tDay.year, tDay.month, tDay.day - 15);
        userData.removeWhere(
            (element) => DateTime.tryParse(element.dateSent ?? '')?.isBefore(deadline) ?? false);
      } else {
        var deadline = DateTime(tDay.year, tDay.month - 1, tDay.day);
        userData.removeWhere(
            (element) => DateTime.tryParse(element.dateSent ?? '')?.isBefore(deadline) ?? false);
      }
      return userData;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return userData;
  }

  Future<List<ChatMessageData>> chatDetailLength(int toUserId) async {
    var userData = <ChatMessageData>[];
    try {
      var db = await instance.database;
      var result = await db.rawQuery('Select * from ChatDetail where ToUserId = $toUserId');
      userData = result.map((e) => ChatMessageData.fromMap(e)).toList();
      return userData;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return userData;
  }

  //region Temperature
  Future insertTemperatureData(List map) async {
    print('DebuggingData ToInsert :: ${map.length}');
    var result;
    try {
      var distinctList = [];
      for (var element in map) {
        var isExist = distinctList
            .any((e) => e['UserId'] == element['UserId'] && e['date'] == element['date']);
        if (!isExist) {
          distinctList.add(element);
        }
      }
      print('DebuggingData  distinct :: ${distinctList.length}');
      var db = await instance.database;
      for (var i = 0; i < distinctList.length; i++) {
        var element = distinctList[i];
        var result = await db.insert('Temperature', element);
      }
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return result;
  }

  Future updateTemperatureData(List map) async {
    var result;
    try {
      var distinctList = [];
      for (var element in map) {
        var isExist = distinctList
            .any((e) => e['UserId'] == element['UserId'] && e['date'] == element['date']);
        if (!isExist) {
          distinctList.add(element);
        }
      }
      print('onResponseTempData distinctList :: ${distinctList.length}');
      var db = await instance.database;
      var query = '';
      var batch = db.batch();
      for (var i = 0; i < distinctList.length; i++) {
        var element = distinctList.elementAt(i);
        batch.update('Temperature', {'IdForApi': element['IdForApi']},
            where: 'date=? and UserId=?', whereArgs: [element['date'], element['UserId']]);
      }
      print('onResponseTempData query :: $query');
      if (batch.length > 0) {
        // var resultData = await db.update('Temperature', {'HRV': 23.32},where: 'date=?',whereArgs: ['2023-08-03 20:00:13']);
        // print('onResponseTempData resultData :: $resultData');
        result = await batch.commit();
        print('onResponseTempData result :: $result');
        var response = await deleteDuplicateTemperatureData();
        print('onResponseTempData response :: $response');
      }
      return result;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return result;
  }

  Future deleteDuplicateTemperatureData() async {
    try {
      // var query = 'DELETE FROM Temperature WHERE (id, UserId, date, IdForApi) NOT IN(SELECT id, UserId, date, IdForApi FROM Temperature where(id, UserId, date, IdForApi) IN (SELECT id, UserId, date, IdForApi FROM Temperature where(id, UserId, date, IdForApi) IN (SELECT id, UserId, date,IdForApi FROM Temperature ORDER BY id)) GROUP by date)';
      // var query =
      //     'DELETE FROM Temperature WHERE (id, UserId, date) NOT IN(SELECT id, UserId, date FROM Temperature)';
      var query =
          'DELETE FROM Temperature WHERE id IN (SELECT id FROM Temperature EXCEPT SELECT MIN(id) FROM Temperature GROUP BY UserId, date)';
      var db = await instance.database;
      final result = await db.rawQuery(query);
      print('onResponseTempData delete :: $query :: $result}');
      return result;
    } catch (e) {
      debugPrint('Exception at deleteDuplicate $e');
    }
    return Future.value();
  }

  Future<List<TempModel>> getTempTableData(
      String userId, String startDate, String endDate, List ids) async {
    try {
      var query =
          'select* from Temperature where UserId = $userId and date between \'$startDate\' and \'$endDate\'';
      if (ids != null) {
        /*ids.forEach((element) {
          if (element != null) {
            query += ' and id != $element';
          }
        });*/
        // query += " GROUP BY date ORDER BY date DESC LIMIT 20";
        query += 'ORDER BY date DESC LIMIT 20 OFFSET ${ids.length}';
      }
      var db = await database;
      var list = await db.rawQuery(query);
      return list.map((e) => TempModel.fromMapForDb(e)).toList();
    } catch (e) {
      debugPrint('Exception at getTempTableData $e');
      return [];
    }
  }

  Future<List<TempModel>> getTempTableDataForCalendar(
      String userId, DateTime startDate, DateTime endDate, String field, int offset) async {
    var strFirst = DateFormat(DateUtil.yyyyMMddhhmmss).format(startDate);
    var strLast = DateFormat(DateUtil.yyyyMMddhhmmss).format(endDate);
    var query =
        'select DISTINCT date from Temperature where UserId = $userId and $field IS NOT NULL and $field > 1 and date between \'$strFirst\' and \'$strLast\'  LIMIT 100 OFFSET $offset';
    var db = await database;
    var list = await db.rawQuery(query);
    return list.map((e) => TempModel.fromMapForDb(e)).toList();
  }

  Future getUnSyncTempTableData(String userId) async {
    if (userId.isEmpty) {
      userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
      print('getUnSyncTempTableData userID :: $userId');
    }
    try {
      var query =
          'select * from Temperature where UserId = $userId and IdForApi is Null GROUP BY date ORDER BY date DESC';
      var db = await database;
      var list = await db.rawQuery(query);
      return list.map((e) => TempModel.fromMapForDb(e)).toList();
    } catch (e) {
      debugPrint('Exception at getTempTableData $e');
      return [];
    }
  }

  Future getSyncTempTableData(String userId) async {
    try {
      var query =
          'select* from Temperature where UserId = $userId and IdForApi NOTNULL ORDER BY date DESC';
      var db = await database;
      var list = await db.rawQuery(query);
      return list.map((e) => TempModel.fromMapForDb(e)).toList();
    } catch (e) {
      debugPrint('Exception at getTempTableData $e');
      return [];
    }
  }

  //endregion

  Future insertSportData(List map) async {
    var result;
    try {
      var distinctList = [];
      for (var element in map) {
        var isExist = distinctList
            .any((e) => e['user_Id'] == element['user_Id'] && e['date'] == element['date']);
        if (!isExist) {
          distinctList.add(element);
        }
      }
      var db = await instance.database;
      var query =
          'REPLACE INTO Sport (date, step, calories, distance, user_Id, completion, data, IdForApi) values';
      for (var element in distinctList) {
        query +=
            '(\'${element['date']}\', ${element['step']}, ${element['calories']}, ${element['distance']}, ${element['user_Id']}, ${element['completion']}, \'${element['data']}\', ${element['IdForApi']}),';
      }
      query = query.replaceRange(query.length - 1, query.length, ';');
      result = await db.rawInsert(query);
      await deleteDuplicateSportData();
      return result;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return result;
  }

  Future deleteDuplicateSportData() async {
    try {
      // var query = 'DELETE FROM Sport WHERE (id, user_Id, date) NOT IN(SELECT id, user_Id, date FROM Sport GROUP BY date);';
      var query =
          'DELETE FROM Sport WHERE id NOT IN (SELECT t1.id FROM Sport t1 LEFT JOIN Sport t2 ON (t1.date= t2.date and t1.step < t2.step) where t2.step is null GROUP by t1.date);';
      var db = await instance.database;
      final result = await db.rawQuery(query);
      return result;
    } catch (e) {
      debugPrint('Exception at deleteDuplicate $e');
    }
    return Future.value();
  }

  Future insertSleepDataList(List map) async {
    var result;
    try {
      var distinctList = [];
      for (var element in map) {
        var isExist = distinctList
            .any((e) => e['user_Id'] == element['user_Id'] && e['date'] == element['date']);
        if (!isExist) {
          distinctList.add(element);
        }
      }
      var db = await instance.database;
      var query =
          'REPLACE INTO Sleep (date, sleepAllTime, deepTime, lightTime, allTime, stayUpTime, user_Id, data, idForApi) values';
      for (var element in distinctList) {
        query +=
            '(\'${element['date']}\', ${element['sleepAllTime']}, ${element['deepTime']}, ${element['lightTime']}, ${element['allTime']}, ${element['stayUpTime']}, ${element['user_Id']}, \'${element['data']}\', ${element['IdForApi']}),';
      }
      query = query.replaceRange(query.length - 1, query.length, ';');
      result = await db.rawInsert(query);
      await deleteDuplicateSleepData();
      return result;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return result;
  }

  Future deleteDuplicateSleepData() async {
    try {
      // var query = 'DELETE FROM Sport WHERE (id, user_Id, date) NOT IN(SELECT id, user_Id, date FROM Sport GROUP BY date);';
      var query =
          'DELETE FROM Sleep WHERE (id, user_Id, date) NOT IN(SELECT id, user_id, date FROM Sleep GROUP BY date)';
      var db = await instance.database;
      final result = await db.rawQuery(query);
      return result;
    } catch (e) {
      debugPrint('Exception at deleteDuplicate $e');
    }
    return Future.value();
  }

  Future insertHealthKitOrGoogleFitDataList(List map) async {
    var result;

    try {
      var distinctList = [];
      for (var element in map) {
        var isExist = distinctList.any((e) =>
            e['user_id'] == element['user_id'] &&
            e['startTime'] == element['startTime'] &&
            e['typeName'] == element['typeName'] &&
            e['value'] == element['value']);
        if (!isExist) {
          distinctList.add(element);
        }
      }
      var db = await instance.database;
      var batch = db.batch();

      var query =
          'INSERT OR IGNORE INTO HealthKitOrGoogleFitTable (user_id,typeName,value,startTime,endTime,isSync,valueId,IdForApi) values';
      for (var element in distinctList) {
        query +=
            '(\'${element['user_id']}\', \'${element['typeName']}\', ${element['value']}, \'${element['startTime']}\', \'${element['endTime']}\', ${element['isSync']}, \'${element['valueId']}\', ${element['IdForApi']}),';
      }
      query = query.replaceRange(query.length - 1, query.length, ';');
      batch.rawQuery(query);
      result = await batch.commit(noResult: true);
      await deleteDuplicateHealthKitOrGoogleFitData();
      List<Map> list = await db.rawQuery('SELECT * FROM HealthKitOrGoogleFitTable');
      print("${distinctList[0]['typeName']}: $list");
      return result;
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return result;
  }

  Future deleteDuplicateHealthKitOrGoogleFitData() async {
    try {
      // var query = 'DELETE FROM Sport WHERE (id, user_Id, date) NOT IN(SELECT id, user_Id, date FROM Sport GROUP BY date);';
      var query =
          'DELETE FROM HealthKitOrGoogleFitTable WHERE (user_id, typeName, value, startTime, endTime ) NOT IN(SELECT user_id, typeName, value, startTime, endTime FROM HealthKitOrGoogleFitTable GROUP BY valueId)';
      var db = await instance.database;
      final result = await db.rawQuery(query);
      return result;
    } catch (e) {
      debugPrint('Exception at deleteDuplicate $e');
    }
    return Future.value();
  }

  Future getFirstRecordDateOfHealthOrGoogleFit(String userId) async {
    var db = await instance.database;
    final result = await db.rawQuery(
        'Select startTime from HealthKitOrGoogleFitTable where user_id = \'$userId\' order by startTime asc limit 1');
    debugPrint('$result');
    if ((result.length) > 0) {
      return result.first['startTime'];
    }
  }

  Future getLastRecordDateOfHealthOrGoogleFit(String userId) async {
    var db = await instance.database;
    final result = await db.rawQuery(
        'Select startTime from HealthKitOrGoogleFitTable where user_id = \'$userId\' order by startTime desc limit 1');
    debugPrint('$result');
    if ((result.length) > 0) {
      return result.first['startTime'];
    }
  }

  Future deleteDuplicateBloodPressureData() async {
    try {
      var query =
          'DELETE FROM BloodPressure WHERE (id, userId, date) NOT IN(SELECT id, userId, date FROM BloodPressure GROUP BY date)';
      var db = await instance.database;
      final result = await db.rawQuery(query);
      return result;
    } catch (e) {
      debugPrint('Exception at deleteDuplicate $e');
    }
    return Future.value();
  }

  Future getBloodPressureTableData(
      String userId, String startDate, String endDate, List ids) async {
    try {
      var query =
          'select * from BloodPressure where userId = $userId and date between \'$startDate\' and \'$endDate\'';
      /*for (var element in ids) {
        if (element != null) {
          query += ' and id != $element';
        }
      }*/
      query += ' GROUP BY date ORDER BY date DESC LIMIT 20 OFFSET ${ids.length}';
      print('getBloodPressureTableData Query : $query');
      var db = await database;
      var list = await db.rawQuery(query);
      print('getBloodPressureTableData Query : $list');
      return list.map((e) => BPModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Exception at getBloodPressureTableData $e');
      return [];
    }
  }

  Future<List<BPModel>> getBloodPressureDataForCalendar(
      String userId, DateTime startDate, DateTime endDate, int offset) async {
    var strFirst = DateFormat(DateUtil.yyyyMMdd).format(startDate);
    var strLast = DateFormat(DateUtil.yyyyMMdd).format(endDate);
    var query =
        'select DISTINCT date from BloodPressure where userId = $userId and date between \'$strFirst\' and \'$strLast\' LIMIT 100 OFFSET $offset';
    var db = await database;
    var list = await db.rawQuery(query);
    return list.map((e) => BPModel.fromMap(e)).toList();
  }

  Future<SaveBPDataRequest> getUnSyncBloodPressureData(String userId) async {
    if (userId.isEmpty) {
      userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
      print('getUnSyncBloodPressureData userID :: $userId');
    }
    var bpData = SaveBPDataRequest(int.parse(userId), []);
    // try {
    var db = await instance.database;
    var list = await db
        .rawQuery('SELECT * FROM BloodPressure WHERE userId = $userId AND idForApi is NULL');
    if (list.isNotEmpty) {
      bpData = SaveBPDataRequest.toObjectFromJson(list);
      print(bpData);
    }
    return bpData;
    // } catch (e) {
    //   debugPrint('Exception at BloodPressure $e');
    //   return bpData;
    // }
  }

  Future getBpIds(String userId) async {
    try {
      var db = await instance.database;
      List list = await db.rawQuery(
          'SELECT idForApi FROM BloodPressure WHERE userId = $userId AND idForApi IS NOT NULL');
      var lst = list.map((map) => map['idForApi']).toList();
      return lst;
    } on Exception catch (e) {
      debugPrint('Exception at BloodPressure $e');
      return [];
    }
  }

  /// Added on : 5th oct 2021
  /// Added by shahzad raza
  /// hr monitoring
  Future<int> deleteHrMonitoringData() async {
    var db = await instance.database;
    return await db.delete('HrMonitoringTable');
  }

  Future<int> insertHrMonitoringData(Map<String, dynamic> row) async {
    var db = await instance.database;

    if (row.containsKey('id') && row['id'] != null) {
      int id = row['id'];
      return await db.update('HrMonitoringTable', row, where: 'id = ?', whereArgs: [id]);
    }
    return await db.insert('HrMonitoringTable', row);
  }

  int get getUserID => int.parse(preferences?.getString(Constants.prefUserIdKeyInt) ?? '0');



  Future<List<HrDataModel>> getLastSavedHrData(String userId) async {
    var hrList = <HrDataModel>[];
    var db = await instance.database;
    List list = await db.rawQuery(
        'select * from HrMonitoringTable where userId = $userId and approxHr IS NOT NULL and approxHr != 0 GROUP BY date ORDER BY date DESC LIMIT 1');
    hrList = list.map((e) => HrDataModel.fromDbMapToObject(e)).toList();
    return hrList;
  }

  Future getHrMonitoringTableData(String userId, String startDate, String endDate, List ids) async {
    try {
      var query =
          'select * from HrMonitoringTable where userId = $userId and date between \'$startDate\' and \'$endDate\'';
      /*for (var i = 0; i < ids.length; i++) {
        var element = ids[i];
        if (element != null) {
          query += ' and id != $element';
        }
      }*/
      query += ' GROUP BY date ORDER BY date DESC LIMIT 20 OFFSET ${ids.length}';
      print('query $query');
      // query += ' GROUP BY date ORDER BY date DESC';
      var db = await database;
      var list = [];
      try {
        list = await db.rawQuery(query);
      } catch (e) {
        print(e);
      }
      if (list.isNotEmpty) {
        var hrList = list.map((e) => HrDataModel.fromDbMapToObject(e)).toList();
        print(hrList);
        return hrList;
      }
      return <HrDataModel>[];
    } catch (e) {
      debugPrint('Exception at getHrMonitorTableData $e');
      return <HrDataModel>[];
    }
  }

  Future getHrMonitoringTableDataZoneData(
      String userId, String startDate, String endDate, String ZoneID) async {
    try {
      var query =
          'select * from HrMonitoringTable where userId = $userId and ZoneID = $ZoneID and date between \'$startDate\' and \'$endDate\'';
      /*for (var i = 0; i < ids.length; i++) {
        var element = ids[i];
        if (element != null) {
          query += ' and id != $element';
        }
      }*/
      // query +=
      //     ' GROUP BY date ORDER BY date DESC LIMIT 20 OFFSET ${ids.length}';
      // print('query $query');
      // query += ' GROUP BY date ORDER BY date DESC';
      var db = await database;
      var list = [];
      try {
        list = await db.rawQuery(query);
      } catch (e) {
        print(e);
      }
      if (list.isNotEmpty) {
        var hrList = list.map((e) => HrDataModel.fromDbMapToObject(e)).toList();
        print(hrList);
        return hrList;
      }
      return <HrDataModel>[];
    } catch (e) {
      debugPrint('Exception at getHrMonitorTableData $e');
      return <HrDataModel>[];
    }
  }

  Future<SaveHrDataRequest> getUnSyncHeartRateData(String userId) async {
    var hrData = SaveHrDataRequest(int.parse(userId), []);
    try {
      var db = await instance.database;
      var list = await db
          .rawQuery('SELECT * FROM HrMonitoringTable WHERE userId = $userId AND idForApi is NULL');
      if (list.isNotEmpty) {
        hrData = SaveHrDataRequest.toObjectFromJson(list);
        print(hrData);
      }
      return hrData;
    } catch (e) {
      debugPrint('Exception at getHrMonitorTableData $e');
      return hrData;
    }
  }

  Future getHrIds(String userId) async {
    var db = await instance.database;
    List list = await db.rawQuery(
        'SELECT idForApi FROM HrMonitoringTable WHERE userId = $userId AND idForApi IS NOT NULL');
    var lst = list.map((map) => map['idForApi']).toList();
    return lst;
  }

  Future<int> getTableRowsCount({required String tableName, required String query}) async {
    var db = await instance.database;
    var count = 0;
    try {
      var q = 'SELECT COUNT(*) FROM $tableName';
      if (query.isNotEmpty) {
        q += ' WHERE $query';
        // for (var i = 0; i < query.keys.length; i++) {
        //   q += '${query.keys.elementAt(i)} = ${query[query.keys.elementAt(i)]}';
        //   if (i != query.length - 1) {
        //     q += ' AND ';
        //   }
        // }
      }
      count = Sqflite.firstIntValue(await db.rawQuery(q)) ?? 0;
    } on Exception catch (e) {
      LoggingService().printLog(message: e.toString());
    }
    return count;
  }

  Future<int> addUpdateOfflineAPIRequest(OfflineAPIRequest apiRequest) async {
    var db = await instance.database;
    if (apiRequest.oarId != null) {
      var res = await db.update('offlineAPIRequests', apiRequest.toJson(),
          where: 'oarId=?', whereArgs: [apiRequest.oarId]);
      print('offlineAPIRequests $res');
      return res;
    } else {
      var res = await db.insert('offlineAPIRequests', apiRequest.toJson());
      print('offlineAPIRequests $res');
      return res;
    }
  }

  Future<List<OfflineAPIRequest>> getAllOfflineAPIRequests({String? filter}) async {
    var db = await instance.database;
    List<Map<String, dynamic>> snapshots = await db.query('offlineAPIRequests');
    if (snapshots.isNotEmpty && snapshots != null) {
      if (filter != null) {
        return snapshots
            .map((e) => OfflineAPIRequest.fromJson(e))
            .toList()
            .where((element) => element.url!.contains(filter))
            .toList();
      }
      return snapshots.map((e) => OfflineAPIRequest.fromJson(e)).toList();
    }

    return [];
  }

  Future<bool> deleteOfflineAPIRequest(int? oarId) async {
    var db = await instance.database;

    var res = await db.delete('offlineAPIRequests', where: 'oarId=?', whereArgs: [oarId]);
    return (res != null && res > 0);
  }

  void clearDatabase() async {
    try {
      print("clearDatabase");
      var query = 'DELETE FROM ';
      var db = await instance.database;

      await db.rawQuery('${query}Sport');
      await db.rawQuery('${query}Sleep');
      await db.rawQuery('${query}Measurement');
      await db.rawQuery('${query}TagNote');
      await db.rawQuery('${query}User');
      await db.rawQuery('${query}Email');
      await db.rawQuery('${query}Contacts');
      await db.rawQuery('${query}Invitation');
      await db.rawQuery('${query}Alarm');
      await db.rawQuery('$query${DatabaseTableNameAndFields.TagTable}');
      await db.rawQuery('$query${DatabaseTableNameAndFields.GraphTypeTable}');
      await db.rawQuery('${query}WeightScaleData');
      await db.rawQuery('${query}HealthKitOrGoogleFitTable');
      await db.rawQuery('${query}Chat');
      await db.rawQuery('${query}Temperature');
      await db.rawQuery('${query}Calendar');
      await db.rawQuery('${query}ChatList');
      await db.rawQuery('${query}BloodPressure');
      await db.rawQuery('${query}ChatDetail');
      await db.rawQuery('${query}GroupChatDetail');
      await db.rawQuery('${query}Reminder');
    } catch (e) {
      print(e);
    }
  }
}
