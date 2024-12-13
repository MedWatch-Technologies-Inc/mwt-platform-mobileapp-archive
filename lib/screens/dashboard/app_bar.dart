import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class AppBarForDashBoard extends StatelessWidget {
  final String userId;
  final String userEmail;
  final GestureTapCallback onTapBluetoothBtn;
  final GestureTapCallback onTapHelpBtn;
  final GestureTapCallback onTapChatBtn;
  final bool isDeviceConnected;

  const AppBarForDashBoard({
    Key? key,
    required this.userId,
    required this.userEmail,
    required this.onTapBluetoothBtn,
    required this.onTapHelpBtn,
    required this.onTapChatBtn,
    required this.isDeviceConnected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.5)
                : HexColor.fromHex('#384341').withOpacity(0.2),
            offset: Offset(0, 2.0),
            blurRadius: 4.0,
          )
        ],
      ),
      child: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        /*bottom: PreferredSize(
          preferredSize: Size.fromHeight(6.5),
          child: ValueListenableBuilder(
            valueListenable: Synchronizations().isSyncData,
            builder: (BuildContext context, value, Widget? child) {
              return Visibility(
                visible: value >= 0 && value <= 99,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: value / 100),
                  duration: const Duration(milliseconds: 2500),
                  builder: (context, value, _) => ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                    child: LinearProgressIndicator(
                      semanticsValue: 'Hello',
                      value: value > 0 ? value : null,
                      backgroundColor: Colors.red,
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                      minHeight: 6.5,
                    ),
                  ),
                ),
                replacement: SizedBox(),
              );
            },
          ),
        ),*/
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              key: Key('clickonWeightMeasurementbutton'),
              padding: const EdgeInsets.all(8.0),
              child: Tooltip(
                message: 'drawerone',
                child: IconButton(
                  key: Key('drawer'),
                  padding: EdgeInsets.only(left: 15),
                  icon: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'asset/dark_buregr_menu_icon.png'
                        : 'asset/buregr_menu_icon.png',
                    height: 32,
                    width: 32,
                  ),
                  onPressed: () async {
                    if (Scaffold.of(context).mounted) {
                      if (Scaffold.of(context).isDrawerOpen) {
                        Scaffold.of(context).openEndDrawer();
                      } else {
                        Scaffold.of(context).openDrawer();
                      }
                    }
                  },
                ),
              ),
            );
          },
        ),
        title: Row(
          children: <Widget>[
            userId == null || userId.contains('Skip')
                ? Container()
                : IconButton(
                    key: Key('chat'),
                    icon: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'asset/chat_icon.png'
                          : 'asset/chat_icon.png',
                      height: 32,
                      // width: 32,
                    ),
                    onPressed: onTapChatBtn,
                    padding: EdgeInsets.only(right: 18.w),
                  ),
            //    userId == null || userId.contains('Skip')
            // ? Container()
            // : IconButton(
            //     key: Key('mail'),
            //     icon: Image.asset(
            //       Theme.of(context).brightness == Brightness.dark
            //           ? 'asset/dark_mail_icon.png'
            //           : 'asset/mail_icon.png',
            //       height: 32,
            //       width: 32,
            //     ),
            //     onPressed: onTapMailBtn,
            //     padding: EdgeInsets.only(right: 20.w),
            //   ),
            Expanded(
              child: Center(
                child: AutoSizeText(stringLocalization.getText(StringLocalization.dashBoardName),
                    minFontSize: 10,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: HexColor.fromHex('62CBC9'),
                    )),
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            key: Key('helpIcon'),
            padding: EdgeInsets.only(right: 18),
            icon: Image.asset( Theme.of(context).brightness == Brightness.dark
                          ? 'asset/dark_help_icon_off.png'
                           : 'asset/help_icon_unselected.png',
              height: 32,
              width: 32,
            ),
            onPressed: onTapHelpBtn,
          ),
          IconButton(
            key: Key('bluetoothIcon'),
            padding: EdgeInsets.only(right: 18),
            icon: Image.asset(
              !isDeviceConnected
                  ? Theme.of(context).brightness == Brightness.dark
                      ? 'asset/ble_disable_dark.png'
                      : 'asset/ble_disable.png'
                  : Theme.of(context).brightness == Brightness.dark
                      ? 'asset/ble_enable_dark.png'
                      : 'asset/ble_enable.png',
              height: 32,
              width: 32,
            ),
            onPressed: onTapBluetoothBtn,
          ),
        ],
      ),
    );
  }
}
