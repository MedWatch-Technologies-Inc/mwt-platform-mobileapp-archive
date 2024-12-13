import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:health_gauge/value/string_localization_support/english_localization.dart';
import 'package:health_gauge/value/string_localization_support/french_localization.dart';
import 'package:health_gauge/value/string_localization_support/hindi_localization.dart';

/// Added by: Akhil
/// Added on: May/28/2020
/// This class contains all the keys of Strings which are used in app to get the value of the keys according to the language of app selected by user.

class StringLocalization {
  final Locale locale;
  static String language = 'language';
  static String call = 'call';
  static String message = 'message';
  static String qq = 'qq';
  static String weChat = 'weChat';
  static String linkedIn = 'linkedIn';
  static String skype = 'skype';
  static String facebookMessenger = 'facebookMessenger';
  static String twitter = 'twitter';
  static String whatsApp = 'whatsApp';
  static String viber = 'viber';
  static String line = 'line';

  static String survey = 'survey';
  static String waterReminderTitle = 'waterReminderTitle';
  static String sedentaryReminderTitle = 'sedentaryReminderTitle';

  static String dontForgetToDrinkWater = 'dontForgetToDrinkWater';

  static var sedentaryDesc = 'sedentaryDesc';

  static String medicineReminderTitle = 'medicineReminderTitle';

  static String ppgReminderTitle = 'ppgReminderTitle';

  static String medicineDesc = 'medicineDesc';
  static String ppgDesc = 'ppgDesc';
  static String doNotAskAgain = 'doNotAskMeAgain';

  static String diet = 'Diet';
  static String medicine = 'medicine';
  static String corona = 'corona';
  static String smoking = 'smoking';
  static String alcohol = 'alcohol';
  static String glucosepatch = 'glucosepatch';

  // static String glucosepatchlocation  = 'glucosepatchlocation';

  static String allowance = 'allowance';

  static String search = 'Search';

  static String more = 'more';

  static String measurementResult = 'measurementResult';
  static String measurementData = 'measurementData';

  static String estimating = 'estimating';

  static String synchronization = 'synchronization';

  static String addNameForBluetoothDevice = 'addNameForBluetoothDevice';

  static String hideFromList = 'hideFromList';

  static String showAll = 'showAll';

  static String hide = 'hide';

  static String allSleep = 'allSleep';

  static String deepSleep = 'deepSleep';

  static String lightSleep = 'lightSleep';

  static String systolic = 'systolic';

  static String diastolic = 'diastolic';

  static String goal = 'goal';

  static String awake = 'awake';

  static String chooseYourCaloriesTarget = 'chooseYourCaloriesTarget';

  static String caloriesSuggestion = 'caloriesSuggestion';

  static String caloriesTarget = 'caloriesTarget';

  static String chooseYourDistanceTarget = 'chooseYourDistanceTarget';

  static String distanceTarget = 'distanceTarget';

  static String distanceSuggestion = 'distanceSuggestion';

  static String distanceSuggestionMile = 'distanceSuggestionMile';

  static String normal = 'normal';

  static String resting = 'resting';

  static String walking = 'walking';

  static String exercising = 'exercising';

  static String slow = 'slow';

  static String fast = 'fast';

  static String whatStateAreYouMeasuringIn = ' whatStateAreYouMeasuringIn';

  static String maxEffort = 'maxEffort';

  static String hardCoreTraining = 'hardCoreTraining';

  static String enduranceTraining = 'enduranceTraining';

  static String fatBurning = 'fatBurning';

  static String normalization = 'Normalization';

  static String measuringKeepStanding = 'measuringKeepStanding';

  static String unStableWeight = 'unStableWeight';

  static String onBoardNow = 'onBoardNow';

  static String measureComplete = 'measureComplete';

  static String allMeasurementNotTaken = 'allMeasurementNotTaken';

  static String oscillometric = 'oscillometric';

  static String tab = 'tab';

  static String editTitleOfGraph = 'editTitleOfGraph';

  static String startDate = 'startDate';

  static String weightMeasurement = 'WeightMeasurement';

  static String withinADay = 'WithinADay';

  static String deviceNotConnected = 'deviceNotConnected';

  static String bodyMassIndex = 'bodyMassIndex';

  static String addWeightDescription = 'addWeightDescription';

  static String selectUnit = 'selectUnit';

  static String researcherProfile = 'researcherProfile';

  static String enterPassword = 'enterPassword';

  static String enterPasswordText = 'enterPasswordText';

  static String wrongPassword = 'wrongPassword';

  static String youAreResearcher = 'youAreResearcher';

  static String heartRateShortForm = 'heartRateShortForm';

  static String notResearcher = 'notResearcher';

  static String Ai = 'Ai';

  static String sleepData = 'sleepData';

  static String researcherProfileTitle = 'researcherProfileTitle';

  static String wrongData = 'wrongData';

  static String measurementNotStarted = 'measurementNotStarted';

  static String wrongDataDescription = 'wrongDataDescription';
  static String measurementNotStartedDescription =
      'measurementNotStartedDescription';

  static String restart = 'restart';

  static String deleteGraph = 'deleteGraph';

  static String no = 'no';

  static String yes = 'yes';

  static String selectColor = 'selectColor';

  static String MMOL = 'MMOL';
  static String MGDL = 'MGDL';

  static String fahrenheit = 'fahrenheit';

  static String glass = 'glass';

  static String running = 'running';

  static String hiking = 'hiking';

  static String biking = 'biking';

  static String easy = 'easy';

  static String moderate = 'moderate';

  static String barGraph = 'barGraph';

  static String selectGraphType = 'selectGraphType';

  static String lineAndBarGraph = 'lineAndBarGraph';

  static var lineGraph = 'lineGraph';

  static var titleDbp = 'titleDbp';

  static String deviceData = 'deviceData';

  static String result = 'result';

  static String AIData = 'AIData';

  static String userData = 'userData';

  static String aDayAgo = 'aDayAgo';

  static String daysAgo = 'daysAgo';

  static String endDate = 'endDate';

  static String collectData = 'collectData';

  static String addGraphRestriction = 'addGraphRestriction';

  static String underweight = 'underweight';

  static String normalWeight = 'normalWeight';

  static String preHyper = 'preHyper';

  static String hyper = 'hyper';

