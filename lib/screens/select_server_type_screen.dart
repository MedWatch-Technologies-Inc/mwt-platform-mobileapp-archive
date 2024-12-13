import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'package:health_gauge/widgets/text_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/concave_decoration.dart';
import 'measurement_screen/cards/progress_card.dart';

class SelectServerTypeScreen extends StatefulWidget {
  @override
  _SelectServerTypeScreenState createState() => _SelectServerTypeScreenState();
}

class _SelectServerTypeScreenState extends State<SelectServerTypeScreen> {
  List<String> serverTypes = ['Staging', 'Production'];
  String selectedValue = 'Staging';

  @override
  void initState() {
    getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex("#384341").withOpacity(0.2),
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
                  Navigator.of(context).pop();
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
              title: SizedBox(
                height: 28,
                // child: AutoSizeText(
                //   StringLocalization.of(context)
                //       .getText(StringLocalization.selectServer),
                //   style: TextStyle(
                //       color: HexColor.fromHex("62CBC9"),
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold),
                //   minFontSize: 10,
                //   maxLines: 1,
                // ),
                child: Body1AutoText(
                  text: StringLocalization.of(context)
                      .getText(StringLocalization.selectServer),
                  color: HexColor.fromHex("62CBC9"),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  minFontSize: 10,
                  // maxLine: 1,
                ),
              ),
              centerTitle: true,
            ),
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: serverTypes.length,
            itemBuilder: (ctx, index) {
              return Container(
                child: Row(
                  children: [
                    Radio(
                        value: serverTypes[index],
                        groupValue: selectedValue,
                        onChanged: (s) {
                          print('change_server ');
                          selectedValue = s!.toString();
                          preferences?.setString(Constants.prefServerType, s.toString());
                          setState(() {});
                          // Navigator.pop(context);


                        }),
                    Body1AutoText(
                      text: serverTypes[index],
                      fontSize: 20,
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }



  getPreferences() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    String? server = preferences?.getString(Constants.prefServerType);
    if (server != null && server.isNotEmpty) {
      selectedValue = server;
    }
    setState(() {});
  }
}
