import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/download_file/bloc/download_bloc.dart';
import 'package:health_gauge/download_file/bloc/download_event.dart';
import 'package:health_gauge/download_file/bloc/download_state.dart';
import 'package:health_gauge/download_file/model/firmware_version_list_model.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/circular_percent_indicator.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';

class DownloadFileScreen extends StatefulWidget {
  const DownloadFileScreen({Key? key}) : super(key: key);

  @override
  _DownloadFileScreenState createState() => _DownloadFileScreenState();
}

class _DownloadFileScreenState extends State<DownloadFileScreen> {
  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return BlocProvider(
      create: (context) => DownloadBloc(),
      child: DownloadFileMain(),
    );
  }
}

class DownloadFileMain extends StatefulWidget {
  const DownloadFileMain({Key? key}) : super(key: key);

  @override
  _DownloadFileMainState createState() => _DownloadFileMainState();
}

class _DownloadFileMainState extends State<DownloadFileMain> {
  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
  late DownloadBloc downloadBloc;
  FirmwareVersionListModel? firmwareVersionListModel;
  FirmwareVersionModel? firmwareVersionModel;
  File? file;

  @override
  void initState() {
    super.initState();
    downloadBloc = BlocProvider.of<DownloadBloc>(context);
    downloadBloc.add(GetFirmwareVersionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex("#111B1A")
            : AppColor.backgroundColor,
        title: Text(
            stringLocalization.getText(StringLocalization.downloadFirmware),
            style: TextStyle(
                fontSize: 18,
                color: HexColor.fromHex("62CBC9"),
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          padding: EdgeInsets.only(left: 10),
          onPressed: () {
            Navigator.of(context).pop();
            // Constants.navigatePushAndRemove(SignInScreen(), context);
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
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex("#111B1A")
              : AppColor.backgroundColor,
          child: Column(
            children: [
              BlocConsumer<DownloadBloc, DownloadState>(
                bloc: downloadBloc,
                listener: (context, state) {
                  if (state is FirmwareVersionSuccessState) {
                    firmwareVersionListModel = state.model;
                  }
                  if (state is ProgressPercentState) {
                    // firmwareVersionModel.data.taskId = state.taskId;
                    // firmwareVersionModel.data.status = state.status;
                    // firmwareVersionModel.data.progress = state.progress;
                    FirmwareVersionModel mod = firmwareVersionListModel!.data!
                        .firstWhere(
                            (element) => element.taskId == state.taskId);
                    mod.progress = state.progress;
                    mod.status = state.status;
                    mod.taskId = state.taskId;
                  }
                  if (state is DeleteSuccessState) {
                    FirmwareVersionModel mod = firmwareVersionListModel!.data!
                        .firstWhere(
                            (element) => element.taskId == state.taskId);
                    mod.progress = 0;
                    mod.status = DownloadTaskStatus.undefined;
                    // firmwareVersionModel.data.progress = 0;
                    // firmwareVersionModel.data.status =
                    //     DownloadTaskStatus.undefined;
                  }
                  if (state is FileSelectedState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('${state.name}')));
                  }
                },
                builder: (context, state) {
                  if (state is FirmwareVersionSuccessState) {
                    if (state.model.result != null && state.model.result!) {
                      return Column(
                        children: _buildListContainer(state.model),
                      );
                    }
                  }
                  if (state is TaskGeneratedSuccessState) {
                    // if (firmwareVersionModel != null &&
                    //     firmwareVersionModel.data != null) {
                    //   firmwareVersionModel.data.taskId = state.taskID;
                    // }
                    FirmwareVersionModel mod = firmwareVersionListModel!.data!
                        .firstWhere(
                            (element) => element.downloadUrl == state.link);
                    mod.taskId = state.taskID;
                    return Column(
                      children: _buildListContainer(firmwareVersionListModel!),
                    );
                  }
                  if (state is ProgressPercentState) {
                    return Column(
                      children: _buildListContainer(firmwareVersionListModel!),
                    );
                  }
                  if (state is DeleteSuccessState) {
                    return Column(
                      children: _buildListContainer(firmwareVersionListModel!),
                    );
                  }
                  if (state is FileSelectedState) {
                    return Text('${file!.path}');
                    // return Column(
                    //   children: _buildListContainer(firmwareVersionListModel),
                    // );
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildListContainer(FirmwareVersionListModel listModel) {
    List<Widget> list = [];
    listModel.data?.forEach((element) {
      list.add(_buildContainer(element));
    });
    return list;
  }

  Widget _buildContainer(FirmwareVersionModel model) {
    return Container(
      margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex("#111B1A")
              : AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(10.h),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                  : Colors.white,
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(-4, -4),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.75)
                  : HexColor.fromHex("#9F2DBC").withOpacity(0.15),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(4, 4),
            ),
          ]),
      child: Container(
        padding:
            EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h, bottom: 12.h),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex("#111B1A")
              : AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.versionName!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text('Version ${model.versionNo}'),
              ],
            ),
            CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 5.0,
              percent: model.progress.toDouble() * 0.01 < 0
                  ? 0
                  : model.progress.toDouble() * 0.01 > 1
                      ? 1
                      : model.progress.toDouble() * 0.01,
              progressColor: Colors.green,
              center: model.status == DownloadTaskStatus.running
                  ? model.progress.toDouble() * 0.01 < 0
                      ? Text('0')
                      : model.progress.toDouble() * 0.01 > 1
                          ? Text('100')
                          : Text('${model.progress}')
                  : IconButton(
                      icon: model.status == DownloadTaskStatus.undefined
                          ? Icon(Icons.download_outlined)
                          : model.status == DownloadTaskStatus.complete
                              ? Icon(Icons.delete)
                              : Icon(
                                  Icons.pause,
                                  color: Colors.transparent,
                                ),
                      onPressed: () {
                        if (model.status == DownloadTaskStatus.undefined) {
                          var dialog = CustomDialog(
                            title: "Information",
                            subTitle:
                                "Are you sure you want to download this firmware?",
                            onClickYes: () {
                              downloadBloc.add(GenerateTaskEvent(
                                  link: model.downloadUrl!,
                                  name: model.versionName!));
                              Navigator.of(context).pop();
                            },
                            onClickNo: () {
                              Navigator.of(context).pop();
                            },
                            maxLine: 2,
                            primaryButton: stringLocalization
                                .getText(StringLocalization.yes),
                            secondaryButton: stringLocalization
                                .getText(StringLocalization.no),
                          );
                          showDialog(
                              context: context,
                              useRootNavigator: false,
                              builder: (context) => dialog,
                              barrierDismissible: true);
                        } else if (model.status ==
                            DownloadTaskStatus.complete) {
                          downloadBloc.add(DeleteEvent(taskId: model.taskId!));
                        }
                      }),
            )
          ],
        ),
      ),
    );
  }
}

class _TaskInfo {
  final String? name;
  final String? link;

  String? taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String? name;
  final _TaskInfo? task;

  _ItemHolder({this.name, this.task});
}
