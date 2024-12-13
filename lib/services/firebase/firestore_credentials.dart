import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/source.dart'
    as firebaseSource;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:health_gauge/services/core_util/app_init_logs.dart';
import 'package:health_gauge/services/core_util/device_utils.dart';
import 'package:health_gauge/services/firebase/model/app_credential.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/services/storage/storage_service.dart';

const kFireStoreEnvironmentChannel = 'development';

/// Singleton,
///
/// Responsible to fetch/set configuration from firestore
class FirestoreCredentials {
  factory FirestoreCredentials() {
    return _singleton;
  }

  FirestoreCredentials._privateConstructor();

  static final FirestoreCredentials _singleton =
      FirestoreCredentials._privateConstructor();
  String logTag = 'AppCredentials';
  Map<String, Map<String, dynamic>?> tempCredentialsHash = {};

  //****** Start ******
  //****** Match with Firestore ******
  final String _appConfigurationKey = 'appConfiguration';
  final String _pemPathKey = 'pemPath';
  final String _configPathKey = 'configPath';
  final String _pemKey = 'pem';

//****** End ******
//****** Match with Firestore ******
//****** End ******

  //User default keys
  final String _appConfigurationLastUpdateTimeKey =
      'firestoreAppConfigurationLastUpdateTime';
  final String _credentialsSavedAppVersionCode =
      'credentialsSavedAppVersionCode';

  //Secure enclave and user default keys for firestore data saving,
  // *** "appDomainConfiguration" is also used in the IOS native code for common domain -> api key.
  // For logger service api
  final String _appDomainConfigKey = 'appDomainConfiguration';
  final String _appModelConfigKey = 'appModelConfiguration';

  final Connectivity _connectivity = Connectivity();
  StorageService? _storageService;
  AppCredential? _appCredential;


  /// Which,
  ///
  /// Find current app version in valid versions list,
  /// If current version is available, return => TRUE
  /// Else returns => FALSE
  Future<bool> isForceUpdate() async {
    var currVersionCode = await _getVersionCode();
    return _appCredential?.modelConfig
        ?.firstWhere((version) => version.code == currVersionCode) ==
        null;
  }

  Future<bool> isUpdateAvailable() async {
    var currVersionCode = await _getVersionCode();
    var latestVersion = _appCredential?.modelConfig
        ?.map((e) => e.code)
        .reduce((value, element) {
      return max(value!, element!);
    });
    return (currVersionCode != latestVersion);
  }

  // Which returns current app version code
  Future<int?> _getVersionCode() async {
    int versionCode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var code = SystemInfoHelpers.getInstance.buildNumber;
      return int.tryParse(code ?? '1');
    } on PlatformException {
      versionCode = 1;
    }

