import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/dashboard/home_item_model.dart';
import 'package:health_gauge/screens/measurement_screen/cards/progress_card.dart';
import 'package:health_gauge/value/app_color.dart';

class HomeVitalItem extends StatelessWidget {
  const HomeVitalItem({
    required this.homeItemModel,
    required this.homeItemModel1,
    required this.onTap,
    this.showGraph = true,
    super.key,
  });

  final HomeItemModel homeItemModel;
  final HomeItemModel homeItemModel1;
  final VoidCallback onTap;
  final bool showGraph;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: isDarkMode(context) ? AppColor.darkBackgroundColor : AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(15.0),
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
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            if (homeItemModel.title.isNotEmpty || homeItemModel.details.isNotEmpty) ...[
              Expanded(
                child: Row(
                  children: [
                    Image.asset(
                      homeItemModel.iconPath,
                      height: homeItemModel.iconSize,
                      width: homeItemModel.iconSize,
                    ),
                    SizedBox(
                      width: 18.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(homeItemModel.title.isNotEmpty)...[
                          AutoSizeText(
                            homeItemModel.title,
                            style: TextStyle(
                              color: isDarkMode(context)
                                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                              fontSize: homeItemModel.fontTitleSize.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            minFontSize: 10.0,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ],
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: homeItemModel.details
                              .map(
                                (e) => AutoSizeText(
                                  e,
                                  style: TextStyle(
                                    color: isDarkMode(context)
                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                        : HexColor.fromHex('#384341'),
                                    fontSize: homeItemModel.fontDetailSize.sp,
                                  ),
                                  minFontSize: 10.0,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (homeItemModel1.title.isNotEmpty || homeItemModel1.details.isNotEmpty) ...[
              Expanded(
                child: Row(
                  children: [
                    Image.asset(
                      homeItemModel1.iconPath,
                      height: homeItemModel1.iconSize,
                      width: homeItemModel1.iconSize,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(homeItemModel1.title.isNotEmpty)...[
                          AutoSizeText(
                            homeItemModel1.title,
                            style: TextStyle(
                              color: isDarkMode(context)
                                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                              fontSize: homeItemModel.fontTitleSize.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            minFontSize: 10.0,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ],
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: homeItemModel1.details
                              .map(
                                (e) => AutoSizeText(
                                          e,
                              style: TextStyle(
                                color: isDarkMode(context)
                                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                                fontSize: homeItemModel.fontDetailSize.sp,
                              ),
                              minFontSize: 10.0,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          )
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (showGraph) ...[
              InkWell(
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 5.0,
                    left: 3.0,
                    top: 3.0,
                    bottom: 3.0,
                  ),
                  child: Image.asset(
                    'asset/graph_icon_selected.png',
                    height: 24,
                    width: 24,
                    errorBuilder: (context, object, stackTrace) {
                      return Container();
                    },
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