  static var imageMeasurement = 'imageMeasurement';

  static String meter = 'meter';

  static var titleSbp = 'titleSbp';

  static String changesNotSaved = 'changesNotSaved';

  static String notSavedDescription = 'notSavedDescription';
  static String hRNormal = 'hRNormal';

  static String brightness = 'brightness';

  static String Low = 'Low';
  static String Medium = 'Medium';
  static String High = 'High';

  static String homeScreenItems = 'homeScreenItems';

  static String oxygen = 'oxygen';

  static String normalCalibration = 'normalCalibration';
  static String lowCalibration = 'lowCalibration';
  static String highCalibration = 'highCalibration';
  static String hyperCalibration = 'hypeCalibration';
  static String highHyperCalibration = 'highHyperCalibration';

  static String tagLevel = 'tagLevel';

  static var bfr = 'bfr';

  static var bodyWater = 'bodyWater';

  static var muscleRate = 'muscleRate';

  static var boneMass = 'boneMass';

  static var bmr = 'bmr';

  static var proteinRate = 'proteinRate';

  static var visceralFatIndex = 'visceralFatIndex';

  static String numberOfPills = 'numberOfPills';
  static String glucosepatchlocation = 'glucosepatchlocation';
  static String fingerStick1Glucose = 'fingerStick1Glucose';
  static String fingerStick2Glucose = 'fingerStick2Glucose';

  static String glassOf = 'glassOf';

  static String numberOfSmoke = 'numberOfSmoke';

  static String start = 'start';

  static String gmail = 'gmail';
  static String instagram = 'instagram';
  static String snapchat = 'snapchat';
  static String facebook = 'facebook';
  static String weibo = 'weibo';
  static String clickAgain = 'clickAgain';
  static var searchUser = 'searchUser';
  static String surveyList = 'surveyList';
  static String addSurvey = 'addSurvey';
  static String addQuestion = 'addQuestion';
  static String backText = 'backText';
  static String changeQuestionType = 'changeQuestionType';

  static String interpolation = 'interpolation';

  static var confirmationText = 'confirmationText';

  static String cameraMeasurement = 'cameraMeasurement';

  static String setUnit = 'setUnit';

  static String cmShort = 'cm';
  static String inchShort = 'in';

  static String celsiusShort = 'celsiusShort';
  static String fahrenheitShort = 'fahrenheitShort';

  static String unitSetSuccess = 'unitSetSuccess';

  static String deviceSetSuccess = 'deviceSetSuccess';

  static String others = 'others';

  static String intensity = 'intensity';

  static String searchIcon = 'searchIcon';

  static String addNewTag = 'addNewTag';
  static String selectCategory = 'selectCategory';
  static String wellness = 'wellness';

  static String exerciseTitle = 'exerciseTitle';
  static String wellnessTitle = 'wellnessTitle';
  static String symptomsTitle = 'symptoms_title';

  static String emptyWeight = 'emptyWeight';

  static String photoLibrary = 'photoLibrary';
  static String takePhoto = 'takePhoto';

  static String connectAgain = 'connectAgain';

  static String addNewCategory = 'addNewCategory';

  static String selectIcon = 'selectIcon';

  static String emptyTitle = 'emptyTitle';

  static String deleteInfo = 'deleteInfo';

  static String tts = 'tts';

  static String speed = 'speed';

  static String selectVoice = 'selectVoice';

  static String stt = 'stt';

  static String selectYourDevice = 'selectYourDevice';

  static String logOutConfirmMsg = 'logOutConfirmMsg';

  static String wifiConnectMsg = 'wifiConnectMsg';

  static String yourBp = 'yourBp';

  static String noData = 'noData';

  static String sysAvg = 'sysAvg';

  static String diaAvg = 'diaAvg';

  static String userRegisteredSuccessfully = 'userRegisteredSuccessfully';
  static String userLoggedInSuccessfully = 'userLoggedInSuccessfully';

  static String tagDeleteInfo = 'tagDeleteInfo';

  static String alreadyUsedName = 'alreadyUsedName';

  static String noIconFound = 'noIconFound';

  static String disclaimer = 'disclaimer';

  static String disclaimerInfo = 'disclaimerInfo';

  static var weight = 'weight';

  static String weightUrl = 'weightUrl';

  static String bpUrl = 'bpUrl';

  static String sleepUrl = 'sleepUrl';

  static String hrUrl = 'hrUrl';

  static var furtherInfoBp = 'furtherInfoBp';
  static var furtherInfoHr = 'furtherInfoHr';
  static var furtherInfoWeight = 'furtherInfoWeight';
  static var furtherInfoSleep = 'furtherInfoSleep';

  static String healthKitNotAvailableOnDevice = 'healthKitNotAvailableOnDevice';

  static String information = 'information';
  static String glucoseCalibrationHelp = 'glucoseCalibrationHelp';

  static String overWeightText = 'overWeightText';

  static String obeseText = 'obeseText';

  static String addAnEvent = 'addAnEvent';

  static String appointment = 'appointment';

  static String minutes = 'minutes';

  static String yourEvents = 'yourEvents';

  static String eventNotAdded = 'eventNotAdded';

  static String eventNotdeleted = 'eventNotdeleted';

  static String reminderNotAdded = 'reminderNotAdded';

  static String taskNotAdded = 'taskNotAdded';

  static String appointmentNotBooked = 'appointmentNotBooked';

  static String allDay = 'allDay';

  static String reminder = 'Reminder';

  static String setDate = 'setDate';

  static String setTime = 'setTime';

  static String outOfTown = 'outOfTown';

  static String autoDeclineNewOrExistingMeetings =
      'autoDeclineNewOrExistingMeetings';

  static String task = 'task';

  static String noResultFound = 'noResultFound';

  static String createFolder = 'createFolder';

  static String noRecordsFound = 'noRecordsFound';

  static String oopsDoSomething = 'oopsDoSomething';

  static String allMailsAlreadyRead = 'allMailsAlreadyRead';

  static String pleaseWait = 'pleaseWait';

  static String noTagsFound = '';

  static var references = 'references';

  static String imageIsEmpty = 'imageIsEmpty';

  static String agreeDisclaimerText = 'agreeDisclaimerText';
  static String studyCodeText = 'studyCodeText';

