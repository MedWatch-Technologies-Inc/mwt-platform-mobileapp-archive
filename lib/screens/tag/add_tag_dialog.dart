import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/tag.dart';
import 'package:health_gauge/models/tag_note.dart';
import 'package:health_gauge/repository/tag/request/add_tag_label_request.dart';
import 'package:health_gauge/repository/tag/request/edit_tag_label_request.dart';
import 'package:health_gauge/repository/tag/tag_repository.dart';
import 'package:health_gauge/screens/icons_screen.dart';
import 'package:health_gauge/screens/tag/helper_widgets/app_text_form_field.dart';
import 'package:health_gauge/screens/tag/model/tag_label.dart';
import 'package:health_gauge/screens/tag/tag_helper.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_item_enum.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_shared_preference_manager_model.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/custom_picker.dart';

enum TagVType { range, slider }

class AddTagDialog extends StatefulWidget {
  final int category;
  final String title;
  final TagLabel? tagLabel;

  AddTagDialog({
    required this.category,
    required this.title,
    this.tagLabel,
  });

  @override
  _AddTagDialogState createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  TextEditingController labelTextEdit = TextEditingController();
  TextEditingController unitTextEdit = TextEditingController();
  TextEditingController minTextEdit = TextEditingController();
  TextEditingController maxTextEdit = TextEditingController();
  TextEditingController precisionTextEdit = TextEditingController();

  String? selectedImage;

  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? userId;
  bool isAutoLoad = false;

  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  // List list = [];
  OverlayEntry? entry;
  bool openKeyboardTagLabel = false;
  bool openKeyboardUnit = false;
  bool openKeyboardMinRange = false;
  bool openKeyboardMaxRange = false;
  bool openKeyboardPrecision = false;

  bool errorTagLabel = false;
  bool errorUnit = false;
  bool errorMinRange = false;
  bool errorMaxRange = false;
  bool errorAlreadyUsedName = false;

  FocusNode tagLabelFocusNode = FocusNode();
  FocusNode unitFocusNode = FocusNode();
  FocusNode minRangeFocusNode = FocusNode();
  FocusNode maxRangeFocusNode = FocusNode();
  FocusNode precisionFocusNode = FocusNode();

  bool errorRange = false;
  bool isTagEdit = false;
  ValueNotifier<TagVType> tagVType = ValueNotifier(TagVType.slider);
  bool errorImage = false;

  TagHelper tagHelper = TagHelper();

  @override
  void initState() {
    tagVType.value = widget.category == 1 ? TagVType.slider : TagVType.range;
    getPreferences();
    setDefaultValue();
    super.initState();
  }

