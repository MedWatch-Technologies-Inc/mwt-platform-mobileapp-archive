import 'package:health_gauge/services/core_util/prefrences_util.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class AppPreferencesHandler {
  static final AppPreferencesHandler _instance = AppPreferencesHandler._();

  AppPreferencesHandler._();

  factory AppPreferencesHandler() {
    return _instance;
  }

  int _weightUnit = 0;
  int _heightUnit = 0;
  int _tempUnit = 0;
  int _distanceUnit = 0;
  int _timeUnit = 0;
  int _bloodGlucoseUnit = 0;
  bool _rememberMe = false;
  String _storedPassword = '';
  String _storedUserId = '';
  int _measurementType = 1;
  String _firebaseMessagingToken = '';
  String _prefUserId = '';
  String _prefEmail = '';
  String _prefUserName = '';
  String _password = '';

  // int get weightUnit => _weightUnit;
  //
  // int get heightUnit => _heightUnit;
  //
  // int get tempUnit => _tempUnit;
  //
  // int get distanceUnit => _distanceUnit;
  //
  // int get timeUnit => _timeUnit;
  //
  // int get bloodGlucoseUnit => _bloodGlucoseUnit;

  bool get rememberMe => _rememberMe;

  String get storedPassword => _storedPassword;

  String get storedUserId => _storedUserId;

  int get measurementType => _measurementType;

  String get firebaseMessagingToken => _firebaseMessagingToken;

  String get prefUserId => _prefUserId;

  String get prefEmail => _prefEmail;

  String get prefUserName => _prefUserName;

  String get password => _password;

  // User Auth
  static final String _storedUserIdKey = 'storedUserId';
  static final String _storedPasswordKey = 'storedPassword';
  static final String _firebaseMessagingTokenKey = 'firebaseMessagingToken';
  static final String _prefUserIdKeyIntKey = 'pref_user_id';
  static final String _prefUserEmailKeyKey = 'pref_email';
  static final String _prefUserNameKey = 'pref_user_name';
  static final String _prefUserPasswordKey = 'password';
  static final String _prefTokenKey = 'Token';

  // Basic keys
  static final String _weightUnitKey = 'wightUnit';
  static final String _mHeightUnitKey = 'mHeightUnit';
  static final String _mDistanceUnitKey = 'mDistanceUnit';
  static final String _mTemperatureUnitKey = 'mTemperatureUnit';
  static final String _mTimeUnitKey = 'mTimeUnit';
  static final String _bloodGlucoseUnitKey = 'bloodGlucoseUnitKey';
  static final String _rememberMeKey = 'rememberMe';
  static final String _measurementTypeKey = 'measurementType';

  Future<void> appInit() async {
    _weightUnit =
        await PreferencesUtil().getInt(_weightUnitKey, defaultValue: 0);
    _heightUnit =
        await PreferencesUtil().getInt(_mHeightUnitKey, defaultValue: 0);
    _tempUnit =
        await PreferencesUtil().getInt(_mTemperatureUnitKey, defaultValue: 0);
    _distanceUnit =
        await PreferencesUtil().getInt(_mDistanceUnitKey, defaultValue: 0);
    _timeUnit = await PreferencesUtil().getInt(_mTimeUnitKey, defaultValue: 0);
    _bloodGlucoseUnit =
        await PreferencesUtil().getInt(_bloodGlucoseUnitKey, defaultValue: 0);
    _rememberMe =
        await PreferencesUtil().getBool(_rememberMeKey, defaultValue: false);
    _storedUserId =
        await PreferencesUtil().getString(_storedUserIdKey, defaultValue: '');
    _storedPassword =
        await PreferencesUtil().getString(_storedPasswordKey, defaultValue: '');
    _measurementType =
        await PreferencesUtil().getInt(_measurementTypeKey, defaultValue: 1);
    _firebaseMessagingToken = await PreferencesUtil()
        .getString(_firebaseMessagingToken, defaultValue: '');
    _prefUserId = await PreferencesUtil()
        .getString(_prefUserIdKeyIntKey, defaultValue: '');
    _prefEmail = await PreferencesUtil()
        .getString(_prefUserEmailKeyKey, defaultValue: '');
    _prefUserName =
        await PreferencesUtil().getString(_prefUserNameKey, defaultValue: '');
    _password = await PreferencesUtil()
        .getString(_prefUserPasswordKey, defaultValue: '');
    // TODO remove global keys logic from here
    weightUnit = _weightUnit;
    heightUnit = _heightUnit;
    tempUnit = _tempUnit;
    distanceUnit = _distanceUnit;
    timeUnit = _timeUnit;
    bloodGlucoseUnit = _bloodGlucoseUnit;
  }

  Future<void> clearAllPreferences() async {
    await PreferencesUtil().clearAll();
    await appInit();
  }

  Future<String> getUserId() async {
    return await PreferencesUtil().getString(_prefUserIdKeyIntKey, defaultValue: '');
  }


  Future<String> getToken() async {
    return await PreferencesUtil().getString(_prefTokenKey, defaultValue: '');
  }


  void updateWeightUnit(int weightUnit) {
    _weightUnit = weightUnit;
    PreferencesUtil().setInt(_weightUnitKey, value: weightUnit);
  }

  void updateHeightUnit(int heightUnit) {
    _heightUnit = heightUnit;
    PreferencesUtil().setInt(_mHeightUnitKey, value: weightUnit);
  }

  void updateTempUnit(int tempUnit) {
    _tempUnit = _tempUnit;
    PreferencesUtil().setInt(_mTemperatureUnitKey, value: weightUnit);
  }

  void updateDistanceUnit(int distanceUnit) {
    _distanceUnit = distanceUnit;
    PreferencesUtil().setInt(_mDistanceUnitKey, value: distanceUnit);
  }

  void updateTimeUnit(int timeUnit) {
    _timeUnit = timeUnit;
    PreferencesUtil().setInt(_mTimeUnitKey, value: _timeUnit);
  }

  void updateBloodGlucoseUnit(int bloodGlucoseUnit) {
    _bloodGlucoseUnit = bloodGlucoseUnit;
    PreferencesUtil().setInt(_bloodGlucoseUnitKey, value: 0);
  }

  void updateRememberMe(bool value) {
    _rememberMe = value;
    PreferencesUtil().setBool(_rememberMeKey, value: value);
  }

  void updateStoredUserId(String userId) {
    _storedUserId = userId;
    PreferencesUtil().setString(_storedUserIdKey, value: userId);
  }

  void updateStoredPassword(String password) {
    _storedPassword = password;
    PreferencesUtil().setString(_storedPassword, value: password);
  }

  void updateMeasurementType(int type) {
    _measurementType = type;
    PreferencesUtil().setInt(_measurementTypeKey, value: type);
  }

  void updateFirebaseMessagingToken(String token) {
    _firebaseMessagingToken = token;
    PreferencesUtil().setString(_firebaseMessagingTokenKey, value: token);
  }

  void updatePrefUserId(String userId) {
    _prefUserId = userId;
    PreferencesUtil().setString(_prefUserIdKeyIntKey, value: userId);
  }

  void updatePrefUserName(String userName) {
    _prefUserName = userName;
    PreferencesUtil().setString(_prefUserNameKey, value: userName);
  }

  void updatePrefEmail(String email) {
    _prefEmail = email;
    PreferencesUtil().setString(_prefUserEmailKeyKey, value: email);
  }

  void updatePassword(String password) {
    _password = password;
    PreferencesUtil().setString(_prefUserPasswordKey, value: password);
  }

  Future<void> saveUnitInServer() async {
    var list = <MeasurementData>[];
    var userId = await PreferencesUtil()
        .getString(Constants.prefUserIdKeyInt, defaultValue: '????');

    list.add(MeasurementData(
      userID: userId,
      measurement: _weightUnitKey,
      unit: _weightUnit == 0 ? StringLocalization.kg : StringLocalization.lb,
      value: _weightUnit.toString(),
    ));

    list.add(MeasurementData(
      userID: userId,
      measurement: _mDistanceUnitKey,
      unit: _distanceUnit == 0
          ? StringLocalization.km
          : StringLocalization.mileage,
      value: _distanceUnit.toString(),
    ));

    list.add(MeasurementData(
      userID: userId,
      measurement: _mTemperatureUnitKey,
      unit: _tempUnit == 0
          ? StringLocalization.celsiusShort
          : StringLocalization.fahrenheitShort,
      value: _tempUnit.toString(),
    ));

    list.add(MeasurementData(
      userID: userId,
      measurement: _mTimeUnitKey,
      unit: _timeUnit == 0
          ? StringLocalization.twelve
          : StringLocalization.twentyFour,
      value: _timeUnit.toString(),
    ));

    list.add(MeasurementData(
      userID: userId,
      measurement: _bloodGlucoseUnitKey,
      unit: _bloodGlucoseUnit == 0
          ? StringLocalization.MMOL
          : StringLocalization.MGDL,
      value: _bloodGlucoseUnit.toString(),
    ));

    //TODO replace it with dio api call
    // Units()
    //     .setUnit('${Constants.baseUrl}SetMeasuremetnUnit', {'UnitData': list});
  }
}

class MeasurementData {
  String userID;
  String measurement;
  String unit;
  String value;

  MeasurementData(
      {required this.userID,
      required this.measurement,
      required this.unit,
      required this.value});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['UserID'] = userID;
    data['Measurement'] = measurement;
    data['Unit'] = unit;
    data['Value'] = value;
    return data;
  }
}