  static String hintForStudyCode = 'hintForStudyCode';

  static String userRegisteredText = 'userRegisteredText';

  static String iAcceptThe = 'iAcceptThe';

  static String resendCodeText = 'resendCodeText';
  static String resendCode = 'resendCode';
  static String enterDate = 'enterDate';

  static String saveDataInGoogleFit = 'saveDataInGoogleFit';

  static String instruction = 'instruction';

  static String camMeasurementInstruction1 = 'camMeasurementInstruction1';
  static String camMeasurementInstruction2 = 'camMeasurementInstruction2';
  static String camMeasurementInstruction3 = 'camMeasurementInstruction3';

  static String done = 'done';

  static String activityTrackScreen = 'activityTrackScreen';

  static String finish = 'finish';
  static String pause = 'pause';
  static String resume = 'resume';

  static String history = 'history';

  static String incorrectMeasurement = 'incorrectMeasurement';

  static String sleepReminder = 'sleepReminder';

  static String enable = 'enable';

  static String activityHistory = 'activityHistory';

  static String sleepReminderSetSuccessfully = 'sleepReminderSetSuccessfully';

  static String discard = 'discard';

  static String weightHistory = 'weightHistory';

  static String bodyMass = 'bodyMass';

  static String requestTimeOUt = 'requestTimeOUt';

  static String temperatureHistory = 'temperatureHistory';

  static String oxygenHistory = 'oxygenHistory';

  static String spO2 = 'sp_o2';

  static String oxygenMonitoring = 'oxygenMonitoring';

  static String shutDown = 'shutDown';
  static String shutDownWatch = 'shut_down_watch';

  static String noEventsFound = 'noEventsFound';

  static String cardiac = 'cardiac';

  static String areYouSureWantToStopMeasurement =
      'areYouSureWantToStopMeasurement';

  static String viewData = 'viewData';
  static String fetchAndNext = 'fetch_and_next';

  static String dataCollected = 'dataCollected';

  static String notificationCenter = 'notificationCenter';

  static String heartRateHistory = 'heartRateHistory';

  static String hgServer = 'hgServer';

  static String enableBle = 'enableBle';
  static String goToSetting = 'goToSetting';

  static String touchElectrod = 'touchElectrod';

  static String fail = 'Failed';

  static String connectionFailReasons = 'connectionFailReasons';
  static String itCanNotBeConnect = 'itCanNotBeConnect';
  static String failingToPhone = 'failingToPhone';
  static String or = 'or';
  static String restartPhone = 'restartPhone';
  static String deviceConnectedSomewhereElse = 'deviceConnectedSomewhereElse';
  static String disconnectFromThere = 'disconnectFromThere';
  static String disconnectFromThereBle = 'disconnectFromThereBle';

  static String isNotYourWatchScanning = 'isNotYourWatchScanning';

  static var itCouldBecauseDeviceConnectedSomewhereElse =
      'itCouldBecauseDeviceConnectedSomewhereElse';

  static var locationPermissionNotGranted = 'locationPermissionNotGranted';

  static var givePermissionAndEnableLocation =
      'givePermissionAndEnableLocation';

  static var deviceBluetoothNotFunctioningWell =
      'deviceBluetoothNotFunctioningWell';

  static String measurementStartFailed = 'measurementStartFailed';
  static String failed = 'failed';

  static String fetchInBackground = 'fetchInBackground';

  static String doItInTheBackground = 'doItInTheBackground';

  static String ifYouCanNotFindYourHGDevice = 'ifYouCanNotFindYourHGDevice';

  static String makeSureItNotConnectedWithAnotherPhone =
      'makeSureItNotConnectedWithAnotherPhone';

  static String makeSureLocationPermission = 'makeSureLocationPermission';

  static String ifYouCanNotPair = 'ifYouCanNotPair';

  static String resetYourDevice = 'resetYourDevice';

  static String bloodOxygen = 'bloodOxygen';
  static String activeCalorieBurn = 'active_calorie_urn';
  static String restingCalorieBurn = 'resting_alorie_urn';

  static String imageWearingMethod2 = 'imageWearingMethod2';

  static String imageBrightenScreen2 = 'imageBrightenScreen2';

  static String imageDoNotDisturb2 = 'imageDoNotDisturb2';

  static String ecgFromWatch = 'ecgFromWatch';

  static String rememberMe = 'rememberMe';

  static String readDisclaimer = 'readDisclaimer';

  static String readTermsAndConditions = 'readTermsAndConditions';

  static String bloodPressureHistory = 'BloodPressureHistory';

  static String weightConnectionType = 'weightConnectionType';

  static String enterValidWeight = 'enterValidWeight';

  static String maxWeightLimit = 'maxWeightLimit';

  static String enterValidHeight = 'enterValidHeight';

  static String maxHeightLimitCm = 'maxHeightLimitCm';

  static String enterFeet = 'enterFeet';

  static String enterInch = 'enterInch';

  static String maxHeightLimitFeet = 'maxHeightLimitFeet';

  static String inchLimit = 'inchLimit';

  static String graphNormalization = 'graphNormalization';

  static String tagNoteDeleteInfo = 'tagNoteDeleteInfo';

  static String measurementDeleteInfo = 'measurementDeleteInfo';

  static String hrvInfo = 'hrvInfo';
  static String spO2Info = 'spO2Info';
  static String bpInfo = 'bpInfo';
  static String tempInfo = 'tempInfo';
  static String forReference = 'forReference';

  StringLocalization(this.locale);

  static StringLocalization of(BuildContext context) =>
      Localizations.of<StringLocalization>(context, StringLocalization)!;

  static String appReminders = 'appReminders';
  static String reminders = 'Reminders';
  static String addReminders = 'Add Reminder';
  static String updateReminders = 'Update Reminder';

