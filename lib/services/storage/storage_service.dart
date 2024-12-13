import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health_gauge/services/core_util/device_utils.dart';
import 'package:health_gauge/services/core_util/prefrences_util.dart';
import 'package:health_gauge/services/logging/logging_service.dart';

import 'data_encryption.dart';

class StorageService {
  FlutterSecureStorage? _secureStorage;
  final String logTag = 'StorageService: ';

  static final StorageService getInstance =
      StorageService._privateConstructor();

  StorageService._privateConstructor() {
    _initSecureStorage();
  }

  Future _initSecureStorage() async {
    // Create storage
    _secureStorage ??= FlutterSecureStorage();
  }

  void setPrefs<T>(String? key, T content) async {
    if (content is String) {
      await PreferencesUtil().setString(key!, value: content);
    } else if (content is bool) {
      await PreferencesUtil().setBool(key!, value: content);
    } else if (content is int) {
      await PreferencesUtil().setInt(key!, value: content);
    } else if (content is double) {
      await PreferencesUtil().setDouble(key!, value: content);
    } else if (content is List<String>) {
      await PreferencesUtil().setStringList(key!, value: content);
    } else if (content is List<Map<String, dynamic>>) {
      await PreferencesUtil().setString(key!, value: json.encode(content));
    }
  }

  dynamic getPrefs(String key, {dynamic defaultValue}) async {
    if (await PreferencesUtil().containsKey(key)) {
      return PreferencesUtil().get(key);
    } else {
      return defaultValue;
    }
  }

  Future<bool> removePrefs(String key) async {
    return await PreferencesUtil().remove(key);
  }

  //Adding the bundle id as prefix and random value as suffix for all keys of secure storage. To make them unique.
  //Specially can say for IOS extension to work for different environment(dev,sit etc) apps together on a device.
  Future<String> _getFormattedKey(String key) async {
    var finalKey = key;
    //Don't modify randomValue value
    //Same values are used on Ios Native code to fetch the credentials for push notification.
    const randomValue = '8102505662';
    var bundleId = SystemInfoHelpers.getInstance.appId;
    if (bundleId != null) {
      finalKey = '$bundleId.$finalKey.$randomValue';
    }
    return finalKey;
  }

  //Keeping isEncrypted false as default.
  //The key is internally modified before using.
  Future<void> setSecureStorageData(String key, String value,
      {bool isEncrypted = false}) async {
    // Write value
    try {
      String? finalValue = value;
      if (isEncrypted) {
        finalValue = await DataEncryption.getInstance.getEncryptedData(value);
      }
      var finalKey = await _getFormattedKey(key);
      var iOptions =
          IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device);
      await _secureStorage!
          .write(key: finalKey, value: finalValue, iOptions: iOptions);
    } on Exception catch (e) {
      LoggingService()
          .logMessage('$logTag {setSecureStorageData} {Key: $key} Error : $e');
      return null;
    }
  }

  //The key is internally modified before using.
  Future<void> removeSecureStorageData(String key) async {
    try {
      var finalKey = await _getFormattedKey(key);
      await _secureStorage!.delete(key: finalKey);
    } on Exception catch (e) {
      LoggingService().logMessage(
          '$logTag {removeSecureStorageData} {Key: $key} Error : $e');
      return null;
    }
  }

  //Keeping isDecryption false as default.
  //The key are modified before read internally.
  Future<String?> readSecureStorageData(String key,
      {bool isDecrypted = false}) async {
    try {
      var finalKey = await _getFormattedKey(key);
      var data = await _secureStorage!.read(key: finalKey);

      var value = data;
      if (isDecrypted) {
        value = await DataEncryption.getInstance.getDecryptedData(data);
      }

      return value;
    } on Exception catch (e) {
      LoggingService()
          .logMessage('$logTag {readSecureStorageData} {Key: $key} Error : $e');
      return null;
    }
  }
}