  @override
  void dispose() {
    tagLabelFocusNode.dispose();
    unitFocusNode.dispose();
    minRangeFocusNode.dispose();
    maxRangeFocusNode.dispose();
    precisionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screen = Constants.tagEditor;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex('#384341').withOpacity(0.2),
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            centerTitle: true,
            leading: IconButton(
              key: Key('backButtonAddTagDialog'),
              padding: EdgeInsets.only(left: 10),
              onPressed: () {},
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
              widget.tagLabel == null
                  ? widget.title
                  : stringLocalization.getText(StringLocalization.updateNote),
              style: TextStyle(
                color: HexColor.fromHex('#62CBC9'),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (widget.tagLabel != null) ...[
                IconButton(
                  key: Key('deleteButton'),
                  padding: EdgeInsets.only(right: 15.w),
                  icon: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'asset/delete_dark.png'
                        : 'asset/delete.png',
                    width: 33,
                    height: 33,
                  ),
                  onPressed: () async {
                    deleteDialog(
                      onClickYes: () async {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                        entry = showOverlay(context);
                        await removeTag(widget.tagLabel!);
                        if (entry != null) entry!.remove();
                        Navigator.of(context).pop('delete');
                      },
                    );
                  },
                )
              ]
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : AppColor.backgroundColor,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // preConfigTagUI(),
                Container(
                  height: 105.h,
                  width: 105.h,
                  margin: EdgeInsets.only(top: 32.h, left: 33.w, right: 33.w),
                  child: selectedImageView(),
                ),
                emojiList(),
                ValueListenableBuilder(
                    valueListenable: labelError,
                    builder: (context, value, widget) {
                      return AppTextFormField(
                        margin: EdgeInsets.only(top: 29.h, left: 33.w, right: 33.w),
                        onChange: (value) {
                          isTagEdit = true;
                        },
                        onTap: (){},
                        isError: value,
                        hintText: stringLocalization.getText(StringLocalization.label),
                        errorMessage: labelErrorMessage.value,
                        hintColor: HexColor.fromHex('#7F8D8C'),
                        keyboardType: TextInputType.text,
                        controller: labelTextEdit,
                        inputFormatter: [
                          FilteringTextInputFormatter(regExForRestrictEmoji(), allow: false),
                          FilteringTextInputFormatter(RegExp('[a-zA-Z0-9 ]'), allow: true),
                          LengthLimitingTextInputFormatter(50),
                        ],
                      );
                    }),
                ValueListenableBuilder(
                    valueListenable: unitError,
                    builder: (context, value, widget) {
                      return AppTextFormField(
                        margin: EdgeInsets.only(top: 20.h, left: 33.w, right: 33.w),
                        onChange: (value) {
                          isTagEdit = true;
                        },
                        isError: value,
                        hintText: stringLocalization.getText(StringLocalization.unit),
                        errorMessage: stringLocalization.getText(StringLocalization.enterUnit),
                        hintColor: HexColor.fromHex('#7F8D8C'),
                        keyboardType: TextInputType.text,
                        controller: unitTextEdit,
                        inputFormatter: [
                          FilteringTextInputFormatter(regExForRestrictEmoji(), allow: false),
                          FilteringTextInputFormatter(RegExp('[a-zA-Z0-9 ]'), allow: true),
                          LengthLimitingTextInputFormatter(50),
                        ],
                      );
                    }),
                ValueListenableBuilder(
                  valueListenable: tagVType,
                  builder: (BuildContext context, TagVType value, Widget? child) {
                    if (value == TagVType.slider) {
                      return slider();
                    }
                    return rangeWidget();
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: tagVType,
                  builder: (BuildContext context, TagVType value, Widget? child) {
                    if (value == TagVType.slider) {
                      return SizedBox();
                    }
                    return selectDefaultValue();
                  },
                ),
                autoLoadWidget(),
                descriptionUI(),
                buttons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController descriptionController = TextEditingController();

  ValueNotifier<int> selectTagID = ValueNotifier(0);
  ValueNotifier<bool> labelError = ValueNotifier(false);
  ValueNotifier<String> labelErrorMessage = ValueNotifier('');
  ValueNotifier<bool> unitError = ValueNotifier(false);
  ValueNotifier<bool> maxRangError = ValueNotifier(false);
  ValueNotifier<String> maxRangErrorMessage = ValueNotifier('');
  ValueNotifier<bool> minRangError = ValueNotifier(false);
  ValueNotifier<String> minRangErrorMessage = ValueNotifier('');
  ValueNotifier<bool> precisionError = ValueNotifier(false);

  void setPreconfigureData({required int id}) {
    var preTag = TagHelper().preConfigTagList.value.firstWhere((element) => element.id == id);
    labelTextEdit.text = stringLocalization.getTextFromEnglish(preTag.labelName);
    unitTextEdit.text = preTag.unitName;
    minTextEdit.text =
        double.parse(preTag.minRange.toStringAsFixed(2).replaceAll(regex, '')).toString();
    maxTextEdit.text =
        double.parse(preTag.maxRange.toStringAsFixed(2).replaceAll(regex, '')).toString();
    precisionTextEdit.text = preTag.precisionDigit.toString().replaceAll(regex, '');
    defaultRangeValue.value =
        double.parse(preTag.defaultValue.toStringAsFixed(2).replaceAll(regex, ''));
    selectedImage = preTag.imageName;
    if (preTag.precisionDigit > 0) {
      tagVType.value = TagVType.range;
      setRangeList();
    } else {
      tagVType.value = TagVType.slider;
    }
    setState(() {});
  }

  Widget preConfigTagUI() {
    return SizedBox(
      height: 70,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
        children: TagHelper()
            .preConfigTagList
            .value
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                child: InkWell(
                  onTap: () {
                    selectTagID.value = e.id.toInt();
                    setPreconfigureData(id: selectTagID.value);
                  },
                  child: ValueListenableBuilder(
                    valueListenable: selectTagID,
                    builder: (context, value, widget) {
                      return Chip(
                        side: BorderSide(color: Colors.transparent),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        labelStyle: TextStyle(
                          color: value == e.id
                              ? HexColor.fromHex('#00AFAA').withOpacity(0.7)
                              : Theme.of(context).brightness == Brightness.light
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          height: 1.0,
                        ),
                        avatar: Image.network(
                          e.imageName,
                          height: 18,
                          width: 18,
                          color: value == e.id
                              ? HexColor.fromHex('#00AFAA').withOpacity(0.7)
                              : Theme.of(context).brightness == Brightness.light
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                        ),
                        labelPadding: EdgeInsets.symmetric(horizontal: 10),
                        label: Text(
                          e.labelName,
                        ),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.5),
                        ),
                        backgroundColor: value == e.id
                            ? Colors.white
                            : HexColor.fromHex('#00AFAA').withOpacity(0.7),
                      );
                    },
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget descriptionUI() {
    return Container(
      height: 80.h,
      margin: EdgeInsets.only(top: 24.h, left: 33.w, right: 33.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.h)),
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                : Colors.white.withOpacity(0.9),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(-5.w, -5.h),
          ),
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.75)
                : HexColor.fromHex('#D1D9E6'),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(5.w, 5.h),
          ),
        ],
      ),
      child: TextFormField(
        controller: descriptionController,
        minLines: 1,
        maxLines: 10,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 16.w, right: 16.w),
          hintText:
              '${StringLocalization.of(context).getText(StringLocalization.noteDescription)}*',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.38)
                : HexColor.fromHex('#7F8D8C'),
          ),
        ),
        onChanged: (value) {
          isTagEdit = true;
          setState(() {});
        },
        textInputAction: TextInputAction.newline,
      ),
    );
  }

  Widget selectedImageView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          Theme.of(context).brightness == Brightness.dark
              ? 'asset/imageBackground_dark.png'
              : 'asset/imageBackground_light.png',
        ),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(15.h),
              child: imageWidget(selectedImage ?? ''),
            )
          ],
        ),
      ],
    );
  }

  Widget imageWidget(String imageName) {
    if (imageName.isEmpty) {
      imageName = 'asset/placeholder.png';
    }
    if (imageName.contains('asset')) {
      return Image.asset(
        imageName,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#62CBC9')
            : HexColor.fromHex('00AFAA'),
      );
    }
    if (imageName.contains('https') || imageName.contains('http')) {
      return Image.network(
        imageName,
        color: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#62CBC9')
            : HexColor.fromHex('00AFAA'),
      );
    }
    return Image.memory(
      base64Decode(imageName),
      color: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#62CBC9')
          : HexColor.fromHex('00AFAA'),
      gaplessPlayback: true,
    );
  }

  Widget emojiList() {
    var imageList = (widget.category == 1)
        ? [
            'asset/Sport/basketball_icon.png',
            'asset/Sport/volleyball_icon.png',
            'asset/Sport/golf_icon.png',
            'asset/Sport/hockey_icon.png',
          ]
        : [
            'asset/Wellness/bone_break_icon.png',
            'asset/Wellness/brain_icon.png',
            'asset/Wellness/frown_icon.png',
            'asset/Wellness/smile_icon.png',
          ];

//    if (selectedImage == null) {
//      selectedImage = imageList[0];
//    }

    return Container(
      margin: EdgeInsets.only(top: 15.h, left: 33.w, right: 33.w),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(stringLocalization.getText(StringLocalization.selectImage),
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp)),
          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List<Widget>.generate(imageList.length, (index) {
                  return InkWell(
                    onTap: () {
                      isTagEdit = true;
                      errorImage = false;
                      selectedImage = imageList[index];
                      setState(() {});
                    },
                    child: Container(
                      key: index == 1
                          ? Key('IconBoneBreak')

                          : Key('randomIcon'),
                      margin: EdgeInsets.only(right: 20.w),
                      height: 43.w,
                      width: 43.w,
                      child: Image.asset(
                        '${imageList[index]}',
                        gaplessPlayback: true,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('00AFAA')
                            : null,
                      ),
                    ),
                  );
                }),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () async {
                          final result = await Constants.navigatePush(
                                  IconsScreen(tagCategory: widget.category), context,
                                  rootNavigation: false)
                              .then((value) {
                            screen = Constants.tagEditor;
                            if (value != null) {
                              errorImage = false;
                              isTagEdit = true;
                              selectedImage = value;
                            }
                            setState(() {});
                          });
                        },
                        child: Tooltip(
                          message: 'moreButton',
                          child: AutoSizeText(
                            stringLocalization.getText(StringLocalization.more),
                            style: TextStyle(
                                color: HexColor.fromHex('#00AFAA'),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp),
                            maxLines: 1,
                            minFontSize: 6,
                          ),
                        )),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future removeTag(TagLabel tagLabel) async {
    var isInternet = await Constants.isInternetAvailable();
    if (tagLabel.iD > 0) {
      if (isInternet) {
        Map map = {'TagLabelID': tagLabel.iD.toInt()};
        final result = await TagRepository().deleteTagLabelByID(tagLabel.iD.toInt());
        if (result.hasData) {
          if (result.getData!.result!) {
            if (userId != null) {
              await dbHelper.removeTagWithSync(tagLabel.iD.toInt(), 1, userId!);
            }
          } else {
            if (userId != null) {
              await dbHelper.removeTagWithSync(tagLabel.iD.toInt(), 0, userId!);
            }
          }
        } else {
          if (userId != null) {
            await dbHelper.removeTagWithSync(tagLabel.iD.toInt(), 0, userId!);
          }
        }
        // await RemoveTagLabelApi()
        //     .callApi(Constants.baseUrl + "DeleteTagLabelByID", map)
        //     .then((value) async {
        //   if (value != null && !value["isError"]) {
        //     if (userId != null)
        //       await dbHelper.removeTagWithSync(tag.id!, 1, userId!);
        //   } else {
        //     if (userId != null)
        //       await dbHelper.removeTagWithSync(tag.id!, 0, userId!);
        //   }
        // });
      } else {
        if (userId != null) {
          await dbHelper.removeTagWithSync(tagLabel.iD.toInt(), 0, userId!);
        }
      }
    } else {
      if (userId != null) await dbHelper.removeTag(tagLabel.iD.toInt(), userId!);
    }
    if (userId != null) {
      dbHelper.removeGraphType(tagLabel.labelName, 'TagNote', userId!);
    }
    removeTagFromPreferences(tagLabel.labelName);
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future removeTagFromPreferences(String tagLabel) async {
    try {
      if (preferences == null) {
        preferences = await SharedPreferences.getInstance();
      }
      var list = preferences!.getStringList(Constants.prefKeyForGraphPages) ?? [];
      var graphList =
          list.map((e) => GraphSharedPreferenceManagerModel.fromMap(jsonDecode(e))).toList();
      graphList.forEach(
        (element) {
          for (var e in element.windowList) {
            var index = -1;
            var ele = e!.selectedType;
            for (var i = 0; i < ele.length; i++) {
              if (ele[i].fieldName == tagLabel && ele[i].tableName == 'TagNote') {
                index = i;
              }
            }
            if (index != -1) {
              e.selectedType.removeAt(index);
              if (e.selectedType.isEmpty) {
                e.title = '';
              } else {
                e.title = e.selectedType.first.name;
              }
            }
          }
          element.windowList.removeWhere((element) => element!.selectedType.isEmpty);
        },
      );
      await preferences!.setStringList(
          Constants.prefKeyForGraphPages, graphList.map((e) => jsonEncode(e.toMap())).toList());
    } catch (e) {
      print('Exception while removing tag from preferences $e');
    }
  }

  Widget label() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 29.h, left: 33.w, right: 33.w),
          // height: 49.h,
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10.h),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : Colors.white,
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5.w, -5.h),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.75)
                      : HexColor.fromHex('#D1D9E6'),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5.w, 5.h),
                ),
              ]),
          child: GestureDetector(
            onTap: () {
              tagLabelFocusNode.requestFocus();
              errorTagLabel = false;
              errorAlreadyUsedName = false;
              openKeyboardMaxRange = false;
              openKeyboardMinRange = false;
              openKeyboardPrecision = false;
              openKeyboardTagLabel = true;
              openKeyboardUnit = false;
              setState(() {});
            },
            child: Container(
              key: Key('labelField'),
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              decoration: openKeyboardTagLabel
                  ? ConcaveDecoration(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
                      depression: 7,
                      colors: [
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.5)
                              : HexColor.fromHex('#D1D9E6'),
                          Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                              : Colors.white,
                        ])
                  : BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.h)),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
                    ),
              child: IgnorePointer(
                ignoring: openKeyboardTagLabel ? false : true,
                child: TextFormField(
                  autovalidateMode: autoValidate,
                  // ? AutovalidateMode.always
                  // : AutovalidateMode.disabled,
                  focusNode: tagLabelFocusNode,
                  controller: labelTextEdit,
                  decoration: InputDecoration(
                      hintText: errorTagLabel
                          ? stringLocalization.getText(StringLocalization.enterLabel)
                          : stringLocalization.getText(StringLocalization.label),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: errorTagLabel
                              ? HexColor.fromHex('#FF6259')
                              : HexColor.fromHex('#7F8D8C'))),
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (value) {
                    openKeyboardTagLabel = false;
                    setState(() {});
                  },
                  onChanged: (value) {
                    isTagEdit = true;
                    setState(() {});
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter(regExForRestrictEmoji(), allow: false),
                    FilteringTextInputFormatter(RegExp('[a-zA-Z0-9 ]'), allow: true),
                    LengthLimitingTextInputFormatter(50),
                  ],
//                  validator: (value) {
//                    if (value.isEmpty) {
//                      return stringLocalization
//                          .getText(StringLocalization.enterLabel);
//                    }
//                    return null;
//                  },
                ),
              ),
            ),
          ),
        ),
        errorAlreadyUsedName
            ? Container(
                padding: EdgeInsets.only(top: 5.h, left: 33.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error,
                      color: HexColor.fromHex('#FF6259'),
                      size: 15.h,
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        stringLocalization.getText(StringLocalization.alreadyUsedName),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: HexColor.fromHex('#FF6259'),
                        ),
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  RegExp regExForRestrictEmoji() => RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  Widget unit() {
    return Container(
        margin: EdgeInsets.only(top: 17.h, left: 33.w, right: 33.w),
        // height: 49.h,
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(10.h),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                    : Colors.white,
                blurRadius: 5,
                spreadRadius: 0,
                offset: Offset(-5.w, -5.h),
              ),
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.75)
                    : HexColor.fromHex('#D1D9E6'),
                blurRadius: 5,
                spreadRadius: 0,
                offset: Offset(5.w, 5.h),
              ),
            ]),
        child: GestureDetector(
            onTap: () {
              unitFocusNode.requestFocus();
              errorUnit = false;
              openKeyboardMaxRange = false;
              openKeyboardMinRange = false;
              openKeyboardPrecision = false;
              openKeyboardTagLabel = false;
              openKeyboardUnit = true;
              setState(() {});
            },
            child: Container(
                key: Key('unitField'),
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                decoration: openKeyboardUnit
                    ? ConcaveDecoration(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
                        depression: 7,
                        colors: [
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.5)
                                : HexColor.fromHex('#D1D9E6'),
                            Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                                : Colors.white,
                          ])
                    : BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.h)),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : AppColor.backgroundColor,
                      ),
                child: IgnorePointer(
                  ignoring: openKeyboardUnit ? false : true,
                  child: TextFormField(
                    autovalidateMode: autoValidate,
                    // ? AutovalidateMode.always
                    // : AutovalidateMode.disabled,
                    focusNode: unitFocusNode,
                    controller: unitTextEdit,
                    decoration: InputDecoration(
                        hintText: errorUnit
                            ? stringLocalization.getText(StringLocalization.enterUnit)
                            : stringLocalization.getText(StringLocalization.unit),
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: errorUnit
                                ? HexColor.fromHex('#FF6259')
                                : HexColor.fromHex('#7F8D8C'))),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (value) {
                      openKeyboardUnit = false;
                      setState(() {});
                    },
                    onChanged: (value) {
                      isTagEdit = true;
                      setState(() {});
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter(regExForRestrictEmoji(), allow: false),
                      FilteringTextInputFormatter(RegExp('[a-zA-Z0-9 ]'), allow: true),
                      LengthLimitingTextInputFormatter(50),
                    ],
//        validator: (value) {
//          if (value.isEmpty) {
//            return stringLocalization.getText(StringLocalization.enterUnit);
//          }
//          return null;
//        },
                  ),
                ))));
  }

  Widget slider() {
    return Container(
      margin: EdgeInsets.only(top: 23.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 33.w,
            ),
            child: Text(
              stringLocalization.getText(StringLocalization.intensity),
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20.h),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  key: Key('exerciseSliderKey'),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 21.h, left: 33.w, right: 33.w),
                  height: 16.h,
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 11,
                        crossAxisSpacing: 28.w,
                        childAspectRatio: 0.1,
                      ),
                      itemCount: 11,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 5.w, top: 4.h, right: 5.w),
                      itemBuilder: (context, index) {
                        return Container(
                          height: 8.h,
                          width: 1.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.38)
                                : HexColor.fromHex('#A7B2AF'),
                            borderRadius: BorderRadius.circular(2.h),
                          ),
                        );
                      })),
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: SliderTheme(
                      data: SliderThemeData(
                        thumbColor: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#99D9D9')
                            : HexColor.fromHex('#62CBC9'),
                        activeTrackColor: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#62CBC9')
                            : HexColor.fromHex('#99D9D9'),
                        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : HexColor.fromHex('#D9E0E0'),
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 26.0),
                        overlayColor: HexColor.fromHex('#99D9D9').withOpacity(0.5),
                        inactiveTickMarkColor: Colors.transparent,
                        activeTickMarkColor: Colors.transparent,
                        valueIndicatorColor: HexColor.fromHex('#FF6259'),
                        valueIndicatorTextStyle: TextStyle(
                            color: HexColor.fromHex('#FFDFDE'),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp),
                        trackShape: RoundedRectSliderTrackShape(),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        key: Key('exerciseSlider'),
                        value: defaultRangeValue.value,
                        min: 0.0,
                        max: 10.0,
                        divisions: 10,
                        label: defaultRangeValue.value.round().toString(),
                        onChanged: (double selectedValue) {
                          isTagEdit = true;
                          setState(() {
                            defaultRangeValue.value = selectedValue;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 33.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleText(
                  text: stringLocalization.getText(StringLocalization.easy).toUpperCase(),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : HexColor.fromHex('#5D6A68'),
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
                TitleText(
                  text: stringLocalization.getText(StringLocalization.moderate).toUpperCase(),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : HexColor.fromHex('#5D6A68'),
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
                TitleText(
                  text: stringLocalization.getText(StringLocalization.max).toUpperCase(),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : HexColor.fromHex('#5D6A68'),
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rangeWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 23.h, left: 33.w, right: 33.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stringLocalization.getText(StringLocalization.range),
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 13.h),
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: minRangError,
                  builder: (context, value, widget) {
                    return AppTextFormField(
                      onChange: (value) {
                        isTagEdit = true;
                        setState(() {});
                        setRangeList();
                      },
                      onTap: (){},
                      controller: minTextEdit,
                      isError: value,
                      errorMessage: minRangErrorMessage.value,
                      hintText: stringLocalization.getText(StringLocalization.enterMin),
                      hintColor:
                          errorMinRange ? HexColor.fromHex('#FF6259') : HexColor.fromHex('#7F8D8C'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                      inputFormatter: [
                        LengthLimitingTextInputFormatter(3),
                        FilteringTextInputFormatter(RegExp('[\\-|\\ ,|]'), allow: false),
                        FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                      ],
                    );
                  },
                ),
              ),
              SizedBox(width: 11.w),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: maxRangError,
                  builder: (context, value, widget) {
                    return AppTextFormField(
                      onChange: (value) {
                        isTagEdit = true;
                        setState(() {});
                        setRangeList();
                      },
                      onTap: (){},
                      controller: maxTextEdit,
                      hintText: stringLocalization.getText(StringLocalization.maximum),
                      isError: value,
                      errorMessage: maxRangErrorMessage.value,
                      hintColor:
                          errorMaxRange ? HexColor.fromHex('#FF6259') : HexColor.fromHex('#7F8D8C'),
                      inputFormatter: [
                        LengthLimitingTextInputFormatter(3),
                        FilteringTextInputFormatter(RegExp('[\\-|\\ ,|]'), allow: false),
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 17.w),
          ValueListenableBuilder(
            valueListenable: precisionError,
            builder: (context, value, widget) {
              return AppTextFormField(
                onChange: (value) {
                  isTagEdit = true;
                  setState(() {});
                  setRangeList();
                },
                controller: precisionTextEdit,
                hintText: stringLocalization.getText(StringLocalization.precision),
                isError: value,
                errorMessage: 'Enter valid precision',
                hintColor: HexColor.fromHex('7F8D8C'),
                inputFormatter: [
                  LengthLimitingTextInputFormatter(3),
                  FilteringTextInputFormatter(RegExp('[\\-|\\ ,|]'), allow: false),
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                ],
                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget range() {
    return Padding(
      padding: EdgeInsets.only(top: 23.h, left: 33.w, right: 33.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            stringLocalization.getText(StringLocalization.range),
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 13.h),
          errorRange
              ? Container(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error,
                        color: HexColor.fromHex('#FF6259'),
                        size: 15.h,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          stringLocalization.getText(StringLocalization.minMustBeSmallerThenMax),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: HexColor.fromHex('#FF6259'),
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget selectDefaultValue() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 33.w,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 23.h),
          ValueListenableBuilder(
            valueListenable: defaultRangeValue,
            builder: (BuildContext context, value, Widget? child) {
              return Text(
                '${stringLocalization.getText(StringLocalization.defaultValueTag)} ${value.toStringAsFixed(1)}',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          SizedBox(height: 13.h),
          Center(
            child: Container(
              height: 35.h,
              width: 259.w,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.8)
                        : HexColor.fromHex('#D1D9E6'),
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: Offset(0, 2.h),
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.8)
                        : HexColor.fromHex('#D1D9E6'),
                    blurRadius: 3,
                    spreadRadius: 0,
                    offset: Offset(0, -2.h),
                  ),
                ],
              ),
              child: Container(
                key: Key('addTagScroller'),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#111B1A')
                      : HexColor.fromHex('#F2F2F2'),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : HexColor.fromHex('#E7EBF2'),
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : HexColor.fromHex('#E7EBF2'),
                      Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#212D2B')
                          : HexColor.fromHex('#FFFFFF'),
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : HexColor.fromHex('#E7EBF2'),
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : HexColor.fromHex('#E7EBF2'),
                    ],
                  ),
                ),
                height: 35.h,
                width: 259.w,
                child: RotatedBox(
                  quarterTurns: 135,
                  child: ValueListenableBuilder(
                    valueListenable: rangeList,
                    builder: (context, valueList, widget) {
                      return CustomCupertinoPicker(
                        backgroundColor: Colors.transparent,
                        scrollController: FixedExtentScrollController(
                            initialItem: valueList.indexOf(defaultRangeValue.value)),
                        itemExtent: maxTextEdit.text.length == 3 ? 50.w : 45.w,
                        children: List.generate(
                          valueList.length,
                          (index) {
                            return RotatedBox(
                              quarterTurns: 45,
                              child: Center(
                                child: ValueListenableBuilder(
                                  valueListenable: defaultRangeValue,
                                  builder: (context, selectedValue, widget) {
                                    return TitleText(
                                      text: valueList[index].toStringAsFixed(
                                          precisionTextEdit.text.contains('.') ? 1 : 0),
                                      color: selectedValue == valueList[index]
                                          ? HexColor.fromHex('#FF6259')
                                          : Theme.of(context).brightness == Brightness.dark
                                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                              : HexColor.fromHex('#5D6A68'),
                                      fontWeight: selectedValue == valueList[index]
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: valueList[index].toString().length > 2
                                          ? 14.sp
                                          : valueList[index].toString().length > 1
                                              ? 16.sp
                                              : 18.sp,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        onSelectedItemChanged: (int value) {
                          isTagEdit = true;
                          setState(() {});
                          defaultRangeValue.value = rangeList.value[value].toDouble();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget autoLoadWidget() {
    return Container(
      margin: EdgeInsets.only(top: 30.h, left: 33.w, right: 33.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                  : Colors.white.withOpacity(0.7),
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
      child: ListTile(
        title: Text(stringLocalization.getText(StringLocalization.autoLoad),
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
                fontWeight: FontWeight.bold,
                fontSize: 16.sp)),
        trailing: CustomSwitch(
          key: Key('customToggleSwitch'),
          value: isAutoLoad,
          onChanged: (value) {
            isTagEdit = true;
            isAutoLoad = value;
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
      ),
    );
  }

  int divisions(double min, double max, double precision) {
    try {
      if (precision >= 0 && precision <= max) {
        return (max) ~/ (precision);
      }
    } catch (e) {
      print(e);
    }
    return 1;
  }

  Widget buttons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 33.w),
      child: Row(
        children: <Widget>[

          Expanded(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.h),
                color: isTagEdit || widget.tagLabel == null
                    ? HexColor.fromHex('#00AFAA')
                    : Colors.grey.withOpacity(0.7),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : Colors.white,
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(-5, -5),
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.75)
                        : HexColor.fromHex('#D1D9E6'),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: Key('updateButton'),
                  borderRadius: BorderRadius.circular(30.h),
                  splashColor: HexColor.fromHex('#00AFAA'),
                  onTap: () async {
                    var validate = checkValidation();
                    print(validate);
                    if (validate) {
                      if (widget.tagLabel == null) {
                        var result = await addTag();
                        Navigator.of(context).pop(result);
                      } else {
                        var updatedTag = await updateTag();
                        if (updatedTag != null) {
                          Navigator.of(context).pop(updatedTag);
                        }
                      }
                    }
                  },
                  child: Container(
                    decoration: ConcaveDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.h),
                      ),
                      depression: 10,
                      colors: [
                        Colors.white,
                        HexColor.fromHex('#D1D9E6'),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        (widget.tagLabel != null
                            ? stringLocalization.getText(StringLocalization.update)
                            : stringLocalization.getText(StringLocalization.add))
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#111B1A')
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 17.w),
          Expanded(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.h),
                color: isTagEdit || widget.tagLabel == null
                    ? HexColor.fromHex('#FF6259').withOpacity(0.8)
                    : Colors.grey.withOpacity(0.7),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : Colors.white,
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(-5, -5),
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.75)
                        : HexColor.fromHex('#D1D9E6'),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30.h),
                  splashColor: HexColor.fromHex('#FF6259').withOpacity(0.8),
                  onTap: widget.tagLabel == null
                      ? () {
                          Navigator.of(context).pop();
                        }
                      : isTagEdit
                          ? () {
                              isTagEdit = false;
                              setDefaultValue();
                              if (mounted) {
                                setState(() {});
                              }
                            }
                          : null,
                  child: Container(
                    key: Key('cancelButton'),
                    decoration: ConcaveDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.h),
                        ),
                        depression: 10,
                        colors: [
                          Colors.white,
                          HexColor.fromHex('#D1D9E6'),
                        ]),
                    child: Center(
                      child: Text(
                        stringLocalization.getText(StringLocalization.cancel).toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#111B1A')
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  void clearValidation() {
    labelError.value = false;
    unitError.value = false;
    minRangError.value = false;
    maxRangError.value = false;
    precisionError.value = false;
  }

  bool checkValidation() {
    clearValidation();
    if (labelTextEdit.text.trim().isEmpty) {
      labelError.value = true;
      labelErrorMessage.value = stringLocalization.getText(StringLocalization.enterLabel);
      return false;
    }
    if (unitTextEdit.text.trim().isEmpty) {
      unitError.value = true;
      return false;
    }
    if (tagVType.value == TagVType.range && minTextEdit.text.trim().isEmpty) {
      minRangError.value = true;
      minRangErrorMessage.value = stringLocalization.getText(StringLocalization.enterMin);
      maxRangError.value = true;
      maxRangErrorMessage.value = ' ';
      return false;
    }
    if (tagVType.value == TagVType.range && maxTextEdit.text.trim().isEmpty) {
      maxRangError.value = true;
      maxRangErrorMessage.value = stringLocalization.getText(StringLocalization.enterMax);
      minRangError.value = true;
      minRangErrorMessage.value = ' ';
      return false;
    }
    if (tagVType.value == TagVType.range &&
        (precisionTextEdit.text.trim().isEmpty ||
            (double.tryParse(precisionTextEdit.text.trim()) ?? 0.0) <= 0.0)) {
      precisionError.value = true;
      return false;
    }

    if (widget.tagLabel == null &&
        tagHelper.tagList.value
            .map((e) => e.labelName.toLowerCase())
            .toList()
            .contains(labelTextEdit.text.trim().toLowerCase())) {
      labelErrorMessage.value = stringLocalization.getText(StringLocalization.alreadyUsedName);
      labelError.value = true;
      return false;
    }
    if (tagVType.value == TagVType.range) {
      var min = double.tryParse(minTextEdit.text.trim()) ?? 0.0;
      var max = double.tryParse(maxTextEdit.text.trim()) ?? 0.0;
      if (min > max) {
        maxRangError.value = false;
        minRangError.value = false;
        if (min > max) {
          maxRangErrorMessage.value = 'min > max';
          minRangErrorMessage.value = ' ';
          maxRangError.value = true;
          minRangError.value = true;
        }
        return false;
      }
    }
    if (selectedImage == null || selectedImage!.isEmpty) {
      CustomSnackBar.buildSnackbar(
          context, stringLocalization.getText(StringLocalization.imageIsEmpty), 3);
      return false;
    }
    return true;
  }

  /// Added by : Shahzad
  /// Added on: 9th Feb 2021
  /// checks whether all required fields are filled or not before creating a tag
  void validateAddTag() {
    if (labelTextEdit.text.isEmpty || labelTextEdit.text.trim().isEmpty) {
      errorTagLabel = true;
      labelTextEdit.clear();
    }
    if (unitTextEdit.text.isEmpty || unitTextEdit.text.trim().isEmpty) {
      errorUnit = true;
      unitTextEdit.clear();
    }
    if (minTextEdit.text.isEmpty || minTextEdit.text.trim().isEmpty) {
      errorMinRange = true;
      minTextEdit.clear();
    }
    if (maxTextEdit.text.isEmpty || maxTextEdit.text.trim().isEmpty) {
      errorMaxRange = true;
      maxTextEdit.clear();
    }
    if (maxTextEdit.text.isNotEmpty &&
        minTextEdit.text.isNotEmpty &&
        double.parse(minTextEdit.text) >= double.parse(maxTextEdit.text)) {
      errorRange = true;
    }

    if (labelTextEdit.text.isNotEmpty) {
      if (widget.tagLabel != null && labelTextEdit.text == widget.tagLabel!.labelName) {
        errorAlreadyUsedName = false;
      } else if (tagHelper.tagList.value.isNotEmpty) {
        tagHelper.tagList.value.forEach((element) {
          if (element.labelName.toLowerCase() == labelTextEdit.text.trim().toLowerCase()) {
            errorAlreadyUsedName = true;
          }
        });
      }
    }
    if (selectedImage == null || selectedImage!.isEmpty) {
      errorImage = true;
    }
    setState(() {
      if (errorImage) {
        CustomSnackBar.buildSnackbar(
            context, stringLocalization.getText(StringLocalization.imageIsEmpty), 3);
      }
    });
  }

  OverlayEntry showOverlay(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);
    var overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(child: CircularProgressIndicator()),
          color: Colors.black26,
        ),
      ),
    );
    overlayState.insert(overlayEntry);
    return overlayEntry;
  }

  Future addTag() async {
    entry = showOverlay(context);
    var base64String = selectedImage ?? '';
    if (selectedImage != null && selectedImage!.contains('asset')) {
      try {
        var bytes = await rootBundle.load(selectedImage!);
        var buffer = bytes.buffer;
        base64String = base64Encode(Uint8List.view(buffer));
      } catch (e) {
        print(e);
      }
    }
    var isInternet = await Constants.isInternetAvailable();
    if (userId != null && !userId!.contains('Skip') && isInternet) {
      var map = {
        'UserID': userId,
        'ImageName': base64String,
        'UnitName': unitTextEdit.text,
        'LabelName': labelTextEdit.text,
        'MinRange': minTextEdit.text.isNotEmpty
            ? double.parse(double.parse(minTextEdit.text).toStringAsFixed(2))
            : 0.0,
        'MaxRange': maxTextEdit.text.isNotEmpty
            ? double.parse(double.parse(maxTextEdit.text).toStringAsFixed(2))
            : 10.0,
        'DefaultValue': defaultRangeValue.value,
        'PrecisionDigit': precisionTextEdit.text.isNotEmpty
            ? double.parse(double.parse(precisionTextEdit.text).toStringAsFixed(2))
            : 1.0,
        'FKTagLabelTypeID': widget.category,
        'IsAutoLoad': isAutoLoad,
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch,
        'Short_description': descriptionController.text.trim(),
      };
      final result = await TagRepository().addTagLabel(AddTagLabelRequest.fromJson(map));
      if (result.hasData) {
        if (result.getData!.result!) {
          if (entry != null) entry!.remove();
          return true;
        }
      }
    }
    if (entry != null) entry!.remove();
    return false;
  }

  Future<TagLabel?> updateTag() async {
    entry = showOverlay(context);
    var base64String = selectedImage ?? '';
    if (selectedImage != null && selectedImage!.contains('asset')) {
      try {
        var bytes = await rootBundle.load(selectedImage!);
        var buffer = bytes.buffer;
        base64String = base64Encode(Uint8List.view(buffer));
      } catch (e) {
        print(e);
      }
    }
    var isInternet = await Constants.isInternetAvailable();
    if (userId != null && !userId!.contains('Skip') && isInternet) {
      var map = {
        'UserID': userId,
        'ID': widget.tagLabel!.iD.toString(),
        'ImageName': base64String,
        'UnitName': unitTextEdit.text,
        'LabelName': labelTextEdit.text,
        'MinRange': double.parse(double.parse(minTextEdit.text).toStringAsFixed(2)),
        'MaxRange': double.parse(double.parse(maxTextEdit.text).toStringAsFixed(2)),
        'DefaultValue': defaultRangeValue.value,
        'PrecisionDigit': double.parse(double.parse(precisionTextEdit.text).toStringAsFixed(2)),
        'FKTagLabelTypeID': widget.tagLabel!.fKTagLabelTypeID,
        'IsAutoLoad': widget.tagLabel!.isAutoLoad,
        'Short_description': descriptionController.text.trim(),
      };
      var editTagLabelResult =
          await TagRepository().editTagLabel(EditTagLabelRequest.fromJson(map));

      if (editTagLabelResult.hasData) {
        if (editTagLabelResult.getData!.result!) {
          map.addAll({
            'TotalRecords': widget.tagLabel!.totalRecords,
            'PageNumber': widget.tagLabel!.pageNumber,
            'PageSize': widget.tagLabel!.pageSize,
            'Suggestion': widget.tagLabel!.suggestion,
            'CreatedDateTime': widget.tagLabel!.createdDateTime,
            'CreatedDateTimeStamp': widget.tagLabel!.createdDateTimeStamp,
          });
          var tagLabel = TagLabel.fromJson(map);
          await dbHelper.updateTagLabel([tagLabel], userId!);
          var temp = await dbHelper.fetchTagLabelByID(tagLabel.userID, tagLabel.iD);
          if (temp != null) {
            if (entry != null) entry!.remove();
            return temp;
          }
        }
      }
    }

    if (entry != null) entry!.remove();
    return null;
  }

  void setDefaultValue() {
    if (widget.tagLabel != null) {
      print('precisionText :: ${widget.tagLabel!.precisionDigit.toDouble()}');
      labelTextEdit.text = stringLocalization.getTextFromEnglish(widget.tagLabel!.labelName);
      unitTextEdit.text = widget.tagLabel!.unitName;
      minTextEdit.text = widget.tagLabel!.minRange.toString().replaceAll(regex, '');
      maxTextEdit.text = widget.tagLabel!.maxRange.toString().replaceAll(regex, '');
      precisionTextEdit.text =
          widget.tagLabel!.precisionDigit.toDouble().toString().replaceAll(regex, '');
      defaultRangeValue.value = double.parse(widget.tagLabel!.defaultValue.toStringAsFixed(2));
      selectedImage = widget.tagLabel!.imageName;
      isAutoLoad = widget.tagLabel!.isAutoLoad;
      descriptionController.text = widget.tagLabel!.shortDescription;
    }
    setRangeList(isFromInit: widget.tagLabel == null);
  }

  ValueNotifier<List<double>> rangeList = ValueNotifier([]);
  ValueNotifier<double> minRange = ValueNotifier(1.0);
  ValueNotifier<double> maxRange = ValueNotifier(10.0);
  ValueNotifier<double> precisionRange = ValueNotifier(1.0);
  ValueNotifier<double> defaultRangeValue = ValueNotifier(1.0);

  void setRangeList({bool isFromInit = false}) {
    var min = 1.0;
    var max = 10.0;
    var precision = 1.0;

    if (minTextEdit.text.trim().isNotEmpty) {
      try {
        min = double.tryParse(minTextEdit.text) ?? 1.0;
      } catch (e) {
        print(e);
      }
    }
    if (maxTextEdit.text.trim().isNotEmpty) {
      try {
        max = double.tryParse(maxTextEdit.text) ?? 10.0;
      } catch (e) {
        print(e);
      }
    }
    if (precisionTextEdit.text.trim().isNotEmpty) {
      try {
        precision = double.tryParse(precisionTextEdit.text) ?? 0;
      } catch (e) {
        print(e);
      }
    }

    minRange.value = min;
    maxRangError.value = false;
    minRangError.value = false;
    if (min > max) {
      maxRangErrorMessage.value = 'min > max';
      minRangErrorMessage.value = ' ';
      maxRangError.value = true;
      minRangError.value = true;
      min = 1.0;
      max = 10.0;
      precision = 1.0;
    }
    maxRange.value = max;
    if (precision <= 0) {
      precision = 1.0;
    }
    precisionRange.value = precision;

    if (isFromInit) {
      precisionTextEdit.text = precision.toStringAsFixed(0);
    }

    var temp = <double>[];
    for (double i = min; i <= max; i = i + precision) {
      temp.add(i);
    }

    rangeList.value.clear();
    rangeList.value.addAll(temp);
    rangeList.notifyListeners();

    if (!rangeList.value.contains(defaultRangeValue.value)) {
      defaultRangeValue.value = rangeList.value.first;
    }
  }

  /*void setValueInPicker() {
    var min = 1.0;
    var max = 10.0;
    var precision = 1.0;
    try {
      if (minTextEdit.text.isNotEmpty) {
        min = double.parse(double.parse(minTextEdit.text).toStringAsFixed(2));
      }
      if (maxTextEdit.text.isNotEmpty) {
        max = double.parse(double.parse(maxTextEdit.text).toStringAsFixed(2));
      }
      if (maxTextEdit.text.isNotEmpty) {
        try {
          precision = double.parse(double.parse(precisionTextEdit.text).toStringAsFixed(2));
        } catch (e) {
          precision = 1.0;
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
    if (min <= max && precision >= 0) {
      list.clear();
      for (var i = min; i <= max; i += precision) {
        list.add(i);
      }
      if (!list.contains(defaultValue)) {
        defaultValue = min.toDouble();
      }
    }
    print('listLength :: ${min <= max}');
    print('listLength :: ${precision != 0}');
    print('listLength :: ${min <= max && precision != 0}');
    print('listLength :: $list');
    setState(() {});
  }*/

  Future getPreferences() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    userId = preferences!.getString(Constants.prefUserIdKeyInt);
    setState(() {});
  }

  void deleteDialog({required GestureTapCallback onClickYes}) {
    var dialog = CustomDialog(
        title: stringLocalization.getText(StringLocalization.delete),
        subTitle: stringLocalization.getText(StringLocalization.tagDeleteInfo),
        onClickYes: onClickYes,
        maxLine: 2,
        onClickNo: onClickDeleteNo);
    showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => dialog,
        barrierColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.color7F8D8C.withOpacity(0.6)
            : AppColor.color384341.withOpacity(0.6),
        barrierDismissible: false);
  }

  backDialog({required GestureTapCallback onClickYes}) {
    var dialog = CustomDialog(
      title: stringLocalization.getText(StringLocalization.changesNotSaved),
      subTitle: stringLocalization.getText(StringLocalization.notSavedDescription),
      onClickYes: onClickYes,
      maxLine: 2,
      onClickNo: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context);
      },
    );
    showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => dialog,
        barrierColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.color7F8D8C.withOpacity(0.6)
            : AppColor.color384341.withOpacity(0.6),
        barrierDismissible: false);
  }

  void onClickDeleteNo() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