  static const String kLanguageHindi = 'hi';
  static const String kLanguageEnglish = 'en';
  static const String kLanguageFrench = 'fr';
  static const String kValues = 'values';
  static const String kMeasurement = 'measurement';
  static const String appName = 'appName';
  static const String dashBoardName = 'dashBoardName';
  static const String cnctnScreen = 'cnctnScreen';
  static const String settingScreen = 'settingScreen';
  static const String surveyScreen = 'surveyScreen';
  static const String calendarScreen = 'calendarScreen';
  static const String voiceConfiguration = 'voiceConfiguration';
  static const String targetScreen = 'targetScreen';
  static const String tagHistory = 'tagHistory';
  static const String sleeptargetScreen = 'sleeptargetScreen';
  static const String btnTitle = 'btnTitle';
  static const String btnTag = 'btnTag';
  static const String btnTagU = 'btnTagU';
  static const String displayOne = 'displayOne';
  static const String tagScreen = 'tagScreen';
  static const String tagScreenSlctn = 'tagScreenSlctn';
  static const String headline = 'headline';
  static const String subHeadline = 'subHeadline';
  static const String title = 'title';
  static const String subTitle = 'subTitle';
  static const String body2 = 'body2';
  static const String body1 = 'body1';
  static const String small = 'small';
  static const String caption = 'caption';
  static const String appbarMgmt = 'appbarMgmt';
  static const String monitor = 'monitor';
  static const String timeFormat = 'timeFormat';
  static const String timeF = 'timeF';
  static const String timeFo = 'timeFo';
  static const String reset = 'reset';
  static const String resetWatch = 'reset_watch';
  static const String hrMonitor = 'hrMonitor';
  static const String bScreen = 'bScreen';
  static const String dNd = 'dNd';
  static const String firmUpdate = 'firmUpdate';
  static const String noInternet = 'noInternet';
  static const String enableInternet = 'enableInternet';
  static const String retry = 'retry';
  static const String cncl = 'cncl';
  static const String mileage = 'mileage';
  static const String kCal = 'kCal';
  static const String comp = 'comp';
  static const String hintForUserId = 'hintForUserId';
  static const String hintForPassword = 'hintForPassword';
  static const String hintForNewPassword = 'hintForNewPassword';
  static const String loginBtn = 'loginBtn';
  static const String type = 'type';
  static const String stps = 'stps';
  static const String value = 'value';
  static const String time = 'time';
  static const String date = 'date';
  static const String notes = 'notes';
  static const String day = 'day';
  static const String week = 'week';
  static const String month = 'month';
  static const String timeH = 'timeH';
  static const String typeH = 'typeH';
  static const String valueH = 'valueH';
  static const String noteH = 'noteH';
  static const String weekH = 'weekH';
  static const String lastH = 'lastH';
  static const String skipBtn = 'skipBtn';
  static const String btnForgotPassword = 'btnForgotPassword';
  static const String btnForgotUserId = 'btnForgotUserId';
  static const String next = 'next';
  static const String dontHaveAnAccount = 'dontHaveAnAccount';
  static const String btnSignUp = 'btnSignUp';
  static const String btnConnect = 'btnConnect';
  static const String btnDisConnect = 'btnDisConnect';
  static const String emptyUserId = 'emptyUserId';
  static const String emptyPassword = 'emptyPassword';
  static const String emptyNewPassword = 'emptyNewPassword';
  static const String btnLogout = 'btnLogout';
  static const String hintForEmail = 'hintForEmail';
  static const String emptyEmail = 'emptyEmail';
  static const String enterValidEmail = 'enterValidEmail';
  static const String hintForFirstName = 'hintForFirstName';
  static const String emptyFirstName = 'emptyFirstName';
  static const String hintForLastName = 'hintForLastName';
  static const String emptyLastName = 'emptyLastName';
  static const String hintForBirthDate = 'hintForBirthDate';
  static const String emptyBirthDate = 'emptyBirthDate';
  static const String hintForPhone = 'hintForPhone';
  static const String emptyPhone = 'emptyPhone';
  static const String enterValidPhone = 'enterValidPhone';
  static const String confirmPasswordDoesntMatch = 'confirmPasswordDoesntMatch';
  static const String hintForConfirmPassword = 'hintForConfirmPassword';
  static const String emptyConfirmPassword = 'emptyConfirmPassword';
  static const String passwordMismatch = 'passwordMismatch';
  static const String passwordInvalid = 'passwordInvalid';
  static const String termsAndConditions = 'termsAndConditions';
  static const String readMore = 'readMore';
  static const String agreeTermsAndCondition = 'agreeTermsAndCondition';
  static const String save = 'save';
  static const String profile = 'profile';
  static const String pleaseLoginFirstToUseThisFeature =
      'pleaseLoginFirstToUseThisFeature';
  static const String cancel = 'cancel';
  static const String ok = 'ok';
  static const String deviceBattery = 'deviceBattery';
  static const String bp = 'bp';
  static const String bloodPressure = 'bloodPressure';
  static const String offLineEcgSbp = 'offLineEcgSbp';
  static const String heartRate = 'heartRate';
  static const String hrv = 'hrv';
  static const String health = 'health';
  static const String symptoms = 'symptoms';
  static const String complete = 'complete';
  static const String steps = 'steps';
  static const String calories = 'calories';
  static const String kml = 'kml';
  static const String zeroKml = 'zeroKml';
  static const String distance = 'distance';
  static const String km = 'km';
  static const String zeroKm = 'zeroKm';
  static const String activity = 'activity';
  static const String sleepS = 'sleepS';
  static const String sleepHour = 'sleepHour';
  static const String hour = 'hour';
  static const String sleep = 'sleep';
  static const String disconnect = 'disconnect';
  static const String areYouSureWantToDisconnect = 'areYouSureWantToDisconnect';
  static const String connectedDevice = 'connectedDevice';
  static const String connected = 'connected';
  static const String disconnected = 'disconnected';
  static const String andConnect = 'andConnect';
  static const String gender = 'gender';
  static const String male = 'male';
  static const String female = 'female';
  static const String unit = 'unit';
  static const String metric = 'metric';
  static const String imperial = 'imperial';
  static const String dateOfBirth = 'dateOfBirth';
  static const String selectBirthDate = 'selectBirthDate';
  static const String height = 'height';
  static const String confirm = 'confirm';
  static const String feet = 'feet';
  static const String inch = 'inch';
  static const String skinPhotoType = 'skinPhotoType';
  static const String width = 'width';
  static const String lb = 'lb';
  static const String measurement = 'measurement';
  static const String startMeasurement = 'startMeasurement';
  static const String training = 'training';
  static const String hrBPM = 'hrBPM';
  static const String bpMmHg = 'bpMmHg';
  static const String bplegend = 'bpLegend';
  static const String countDown = 'countDown';
  static const String ecg = 'ecg';
  static const String ppg = 'ppg';
  static const String calibration = 'calibration';
  static const String hr = 'hr';
  static const String sbd = 'sbd';
  static const String dbp = 'dbp';
  static const String shortDescription = 'shortDescription';
  static const String noteDescription = 'noteDescription';
  static const String add = 'add';
  static const String addToGraph = 'addToGraph';
  static const String measurementHistory = 'measurementHistory';
  static const String cardiacHistory = 'cardiacHistory';
  static const String today = 'today';
  static const String yesterday = 'yesterday';
  static const String tomorrow = 'tomorrow';
  static const String stopMeasurement = 'stopMeasurement';
  static const String edit = 'edit';
  static const String camera = 'camera';
  static const String gallery = 'gallery';
  static const String remove = 'remove';
  static const String min = 'min';
  static const String max = 'max';
  static const String enterMin = 'enterMin';
  static const String minMustBeSmallerThenMax = 'minMustBeSmallerThenMax';
  static const String valueMustBeGreaterThenZero = 'valueMustBeGreaterThenZero';
  static const String enterMax = 'enterMax';
  static const String minMustBeSmallerThenMin = 'minMustBeSmallerThenMin';
  static const String label = 'label';
  static const String enterLabel = 'enterLabel';
  static const String defaultValue = 'defaultValue';
  static const String enterBetween = 'enterBetween';
  static const String digit = 'digit';
  static const String enterDigit = 'enterDigit';
  static const String centimetre = 'centimetre';
  static const String kg = 'kg';
  static const String weightHelp = 'weightHelp';
  static const String updatedSuccessfully = 'updatedSuccessfully';
  static const String failToUpdate = 'failToUpdate';
  static const String sleepHistoryTitle = 'sleepHistoryTitle';
  static const String chooseYourStepTarget = 'chooseYourStepTarget';
  static const String stepSuggestion = 'stepSuggestion';
  static const String chooseSleepTarget = 'chooseSleepTarget';
  static const String sleepSuggestion = 'sleepSuggestion';
  static const String noDataFound = 'noDataFound';
  static const String stayUp = 'stayUp';
  static const String light = 'light';
  static const String deep = 'deep';
  static const String commingSoon = 'commingSoon';
  static const String target = 'target';
  static const String minute = 'minute';
  static const String privacyPolicy = 'privacyPolicy';
  static const String tagLabelEditor = 'tagLabelEditor';
  static const String addTagTitle = 'addTagTitle';
  static const String update = 'update';
  static const String selectTag = 'selectTag';
  static const String range = 'range';
  static const String minimum = 'minimum';
  static const String maximum = 'maximum';
  static const String defaultValueTag = 'defaultValueTag';
  static const String precision = 'precision';
  static const String tag = 'tag';
  static const String tagValue = 'tagValue';
  static const String change = 'change';
  static const String addNote = 'addNote';
  static const String updateNote = 'updateNote';
  static const String enterUnit = 'enterUnit';
  static const String stress = 'stress';
  static const String number = 'number';
  static const String MMOLPerLiter = 'MMOLPerLiter';
  static const String MMGL = 'MMGL';
  static const String fatigue = 'fatigue';
  static const String bloodGlucose = 'bloodGlucose';
  static const String glucoseCalibrationTag = 'glucoseCalibrationTag';
  static const String exercise = 'exercise';
  static const String bodyTemperature = 'bodyTemperature';
  static const String celsius = 'celsius';
  static const String breathing = 'breathing';
  static const String deviceManagement = 'deviceManagement';
  static const String hourlyHrMonitor = 'hourlyHrMonitor';
  static const String hourlyBPMonitor = 'hourlyBPMonitor';
  static const String liftTheWristBrighten = 'liftTheWristBrighten';
  static const String doNotDisturb = 'doNotDisturb';
  static const String twelve = 'twelve';
  static const String twentyFour = 'twentyFour';
  static const String wearType = 'wearType';
  static const String leftHand = 'leftHand';
  static const String rightHand = 'rightHand';
  static const String graph = 'graph';
  static const String selectItem = 'selectItem';
  static const String somethingWentWrong = 'somethingWentWrong';
  static const String hgSyncedSuccessfully = 'hg_synced_successfully';
  static const String oops = 'oops';
  static const String unknown = 'unknown';
  static const String healthGauge = 'HealthGauge';
  static const String helpForMeasurement = 'helpForMeasurement';
  static const String help = 'help';
  static const String findBracelet = 'findBracelet';
  static const String version = 'version';
  static const String selectLanguage = 'selectLanguage';
  static const String overrideLanguageSetting = 'overrideLanguageSetting';
  static const String localization = 'localization';
  static const String chooseSelectedLanguage = 'Choose Selected Language';
  static const String english = 'english';
  static const String hindi = 'hindi';
  static const String french = 'french';
  static const String spanish = 'spanish';

