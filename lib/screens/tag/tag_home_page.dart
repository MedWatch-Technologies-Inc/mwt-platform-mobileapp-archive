import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/tag.dart';
import 'package:health_gauge/screens/tag/helper_widgets/app_floating_button.dart';
import 'package:health_gauge/screens/tag/helper_widgets/tag_app_bar.dart';
import 'package:health_gauge/screens/tag/helper_widgets/tag_label_item.dart';
import 'package:health_gauge/screens/tag/model/tag_label.dart';
import 'package:health_gauge/screens/tag/tag_detail_page.dart';
import 'package:health_gauge/screens/tag/tag_helper.dart';
import 'package:health_gauge/screens/tag/tag_note_screen.dart';
import 'package:health_gauge/screens/tag/tag_select_category_screen.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TagHomePage extends StatefulWidget {
  final List<TagLabel> tagList;
  final bool showNavigators;

  const TagHomePage({
    super.key,
    this.tagList = const [],
    this.showNavigators = false,
  });

  @override
  State<TagHomePage> createState() => _TagHomePageState();
}

class _TagHomePageState extends State<TagHomePage> {
  TagHelper tagHelper = TagHelper();

  @override
  void initState() {
    tagHelper.tagList.value.addAll(widget.tagList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      floatingActionButton: AppFloatingButton(
        onPressed: () {
          onFloatingPressed(context);
        },
        widgetKey: Key('addTagButton'),
        iconPath: 'asset/plus_icon.png',
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: TagAppBar(
          showNavigators: widget.showNavigators,
        ),
      ),
      body: SmartRefresher(
        controller: tagHelper.controller,
        onRefresh: tagHelper.getTagList,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: ValueListenableBuilder(
            valueListenable: tagHelper.tagList,
            builder: (BuildContext context, List<TagLabel> listValue, Widget? child) {
              if (listValue.isEmpty) {
                return Container(
                  height: 300.h,
                  alignment: Alignment.center,
                  child: TitleText(
                    text: 'No tags found',
                  ),
                );
              }
              return GridView.builder(
                key: Key('long_list'),
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12.h,
                ),
                itemCount: listValue.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
                itemBuilder: (BuildContext context, int index) {
                  var tagItem = listValue[index];
                  return TagLabelItem(
                    tagItem: tagItem,
                    onTap: () async {
                      Tag tag = await Tag().fromMap(tagItem.toJson());
                      moveToTagNoteScreen(context, tag, index, tagItem);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void moveToTagNoteScreen(BuildContext context, Tag tag, int index, TagLabel tagLabel,
      {MODE mode = MODE.MANUAL}) async {
    try {
      var result = await Navigator.push(
        context,
        CupertinoDialogRoute(
          builder: (context) => TagDetailPage(
            tagLabel: tagLabel,
            tagCount: tagHelper.tagList.value.length,
            mode: mode,
          ),
          context: context,
        ),
      );
     /* var result = await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => TagNoteScreen(
            tag: tag,
            tagCount: tagHelper.tagList.value.length,
            index: index,
            mode: mode,
          ),
        ),
      );*/
      if (result != null && result is int && result == 0) {
        tagHelper.deleteFromLocal(tagLabel, context);
      }
      if (result != null && result is bool && result) {
        tagHelper.controller.requestRefresh();
      }
    } catch (e) {
      print(e);
    }
  }

  void onFloatingPressed(BuildContext context) async {
    var result = await Constants.navigatePush(
      TagSelectCategoryScreen(),
      context,
    );
    if (result != null && result is bool && result) {
      tagHelper.controller.requestRefresh();
      CustomSnackBar.buildSnackbar(context, 'Tag Added Successfully', 3);
    }
  }
}
