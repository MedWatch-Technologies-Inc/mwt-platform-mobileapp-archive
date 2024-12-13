import 'package:flutter/material.dart' as slider;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/tag/TagHistory/tag_history_home.dart';
import 'package:health_gauge/screens/tag/add_tag_dialog.dart';
import 'package:health_gauge/screens/tag/model/tag_label.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';

class TagDetailAppbar extends StatelessWidget implements PreferredSizeWidget {
  const TagDetailAppbar({
    required this.tagLabel,
    this.result = false,
    this.onUpdate,
    super.key,
  });

  final TagLabel tagLabel;
  final bool result;
  final Function(TagLabel)? onUpdate;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      shadowColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black.withOpacity(0.5)
          : HexColor.fromHex('#384341').withOpacity(0.2),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop(result);
        },
        icon: Image.asset(
          Theme.of(context).brightness == Brightness.dark
              ? 'asset/dark_leftArrow.png'
              : 'asset/leftArrow.png',
          width: 13.w,
          height: 22.h,
        ),
      ),
      centerTitle: true,
      title: Text(
        StringLocalization.of(context).getTextFromEnglish(tagLabel.labelName),
        style: slider.TextStyle(
          fontSize: 18.sp,
          color: HexColor.fromHex('#62CBC9'),
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Constants.navigatePush(TagHistoryHome(), context);
          },
          icon: Image.asset(
            'asset/reload.png',
            height: 30,
            width: 30,
          ),
        ),
        if (tagLabel.fKTagLabelTypeID <= 2) ...[
          IconButton(
            onPressed: () async {
              var labelName = tagLabel.labelName;
              var result = await Constants.navigatePush(
                AddTagDialog(
                  title: labelName,
                  category: tagLabel.fKTagLabelTypeID,
                  tagLabel: tagLabel,
                ),
                context,
              );
              if(result!=null){
                if(result is String && result == 'delete'){
                  Navigator.of(context).pop(0);
                }
                if(result is TagLabel){
                  CustomSnackBar.buildSnackbar(context, 'Updated Tag Successfully', 3);
                  if(onUpdate!=null){
                    onUpdate!(result);
                  }
                }
              }
            },
            icon: Image.asset(
              'asset/edit_pencil.png',
              height: 22,
              width: 22,
            ),
          ),
        ]
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
