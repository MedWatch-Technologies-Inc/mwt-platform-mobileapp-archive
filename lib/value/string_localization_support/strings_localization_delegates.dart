import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'string_localization.dart';

/// Added by: Akhil
/// Added on: May/28/2020
/// Localiztion Delegate class to check the supported languaged of app and load the system's locale.
class StringsLocalizationDelegate
 extends LocalizationsDelegate<StringLocalization>{
  const StringsLocalizationDelegate();

  /// Added by: Akhil
  /// Added on: May/28/2020
  /// Method to return which language is supported by app.
  /// @return true if language is supported and false if not supported.
  @override
  bool isSupported(Locale locale) {
    if([StringLocalization.kLanguageHindi]
      .contains(locale.languageCode))
      return true;
    else if ([StringLocalization.kLanguageEnglish].contains(locale.languageCode))
      return true;
    else if ([StringLocalization.kLanguageFrench].contains(locale.languageCode))
      return true;
    return false;
  }

  @override
  bool shouldReload(LocalizationsDelegate old) => false;

  /// Added by: Akhil
  /// Added on: May/28/2020
  /// Method to load the system's locale.
  @override
  Future<StringLocalization> load(Locale locale) => SynchronousFuture<StringLocalization>(
      StringLocalization(locale));

}