import 'package:flutter/widgets.dart';
import 'package:health_gauge/resources/db/app_preferences_handler.dart';
import 'package:health_gauge/services/core_util/app_init_logs.dart';
import 'package:health_gauge/services/firebase/firestore_credentials.dart';
import 'package:health_gauge/services/firebase/model/app_credential.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/services/navigator/domain/domain_service_contract.dart';
import 'package:health_gauge/services/navigator/helpers/navigator_helper.dart';
import 'package:health_gauge/services/navigator/helpers/navigator_utils.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/reminder_notification.dart';
import 'package:rxdart/rxdart.dart';

class AppService {
  AppService._privateConstructor();

  String tag = 'AppService';
  static final AppService getInstance = AppService._privateConstructor();

  // ignore: close_sinks
  BehaviorSubject<bool> isTutorialVisible = BehaviorSubject<bool>();

  bool _isPreInitialised = false;


  /// Which,
  ///
  /// Map of domains,
  /// Responsible of providing name and contract for requested domain
  final Map<NavigationDomains, DomainServiceContract> _domainContracts = {};

  Future<void> _initConfig() async {
    AppInitLogs.instance.log('fetchCredentials-init-start');
    var _appCredential = await FirestoreCredentials().fetchCredentials();
    AppInitLogs.instance.log('fetchCredentials-init-end');
    AppInitLogs.instance.log('fetchCredentials-domains-init-start');
    for (var domain in getSupportedDomains()) {
      if (_appCredential != null) {
        // Get domain name from key
        var domainName = getDomainNameString(domain);
        var domainConfig = _appCredential.domainConfig![domainName];
        await _updateDomainContracts(
            domain: domain, domainConfig: domainConfig);
      }
    }
    AppInitLogs.instance.log('fetchCredentials-domains-init-end');
  }

  //Update the domainConfig in domain's contract (i.e in _domainContracts)
  Future<void> _updateDomainContracts(
      {NavigationDomains? domain, DomainConfig? domainConfig}) async {
    if (domainConfig != null) {
      if (_domainContracts[domain!] != null) {
        _domainContracts[domain]?.domainConfig = domainConfig;
      }
    }
  }

  Future<bool> preInit(BuildContext context) async {
    if (_isPreInitialised) return true;
    AppInitLogs.instance.log('app-preInit-start');

    AppInitLogs.instance.log('app-preInit-AppPreferencesHandler-start');
    await AppPreferencesHandler().appInit();
    AppInitLogs.instance.log('app-preInit-AppPreferencesHandler-end');

    AppInitLogs.instance.log('app-preInit-initConfig-start');
    await _initConfig();
    AppInitLogs.instance.log('app-preInit-initConfig-end');

    AppInitLogs.instance.log('app-preInit-database-start');
    await dbHelper.database;
    AppInitLogs.instance.log('app-preInit-database-end');

    /// Which,
    ///
    /// Check for update and returns TRUE if there will be an update
    var isForceUpdate = await FirestoreCredentials().isForceUpdate();

    /// Stop service initialization,
    /// Return false in case of having an app update

    if (isForceUpdate) {
      LoggingService().printLog(tag: tag, message: 'App having Force-Update');
      return false;
    }

    /// Returning true, As all the services are initialised
    _isPreInitialised = true;
    AppInitLogs.instance.log('app-preInit-end');
    return true;

  }

  Future<void> postInit(BuildContext context) async {}

  Future<void> init(BuildContext context) async {
    // await connections.requestHealthKitOrGoogleFitAuthorization();
    // LocationUtils().checkPermission(context);
  }

  Future<bool> isUserLoggedIn() async {
    try {
      var userId = await AppPreferencesHandler().getUserId();
      var token = await AppPreferencesHandler().getToken();
      if (token.trim().isNotEmpty) {
        Constants.authToken = token;
        Constants.header = {
          'Authorization': '${Constants.authToken}',
          'Content-Type': 'application/json',
        };
      }
      print('Auth token : ${Constants.authToken}');
      if (userId.trim().isNotEmpty) {
        AppPreferencesHandler().updateMeasurementType(1);
        LoggingService().setUserInfo(userId);
        LoggingService().info(
            'Sign In', 'Auto SignIn successful opening connection screen');
        return true;
      }
    } catch (e) {
      LoggingService().warning('SignIn ', 'Exception', error: e);
    }
    return false;
  }

  Future<void> logoutUser() async {
    try {
      var userId = await AppPreferencesHandler().getUserId();
      await ReminderNotification.cancelUserAllCustomReminder(userId);
      ReminderNotification.disableAllNotification();
      preferences?.remove(Constants.prefsLastSyncTimeStamp);
      preferences?.remove(Constants.prefUserPasswordKey);
      preferences?.remove(Constants.prefSavedStepTarget);
      preferences?.remove(Constants.prefSavedSleepTarget);
      preferences?.remove(Constants.prefUserIdKeyInt);
      preferences?.remove(Constants.prefLoginResponse);
      preferences?.remove(Constants.prefTokenKey);
      preferences?.remove(Constants.prefKeyForGraphWindowTemp);
      preferences?.remove(Constants.toggleSwitch);
      var email = preferences?.getString(Constants.storedUserId);
      var password = preferences?.getString(Constants.storedPassword);
      var rememberMe = preferences?.getBool(Constants.rememberMe);
      var device = preferences?.getString(Constants.connectedDeviceAddressPrefKey);
      var selectedUrl = preferences?.getString(Constants.prefServerType) ?? '';
      await AppPreferencesHandler().clearAllPreferences();
      preferences?.clear();
      preferences?.setString(Constants.prefServerType, selectedUrl);
      preferences?.setString(Constants.storedUserId, email ?? '');
      preferences?.setString(Constants.storedPassword, password ?? '');
      preferences?.setBool(Constants.rememberMe, rememberMe ?? false);
      preferences?.setString(Constants.connectedDeviceAddressPrefKey, device ?? '');
      dbHelper.clearDatabase();
    } catch (e) {
      LoggingService().printLog(tag: 'LogoutUser', message: e.toString());
    }
  }
}