  static const String enterTitle = 'enterTitle';
  static const String enterName = 'enterName';

  static const String ppgNoChartDataAvailable = 'ppgNoChartDataAvailable';
  static const String kSearchMailHint = 'searchMailHint';
  static const String kInbox = 'Inbox';
  static const String kDrafts = 'drafts';
  static const String kTrash = 'trash';
  static const String kSent = 'sent';
  static const String kSend = 'send';
  static const String kOutBox = 'outbox';

  static const String onConnect = 'onConnect';
  static const String onConnectError = 'onConnectError';
  static const String onConnectTimeout = 'onConnectTimeout';
  static const String noClientFoundInNetwork = 'noClientFoundInNetwork';

  static const String startTime = 'startTime';
  static const String endTime = 'endTime';
  static const String intervalTime = 'intervalTime';
  static const String repeat = 'repeat';
  static const String description = 'description';
  static const String sun = 'sun';
  static const String mon = 'mon';
  static const String tue = 'tue';
  static const String wed = 'wed';
  static const String thu = 'thu';
  static const String fri = 'fri';
  static const String sat = 'sat';
  static const String selectImage = 'selectImage';
  static const String notification = 'notification';

  static const String leadOff = 'leadOff';
  static const String leadDesc = 'leadDesc';

  static const String poorConductive = 'poorConductive';
  static const String poorConductiveDesc = 'poorConductiveDesc';

