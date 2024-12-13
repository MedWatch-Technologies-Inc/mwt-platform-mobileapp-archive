import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:permission_handler/permission_handler.dart';

class AppRemindersScreen extends StatefulWidget {
  @override
  _AppRemindersScreenState createState() => _AppRemindersScreenState();
}

class _AppRemindersScreenState extends State<AppRemindersScreen> {
  bool callEnable = false;
  bool messageEnable = false;
  bool qqEnable = false;
  bool weChatEnable = false;
  bool linkedInEnable = false;
  bool skypeEnable = false;
  bool facebookMessengerEnable = false;
  bool twitterEnable = false;
  bool whatsAppEnable = false;
  bool viberEnable = false;
  bool lineEnable = false;

  String arg1 = '00000000';
  String arg2 = '00000000';

  bool gmailEnable = false;
  bool instagramEnable = false;
  bool snapchatEnable = false;
  bool facebookEnable = false;
  bool weiboEnable = false;

  DeviceModel? connectedDevice;

  @override
  void initState() {
    openNotificationDialog();
    // Platform.isIOS ? getPreferences() : getAndSetFromSdk();
    getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: Constants.staticWidth,
    //     height: Constants.staticHeight,
    //     allowFontScaling: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.5)
                  : HexColor.fromHex('#384341').withOpacity(0.2),
              offset: Offset(0, 2.0),
              blurRadius: 4.0,
            )
          ]),
          child: AppBar(
            elevation: 0,
            leading: IconButton(
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Image.asset(
                      'asset/dark_leftArrow.png',
                      width: 13,
                      height: 22,
                    )
                  : Image.asset(
                      'asset/leftArrow.png',
                      width: 13,
                      height: 22,
                    ),
            ),
            centerTitle: true,
            title: Text(
              StringLocalization.of(context)
                  .getText(StringLocalization.appReminders),
              style: TextStyle(
                  color: HexColor.fromHex('#62CBC9'),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: ListView(
          shrinkWrap: true,
          children: ListTile.divideTiles(context: context, tiles: [
            call(),
            message(),
            qqApp(),
            weChat(),
            linkedIn(),
            skype(),
            facebookMessenger(),
            twitter(),
            whatsApp(),
            viber(),
            line(),
            gmail(),
            instagram(),
            snapchat(),
            facebook(),
            weibo(),
          ]).toList(),
        ),
      ),
    );
  }

  Widget gmail() {
    if (connectedDevice == null ||
        (connectedDevice?.sdkType ?? 2) != Constants.e66) {
      return Container();
    }
    return ListTile(
      leading: Image.asset(
        'asset/gmail.png',
        height: 15.h,
        width: 15.h,
      ),
      title: Text(
          StringLocalization.of(context).getText(StringLocalization.gmail)),
      trailing: CustomSwitch(
        value: gmailEnable,
        onChanged: (value) async {
          gmailEnable = value;
          if (connections != null) {
            // connections.setCallEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.gmailEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget instagram() {
    if (connectedDevice == null || connectedDevice?.sdkType != Constants.e66) {
      return Container();
    }
    return ListTile(
      leading: Image.asset(
        'asset/instagram.png',
        height: 15.h,
        width: 15.h,
      ),
      title: Text(
          StringLocalization.of(context).getText(StringLocalization.instagram)),
      trailing: CustomSwitch(
        value: instagramEnable,
        onChanged: (value) async {
          instagramEnable = value;
          if (connections != null) {
            // connections.setCallEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.instagramEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget snapchat() {
    if (connectedDevice == null || connectedDevice?.sdkType != Constants.e66) {
      return Container();
    }
    return ListTile(
      leading: Image.asset(
        'asset/snapchat.png',
        height: 15.h,
        width: 15.h,
      ),
      title: Text(
          StringLocalization.of(context).getText(StringLocalization.snapchat)),
      trailing: CustomSwitch(
        value: snapchatEnable,
        onChanged: (value) async {
          snapchatEnable = value;
          if (connections != null) {
            // connections.setCallEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.snapchatEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget facebook() {
    if (connectedDevice == null || connectedDevice?.sdkType != Constants.e66) {
      return Container();
    }
    return ListTile(
      leading: Image.asset(
        'asset/facebook.png',
        height: 15.h,
        width: 15.h,
      ),
      title: Text(
          StringLocalization.of(context).getText(StringLocalization.facebook)),
      trailing: CustomSwitch(
        value: facebookEnable,
        onChanged: (value) async {
          facebookEnable = value;
          if (connections != null) {
            // connections.setCallEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.facebookEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget weibo() {
    if (connectedDevice == null || connectedDevice?.sdkType != Constants.e66) {
      return Container();
    }
    return ListTile(
      leading: Image.asset(
        'asset/weibo.png',
        height: 15.h,
        width: 15.h,
      ),
      title: Text(
          StringLocalization.of(context).getText(StringLocalization.weibo)),
      trailing: CustomSwitch(
        value: weiboEnable,
        onChanged: (value) async {
          weiboEnable = value;
          if (connections != null) {
            // connections.setCallEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.weiboEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget call() {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
        height: IconTheme.of(context).size,
        width: IconTheme.of(context).size,
        child: Icon(
          Icons.call,
          color: Colors.white,
          size: 15.h,
        ),
      ),
      title:
          Text(StringLocalization.of(context).getText(StringLocalization.call)),
      trailing: CustomSwitch(
        value: callEnable,
        onChanged: (value) async {
          if (value) {
            if (Platform.isAndroid) {
              bool isGranted = await Permission.phone.isGranted;
              if (!isGranted) {
                isGranted = await Permission.phone.request() ==
                    PermissionStatus.granted;
              }

             /* isGranted = await Permission.contacts.isGranted;
              if (!isGranted) {
                isGranted = await Permission.contacts.request() ==
                    PermissionStatus.granted;
              }*/
            }
          }
          callEnable = value;
          if (connections != null) {
            connections.setCallEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.callEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget message() {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
        height: IconTheme.of(context).size,
        width: IconTheme.of(context).size,
        child: Icon(
          Icons.sms,
          color: Colors.white,
          size: 15.h,
        ),
      ),
      title: Text(
          StringLocalization.of(context).getText(StringLocalization.message)),
      trailing: CustomSwitch(
        value: messageEnable,
        onChanged: (value) async {
          if (value) {
            if (Platform.isAndroid) {
              bool isGranted = await Permission.sms.isGranted;
              if (!isGranted) {
                isGranted =
                    await Permission.sms.request() == PermissionStatus.granted;
              }
            }
          }

          messageEnable = value;
          if (connections != null) {
            connections.setMessageEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.messageEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget qqApp() {
    return ListTile(
      leading: Image.asset(
        'asset/qq.png',
        height: IconTheme.of(context).size,
        width: IconTheme.of(context).size,
      ),
      title:
          Text(StringLocalization.of(context).getText(StringLocalization.qq)),
      trailing: CustomSwitch(
        value: qqEnable,
        onChanged: (value) async {
          qqEnable = value;
          if (connections != null) {
            connections.setQqEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.qqEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget weChat() {
    return ListTile(
      leading: Image.asset(
        'asset/wechat.png',
        height: IconTheme.of(context).size,
        width: IconTheme.of(context).size,
      ),
      title: Text(
          StringLocalization.of(context).getText(StringLocalization.weChat)),
      trailing: CustomSwitch(
        value: weChatEnable,
        onChanged: (value) async {
          weChatEnable = value;
          if (connections != null) {
            connections.setWeChatEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.weChatEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget linkedIn() {
    return ListTile(
      leading: Image.asset(
        'asset/linkedin.png',
        height: IconTheme.of(context).size,
        width: IconTheme.of(context).size,
      ),
      title: Text(
          StringLocalization.of(context).getText(StringLocalization.linkedIn)),
      trailing: CustomSwitch(
        value: linkedInEnable,
        onChanged: (value) async {
          linkedInEnable = value;
          if (connections != null) {
            connections.setLinkedInEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.linkedInEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget skype() {
    return ListTile(
      leading: Image.asset(
        'asset/skype.png',
        height: IconTheme.of(context).size,
        width: IconTheme.of(context).size,
      ),
      title: Text(
          StringLocalization.of(context).getText(StringLocalization.skype)),
      trailing: CustomSwitch(
        value: skypeEnable,
        onChanged: (value) async {
          skypeEnable = value;
          if (connections != null) {
            connections.setSkypeEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.skypeEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget facebookMessenger() {
    return ListTile(
      leading: Image.asset(
        'asset/facebookMessenger.png',
        height: IconTheme.of(context).size,
        width: IconTheme.of(context).size,
      ),
      title: Text(StringLocalization.of(context)
          .getText(StringLocalization.facebookMessenger)),
      trailing: CustomSwitch(
        value: facebookMessengerEnable,
        onChanged: (value) async {
          facebookMessengerEnable = value;
          if (connections != null) {
            connections.setFacebookMessengerEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.facebookMessengerEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget twitter() {
    return ListTile(
      leading: Image.asset(
        'asset/twitter.png',
        height: IconTheme.of(context).size,
        width: IconTheme.of(context).size,
      ),
      title: Text(
          StringLocalization.of(context).getText(StringLocalization.twitter)),
      trailing: CustomSwitch(
        value: twitterEnable,
        onChanged: (value) async {
          twitterEnable = value;
          if (connections != null) {
            connections.setTwitterEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.twitterEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget whatsApp() {
    return ListTile(
      leading: Image.asset(
        'asset/whatsApp.png',
        height: IconTheme.of(context).size,
        width: IconTheme.of(context).size,
      ),
      title: Text(
          StringLocalization.of(context).getText(StringLocalization.whatsApp)),
      trailing: CustomSwitch(
        value: whatsAppEnable,
        onChanged: (value) async {
          whatsAppEnable = value;
          if (connections != null) {
            connections.setWhatsAppEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.whatsAppEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget viber() {
    if (connectedDevice?.sdkType == Constants.zhBle) {
      return ListTile(
        leading: Image.asset(
          'asset/viber.png',
          height: IconTheme.of(context).size,
          width: IconTheme.of(context).size,
        ),
        title: Text(
            StringLocalization.of(context).getText(StringLocalization.viber)),
        trailing: CustomSwitch(
          value: viberEnable,
          onChanged: (value) async {
            viberEnable = value;
            if (connections != null) {
              connections.setViberEnable(value);
              if (preferences == null) {
                await getPreferences();
              }
              preferences?.setBool(Constants.viberEnable, value);
            }
            setState(() {});
          },
          activeColor: HexColor.fromHex('#00AFAA'),
          inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
              : HexColor.fromHex('#E7EBF2'),
          inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.6)
              : HexColor.fromHex('#D1D9E6'),
          activeTrackColor: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
              : HexColor.fromHex('#E7EBF2'),
        ),
      );
    }
    return Container();
  }

  Widget line() {
    return ListTile(
      leading: Image.asset(
        'asset/line.png',
        height: IconTheme.of(context).size,
        width: IconTheme.of(context).size,
      ),
      title:
          Text(StringLocalization.of(context).getText(StringLocalization.line)),
      trailing: CustomSwitch(
        value: lineEnable,
        onChanged: (value) async {
          lineEnable = value;
          if (connections != null) {
            connections.setLineEnable(value);
            if (preferences == null) {
              await getPreferences();
            }
            setAppReminderForE66();
            preferences?.setBool(Constants.lineEnable, value);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  openNotificationDialog() {
    if (connections != null) {
      connections.openNotificationDialog();
    }
  }

  void getAndSetFromSdk() async {
    if (connections != null) {
      callEnable = await connections.getCallEnable();
      messageEnable = await connections.getMessageEnable();
      qqEnable = await connections.getQqEnable();
      weChatEnable = await connections.getWeChatEnable();
      linkedInEnable = await connections.getLinkedInEnable();
      skypeEnable = await connections.getSkypeEnable();
      facebookMessengerEnable = await connections.getFacebookMessengerEnable();
      twitterEnable = await connections.getTwitterEnable();
      whatsAppEnable = await connections.getWhatsAppEnable();
      viberEnable = await connections.getViberEnable();
      lineEnable = await connections.getLineEnable();
      connections.checkAndConnectDeviceIfNotConnected().then((value) {
        if (mounted) {
          setState(() {});
        }
      });
      if (mounted) {
        setState(() {});
      }
    }
  }

  getPreferences() async {
    if (Platform.isAndroid) {
      bool isGranted = await Permission.phone.isGranted;
      if (!isGranted) {
        isGranted =
            await Permission.phone.request() == PermissionStatus.granted;
      }

      // isGranted = await Permission.contacts.isGranted;
      // if (!isGranted) {
      //   isGranted =
      //       await Permission.contacts.request() == PermissionStatus.granted;
      // }

      isGranted = await Permission.sms.isGranted;
      if (!isGranted) {
        isGranted = await Permission.sms.request() == PermissionStatus.granted;
      }
    }

    callEnable = preferences?.getBool(Constants.callEnable) == null
        ? false
        : preferences?.getBool(Constants.callEnable) ?? false;
    messageEnable = preferences?.getBool(Constants.messageEnable) == null
        ? false
        : preferences?.getBool(Constants.messageEnable) ?? false;
    qqEnable = preferences?.getBool(Constants.qqEnable) == null
        ? false
        : preferences?.getBool(Constants.qqEnable) ?? false;
    weChatEnable = preferences?.getBool(Constants.weChatEnable) == null
        ? false
        : preferences?.getBool(Constants.weChatEnable) ?? false;
    linkedInEnable = preferences?.getBool(Constants.linkedInEnable) == null
        ? false
        : preferences?.getBool(Constants.linkedInEnable) ?? false;
    skypeEnable = preferences?.getBool(Constants.skypeEnable) == null
        ? false
        : preferences?.getBool(Constants.skypeEnable) ?? false;
    facebookMessengerEnable =
        preferences?.getBool(Constants.facebookMessengerEnable) == null
            ? false
            : preferences?.getBool(Constants.facebookMessengerEnable) ?? false;
    twitterEnable = preferences?.getBool(Constants.twitterEnable) == null
        ? false
        : preferences?.getBool(Constants.twitterEnable) ?? false;
    whatsAppEnable = preferences?.getBool(Constants.whatsAppEnable) == null
        ? false
        : preferences?.getBool(Constants.whatsAppEnable) ?? false;
    viberEnable = preferences?.getBool(Constants.viberEnable) == null
        ? false
        : preferences?.getBool(Constants.viberEnable) ?? false;
    lineEnable = preferences?.getBool(Constants.lineEnable) == null
        ? false
        : preferences?.getBool(Constants.lineEnable) ?? false;

    gmailEnable = preferences?.getBool(Constants.gmailEnable) == null
        ? false
        : preferences?.getBool(Constants.gmailEnable) ?? false;
    instagramEnable = preferences?.getBool(Constants.instagramEnable) == null
        ? false
        : preferences?.getBool(Constants.instagramEnable) ?? false;
    snapchatEnable = preferences?.getBool(Constants.snapchatEnable) == null
        ? false
        : preferences?.getBool(Constants.snapchatEnable) ?? false;
    facebookEnable = preferences?.getBool(Constants.facebookEnable) == null
        ? false
        : preferences?.getBool(Constants.facebookEnable) ?? false;
    weiboEnable = preferences?.getBool(Constants.weiboEnable) == null
        ? false
        : preferences?.getBool(Constants.weiboEnable) ?? false;
    connections.checkAndConnectDeviceIfNotConnected().then((value) {
      if (value != null) {
        connectedDevice = value;
      }
      if (mounted) {
        setState(() {});
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  setAppReminderForE66() {
    if (callEnable) {
      arg1 = replaceCharAt(arg1, 0, '1');
    } else {
      arg1 = replaceCharAt(arg1, 0, '0');
    }
    if (messageEnable) {
      arg1 = replaceCharAt(arg1, 1, '1');
    } else {
      arg1 = replaceCharAt(arg1, 1, '0');
    }
    if (gmailEnable) {
      arg1 = replaceCharAt(arg1, 2, '1');
    } else {
      arg1 = replaceCharAt(arg1, 2, '0');
    }
    if (weChatEnable) {
      arg1 = replaceCharAt(arg1, 3, '1');
    } else {
      arg1 = replaceCharAt(arg1, 3, '0');
    }
    if (qqEnable) {
      arg1 = replaceCharAt(arg1, 4, '1');
    } else {
      arg1 = replaceCharAt(arg1, 4, '0');
    }
    if (weiboEnable) {
      arg1 = replaceCharAt(arg1, 5, '1');
    } else {
      arg1 = replaceCharAt(arg1, 5, '0');
    }
    if (facebookEnable) {
      arg1 = replaceCharAt(arg1, 6, '1');
    } else {
      arg1 = replaceCharAt(arg1, 6, '0');
    }
    if (twitterEnable) {
      arg1 = replaceCharAt(arg1, 7, '1');
    } else {
      arg1 = replaceCharAt(arg1, 7, '0');
    }

    if (facebookMessengerEnable) {
      arg2 = replaceCharAt(arg2, 0, '1');
    } else {
      arg2 = replaceCharAt(arg2, 0, '0');
    }

    if (whatsAppEnable) {
      arg2 = replaceCharAt(arg2, 1, '1');
    } else {
      arg2 = replaceCharAt(arg2, 1, '0');
    }
    if (linkedInEnable) {
      arg2 = replaceCharAt(arg2, 2, '1');
    } else {
      arg2 = replaceCharAt(arg2, 2, '0');
    }
    if (instagramEnable) {
      arg2 = replaceCharAt(arg2, 3, '1');
    } else {
      arg2 = replaceCharAt(arg2, 3, '0');
    }
    if (skypeEnable) {
      arg2 = replaceCharAt(arg2, 4, '1');
    } else {
      arg2 = replaceCharAt(arg2, 4, '0');
    }

    if (lineEnable) {
      arg2 = replaceCharAt(arg2, 5, '1');
    } else {
      arg2 = replaceCharAt(arg2, 5, '0');
    }

    if (snapchatEnable) {
      arg2 = replaceCharAt(arg2, 6, '1');
    } else {
      arg2 = replaceCharAt(arg2, 6, '0');
    }

    if (Platform.isIOS && connectedDevice?.sdkType == Constants.e66) {
      int arg1IntValue = 0;
      int arg2IntValue = 0;
      for (int i = 0; i < arg1.length; i++) {
        arg1IntValue *= 2; // double the result so far
        if (arg1[i] == '1') arg1IntValue++;
      }
      for (int i = 0; i < arg2.length; i++) {
        arg2IntValue *= 2; // double the result so far
        if (arg2[i] == '1') arg2IntValue++;
      }

      connections.setAppRemindersForE66(arg1IntValue, arg2IntValue);
    }
  }

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }
}
