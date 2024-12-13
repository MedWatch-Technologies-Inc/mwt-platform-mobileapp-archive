import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_gauge/models/tag.dart';
import 'package:health_gauge/repository/tag/request/edit_tag_label_request.dart';
import 'package:health_gauge/repository/tag/tag_repository.dart';
import 'package:health_gauge/resources/values/app_api_constants.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoTaggingScreen extends StatefulWidget {
  @override
  _AutoTaggingScreenState createState() => _AutoTaggingScreenState();
}

class _AutoTaggingScreenState extends State<AutoTaggingScreen> {
  List<Tag> tagList = [];

  bool isLoading = true;
  DatabaseHelper helper = DatabaseHelper.instance;



  late String userId;

  @override
  void initState() {
    getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: Constants.width, height: Constants.height, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? AppColor.darkBackgroundColor
        : AppColor.backgroundColor,
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
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
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
              title: Text(
                StringLocalization.of(context)
                    .getText(StringLocalization.autoTagging),
                style: TextStyle(
                    color: HexColor.fromHex('62CBC9'),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          )),
      body: mainLayout(context),
    );
  }

  Widget mainLayout(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: tagList.isEmpty ? Container(
        child: Center(
          child: Text(stringLocalization.getText(
              StringLocalization.noTagsFound)
          ),
        ),
      ) : ListView.separated(
        itemCount: tagList.length,
        itemBuilder: (BuildContext context, int index) {
          var model = tagList[index];
          if (model != null) {
            return item(model);
          }
          return Container();
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }

  Widget item(Tag model) {
//    Widget imageWidget =Container(width: 1,height: 1,);
//    if (model.icon.contains("asset")) {
//      imageWidget = Image.asset(
//        model.icon,
//        height: IconTheme.of(context).size,width: IconTheme.of(context).size,);
//    } else {
//    imageWidget = Image.memory(
//        base64Decode(model.icon),
//     height: IconTheme.of(context).size,width: IconTheme.of(context).size,);
//
//    }

    return ListTile(
        leading: tagIcon(model),
        title: Text(model.label ?? ''),
        trailing: Padding(
          padding: EdgeInsets.zero,
          key: Key('clickOnMeasurement${model.label}'),
          child: CustomSwitch(
            value: model.isAutoLoad ?? false,
            onChanged: (value) async {
              await onChangeValue(model, value);
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
        ));
    }


  Future<bool> checkInternetAndUserId() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    return await Constants.isInternetAvailable() &&
        userId != null &&
        userId.isNotEmpty &&
        !userId.contains('Skip');
  }

  void updateTag(Tag model) async{
    bool isSyncAble = await checkInternetAndUserId();
    if (isSyncAble) {
      var postMap = {
        'UserID': userId,
        'ImageName': model.icon ?? '',
        'UnitName': model.unit,
        'LabelName': model.label,
        'MinRange': model.min,
        'MaxRange': model.max,
        'DefaultValue': model.defaultValue,
        'PrecisionDigit': model.precision,
        'IsAutoLoad': model.isAutoLoad,
      };
      Map result;
      if (model.apiId != null && model.apiId!.isNotEmpty) {
        postMap['ID'] = model.apiId;
        var editTagLabelResult = await TagRepository()
            .editTagLabel(EditTagLabelRequest.fromJson(postMap));
        if (editTagLabelResult.hasData) {
          if (editTagLabelResult.getData!.result!) {
            model.apiId = editTagLabelResult.getData!.iD!.toString();
            model.isSync = 1;
          }
        } else {}
        // result = await PostTagLabel().callApi(
        //     Constants.baseUrl + "EditTagLabel", jsonEncode(postMap));
        // if (!result["isError"] &&
        //     result["value"] != null &&
        //     result["value"] is int) {
        //   model.apiId = result["value"].toString();
        //   model.isSync = 1;
        // }
      }
      //endregion

      //region update in database
      Map<String, dynamic> map = model.toMap();
      map['Id'] = model.id;
      var value = await dbHelper.insertTag(map);
    }
    else{
      var map = model.toMap();
      map['Id'] = model.id;
      await dbHelper.insertTag(map);
    }
  }

  Future onChangeValue(Tag model, bool value) async {
    // Constants.progressDialog(true, context);
    try {
      model.isAutoLoad = value;
      model.isSync = 0;
      updateTag(model);
    } on Exception catch (e) {
      print('exception in auto tag screen $e');
    }

    // Constants.progressDialog(false, context);
    if(mounted) {
      setState(() {});
    }
  }

  Widget tagIcon(Tag tag) {
    try{
      if (tag.icon == null || tag.icon!.isEmpty) {
        return Image.asset(
          'asset/placeholder.png',
          height: IconTheme.of(context).size,
          gaplessPlayback: true,
        );
      }
      if (tag.icon!.contains('asset')) {
        return Image.asset(
          tag.icon!,
          height: IconTheme.of(context).size,
          gaplessPlayback: true,
        );
      }
      return Image.memory(
        base64Decode(tag.icon!),
        height: IconTheme.of(context).size,
        gaplessPlayback: true,
      );
    }catch(e){
      return Image.asset(
        'asset/placeholder.png',
        height: IconTheme.of(context).size,
        gaplessPlayback: true,
      );
    }
  }

  getTagList() async {
    try {
      if (preferences == null) {
        await getPreferences();
      }
      tagList = await helper.getTagList(userId);
      List<Tag> distinctList = [];
      tagList.forEach((element) {
        try {
          if(!distinctList.any((e) => e.tagType == element.tagType && e.label == element.label)){
            distinctList.add(element);
          }
        } on Exception catch (e) {
          print('exception in auto tag screen $e');
        }
      });

      tagList = distinctList;

      try {
        List indexList = tagList.where((tag) {
          return (tag == null || (tag.tagType != null && (tag.tagType == TagType.sleep.value || tag.tagType == TagType.CORONA.value)));
        }).toList();

        for (int i = 0; i < indexList.length; i++) {
          tagList.remove(indexList[i]);
        }
      } on Exception catch (e) {
        print('exception in auto tag screen $e');
      }

      tagList = distinctList;
      tagList.forEach((element) {
        print('measurementTagging ${element.label}');
      });

    } on Exception catch (e) {
      print('exception in auto tag screen $e');
    }

    isLoading = false;
    if(mounted) {
      setState(() {});
    }
  }

  Future getPreferences() async {
    if (preferences != null)
      userId = preferences!.getString(Constants.prefUserIdKeyInt) ?? '';
    if (userId != null && userId.isNotEmpty) {
      await getTagList();
    }
  }
}