  static const String goodSignal = 'goodSignal';
  static const String readyForMeasurement = 'readyForMeasurement';
  static const String measurementInProgress = 'measurement_in_progress';
  static const String holdHand = 'holdHand';
  static const String graphdisclaimer = 'graphdisclaimer';
  static const String braceletSung = 'braceletSung';
  static const String putYourFinger = 'putYourFinger';
  static const String recommodateMoisten = 'recommodateMoisten';
  static const String contacts = 'Contact';
  static const String contactDeleted = 'contactDeleted';
  static const String delete = 'delete';
  static const String noContactFound = 'noContactFound';
  static const String searchContact = 'Search Contact';
  static const String invitations = 'invitations';
  static const String noPendingInvitationToSearchFrom =
      'noPendingInvitationToSearchFrom';
  static const String noPendingInvitations = 'noPendingInvitations';

  static const String addContacts = 'addContacts';
  static const String invitedSucessfully = 'invitedSucessfully';
  static const String invitationFailed = 'invitationFailed';
  static const String searchNameOfUser = 'searchNameOfUser';
  static const String nothingToShow = 'nothingToShow';
  static const String pageDeleted = 'pageDeleted';
  static const String pageAdded = 'pageAdded';
  static const String youCanNotAddMorePages = 'youCanNotAddMorePages';
  static const String addPage = 'addPage';
  static const String deleteCurrentPage = 'deleteCurrentPage';
  static const String editTitleOfpage = 'editTitleOfPage';
  static const String addTitleOfpage = 'addTitleOfpage';
  static const String editTitle = 'editTitle';
  static const String compose = 'compose';
  static const String to = 'to';
  static const String cc = 'cc';
  static const String subject = 'subject';
  static const String body = 'body';
  static const String enterAllFields = 'enterAllFields';
  static const String pleaseEnterToSubject = 'pleaseEnterToSubject';
  static const String addToDrafts = 'addToDrafts';
  static const String draftConfirmation = 'draftConfirmation';
  static const String messageSentSuccessfully = 'messageSentSuccessfully';
  static const String messageNotSent = 'messageNotSent';
  static const String untrash = 'unTrash';
  static const String emailDeletedSuccessfully = 'emailDeletedSuccessfully';
  static const String selectAll = 'selectAll';
  static const String emailRestoredSuccessfully = 'emailRestoredSuccessfully';
  static const String emailSavedInOutbox = 'emailSavedInOutbox';
  static const String detail = 'detail';
  static const String from = 'from';
  static const String reply = 'reply';
  static const String replyAll = 'replyAll';
  static const String forward = 'forward';
  static const String requested = 'requested';
  static const String helpPageUrl = 'helpPageUrl';
  static const String healthKit = 'healthKit';
  static const String alarm = 'alarm';
  static const String addAlarm = 'addAlarm';
  static const String selectDays = 'selectDays';
  static const String alarmLabel = 'alarmLabel';
  static const String selectTime = 'selectTime';
  static const String autoLoad = 'autoLoad';
  static const String autoTagging = 'autoTagging';
  static const String termsAndConditionPageUrl = 'termsAndConditionPageUrl';
  static const String googleFit = 'googleFit';
  static const String chooseYourWeightTarget = 'chooseYourWeightTarget';
  static const String weightTarget = 'weightTarget';
  static const String weightSuggestion = 'weightSuggestion';
  static const String tagNoteDeletedSuccessfully = 'tagNoteDeletedSuccessfully';
  static const String maxWeight = 'maxWeight';
  static const String initialWeightTitle = 'initialWeightTitle';
  static const String syncHealthKit = 'syncHealthKit';
  static const String syncGoogleFit = 'syncGoogleFit';
  static const String chat = 'chat';
  static const String wifiConnect = 'UOFA';
  static const String library = 'library';
  static const String hrZone = 'Heart Rate Zones';
  static const String hrZoneHistory = 'HR Zone Report';
  static const String deletePermanently = 'deletePermanently';
  static const String shareWithUser = 'shareWithUser';
  static const String shareSuccessMessage = 'shareSuccessMessage';
  static const String shareFailureMessage = 'shareFailureMessage';
  static const String shareLink = 'shareLink';
  static const String createdFolderSuccessfully = 'createdFolderSuccessfully';
  static const String deletedFileFolderSuccessfully =
      'deletedFileFolderSuccessfully';
  static const String restoredFileFolderSuccessfully =
      'restoredFileFolderSuccessfully';
  static const String uploadedSuccessfully = 'uploadedSuccessfully';
  static const String errorWhileUploading = 'errorWhileUploading';
  static const String errorWhileDeleting = 'errorWhileDeleting';
  static const String yoursFilesAreUploading = 'yourFilesAreUploading';
  static const String sortBy = 'sortBy';
  static const String name = 'name';
  static const String lastModified = 'lastModified';
  static const String lastModifiedByMe = 'lastModifiedByMe';
  static const String lastOpenedByMe = 'lastOpenedByMe';
  static const String bin = 'bin';
  static const String shareWithMe = 'shareWithMe';
  static const String myDrive = 'myDrive';
  static const String searchInDrive = 'searchInDrive';
  static const String createNew = 'createNew';
  static const String create = 'create';
  static const String savedSurvey = 'savedsurvey';
  static const String sharedSurvey = 'sharedsurvey';
  static const String folder = 'folder';
  static const String upload = 'upload';
  static const String deleteDialogMessage = 'deleteDialogMessage';

  ///Added by shahzad
  ///Added on 21/09/2020
  /// Weight measurement strings
  static const String thin = 'thin';
  static const String low = 'low';
  static const String excellent = 'excellent';
  static const String obese = 'obese';
  static const String ideal = 'ideal';
  static const String overweight = 'overweight';
  static const String high = 'high';
  static const String alert = 'alert';
  static const String danger = 'danger';
  static const String bMI = 'bMI';
  static const String avgOfDay = 'avgOfDay';
  static const String avgOfWeek = 'avgOfWeek';
  static const String avgOfMonth = 'avgOfMonth';

