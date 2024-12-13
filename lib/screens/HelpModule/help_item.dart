import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/HelpModule/help_item_model.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class HelpItem extends StatelessWidget {
  const HelpItem({
    required this.helpItemModel,
    required this.indexNumber,
    this.fontDifference = 0,
    super.key,
  });

  final HelpItemModel helpItemModel;
  final String indexNumber;
  final int fontDifference;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (helpItemModel.title.isNotEmpty) ...[
              TitleText(
                text: '$indexNumber.',
                fontSize: 18.0 + fontDifference,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w900,
                align: TextAlign.left,
                maxLine: 1,
              ),
              SizedBox(
                width: 5.0.w,
              ),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (helpItemModel.title.isNotEmpty) ...[
                    TitleText(
                      text: helpItemModel.title,
                      fontSize: 18.0 + fontDifference,
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w900,
                      align: TextAlign.left,
                      maxLine: 1,
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                  ],
                  if (helpItemModel.detail.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(right: 5.0.w),
                      child: Text(
                        helpItemModel.detail,
                        style: TextStyle(
                          fontSize: 13.0 + fontDifference,
                          color: AppColor.primaryColor,
                        ),
                        maxLines: 17,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(
                      height: 20.0.h,
                    ),
                  ],
                  if (helpItemModel.image.isNotEmpty) ...[
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: SizedBox(
                          width: 240.h,
                          height: 450.h,
                          child: Image.asset(
                            helpItemModel.image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if(helpItemModel.showDivider)...[
                    Divider(
                      height: 40.h,
                      thickness: 1.0,
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
        if (helpItemModel.listInfo.isNotEmpty) ...[
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(left: 10.0.w),
            children: helpItemModel.listInfo
                .map(
                  (e) => HelpItem(
                    helpItemModel: e,
                    indexNumber: '${helpItemModel.listInfo.indexOf(e) + 1}',
                    fontDifference: -2,
                  ),
                )
                .toList(),
          ),
        ]
      ],
    );
  }
}
