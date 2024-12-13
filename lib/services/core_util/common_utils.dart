import 'dart:math' as math;

class CommonUtils {
  CommonUtils._();

  /// direct copy of 'package:flutter/foundation.dart' so that no need to import it
  static String describeEnum(Object enumEntry) {
    final description = enumEntry.toString();
    final indexOfDot = description.indexOf('.');
    assert(indexOfDot != -1 && indexOfDot < description.length - 1);
    return description.substring(indexOfDot + 1);
  }

  static String enumName(String enumToString) {
    var paths = enumToString.split('.');
    return paths[paths.length - 1];
  }
}

extension StringX on String {
  bool containsIgnoreCase(String stringToMatch) {
    return toLowerCase().contains(stringToMatch.toLowerCase());
  }

  bool hasValidData() {
    return this != null && trim().isNotEmpty;
  }

  String getSafeData() {
    return hasValidData() ? this : '';
  }

  bool get isNullOrEmpty => !hasValidData();

  Iterable<String> toIterable() sync* {
    for (var i = 0; i < length; i++) {
      yield (this[i]);
    }
  }

  /// Same as contains, but allows for case insensitive searching
  ///
  /// [caseInsensitive] defaults to false
  bool containsX(String string, {bool caseInsensitive = false}) {
    if (caseInsensitive) {
      // match even if case doesn't match
      return toLowerCase().contains(string.toLowerCase());
    } else {
      return contains(string);
    }
  }

  String substringUntil(Pattern occurrence) {
    final index = indexOf(occurrence);
    if (index == -1) {
      return this;
    }
    return substring(0, index);
  }

  String toLowerCaseNoSpaces() => toLowerCase().replaceAll(' ', '');
}

extension ListEmptyValidation<E> on Iterable<E> {
  bool hasData() => this != null && isNotEmpty;
}

extension Precision on double {
  double toPrecision(int fractionDigits) {
    num mod = math.pow(10, fractionDigits.toDouble());
    return ((this * mod).round().toDouble() / mod);
  }
}
