import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:health_gauge/services/core_util/device_utils.dart';
import 'package:health_gauge/services/storage/storage_service.dart';

const kSecureEnclaveMasterPasswordKey = 'master_password_key';

class DataEncryption {
  DataEncryption._privateConstructor() {
    _storageService = StorageService.getInstance;
  }

  StorageService? _storageService;

  static final DataEncryption getInstance =
      DataEncryption._privateConstructor();

  Future<String?> getEncryptedData(String value) async {
    var password = await _getMasterPassword();

    var encrypted;
    final key = Key.fromUtf8(password);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    encrypted = encrypter.encrypt(value, iv: iv);

    return encrypted.base64;
  }

  Future<String?> getDecryptedData(String? data) async {
    if (data == null) {
      return data;
    }
    var password = await _getMasterPassword();

    var encrptedData = Encrypted.fromBase64(data);
    final key = Key.fromUtf8(password);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));

    return encrypter.decrypt(encrptedData, iv: iv);
  }

  Future<String> _getEncryptionPassword() async {
    var deviceId = SystemInfoHelpers.getInstance.deviceId;
    deviceId = '$deviceId${DateTime.now().millisecondsSinceEpoch}';

    // key should be of 32, 64 lenght long
    var bytes = utf8.encode(deviceId);
    var digest = md5.convert(bytes);

    return digest.toString();
  }

  ///This is the master key used for DB encryption and secure enclave data encryption
  Future<String> _getMasterPassword() async {
    var masterPassword = await _storageService!.readSecureStorageData(
        kSecureEnclaveMasterPasswordKey,
        isDecrypted: false);
    if (masterPassword == null) {
      masterPassword = await _getEncryptionPassword();
      //Master key should not be encrypted as per current scenario.
      await _storageService!.setSecureStorageData(
          kSecureEnclaveMasterPasswordKey, masterPassword,
          isEncrypted: false);
    }
    return masterPassword;
  }
}