  ///Added by shahzad
  ///Added on 28/10/2020
  /// Help page Strings
  static const String HGOverview = 'HGOverview';
  static const String HGIntro = 'HGIntro';
  static const String login = 'login';
  static const String loginInfo = 'loginInfo';
  static const String signUp = 'signUp';
  static const String signUpInfo = 'signUpInfo';
  static const String resetPassword = 'resetPassword';
  static const String resetPasswordInfo = 'resetPasswordInfo';
  static const String home = 'home';
  static const String homeInfo = 'homeInfo';
  static const String HGProfile = 'Profile';
  static const String profileInfo = 'profileInfo';
  static const String HGConnection = 'Connections';
  static const String connectionInfo = 'connectionInfo';
  static const String HGSettings = 'Settings';
  static const String settingsInfo = 'settingsInfo';
  static const String cardioMeasurement = 'cardioMeasurement';
  static const String cardioMeasurementInfo = 'cardioMeasurementInfo';
  static const String activityDay = 'activityDay';
  static const String activityDayInfo = 'activityDayInfo';
  static const String activityWeeklyMonthly = 'activityWeeklyMonthly';
  static const String activityWeeklyMonthlyInfo = 'activityWeeklyMonthlyInfo';
  static const String HGSleep = 'Sleep';
  static const String sleepInfo = 'sleepInfo';
  static const String HGTag = 'Tag';
  static const String tagInfo = 'tagInfo';
  static const String tagEditorList = 'TagEditorList';
  static const String tagEditorListInfo = 'tagEditorListInfo';
  static const String tagEditor = 'TagEditor';
  static const String tagEditorInfo = 'tagEditorInfo';
  static const String HGGraph = 'Graph';
  static const String graphInfo = 'graphInfo';
  static const String HGMeasurementHistory = 'MeasurementHistory';
  static const String measurementHistoryInfo = 'measurementHistoryInfo';
  static const String HGTagHistory = 'TagHistory';
  static const String tagHistoryInfo = 'tagHistoryInfo';
  static const String moreFunctions = 'moreFunctions';
  static const String HGFindBracelet = 'FindBracelet';
  static const String findBraceletInfo = 'findBraceletInfo';
  static const String HGliftTheWristBrighten = 'LiftTheWristBrighten';
  static const String liftTheWristBrightenInfo = 'liftTheWristBrightenInfo';
  static const String HGDoNotDisturb = 'DoNotDisturb';
  static const String doNotDisturbInfo = 'doNotDisturbInfo';
  static const String HGTimeFormat = 'TimeFormat';
  static const String timeFormatInfo = 'timeFormatInfo';
  static const String HGWearingMethod = 'WearingMethod';
  static const String wearingMethodInfo = 'wearingMethodInfo';
  static const String HGTraining = 'Training';
  static const String trainingInfo = 'trainingInfo';
  static const String HGhrMonitor = 'HRMonitor';
  static const String hrMonitorInfo = 'hrMonitorInfo';
  static const String imageLogin = 'imageLogin';
  static const String imageSignUp = 'imageSignUp';
  static const String imageResetPassword = 'imageResetPassword';
  static const String imageDashboard = 'imageDashboard';
  static const String imageProfile = 'imageProfile';
  static const String imageConnection = 'imageConnection';
  static const String imageSetting = 'imageSetting';
  static const String imageActivityDay = 'imageActivityDay';
  static const String imageActivityWeek = 'imageActivityWeek';
  static const String imageSleep = 'imageSleep';
  static const String imageTag = 'imageTag';
  static const String imageTagEditor = 'imageTagEditor';
  static const String imageTagUpdate = 'imageTagUpdate';
  static const String imageGraph = 'imageGraph';
  static const String imageMeasurementHistory = 'imageMeasurementHistory';
  static const String imageTagHistory = 'imageTagHistory';
  static const String imageDeviceManagement = 'imageDeviceManagement';
  static const String imageTraining = 'imageTraining';
  static const String imageFindBracelet = 'imageFindBracelet';
  static const String imageHourlyHR = 'imageHourlyHR';
  static const String imageWearingMethod = 'imageWearingMethod';
  static const String imageTimeFormat = 'imageTimeFormat';
  static const String imageDoNotDisturb = 'imageDoNotDisturb';
  static const String imageBrightenScreen = 'imageBrightenScreen';
  static const String initialWeightInfo = 'initialWeightInfo';
  static const String selectServer = 'selectServer';
  static const String temperatureMonitoring = 'temperatureMonitoring';
  static const String hrBPMonitoring = 'heartRateMonitoring';
  static const String trends = 'trends';
  static const String bpMonitoring = 'bpMonitoring';
  static const String hg08Name = 'hg08Name';
  static const String hg66Name = 'hg66Name';
  static const String hg80Name = 'hg80Name';
  static const String bluetooth = 'bluetooth';
  static const String feetShort = 'feetShort';
  static const String noConnectionMessage = 'noConnectionMessage';
  static const String addNewGraphTab = 'addNewGraphTab';
  static const String iAccept = 'iAccept';
  static const String weightMeasurementDialog = 'weightMeasurementDialog';
  static const String workoutRecord = 'workoutRecord';
  static const String pace = 'pace';
  static const String pace1 = 'pace1';

