import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';

class UserImage extends StatelessWidget {
  final UserModel? user;

  const UserImage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);

    print("profile_picture ${user!.picture}");
    var imageName = 'O';
    if (globalUser == null ||
        globalUser?.gender == null ||
        globalUser!.gender!.isEmpty ||
        globalUser!.gender == 'M') {
      imageName = 'asset/m_profile_icon.png';
    } else if (globalUser?.gender == 'F') {
      imageName = 'asset/f_profile_icon.png';
    }

    if (user != null) {
      try {
        if (user!.picture != null && user!.picture!.trim().isNotEmpty) {
            var bytes = base64Decode(user!.picture!);
            return Image.memory(
              bytes,
              height: 73.h,
              width: 73.h,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            );
        }
      } catch (e) {
        print('exception in user_image $e');
        if(!user!.picture!.contains('https') && user!.picture!.contains('ProfilePicture')){
          print('exception in user_image ${user!.picture!}');
          user!.picture = 'https://storage.googleapis.com/healthgauge/${user!.picture!}';
        }
        return Image.network(
          user!.picture!,
          height: 73.h,
          width: 73.h,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      }

      if (user!.gender != null && user!.gender == 'O') {
        var name = '';
        if (user!.firstName != null && user!.lastName != null) {
          name = user!.firstName![0] + user!.lastName![0];
        }
        return Container(
          height: 60.h,
          child: AutoSizeText(
            name.toUpperCase(),
            style: TextStyle(
              fontSize: 44.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#62CBC9')
                  : HexColor.fromHex('#00AFAA'),
            ),
            maxLines: 1,
            minFontSize: 20,
            textAlign: TextAlign.center,
          ),
        );
      }
    }

    return Image.asset(
      imageName,
      height: 75.h,
      width: 75.h,
    );
  }
}
