import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/apis/save_and_get_local_settings.dart';
import 'package:health_gauge/repository/preference/preference_repository.dart';
import 'package:health_gauge/screens/localization/inherited_data.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/widgets/text_utils.dart';

/// Added by: Akhil
/// Added on: May/28/2020
/// This class is used to set the inApp Localisation

class Localisation extends StatefulWidget {
  @override
  LocalisationScreenState createState() => LocalisationScreenState();
}

class LocalisationScreenState extends State<Localisation> {
  bool isOverrideLanguageSetting =
      true; //To check whether user is changing language from the app
  Function?
      setLocale; //Funtion to change the language of whole app when user select any language

  @override
  void initState() {
    super.initState();
    this.getPreference();
  }

  /// Added by: Akhil
  /// Added on: May/28/2020
  /// Lifecycle Method to build the Widgets
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    //Context of Set Locale function is provided which will be called on main.dart to language of whole app.
    setLocale = LocaleSetter.of(context)!.setLocale;
    Locale myLocale = Localizations.localeOf(context);
    String l = preferences?.getString('languageCode') ?? 'en';
    if (l != myLocale.languageCode.toLowerCase()) {
      preferences?.setString('languageCode', myLocale.languageCode);
    }
    print(myLocale);
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.5)
                      : HexColor.fromHex("#384341").withOpacity(0.2),
                  offset: Offset(0, 2.0),
                  blurRadius: 4.0,
                )
              ]),
              child: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                leading: IconButton(
                  padding: EdgeInsets.only(left: 10),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Theme.of(context).brightness == Brightness.dark
                      ? Image.asset(
                          "asset/dark_leftArrow.png",
                          width: 13,
                          height: 22,
                        )
                      : Image.asset(
                          "asset/leftArrow.png",
                          width: 13,
                          height: 22,
                        ),
                ),
                title: Text(
                  StringLocalization.of(context)
                      .getText(StringLocalization.language),
                  style: TextStyle(
                      color: HexColor.fromHex("62CBC9"),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
            )),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        body: Container(
          // height: MediaQuery.of(context).size.height,
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          child: Column(
              children: ListTile.divideTiles(
            context: context,
            tiles: [english(), spanish()],
          ).toList()),
        ),
      ),
    );
  }

  Widget checkLanguageBtn() {
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: 22.w,
        right: 28.w,
      ),
      leading: Image.asset(
        "asset/language_icon.png",
        height: 33,
        width: 33,
      ),
      title: Body1AutoText(
        text: StringLocalization.of(context)
            .getText(StringLocalization.chooseSelectedLanguage),
        fontSize: 16,
        maxLine: 2,
      ),
      trailing: InkWell(
        child: CustomSwitch(
          value: isOverrideLanguageSetting == null
              ? true
              : isOverrideLanguageSetting,
          onChanged: (value) {
            setState(() {
              isOverrideLanguageSetting = true;
              preferences?.setBool(Constants.isOverrideLanguageSetting,
                  isOverrideLanguageSetting);
              if (!isOverrideLanguageSetting)
                setLocale!(null);
              else {
                setLocale!(
                    Locale(preferences?.getString('languageCode') ?? 'en'));
              }
            });
          },
          activeColor: HexColor.fromHex("#00AFAA"),
          inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
              : HexColor.fromHex("#E7EBF2"),
          inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.6)
              : HexColor.fromHex("#D1D9E6"),
          activeTrackColor: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
              : HexColor.fromHex("#E7EBF2"),
        ),
      ),
    );
  }

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;

  Future savePreferenceInServer() async {
    String url = Constants.baseUrl + "StorePreferenceSettings";
    // if (userId == null) {
    String userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
    // }
    // final result =
    //     await SaveAndGetLocalSettings().savePreferencesInServer(url, userId);
    final storeResult =
        await PreferenceRepository().storePreferenceSettings(userId);
    return Future.value();
  }

  Widget english() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('englishButton'),
        onTap: () async {
          // if (isOverrideLanguageSetting != null && isOverrideLanguageSetting) {
          setLocale!(Locale('en'));
          preferences?.setString('languageCode', 'en');
          savePreferenceInServer();
          // }
        },
        child: ListTile(
          contentPadding: EdgeInsets.only(
            left: 22.w,
            right: 28.w,
          ),
          trailing: preferences?.getString('languageCode') == 'en'
              ? Container(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Image.asset(
                    "asset/check_icon.png",
                    height: 33,
                    width: 33,
                  ),
                )
              // : Container(
              //     padding: EdgeInsets.only(right: 10.w),
              //     child: Image.asset(
              //       "asset/check_icon_grey.png",
              //       height: 33,
              //       width: 33,
              //     ),
              //   )
              : Text(""),
          title: Body1AutoText(
              color:
                  isDarkMode() ? AppColor.white87 : HexColor.fromHex("#384341"),
              text: StringLocalization.of(context)
                  .getText(StringLocalization.english)),
        ),
      ),
    );
  }

  /// Added by: Akhil
  /// Added on: May/28/2020
  /// english Widget to allow user to select Hindi Language as the app's Language
  /// @Return Hindi language widget
  Widget hindi() {
    return ListTile(
      onTap: () async {
        if (isOverrideLanguageSetting) {
          setLocale!(Locale('hi'));
          preferences?.setString('languageCode', 'hi');
        }
      },
      title: Body1AutoText(
          text:
              StringLocalization.of(context).getText(StringLocalization.hindi)),
    );
  }

  Widget french() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('frenchButton'),
        onTap: () async {
          // if (isOverrideLanguageSetting == true) {
          setLocale!(Locale('fr'));
          preferences?.setString('languageCode', 'fr');
          savePreferenceInServer();
          // }
        },
        child: ListTile(
          contentPadding: EdgeInsets.only(
            left: 22.w,
            right: 28.w,
          ),
          trailing: preferences?.getString('languageCode') == 'fr'
              ? Container(
                  padding: EdgeInsets.only(right: 28),
                  child: Image.asset(
                    "asset/check_icon.png",
                    height: 33,
                    width: 33,
                  ),
                )
              : Text(""),
          title: Body1AutoText(
              color:
                  isDarkMode() ? AppColor.white87 : HexColor.fromHex("#384341"),
              // : HexColor.fromHex("#7F8D8C"),
              text: StringLocalization.of(context)
                  .getText(StringLocalization.french)),
        ),
      ),
    );
  }

  Widget spanish() {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.only(
          left: 22.w,
          right: 28.w,
        ),
        trailing: Body1AutoText(
            color:
                isDarkMode() ? AppColor.white87 : HexColor.fromHex("#384341"),
            fontSize: 12,
            text: StringLocalization.of(context)
                .getText(StringLocalization.commingSoon)),
        title: Body1AutoText(
            color:
                isDarkMode() ? AppColor.white87 : HexColor.fromHex("#384341"),
            // : HexColor.fromHex("#7F8D8C"),
            text: StringLocalization.of(context)
                .getText(StringLocalization.spanish)),
      ),
    );
  }

  /// Added by: Akhil
  /// Added on: May/28/2020
  /// Method to get value of isOverrideLanguageSetting from shared preferences which is used to check if app language is same as system language or not.
  Future getPreference() async {
    isOverrideLanguageSetting =
        preferences?.getBool(Constants.isOverrideLanguageSetting) ?? true;
    setState(() {});
  }
}
