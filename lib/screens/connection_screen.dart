import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/repository/device_info/device_info_repository.dart';
import 'package:health_gauge/repository/device_info/request/store_device_info_request.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/screens/dashboard/dash_board_screen.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/connections.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/location_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/buttons.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/my_behaviour.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:location/location.dart' as locationLib;
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../models/ble_device_model.dart';

/// Added by: chandresh
/// Added at: 04-06-2020
/// This screen find device from Bluetooth and connection with application
class ConnectionScreen extends StatefulWidget {
  final int? sdkType;
  final title;
  final bool fromMeasurement;
  DeviceModel? connectedDevice;

  @override
  ConnectionScreenState createState() => ConnectionScreenState();

  ConnectionScreen({
    Key? key,
    this.sdkType,
    this.title,
    this.fromMeasurement = false,
    this.connectedDevice,
  }) : super(key: key);
}

class ConnectionScreenState extends State<ConnectionScreen>
    with ScanDeviceListener, WeightScaleListener {
  bool? showHiddenDevice;

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// isLoading boolean used to refresh
  bool isLoading = true;

  AppImages images = AppImages();

  /// Added by: chandresh
  /// Added at: 04-06-2020
  //this list contains available bluetooth band devices
  List<DeviceModel> deviceList = <DeviceModel>[];
  DeviceModel? selectedDevice;

  String userId = '';

  /// Added by: chandresh
  /// Added at: 04-06-2020
  //this is last connected bluetooth band device
  DeviceModel? connectedDevice;
  bool canTapFindBracelet = true;
  bool isConnected = false;
  bool isProgressShowing = false;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController renameDeviceOfListItemTextFieldController = new TextEditingController();
  ValueNotifier<bool> onCheckHide = new ValueNotifier(false);

  var tryCount = 0;

  // Connections connections = new Connections();

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// in initial of screen its register overridden device dound method
  @override
  void initState() {
    if (widget.connectedDevice != null) {
      connectedDevice = widget.connectedDevice;
      isConnected = connectedDevice != null;
    }
    getLocation();
    if (connections != null) {
      connections.scanDeviceListener = this;
      connections.weightScaleListener = this;

      connections.checkAndConnectDeviceIfNotConnected().then((DeviceModel? value) {
        print('get_deviceList ${value?.deviceName}');
        isConnected = value != null;
        print('get_deviceList $isConnected');
      });
    }
    getPreference();
    // checkPermission();
    super.initState();
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// this checks permission of location
  Future<bool> checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }
    bool isGranted = await Permission.location.isGranted;
    if (!isGranted) {
      return (await Permission.location.request() == PermissionStatus.granted);
    }
    return false;
  }

  @override
  void dispose() {
    //region stop to finding new bluetooth devices
    if (connections != null) {
      connections.stopScan();
    }
    //endregion
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    screen = Constants.connections;
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar(),
      body: layoutMain(),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
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
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          titleSpacing: 0.0,
          leading: IconButton(
            key: Key('backScreenButton'),
            padding: EdgeInsets.only(left: 10),
            onPressed: () {
              if (mounted) {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
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
          title: Text(
            widget.title,
            style: TextStyle(
                color: HexColor.fromHex('#62CBC9'), fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            IconButton(
              key: Key('refreshButton'),
              padding: EdgeInsets.only(right: 15),
              icon: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'asset/refresh_dark.png'
                    : 'asset/refresh.png',
                height: 33,
                width: 33,
              ),
              onPressed: () {
                isLoading = true;
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ],
          centerTitle: true,
        ),
      ),
    );
  }

  Widget layoutMain() {
    if (isLoading && connections != null) {
      //connections.startScan(Constants.zhBle);
      connections.startScan(Constants.e66);
      //   connections.startScan(Constants.hBand);
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      child: dataLayout(),
    );
  }

  Widget dataLayout() {
    //
    // String deviceNameContains = '';
    // switch (widget.sdkType) {
    //   case Constants.zhBle:
    //     deviceNameContains = '';
    //     break;
    //   case Constants.e66:
    //     deviceNameContains = widget.title ==
    //             stringLocalization.getText(StringLocalization.hg66Name)
    //         ? 'E66'
    //         : 'E80';
    //     break;
    //   // case Constants.e80:
    //   //   deviceNameContains = 'E80';
    //   //   break;
    // }
    if (widget.sdkType == Constants.zhBle) {
//      deviceList.removeWhere((element) =>
//          !element.deviceName.contains(deviceNameContains) &&
//          !element.deviceName.contains('E08'));
      // Future.delayed(Duration(seconds: 5)).then((value) {
      //   if(deviceList.length == 0){
      //     showDialog(
      //         context: context,
      //         builder: (BuildContext context){
      //           return AlertDialog(
      //             title: Text('Suggestion'),
      //             content: Text('Please disconnect the Bracelet from Settings'),
      //             actions:[
      //               FlatButton(
      //                 child: Text('Close'),
      //                 onPressed: () {
      //                   Navigator.of(context).pop();
      //                 }
      //               )
      //
      //             ],
      //           );
      //         }
      //     );
      //   }
      // });
    }
    // else if (deviceNameContains.isNotEmpty) {
    //   deviceList.removeWhere(
    //       (element) => !element.deviceName.contains(deviceNameContains));
    // }

    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 34.h, horizontal: 8.h),
        children: <Widget>[
          // logoImageLayout(),
          findBracelet(),
          FutureBuilder(
            future: connections.bluetoothEnable(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return Visibility(
                visible: Platform.isAndroid && !(snapshot.data ?? false),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: InkWell(
                      onTap: () {
                        connections.goToBle();
                      },
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        direction: Axis.horizontal,
                        children: [
                          Body1Text(
                            text: stringLocalization.getText(StringLocalization.enableBle),
                          ),
                          Body1Text(
                            text: ' ' + stringLocalization.getText(StringLocalization.goToSetting),
                            color: AppColor.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 33.7),
          connectedDevice !=
                  null //&& connectedDevice.sdkType ==  (widget.sdkType == Constants.e80 && connectedDevice.deviceName.contains('E80') ? Constants.e66 : widget.sdkType)
              ? deviceListItem(connectedDevice!)
              : Container(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(deviceList.length + 1, (index) {
              if (index == deviceList.length) {
                return shimmerLoader();
              }
              var model = deviceList[index];
              if ((connectedDevice?.deviceAddress == model.deviceAddress)) {
                return Container();
              }
              // if (model.sdkType != null && model.sdkType == widget.sdkType) {
              if (model.sdkType != null) {
                return deviceListItem(model);
              } else {
                return deviceListItem(model);
              }
            }),
          ),
          isLoading
              ? Column(
                  children: <Widget>[
                    shimmerLoader(),
                    shimmerLoader(),
                  ],
                )
              : Container(),
          SizedBox(height: 40.0),
          Visibility(
            visible: (deviceList.isEmpty) && (connectedDevice == null),
            child: IsNotYourDeviceComingInScanList(),
          ),
          // connectionBtn(),
        ],
      ),
    );
  }

  Widget findBracelet() {
    return Visibility(
      visible: connectedDevice != null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 92.h,
            width: 92.h,
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.darkBackgroundColor
                    : AppColor.backgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : Colors.white,
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(-4, -4),
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.75)
                        : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(4, 4),
                  ),
                ]),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(46.h),
                onTap: canTapFindBracelet
                    ? () async {
                        if (connections != null) {
                          await connections.checkAndConnectDeviceIfNotConnected().then((value) {
                            if (value != null) {
                              // HapticFeedback.vibrate();
                              connectedDevice = value;
                              isConnected = true;
                              connections.getVibrationBracelet();
                            }else{
                              connectedDevice = null;
                              isConnected = false;
                              setState(() {});
                            }
                          });
                        }
                        if (connections == null || !isConnected) {
                          canTapFindBracelet = false;
                          CustomSnackBar.buildSnackbar(
                              context,
                              StringLocalization.of(context)
                                  .getText(StringLocalization.noConnectionMessage),
                              3);
                          Timer(Duration(seconds: 3), () {
                            canTapFindBracelet = true;
                            if (mounted) {
                              setState(() {});
                            }
                          });
                          setState(() {});
                        }
                      }
                    : null,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Image.asset(
                    'asset/bracelet_75.png',
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 11.h),
            height: 25.h,
            child: Body1Text(
              text: StringLocalization.of(context).getText(StringLocalization.findBracelet),
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }

  Widget connectionBtn() {
    if (selectedDevice?.deviceAddress == connectedDevice?.deviceAddress) {
      return RaisedBtn(
        elevation: 4.0,
        onPressed: () {
          var dialog = CustomDialog(
            title: stringLocalization.getText(StringLocalization.disconnect),
            subTitle:
                '${StringLocalization.of(context).getText(StringLocalization.areYouSureWantToDisconnect)} ${connectedDevice?.deviceName}?',
            onClickNo: onClickCancel,
            onClickYes: onClickOk,
            maxLine: 3,
          );
          showDialog(
              context: context,
              useRootNavigator: true,
              barrierColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.color7F8D8C.withOpacity(0.6)
                  : AppColor.color384341.withOpacity(0.6),
              builder: (context) => dialog,
              barrierDismissible: false);
        },
        text:
            StringLocalization.of(context).getText(StringLocalization.btnDisConnect).toUpperCase(),
      );
    }
    return RaisedBtn(
      elevation: 4.0,
      onPressed: selectedDevice != null ? () => onClickConnect() : null,
      text: StringLocalization.of(context).getText(StringLocalization.btnConnect).toUpperCase(),
    );
  }

  void onClickCancel() {
    if (mounted) {
      if (context != null) {
        if (Navigator.canPop(context)) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    }
  }

  void onClickOk() async {
    if (mounted) {
      if (context != null) {
        if (Navigator.canPop(context)) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    }
    await onClickDisConnect();
    if (mounted) {
      setState(() {});
    }
  }

  Widget connectedDeviceLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              child: Body1AutoText(
                text: connectedDevice?.deviceName ??
                    StringLocalization.of(context).getText(StringLocalization.connectedDevice),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Body1AutoText(text: connectedDevice?.deviceRange ?? '', maxLine: 1),
          ),
          Expanded(
            flex: 2,
            child: Body1AutoText(
              text: StringLocalization.of(context).getText(StringLocalization.connected),
              maxLine: 1,
              align: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }

  Widget deviceListItem(DeviceModel model) {
    // print('onDeviceFound ${model.toMap()}');

    if (model != null) {
      Color textColor;
      bool deviceConnected = false;
      String connected = StringLocalization.of(context).getText(StringLocalization.disconnected);
      if (model.deviceAddress == connectedDevice?.deviceAddress) {
        connected = StringLocalization.of(context).getText(StringLocalization.connected);
        LoggingService().info('Connection', 'Device Connected');
        deviceConnected = true;
      }

      return InkWell(
        onTap: () {
          selectedDevice = model;
          if (selectedDevice?.deviceAddress == connectedDevice?.deviceAddress) {
            var dialog = CustomDialog(
              title: stringLocalization.getText(StringLocalization.disconnect),
              subTitle:
                  '${StringLocalization.of(context).getText(StringLocalization.areYouSureWantToDisconnect)} ${connectedDevice?.deviceName}?',
              maxLine: 2,
              onClickNo: onClickCancelDisconnect,
              onClickYes: onClickOkDisconnect,
            );
            showDialog(
                context: context,
                useRootNavigator: true,
                barrierColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.color7F8D8C.withOpacity(0.6)
                    : AppColor.color384341.withOpacity(0.6),
                builder: (context) => dialog,
                barrierDismissible: false);
            if (mounted) {
              setState(() {});
            }
          } else {
            selectedDevice != null ? onClickConnect() : print('');
            if (mounted) {
              setState(() {});
            }
          }
        },
        child: Container(
          height: 52,
          margin: EdgeInsets.only(left: 13, right: 13, top: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkBackgroundColor
                : deviceConnected
                    ? HexColor.fromHex('#E5E5E5').withOpacity(0.8)
                    : AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                    : Colors.white,
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(-4, -4),
              ),
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.75)
                    : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: deviceConnected
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: Theme.of(context).brightness == Brightness.dark
                            ? [
                                HexColor.fromHex('#CC0A00').withOpacity(0.15),
                                HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                              ]
                            : [
                                HexColor.fromHex('#FFDFDE').withOpacity(0),
                                HexColor.fromHex('#FFDFDE').withOpacity(0),
                                HexColor.fromHex('#FFDFDE').withOpacity(0.5),
                                HexColor.fromHex('#FFDFDE').withOpacity(0),
                                HexColor.fromHex('#FFDFDE').withOpacity(0),
                              ],
                      )
                    : LinearGradient(colors: [
                        Theme.of(context).brightness == Brightness.dark
                            ? AppColor.darkBackgroundColor
                            : AppColor.backgroundColor,
                        Theme.of(context).brightness == Brightness.dark
                            ? AppColor.darkBackgroundColor
                            : AppColor.backgroundColor,
                      ])),
            child: Padding(
              key: Key('connectDevice'),
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: deviceName(
                          model,
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.87)
                              : AppColor.darkBackgroundColor),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Body1AutoText(
                      text: model.deviceRange ?? '',
                      maxLine: 1,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.87)
                          : AppColor.darkBackgroundColor,
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Body1AutoText(
                      text: connected,
                      maxLine: 1,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? deviceConnected
                              ? Colors.white.withOpacity(0.87)
                              : Colors.white.withOpacity(0.38)
                          : deviceConnected
                              ? AppColor.darkBackgroundColor
                              : HexColor.fromHex('#7F8D8C'),
                      align: TextAlign.right,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
//              InkResponse(
//                onTap: ()async{
//                  await showUpdateNameDialog(model);
//                },
//                child: Padding(
//                  padding: EdgeInsets.only(left: 8),
//                  child: Icon(Icons.settings),
//                ),
//              )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  void onClickOkDisconnect() async {
    if (mounted) {
      if (context != null) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
    await onClickDisConnect();
    if (mounted) {
      setState(() {});
    }
  }

  void onClickCancelDisconnect() {
    if (mounted) {
      if (context != null) {
        if (Navigator.canPop(context)) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    }
  }

  Body1AutoText deviceName(DeviceModel model, Color textColor) {
    String name = model.deviceName ?? '';

    return Body1AutoText(
      text: name,
      color: textColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      maxLine: 1,
    );
  }

  Widget shimmerLoader() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, right: 4.0, left: 4.0),
      color: Theme.of(context).brightness == Brightness.dark ? Colors.white24 : Colors.grey[200],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Shimmer.fromColors(
                baseColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white24
                    : Colors.grey.shade200,
                highlightColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.grey.shade400,
                enabled: true,
                child: Container(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white54
                      : Colors.grey[400],
                  child: Body1AutoText(
                    text: '',
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 5.0),
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white24
                      : Colors.grey.shade200,
                  highlightColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white54
                      : Colors.grey.shade400,
                  enabled: true,
                  child: Container(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white54
                        : Colors.grey[400],
                    child: Body1AutoText(
                      text: '',
                      maxLine: 1,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(left: 5.0),
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white24
                      : Colors.grey.shade200,
                  highlightColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white54
                      : Colors.grey.shade400,
                  enabled: true,
                  child: Container(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white54
                        : Colors.grey[400],
                    child: Body1AutoText(
                      text: '',
                      maxLine: 1,
                      align: TextAlign.right,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget logoImageLayout() {
    return Image.asset(
      images.appLogo,
      height: 97.81,
      width: 140.0,
    );
  }

  /// Added by: chandresh
  /// Added at: 16-07-2020
  /// validate form by key
  //region rename device list item dialog
  Future showUpdateNameDialog(DeviceModel deviceModel) async {
    var name = '';
    var isSelected = false;

    renameDeviceOfListItemTextFieldController.text = name;
    onCheckHide.value = isSelected;

    var dialog = AlertDialog(
//      title: Text(stringLocalization.getText(StringLocalization.addNameForBluetoothDevice)),
      title: Text(deviceModel.deviceName ?? ''),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 200.w,
                height: 30.h,
                child: Body1AutoText(
                    text: stringLocalization.getText(StringLocalization.hideFromList)),
              ),
              ValueListenableBuilder(
                valueListenable: onCheckHide,
                builder: (BuildContext context, value, Widget? child) {
                  return Checkbox(
                    value: onCheckHide.value,
                    onChanged: (value) => onCheckHide.value = value!,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                },
              ),
            ],
          ),
          TextFormField(
            controller: renameDeviceOfListItemTextFieldController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: stringLocalization.getText(StringLocalization.addNameForBluetoothDevice),
              hintText: stringLocalization.getText(StringLocalization.addNameForBluetoothDevice),
            ),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return stringLocalization.getText(StringLocalization.addNameForBluetoothDevice);
              }
              return null;
            },
          ),
        ],
      ),
      actions: [
        FlatBtn(
          onPressed: () {
            if (mounted) {
              if (Navigator.canPop(context)) {
                Navigator.of(context, rootNavigator: true).pop(true);
              }
            }
          },
          text: stringLocalization.getText(StringLocalization.ok),
          color: AppColor.primaryColor,
        ),
        FlatBtn(
          onPressed: () {
            if (mounted) {
              if (Navigator.canPop(context)) {
                Navigator.of(context, rootNavigator: true).pop(false);
              }
            }
          },
          text: stringLocalization.getText(StringLocalization.cancel),
          color: IconTheme.of(context).color!,
        ),

      ],
    );
    bool isUpdate =
        await showDialog(context: context, builder: (context) => dialog, useRootNavigator: true);
    if (isUpdate == true) {
      deviceModel.friendlyName = renameDeviceOfListItemTextFieldController.text;
      deviceModel.isBlocked = onCheckHide.value ? 1 : 0;
      var isInternet = await Constants.isInternetAvailable();
      if (isInternet && !userId.contains('Skip')) {
        var map = {
          'UserID': userId,
          'DeviceName': deviceModel.deviceName,
          'DeviceAddress': deviceModel.deviceAddress,
          'BlockStatus': deviceModel.isBlocked == 0 ? 'Active' : 'Inactive',
          'ID': deviceModel.idForApi,
          'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch
        };
        final storeResult = await DeviceInfoRepository().storeDeviceInfo(StoreDeviceInfoRequest(
          userID: userId,
          deviceName: deviceModel.deviceName,
          deviceAddress: deviceModel.deviceAddress,
          blockStatus: deviceModel.isBlocked == 0 ? 'Active' : 'Inactive',
          iD: deviceModel.idForApi,
          createdDateTimeStamp: DateTime.now().millisecondsSinceEpoch,
        ));
        if (storeResult.hasData) {
          if (storeResult.getData!.result ?? false) {
            if (storeResult.getData!.iD != null && storeResult.getData!.iD is int) {
              deviceModel.idForApi = storeResult.getData!.iD!;
            }
            deviceModel.isSync = 1;
          } else {
            deviceModel.isSync = 0;
          }
        }
      } else {
        deviceModel.isSync = 0;
      }
      if (mounted) {
        setState(() {});
      }
    }
    return Future.value();
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  ///this trigger when user select device and press connect button
  /// this method shows dialog if user is already connected with another device
  /// this method checks application connect with another device
  void onClickConnect() async {
    tryCount = 0;
    late DeviceModel model;

    //this line returns the index of selected device
    if (selectedDevice != null) {
      var selectedDeviceIndex = deviceList
          .indexWhere((DeviceModel model) => model.deviceAddress == selectedDevice?.deviceAddress);
      //get Model from selected device index
      if (selectedDeviceIndex != -1) {
        model = deviceList[selectedDeviceIndex];
      }
    }

    //here if any connected device found then it will give alert that connected device will disconnect and selected will be connect.
    //other wise simple connection will being.
    if (connectedDevice != null) {
      var dialog = CustomDialog(
        title: stringLocalization.getText(StringLocalization.disconnect),
        subTitle:
            '${StringLocalization.of(context).getText(StringLocalization.areYouSureWantToDisconnect)} ${connectedDevice?.deviceName} ${StringLocalization.of(context).getText(StringLocalization.andConnect)} ${model.deviceName}?',
        maxLine: 2,
        onClickNo: onClickCancelDeviceName,
        onClickYes: () async {
          if (mounted) {
            if (Navigator.canPop(context)) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          }
          isProgressShowing = true;
          Constants.progressDialog(true, context);
          await connections.disConnectToDevice();
          await connectDevice(model);
        },
      );
      showDialog(context: context, useRootNavigator: true, builder: (context) => dialog);
    } else {
      isProgressShowing = true;
      Constants.progressDialog(true, context);
      await connectDevice(model);
    }
  }

  void onClickCancelDeviceName() {
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void successfulConnect(DeviceModel model) {
    preferences?.setString(Constants.connectedDeviceAddressPrefKey, jsonEncode(model.toMap()));
    connectedDevice = model;
    connectedDeviceDash = model;
    connections.sdkType = model.sdkType ?? Constants.e66;;
    connectedDeviceDash!.sdkType = model.sdkType ?? Constants.e66;
    isDeviceConnected.value = true;
    connections.sdkType = connectedDevice?.sdkType ?? 2;
    isConnected = true;
    if (isProgressShowing) {
      isProgressShowing = false;
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Constants.progressDialog(false, context);
      }
    }
    if (widget.fromMeasurement) {
      Future.delayed(Duration(milliseconds: 250), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        }
      });
    }
    setState(() {});
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  /// this is used to connect selected device
  /// this method trigger call in native sdk with device infomation
  /// @model is type of DeviceModel and contains device information mac address, name,RSSI
  Future connectDevice(DeviceModel model) async {
    print('DeviceModel :: ${model.toMap()}');
    var isCnt = await connections.isConnected(model.sdkType ?? Constants.e66);
    if (isCnt) {
      successfulConnect(model);
    } else {
      connections.connectToDevice(model).then((value) {
        if (value) {
          successfulConnect(model);
        }
      });
    }
    if (Platform.isIOS) {
      connections.getDeviceConfigurationInfo();
    }
    Future.delayed(Duration(seconds: 7), () async {
      var isCnt = await connections.isConnected(model.sdkType ?? Constants.e66);
      if (isCnt && mounted) {
        successfulConnect(model);
      }
    });
  }

  Future showConnectionFailDialog() {
    var dialog = CustomChildDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TitleText(
            text: '${StringLocalization.of(context).getText(StringLocalization.fail)} !',
            color: AppColor.selectedItemColor,
            fontSize: 20,
            align: TextAlign.start,
          ),
          SizedBox(height: 10.h),
          SubTitleText(
            text: StringLocalization.of(context).getText(StringLocalization.itCanNotBeConnect),
            align: TextAlign.start,
          ),
          SizedBox(height: 5.h),
          SubTitleText(
            text:
                '1) ${StringLocalization.of(context).getText(StringLocalization.failingToPhone)}.',
            align: TextAlign.start,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 5.h),
          SubTitleText(
            text:
                '   - ${StringLocalization.of(context).getText(StringLocalization.restartPhone)}.',
            align: TextAlign.start,
          ),
          SizedBox(height: 5.h),
          SubTitleText(
            text: '${StringLocalization.of(context).getText(StringLocalization.or)}',
            align: TextAlign.center,
          ),
          SizedBox(height: 5.h),
          SubTitleText(
            text:
                '2) ${StringLocalization.of(context).getText(StringLocalization.deviceConnectedSomewhereElse)}.',
            align: TextAlign.start,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 5.h),
          SubTitleText(
            text:
                '   - ${StringLocalization.of(context).getText(StringLocalization.disconnectFromThere)}.',
            align: TextAlign.start,
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    if (Navigator.of(context, rootNavigator: true).canPop()) {
                      Navigator.of(context, rootNavigator: true).maybePop();
                    }
                  },
                  child: SizedBox(
                    height: 23,
                    child: Body1AutoText(
                      text: StringLocalization.of(context)
                          .getText(StringLocalization.ok)
                          .toUpperCase(),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: HexColor.fromHex('#00AFAA'),
                      maxLine: 1,
                      minFontSize: 8,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
    return showDialog(
      context: context,
      builder: (context) => dialog,
      useRootNavigator: true,
      useSafeArea: true,
    );
  }

  /// Added by: chandresh
  /// Added at: 04-06-2020
  //this method used to disconnect device
  Future onClickDisConnect() async {
    if (connections != null) {
      isProgressShowing = true;
      Constants.progressDialog(true, context);
      connections.disConnectToDevice().then((isDisconnect) {
        if (mounted) {
          if (isProgressShowing) {
            isProgressShowing = false;
            preferences?.remove(Constants.connectedDeviceAddressPrefKey);
            connectedDevice = null;
            connectedDeviceDash = null;
            isDeviceConnected.value = false;
            selectedDevice = null;
            Constants.progressDialog(false, context);
            if (Platform.isIOS && widget.sdkType == Constants.zhBle) {
              bluetoothSetupDialog();
            }
            setState(() {});
          }
        }
      });
    }
    Future.delayed(Duration(seconds: 15)).then((_) async {
      try {
        if (connectedDevice != null) {
          var isConnected =
              await connections.isConnected(connectedDevice?.sdkType ?? Constants.e66);
          if (!isConnected) {
            if (mounted) {
              if (isProgressShowing) {
                isProgressShowing = false;
                connections.disConnectToDevice();
                preferences?.remove(Constants.connectedDeviceAddressPrefKey);
                connectedDevice = null;
                Constants.progressDialog(false, context);
                CustomSnackBar.CurrentBuildSnackBar(context,
                    StringLocalization.of(context).getText(StringLocalization.somethingWentWrong));
              }
            }
          } else if (mounted) {
            if (isProgressShowing) {
              Constants.progressDialog(false, context);
            }
          }

          if (mounted) {
            setState(() {});
          }
        }
      } catch (e) {
        print('Exception at onClickDisConnect $e');
      }
    });

    return Future.value();
  }

  @override
  void onDeviceFound(DeviceModel device) {
    var index = deviceList.indexWhere((DeviceModel model) {
      if (device.deviceAddress == model.deviceAddress) {
        return true;
      }
      return false;
    });
    if (index != null && index != -1) {
      deviceList[index] = device;
      if (connectedDevice != null) {
        if (connectedDevice?.deviceAddress == device.deviceAddress) {
          connectedDevice = device;
          preferences?.setString(
              Constants.connectedDeviceAddressPrefKey, jsonEncode(device.toMap()));
          connections.sdkType = connectedDevice?.sdkType ?? 2;
          deviceList.remove(index);
        }
      }
    } else {
      deviceList.add(device);
    }

    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future getPreference() async {
    userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
    connectedDevice = await connections.checkAndConnectDeviceIfNotConnected();
    if (connectedDevice == null) {
      connections.disConnectToDevice();
    }

    if (this.mounted) {
      setState(() {});
    }
  }

  getLocation() async {
    bool granted = await LocationUtils().checkPermission(context);
    if (Platform.isAndroid && granted) {
      locationLib.Location location = new locationLib.Location();
      var serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (serviceEnabled) {
          isLoading = true;
          if (mounted) {
            setState(() {});
          }
        }
      }
    }
  }

  bluetoothSetupDialog() {
    var dialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.h),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(10.h),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                    : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 0,
                offset: Offset(-5, -5),
              ),
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#000000').withOpacity(0.75)
                    : HexColor.fromHex('#384341').withOpacity(0.9),
                blurRadius: 5,
                spreadRadius: 0,
                offset: Offset(5, 5),
              ),
            ]),
        padding: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
        height: 275.h,
        width: 309.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                child: Container(
                  height: 20.h,
                  child: Body1AutoText(
                    text: 'Remove phone and matching bracelet',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                    minFontSize: 12,
                    // maxLine: 1,
                  ),
                )),
            Container(
              padding: EdgeInsets.only(
                top: 5.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.h),
                    child: SizedBox(
                      height: 60.h,
                      child: Body1AutoText(
                        text:
                            'Remove after the match, the bracelet can be other phone binding.Please go to Settings -> Bluetooth -> Click exclamation -> Ignore this equipment',
                        maxLine: 3,
                        fontSize: 14.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                        minFontSize: 10,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.asset(
                          'asset/system_bluetooth.jpg',
                          height: 90.h,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: Image.asset(
                          'asset/forget_device.jpg',
                          height: 80.h,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          onPressed: () {
                            if (mounted) {
                              if (context != null) {
                                if (Navigator.canPop(context)) {
                                  Navigator.of(context, rootNavigator: true).pop();
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 20.h,
                            child: Body1AutoText(
                              text: 'Don\'t Set',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: HexColor.fromHex('#00AFAA'),
                              minFontSize: 10,
                              // maxLine: 1,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () async {
                            if (mounted) {
                              if (context != null) {
                                if (Navigator.canPop(context)) {
                                  Navigator.of(context, rootNavigator: true).pop();
                                }
                              }
                            }
                            AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          child: Container(
                            height: 20.h,
                            child: Body1AutoText(
                                text: 'Set Up',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: HexColor.fromHex('#00AFAA'),
                                // maxLine: 1,
                                minFontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, useRootNavigator: true, builder: (context) => dialog);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void onDeviceConnected(int status) {
    // TODO: implement onDeviceConnected
  }

  @override
  void onGetWeightScaleData(WeightMeasurementModel weightMeasurementModel) {
    // TODO: implement onGetWeightScaleData
  }
}

class IsNotYourDeviceComingInScanList extends StatefulWidget {
  const IsNotYourDeviceComingInScanList({key}) : super(key: key);

  @override
  _IsNotYourDeviceComingInScanListState createState() => _IsNotYourDeviceComingInScanListState();
}

class _IsNotYourDeviceComingInScanListState extends State<IsNotYourDeviceComingInScanList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleText(
              text: StringLocalization.of(context)
                  .getText(StringLocalization.ifYouCanNotFindYourHGDevice),
              color: AppColor.selectedItemColor,
              align: TextAlign.center,
              fontSize: 20,
              maxLine: 3,
            ),
            SizedBox(height: 20.h),
            SubTitleText(
              text: StringLocalization.of(context)
                  .getText(StringLocalization.makeSureItNotConnectedWithAnotherPhone),
              fontWeight: FontWeight.bold,
              align: TextAlign.start,
            ),
            SizedBox(height: 20.h),
            SubTitleText(
              text: StringLocalization.of(context)
                  .getText(StringLocalization.makeSureLocationPermission),
              align: TextAlign.start,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            SubTitleText(
              text: '${StringLocalization.of(context).getText(StringLocalization.ifYouCanNotPair)}',
              align: TextAlign.start,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            SubTitleText(
              text: '${StringLocalization.of(context).getText(StringLocalization.resetYourDevice)}',
              align: TextAlign.start,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
