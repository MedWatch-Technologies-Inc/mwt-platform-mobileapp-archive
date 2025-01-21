import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nordic_dfu/flutter_nordic_dfu.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/download_file/bloc/download_bloc.dart';
import 'package:health_gauge/download_file/bloc/download_event.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/utils/connections.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_container_box.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:percent_indicator/percent_indicator.dart';

class UpdateFirmware extends StatefulWidget {
  const UpdateFirmware({Key? key}) : super(key: key);

  @override
  UpdateFirmwareState createState() => UpdateFirmwareState();
}

class UpdateFirmwareState extends State<UpdateFirmware> implements ScanDeviceListener{
  bool dfuRunning = false;
  DeviceModel? deviceModel;
  bool hasStarted = false;
  bool filePicked = false;
  int percentage = 0;
  late ProgressListenerListener progressListenerListener;
  File? file;

  @override
  void initState() {
    if (connections != null) {
      connections.scanDeviceListener = this;
    }

    progressListenerListener = ProgressListenerListener();
    startMeasurement();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    if (connections != null) {
      connections.stopScan();
    }
  }

  void startMeasurement() async {
    if (connections != null) {
      deviceModel = await connections.checkAndConnectDeviceIfNotConnected();
    }
  }



  Future<void> doDfu(String deviceId) async {

    dfuRunning = true;
    try {
      var s = await FlutterNordicDfu.startDfu(
        deviceId,
        file == null ? "asset/file_old.zip" : file!.absolute.path,
        fileInAsset: true,
        progressListener:
            DefaultDfuProgressListenerAdapter(onProgressChangedHandle: (
          deviceAddress,
          percent,
          speed,
          avgSpeed,
          currentPart,
          partsTotal,
        ) {
          print('deviceAddress: $deviceAddress, percent: $percent');
          percentage=percent;
        if(percentage>=100){
          hasStarted=false;
        }
        setState(() {

        });
      }),
    );
      print(s);

      dfuRunning = false;
    } catch (e) {
      dfuRunning = false;
      print(e.toString());
    }
  }

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
  bool isPause = false;

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : AppColor.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: isDarkMode()
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex("#384341").withOpacity(0.2),
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              elevation: 0,
              backgroundColor: isDarkMode()
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              leading: IconButton(
                padding: EdgeInsets.only(left: 10),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: isDarkMode()
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
              title: SizedBox(
                height: 28.h,
                child: AutoSizeText(
                  stringLocalization.getText(StringLocalization.updateFirmware),
                  style: TextStyle(
                      color: HexColor.fromHex("62CBC9"),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              centerTitle: true,
            ),
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            !filePicked
                ? Center(
                    child: Text('Please choose a file for updating firmware'),
                  )
                : Center(
                    child: GestureDetector(
                      onTap: () async {
                        hasStarted = !hasStarted;

                        setState(() {});
                        if (hasStarted) {
                          await this.doDfu(deviceModel?.deviceAddress ?? '');
                        }
                        progressListenerListener.isError
                            ? CustomSnackBar.buildSnackbar(
                                context, "Something went wrong", 3)
                            : null;
                      },
                  child: CustomBoxContainer(
                    width: 200,
                    height: 70,
                    child: Center(
                        child: Text(
                      hasStarted ? "Updating..." : "Update",
                      style: TextStyle(
                          color: HexColor.fromHex("62CBC9"),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              hasStarted
                  ? CircularPercentIndicator(
                      radius: 60.0,
                    lineWidth: 5.0,
                    percent: percentage * 0.01,
                    center: Text(percentage.toString()),
                    progressColor: Colors.green,
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: filePicked
          ? Container()
          : FloatingActionButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  file = File(result.files.single.path!);
                  print(file);
                  filePicked = true;
                  setState(() {});
                  // Scaffold.of(context).showSnackBar(SnackBar(content: Text('${result.files.single}')));
                } else {
                  // User canceled the picker
                }
              },
              child: Icon(Icons.add),
            ),
    );
  }

  @override
  void onDeviceFound(DeviceModel device) {
    // TODO: implement onDeviceFound
    if(device != null && device.deviceName!.toLowerCase().contains('dfu') && Platform.isIOS)
     this.doDfu(device.deviceAddress!);
  }
}

class ProgressListenerListener extends DfuProgressListenerAdapter {
  bool isError=false;
  int per=0;
  @override
  void onProgressChanged(String deviceAddress, int percent, double speed,
      double avgSpeed, int currentPart, int partsTotal) {
    super.onProgressChanged(
        deviceAddress, percent, speed, avgSpeed, currentPart, partsTotal);
    print('deviceAddress: $deviceAddress, percent: $percent');
    per=percent;

  if(percent==100){
    onDfuCompleted(deviceAddress);
  }


  }



  @override
  void onEnablingDfuMode(String deviceAddress) {
    super.onEnablingDfuMode(deviceAddress);
    print('DFU mode enabled $deviceAddress');
    if(Platform.isIOS) {
      connections.startScan(1);
    }
  }

  @override
  void onDfuCompleted(String deviceAddress) {
    // TODO: implement onDfuCompleted



    super.onDfuCompleted(deviceAddress);
  }

  @override
  void onError(String deviceAddress, int error, int errorType, String message) {
    // TODO: implement onError

    isError=true;

    super.onError(deviceAddress, error, errorType, message);
  }
}

// class DeviceItem extends StatelessWidget {
//   final VoidCallback onPress;
//
//   const DeviceItem({Key key, this.onPress}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return CustomSnackBar.buildSnackbar(context, "Something went wrong ", 3);
//   }
// }
