import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:animated_widgets/widgets/opacity_animated.dart';
import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/home/home_screeen.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_item_enum.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/buttons.dart';

import '../../../utils/constants.dart';

class ChooseGraphItems extends StatefulWidget {
  final List<GraphTypeModel> typeList;
  final List<GraphTypeModel> selectedGraphType;

  ChooseGraphItems({required this.typeList, required this.selectedGraphType});

  @override
  _ChooseGraphItemsState createState() => _ChooseGraphItemsState();
}

class _ChooseGraphItemsState extends State<ChooseGraphItems> {
  bool showColorChooser = false;
  late GraphTypeModel selectedType;

  List<GraphTypeModel> searchList = [];
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    widget.typeList.removeWhere((element) => (
        element.fieldName == DefaultGraphItem.deepSleep.fieldName ||
            element.fieldName == DefaultGraphItem.lightSleep.fieldName ||
            // element.fieldName == DefaultGraphItem.allSleep.fieldName ||
            element.fieldName == DefaultGraphItem.awake.fieldName));
    if(preferences?.getInt(Constants.measurementType) == 2){
      widget.typeList.removeWhere((element) => (element.fieldName == DefaultGraphItem.sbp.fieldName ||
          element.fieldName == DefaultGraphItem.dbp.fieldName || element.fieldName == DefaultGraphItem.oxygen.fieldName ||
          element.fieldName == DefaultGraphItem.temperature.fieldName));
    }
    selectedType = widget.typeList.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex("#111B1A")
            : AppColor.backgroundColor,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#111B1A")
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                      : HexColor.fromHex("#DDE3E3").withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex("#000000").withOpacity(0.75)
                      : HexColor.fromHex("#384341").withOpacity(0.9),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5),
                ),
              ]),
          padding: EdgeInsets.only(top: 27.h, left: 26.w, right: 26.w),
          height: 446.h,
          width: 309.w,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stringLocalization.getText(StringLocalization.selectItem),
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.87)
                          : HexColor.fromHex("#384341"),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  height: showColorChooser ? 0 : 375.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      searchBar(),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        height: 300.h,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: listViewWidget(
                                searchController.text.trim().length > 0
                                    ? searchList
                                    : widget.typeList),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: showColorChooser ? 370.h : 0,
                  child: TranslationAnimatedWidget.tween(
                    enabled: showColorChooser,
                    translationDisabled: Offset(0, 200),
                    translationEnabled: Offset(0, 0),
                    child: OpacityAnimatedWidget.tween(
                        curve: Curves.easeInToLinear,
                        enabled: showColorChooser,
                        opacityDisabled: 0,
                        opacityEnabled: 1,
                        child: ColorChooser(
                          selectedColor: HexColor.fromHex(selectedType.color),
                          onSelectColor: (value) {
                            selectedType.color = value.toHex();
                            showColorChooser = false;
                            setState(() {});
                          },
                          onClickCancel: () {
                            showColorChooser = false;
                            setState(() {});
                          },
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  List<Widget> listViewWidget(List<GraphTypeModel> list) {
    List<GraphTypeModel> distinctList = [];
    distinctListMethod(list, distinctList);
    return List.generate(
      distinctList.length,
      (index) {
        GraphTypeModel model = distinctList[index];
        bool isAlreadySelected = widget.selectedGraphType
            .any((element) => element.fieldName == model.fieldName);
        if (isAlreadySelected != null && isAlreadySelected) {
          return Container();
        }
        return Container(
          height: 33.h,
          margin: EdgeInsets.only(bottom: searchController.text.trim().length > 0 && index == distinctList.length - 1 ? 44.h : 22.h),
          child: ListTile(
            key: index == 0
                ? Key("firstItem")
                : index == 1
                    ? Key("secondItem")
                    : index == 2
                        ? Key("thirdItem")
                        : Key("moreItems"),
            onTap: () {
              selectedType = model;
              Navigator.of(context).pop(selectedType);
            },
            leading: imageWidget(model),
            title: Text(
              stringLocalization.getTextFromEnglish(model.name),
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.87)
                    : HexColor.fromHex("#384341"),
                fontSize: 16.sp,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        );
      },
    );
  }

  void distinctListMethod(
      List<GraphTypeModel> list, List<GraphTypeModel> distinctList) {
    list.forEach((element) {
      try {
        if (element != null &&
            element.fieldName != null &&
            element.tableName != null) {
          if (!distinctList.any((e) =>
              e.fieldName == element.fieldName &&
              e.tableName == element.tableName)) {
            distinctList.add(element);
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }

  Widget searchBar() {
    return Container(
        height: 56.h,
        decoration: ConcaveDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.h)),
            depression: 7,
            colors: [
              Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#000000").withOpacity(0.8)
                  : HexColor.fromHex("#D1D9E6"),
              Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                  : Colors.white,
            ]),
        padding: EdgeInsets.only(left: 20.w, right: 10.w),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: TextFormField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: StringLocalization.of(context)
                      .getText(StringLocalization.search),
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex("#FFFFFF").withOpacity(0.38)
                        : HexColor.fromHex("#7F8D8C"),
                  ),
                  suffixIcon: Image.asset(
                    "asset/search_icon.png",
                    color: HexColor.fromHex("#00AFAA"),
                  )),
              onChanged: (value) {
                searchList.clear();
                searchList = widget.typeList.where((element) {
                  return (element.toString().contains(value) ||
                      stringLocalization
                          .getTextFromEnglish(element.name)
                          .toLowerCase()
                          .contains(value.toLowerCase()));
                }).toList();
                setState(() {});
              },
            ),
          ),
        ));
//    return Padding(
//      padding: EdgeInsets.only(bottom: 10.h, top: 5.h),
//      child: TextFormField(
//        controller: searchController,
//        textInputAction: TextInputAction.search,
//        decoration: InputDecoration(
//            border: OutlineInputBorder(),
//            hintText: stringLocalization.getText(StringLocalization.search),
//            labelText: stringLocalization.getText(StringLocalization.search),
//            prefixIcon: Icon(Icons.search),
//            contentPadding: EdgeInsets.all(0)),
//        onChanged: (value) {
//          searchList.clear();
//          searchList = widget.typeList.where((element) {
//            return (element.toString().contains(value) ||  stringLocalization.getTextFromEnglish(element.name).toLowerCase().contains(value.toLowerCase()));
//          }).toList();
//          setState(() {});
//        },
//      ),
//    );
  }

  Widget imageWidget(GraphTypeModel model) {
    try {
      if (model.image != null && model.image.isNotEmpty) {
        Uint8List bytes = base64Decode(model.image);
        return Image.memory(bytes, height: 33.h, width: 33.h);
      }
    } catch (e) {
      print(e);
    }
    return Image.asset("asset/placeholder.png", width: 33.h, height: 33.h);
  }
}

class ColorChooser extends StatefulWidget {
  final UI.Color selectedColor;
  final ValueChanged<UI.Color> onSelectColor;
  final GestureTapCallback onClickCancel;

   ColorChooser(
      {required this.selectedColor, required this.onSelectColor, required this.onClickCancel});

  @override
  _ColorChooserState createState() => _ColorChooserState();
}

class _ColorChooserState extends State<ColorChooser> {
  late UI.Color selectedColor;

  @override
  void initState() {
    selectedColor = widget.selectedColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Expanded(
            child: MaterialColorPicker(
              shrinkWrap: true,
              circleSize: 30.h,
              colors: fullMaterialColors,
              selectedColor: selectedColor,
              onMainColorChange: (color) => setState(() {}),
              onColorChange: (Color color) {
                selectedColor = color;
                setState(() {});
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              FlatBtn(
                onPressed: () {
                  widget.onSelectColor(selectedColor);
                },
                text: stringLocalization.getText(StringLocalization.ok),
                color: AppColor.primaryColor,
              ),
              FlatBtn(
                onPressed: widget.onClickCancel,
                text: stringLocalization.getText(StringLocalization.cancel),
                color: AppColor.black,
              ),

            ],
          )
        ],
      ),
    );
  }
}