  static const String avgPace = 'avgPace';
  static const String avgPace1 = 'avgPace';
  static const String duration = 'duration';
  static const String startWorkout = 'startWorkout';
  static const String puase = 'pause';
  static const String friends = 'friends';
  static const String distanceKm = 'distanceKm';
  static const String morningWalk = 'morningWalk';
  static const String howWasYourRun = 'howWasYourRun';
  static const String typeNotesHere = 'typeNotesHere';
  static const String saveWorkout = 'saveWorkout';
  static const String forgotId = 'forgotId';
  static const String forgotPassword = 'password';
  static const String updateFirmware = 'updateFirmware';
  static const String emptyTrashNow = 'emptyTrashNow';
  static const String inboxIsEmpty = 'inboxIsEmpty';
  static const String sentIsEmpty = 'sentIsEmpty';
  static const String outboxIsEmpty = 'outboxIsEmpty';
  static const String draftIsEmpty = 'draftIsEmpty';
  static const String trashIsEmpty = 'trashIsEmpty';
  static const String firstNameValidation = 'firstNameValidation';
  static const String lastNameValidation = 'lastNameValidation';
  static const String termsOfService = 'termsOfService';
  static const String invitationAcceptedSuccessfully =
      'invitationAcceptedSuccessfully';
  static const String january = 'january';
  static const String february = 'february';
  static const String march = 'march';
  static const String april = 'april';
  static const String may = 'may';
  static const String june = 'june';
  static const String july = 'july';
  static const String august = 'august';
  static const String september = 'september';
  static const String october = 'october';
  static const String november = 'november';
  static const String december = 'december';
  static const String areYouReadyToEmptyYourTrash =
      'areYouReadyToEmptyYourTrash';
  static const String messageDeletedFromTrashSuccessfully =
      'messageDeletedFromTrashSuccessfully';
  static const String changePassword = 'changePassword';
  static const String voiceSetting = 'voiceSetting';
  static const String oldPassword = 'oldPassword';
  static const String confirmNewPassword = 'confirmNewPassword';
  static const String oldPasswordDoesNotMatch = 'oldPasswordDoesNotMatch';
  static const String enterHeight = 'enterHeight';
  static const String measurementType = 'measurementType';
  static const String notice = 'notice';
  static const String forgotUserId = 'forgotUserId';
  static const String downloadFirmware = 'downloadFirmware';
  static const String auto_sync_data = 'auto_sync_data';
  static const String onlyMe = 'onlyMe';
  static const String everyone = 'everyone';
  static const String saySomethingAboutThisPhoto = 'saySomethingAboutThisPhoto';
  static const String workoutPhotos = 'workoutPhotos';
  static const String basedOnYourMaxHeartRate = 'basedOnYourMaxHeartRate';
  static const String heartRateZones = 'heartRateZones';
  static const String earlier = 'earlier';
  static const String news = 'new';
  static const String notifications = 'notifications';
  static const String workoutFeeds = 'workoutFeeds';
  static const String comment = 'comment';
  static const String likes = 'likes';
  static const String viewAnalysis = 'viewAnalysis';
  static const String workoutAnalysis = 'workoutAnalysis';
  static const String elevation = 'elevation';
  static const String microphone = 'microphone';
  static const String resend = 'resend';
  static const String pleaseEnterTheSixDigitCodeSentToYourEmail =
      'pleaseEnterTheSixDigitCodeSentToYourEmail';
  static const String pleaseEnterTheSixDigitCodeSentToYourPhone =
      'pleaseEnterTheSixDigitCodeSentToYourPhone';
  static const String verify = 'verify';
  static const String pleaseEnterYourNewPassword = 'pleaseEnterYourNewPassword';
  static const String addPassword = 'addPassword';
  static const String verificationCode = 'verificationCode';
  static const String errorWhileRequestTryAgainLater =
      'errorWhileRequestTryAgainLater';
  static const String noRecordWithUserId = 'noRecordWithUserId';
  static const String incorrectUserId = 'incorrectUserId';
  static const String error = 'error';
  static const String noPhoneNumberAssociated = 'noPhoneNumberAssociated';
  static const String noEmailAssociated = 'noEmailAssociated';
  static const String whereAuthenticationCode = 'whereAuthenticationCode';
  static const String passwordChangedSuccessfully =
      'passwordChangedSuccessfully';
  static const String min8toMax20 = 'min8toMax20';
  static const String oneUppercase = 'oneUppercase';
  static const String oneLowercase = 'oneLowercase';
  static const String oneSpecialCharacter = 'oneSpecialCharacter';
  static const String oneNumber = 'oneNumber';
  static const String agree = 'agree';
  static const String disagree = 'disagree';
  static const String oldNewPassword = 'oldNewPassword';
  static const String hrvRmssd = 'hrvRmssd';
  static const String discardWorkout = 'discardWorkout';
  static const String areYouSureYouWantToDiscardTheWorkout =
      'areYouSureYouWantToDiscardTheWorkout';
  static const String pleaseConnectTheInternet = 'pleaseConnectTheInternet';
  static const String close = 'close';
  static const String maxSpeed = 'maxSpeed';

  static const String binary = 'Binary';
  static const String multipleChoices = 'MultipleChoices';
  static const String slider = 'Slider';
  static const String note = 'Note';
  static const String multipleAnswer = 'MultipleAnswer';

  static const String ble_devices = 'ble_devices';
  static const String transmit_command = 'transmit_command';
  static const String connect = 'connect';
  static const String device_connect_successfully =
      'device_connect_successfully';
  static const String enter = 'Enter';

  static const String consentTitle = 'consent_title';
  static const String cInfoTitle = 'c_info_title';
  static const String cInfoData = 'c_info_data';
  static const String cNoMedTitle = 'c_no_med_title';
  static const String cNoMedData = 'c_no_med_data';
  static const String cConsultTitle = 'c_consult_title';
  static const String cConsultData = 'c_consult_data';
  static const String cNoSubTitle = 'c_no_sub_title';
  static const String cNoSubData = 'c_no_sub_data';
  static const String cIndividualTitle = 'c_individual_title';
  static const String cIndividualData = 'c_individual_data';
  static const String cCheckMessage = 'c_check_message';
  static const String consentEnd = 'consent_end';
  static const String accept = 'accept';
  static const String decline = 'decline';

  /// Added by: Akhil
  /// Added on: May/28/2020
  /// Method to map different languages which the app supports
  static final Map<String, Map<String, String>> _localizedValues = {
    kLanguageHindi: HindiLocalization.getLocalization,
    kLanguageEnglish: EnglishLocalization.getLocalization,
    kLanguageFrench: FrenchLocalization.getLocalization
  };

  String getTextFromEnglish(String value) {
    String tag = '';
    EnglishLocalization.getLocalization.forEach((k, v) {
      v == value ? tag = k : null;
    });
    FrenchLocalization.getLocalization.forEach((k, v) {
      v == value ? tag = k : null;
    });
    if (tag == null || tag.trim().isEmpty)
      return value;
    else
      return getText(tag);
  }

  /// Added by: Akhil
  /// Added on: May/28/2020
  /// Method to get value of particular key in language which is selected by user
  /// @return: String according to the language selected.
  String getText(String tag) {
    if (_localizedValues.containsKey(locale.languageCode) &&
        _localizedValues[locale.languageCode]!.containsKey(tag)) {
      return _localizedValues[locale.languageCode]![tag] ?? '?>?';
    } else {
      return '???';
    }
  }
}
