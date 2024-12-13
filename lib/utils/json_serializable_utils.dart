import 'package:intl/intl.dart';

class JsonSerializableUtils {
  static JsonSerializableUtils get instance => JsonSerializableUtils();

  bool checkBool(dynamic value, {bool defaultValue = false}) {
    if (value != null && value is bool) {
      return value;
    } else if (value != null && value is String && value.isNotEmpty) {
      return value.toLowerCase() == 'true';
    }
    return defaultValue;
  }

  String checkString(dynamic value, {String defaultValue = ''}) {
    if (value != null && value is String && value.isNotEmpty) {
      return value.trim();
    }
    return value == null ? defaultValue : value.toString().trim();
  }

  num checkNum(dynamic value, {num defaultValue = 0.0}) {
    if (value != null && value is num) {
      return value;
    } else if (value != null && value is String && value.isNotEmpty) {
      return num.parse(value);
    }
    return defaultValue;
  }

  int checkInt(dynamic value, {int defaultValue = 0}) {
    if (value != null && value is int) {
      return value;
    } else if (value != null && value is String && value.isNotEmpty) {
      return int.parse(value);
    }
    return defaultValue;
  }

  DateTime checkDate(dynamic value, {String formatDate = 'yyyy-MM-dd HH:mm:ss'}) {
    if (value != null && value is String) {
      try {
        return DateFormat(formatDate).parse(value);
      } catch (e) {
        print('checkDate :: $e');
      }
      try {
        return DateFormat(formatDate).parse(DateTime.fromMillisecondsSinceEpoch(int.parse(value)).toString());
      } catch (e) {
        return DateFormat(formatDate).parse(DateTime.now().toString());
      }
    }
    return DateFormat(formatDate).parse(DateTime.now().toString());
  }
}