    return versionCode;
  }


  // This function will provide the credentials,
  // This can be fetching them from the firestore server or secure enclave (after decrypt)
  // Set isForceFirestoreUpdate = true, if you want to fetch firestore credentials everytime,
  // irrespective of any fetch logic
  Future<AppCredential?> fetchCredentials(
      {bool isForceFirestoreUpdate = false}) async {
    _storageService = StorageService.getInstance;

    var isRequired = isForceFirestoreUpdate
        ? true
        : await _isAppConfigurationUpdateRequired();
    final result = await _connectivity.checkConnectivity();
    final isNetworkConnected = !(result == ConnectivityResult.none);
    AppInitLogs.instance.log(
        'fetchCredentials-init: Firestore update required - $isRequired and network connected - $isNetworkConnected');

    if (isRequired && isNetworkConnected) {
      // We are here means,
      // We need to sync data with server

      // This is to check whether we have data in cache or not
      var domainConfigData = await _storageService!
          .readSecureStorageData(_appDomainConfigKey, isDecrypted: true);
      if (domainConfigData == null) {
        // We are here means,
        // We don't have data in cache,
        // We wait and download/save data from server
        await _handleOnlineMode();
      } else {
        // We are here means,
        // We have data in cache,
        // Hence, Will return cache data AND download/save from server
        await _handleOfflineMode();
        _handleOnlineMode();
      }
    } else {
      // We are here means,
      // We don't need to sync data with server,
      // Hence, Will return data from cache
      await _handleOfflineMode();
    }
    return _appCredential;
  }

  //Fetch online and handle the fallback conditions if any error while fetching
  Future<void> _handleOnlineMode({alreadyTriedOfflineMode = false}) async {
    var logStopWatch = Stopwatch();
    logStopWatch.start();

    try {
      AppInitLogs.instance.log('app-preInit-signInAnonymously-start');
      await _signInUser();
      AppInitLogs.instance.log('app-preInit-signInAnonymously-end');
      _appCredential = await _fetchCredentialsOnlineMode();
      if (!alreadyTriedOfflineMode) {
        //Logging included with case, where alreadyTriedOfflineMode = true
        LoggingService().logMessage(
            '*** $logTag *** Fetched From Firebase -> escapedTime:${logStopWatch.elapsedMilliseconds} ms');
      }
    } on FirebaseException catch (fException){
      // If online data not available for any reason fetch offline.
      if (!alreadyTriedOfflineMode) {
        _appCredential = await _fetchCredentialsOfflineMode();
        var finalMessage =
            'First Tried to fetch from Firebase, but was not available, so fetched from App Cache';
        LoggingService().logMessage(
            '*** $logTag *** $finalMessage -> escapedTime:${logStopWatch.elapsedMilliseconds} ms');
      }

      //If not having data offline also
      if (_appCredential == null) {
        rethrow;
      }
    } finally {
      logStopWatch.stop();
    }
  }

  //Fetch offline and handle the fallback conditions if any error while fetching
  Future<void> _handleOfflineMode() async {
    var logStopWatch = Stopwatch();
    logStopWatch.start();

    var finalMessage = 'Fetched From App Cache';
    _appCredential = await _fetchCredentialsOfflineMode();

    if (_appCredential == null) {
      // If offline data not available for any reason fetch online.
      await _handleOnlineMode(alreadyTriedOfflineMode: true);
      finalMessage =
          'First Tried to fetch from App Cache. Cache was not available, so fetched from firebase online';
    }

    logStopWatch.stop();
    LoggingService().logMessage(
        '*** $logTag *** $finalMessage -> escapedTime:${logStopWatch.elapsedMilliseconds} ms');
  }

  Future<AppCredential?> _fetchCredentialsOnlineMode() async {
    AppInitLogs.instance
        .log('fetchCredentials-init:fetch-from-firestore-start');
    try {
      _appCredential = await _fetchCredentialsFromFirestore();
      await _storeAppConfigurationAndUpdateLastUpdateDetails();
    } on FirebaseException {
      // Setting _appCredential = null
      // Might not  updated all paths(pem and config) in the credentials.
      _appCredential = null;
      AppInitLogs.instance.log(
          'fetchCredentials-init:fetch-from-firestore-end:Exception thrown');
      rethrow;
    }
    AppInitLogs.instance.log('fetchCredentials-init:fetch-from-firestore-end');
    return _appCredential;
  }

  Future<AppCredential?> _fetchCredentialsOfflineMode() async {
    AppInitLogs.instance
        .log('fetchCredentials-init:fetch-from-secureEnclave-start');

    ///Fetch and Update domain config
    var domainConfigData = await _storageService!
        .readSecureStorageData(_appDomainConfigKey, isDecrypted: true);

    if (domainConfigData == null) {
      return _appCredential;
    }

    Map<String, dynamic>? decodedData = await json.decode(domainConfigData);
    var tempDomainConfig = <String, DomainConfig>{};
    if (decodedData != null && decodedData.isNotEmpty) {
      decodedData.forEach((key, value) {
        var domainValue = DomainConfig.fromJson(value);
        tempDomainConfig.addAll({key: domainValue});
      });
    }

    ///Fetch and Update model config
    var modelConfigData = await _storageService!.getPrefs(_appModelConfigKey);
    if (modelConfigData == null) {
      return _appCredential;
    }
    var modelDecodedData = await json.decode(modelConfigData);
    modelDecodedData = modelDecodedData.map<ModelConfig>((data) {
      return ModelConfig.fromJson(data);
    }).toList();
    if (tempDomainConfig.isNotEmpty &&
        modelDecodedData != null &&
        modelDecodedData.isNotEmpty) {
      _appCredential = AppCredential(
        domainConfig: tempDomainConfig,
        modelConfig: modelDecodedData,
      );
    }
    AppInitLogs.instance
        .log('fetchCredentials-init:fetch-from-secureEnclave-end');

    return _appCredential;
  }

  Future<void> _storeAppConfigurationAndUpdateLastUpdateDetails() async {
    //Save in secure enclave encrypted
    var jsonEncodedDomainConfig = json.encode(_appCredential?.domainConfig);
    var jsonEncodedModelConfig = json.encode(_appCredential?.modelConfig);

    if (jsonEncodedDomainConfig.trim().isNotEmpty &&
        jsonEncodedModelConfig.trim().isNotEmpty) {
      AppInitLogs.instance.log(
          'fetchCredentials-init:saving-firebase-fetched-data-app-side-start');
      await _storageService!.setSecureStorageData(
          _appDomainConfigKey, jsonEncodedDomainConfig,
          isEncrypted: true);

      _storageService!.setPrefs(_appModelConfigKey, jsonEncodedModelConfig);

      final currentUTCTime = DateTime.now().toUtc();
      //update current utc time in last updated time for app configuration
      _storageService!.setPrefs(
          _appConfigurationLastUpdateTimeKey, currentUTCTime.toString());

      AppInitLogs.instance.log(
          'fetchCredentials-init:saving-firebase-fetched-data-app-side-end');
    }
  }

  ///************** Start **************//
  ///************** Methods to fetch Credentials from firestore ***************//
  Future<AppCredential?> _fetchCredentialsFromFirestore() async {
    //Fetch the app configuration form server
    var option = GetOptions(source: firebaseSource.Source.server);
    var documentSnapshot = await FirebaseFirestore.instance
        .collection(kFireStoreEnvironmentChannel)
        .doc(_appConfigurationKey)
        .get(option);

    var firestoreData = documentSnapshot.data()!;
    _appCredential = AppCredential.fromJson(firestoreData);
    await _updateCredentialsPath();
    return _appCredential;
  }

  Future<Map<String, dynamic>?> _fetchConfigDocumentFromFirebase(
      DocumentReference documentReference) async {
    var path = documentReference.path;
    var option = GetOptions(source: firebaseSource.Source.server);
    var documentSnapshot = await FirebaseFirestore.instance
        .collection(kFireStoreEnvironmentChannel)
        .doc('$_appConfigurationKey/$path')
        .get(option);

    var configData = documentSnapshot.data();
    tempCredentialsHash[documentReference.path] = configData;
    return configData;
  }

  Future<Map<String, dynamic>?> _fetchConfigDocument(
      DocumentReference documentReference) async {
    var configData;
    if (tempCredentialsHash.containsKey(documentReference.path)) {
      configData = tempCredentialsHash[documentReference.path];
    }

    configData ??= await _fetchConfigDocumentFromFirebase(documentReference);
    return configData;
  }

  ///************** END **************//

  ///************** Start **************//
  ///************** Methods to Manipulate Credentials fetched from firestore ***************//

  ///Update the PemPath and configPath with values
  Future<void> _updateCredentialsPath() async {
    if (_appCredential == null) {
      return;
    }

    for (var domainKey in _appCredential!.domainConfig!.keys) {
      //Check such path reference exists, then only go head to update it.
      var domainCredentials =
          _appCredential!.domainConfig![domainKey]!.credentials!;
      if (domainCredentials.containsKey(_pemPathKey) ||
          domainCredentials.containsKey(_configPathKey) ||
          domainCredentials.containsKey(_pemKey)) {
        var domainConfig = _appCredential?.domainConfig![domainKey];
        await _updateDomainConfig(
            domainName: domainKey, domainConfig: domainConfig);
      }
    }
  }

  //Update the domainConfig in domain's contract (i.e in _domainContracts)
  Future<void> _updateDomainConfig(
      {String? domainName, DomainConfig? domainConfig}) async {
    if (domainConfig != null) {
      //On firestore we have reference to Configurations and Pem (configPath and pemPath keys).
      //So to access configs and pem data, we need to fetch from references and update them on credentials directly.
      domainConfig = await _updateConfigPathInDomainConfig(
          domainName: domainName, domainConfig: domainConfig);
      domainConfig = await _updatePemPathInDomainConfig(
          domainName: domainName, domainConfig: domainConfig);

      //Update credentials for Pem format.
      //The pem key can be present directly or as pemPath.So update it at last before final setting on domain config.
      if (domainConfig.credentials!.containsKey(_pemKey)) {
        domainConfig.credentials![_pemKey] =
            _formatRequiredPem(domainConfig.credentials![_pemKey]);
      }
    }
  }

  ///On firestore we have reference to Configurations (configPath).
  ///So to access configs, we need to fetch from references and update them on credentials directly.
  Future<DomainConfig> _updateConfigPathInDomainConfig(
      {required DomainConfig domainConfig, String? domainName}) async {
    //Fetch the configs and update them
    if (domainConfig.credentials!.containsKey(_configPathKey)) {
      //Update the configs if configPath exists and remove the configPath so avoid confusion.
      var documentRef =
          domainConfig.credentials![_configPathKey] as DocumentReference;
      var data = await _fetchConfigDocument(documentRef);
      if (data != null) {
        //Add all data set from config to credentials
        domainConfig.credentials!.addAll(data);
      } else {
        LoggingService().logMessage(
            ':::ServiceHelper/FetchFirestoreConfiguration:::Not able to get "$domainName" domain configuration. Please verify on firestore path ===> On domain  "$domainName" ===> for "$_configPathKey" key ');
      }
      domainConfig.credentials?.remove(_configPathKey);
    }
    return domainConfig;
  }

  ///On firestore we have reference to  Pem  pemPath keys).
  ///So to access pem data, we need to fetch from references and update them on credentials directly.
  Future<DomainConfig> _updatePemPathInDomainConfig(
      {required DomainConfig domainConfig, String? domainName}) async {
    //Fetch the pem and update them

    if (domainConfig.credentials!.containsKey(_pemPathKey)) {
      //Update the pem if pemPath exists and remove the pemPath so avoid confusion.
      var documentRef =
          domainConfig.credentials![_pemPathKey] as DocumentReference;
      var data = await _fetchConfigDocument(documentRef);
      if (data != null) {
        if (data.containsKey(_pemKey)) {
          domainConfig.credentials![_pemKey] = data[_pemKey];
        } else {
          LoggingService().logMessage(
              ':::ServiceHelper/FetchFirestoreConfiguration:::Not able to get "$domainName" domain configuration. Please verify on firestore ===> On domain "$domainName" ===> for "$_pemPathKey" key ==> "$_pemKey" key is set');
        }
      } else {
        LoggingService().logMessage(
            ':::ServiceHelper/FetchFirestoreConfiguration:::Not able to get "$domainName" pem configuration. Please verify on firestore path ===> On domain  "$domainName" ===> for "$_pemPathKey" key');
      }
      domainConfig.credentials?.remove(_pemPathKey);
    }
    return domainConfig;
  }

  String _formatRequiredPem(String? serverPem) {
    return '-----BEGIN CERTIFICATE-----\n$serverPem\n-----END CERTIFICATE-----';
  }

  ///************** End **************//

  ///************** Start **************//
  ///************** App Logic **************//
  ///Update configuration from firestore with 1 day difference.
  Future<bool> _isAppConfigurationUpdateRequired() async {
    final _lastUpdatedTime =
        await _storageService!.getPrefs(_appConfigurationLastUpdateTimeKey);
    var isRequired = true;

    var _versionUpdateRequired =
        await _isAppConfigurationUpdateRequiredVersionCheck();
    if (_versionUpdateRequired) {
      // Clear existing data to refer remote data
      await _storageService!.removeSecureStorageData(_appDomainConfigKey);
      return true;
    }

    //1 day passed
    if (_lastUpdatedTime != null) {
      final currentUTCTime = DateTime.now().toUtc();
      final parsedLastUpdatedTime = DateTime.parse(_lastUpdatedTime);

      //if difference is more than 1 day updated the credentials again.
      final aDayAfterLastUpdatedTime =
          parsedLastUpdatedTime.add(Duration(days: 1, hours: 0));
      final isBefore = currentUTCTime.isBefore(aDayAfterLastUpdatedTime);
      if (isBefore) {
        isRequired = false;
      }
    }
    return isRequired;
  }

  Future<bool> _isAppConfigurationUpdateRequiredVersionCheck() async {
    var isRequired = true;

    //If build updated
    var _savedAppVersionCode =
        await _storageService!.getPrefs(_credentialsSavedAppVersionCode);
    var _currentAppVersionCode =
        await _getVersionCode();

    if (_currentAppVersionCode != null &&
        _savedAppVersionCode != null &&
        _currentAppVersionCode == _savedAppVersionCode) {
      isRequired = false;
      return isRequired;
    }

    if (_currentAppVersionCode != null &&
        _currentAppVersionCode != _savedAppVersionCode) {
      _storageService!
          .setPrefs(_credentialsSavedAppVersionCode, _currentAppVersionCode);
    }

    return isRequired;
  }

  ///************** END **************//

  ///
  /// Performs the Firebase signin
  ///
  Future<void> _signInAnonymously() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<void> _signInUser() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: 'anshul.arora@daffodilsw.com', password: 'Test1234');
  }
}
