import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class WeightMeasurementDetail extends StatefulWidget {
  final int index;
  final WeightMeasurementModel data;

  WeightMeasurementDetail({required this.index, required this.data});

  @override
  _WeightMeasurementDetailState createState() =>
      _WeightMeasurementDetailState();
}

class _WeightMeasurementDetailState extends State<WeightMeasurementDetail> {
  late PageController pc;
  late int selectedPage;
  String emptyData = '--.--';

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: widget.index);
    selectedPage = widget.index;
  }

  Widget msrmentDetail(title, IconData icon, String info, dynamic val, Function crd, String msrType) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Icon(icon, size: 80.h),
            ),
            Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 30.h, top: 20),
                alignment: Alignment.centerLeft,
                child: Text(info, style: TextStyle(fontSize: 16.h))),
            crd(title, val, msrType),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> msrmentDetList = [
      msrmentDetail(
          //StringLocalization.of(context).getText(StringLocalization.weightSum),
          "Weight",
          Icons.brightness_medium,
          "For accurate results, it is recommended to wear loose /lightweighed clothes before weighing.",
          widget.data.weightSum == null
              ? widget.data.weightSum
              : double.parse(widget.data.weightSum!.toStringAsFixed(2)),
          WeightMeasurementCard.wgSumCard,
          "kg"),
      msrmentDetail(
          //StringLocalization.of(context).getText(StringLocalization.bMI),
        "BMI",
          Icons.graphic_eq,
          "The body mass index or BMI is a international tool to assess weight and health status. The formula is BMl = kg/m2.",
          widget.data.bMI == null ? widget.data.bMI : double.parse(widget.data.bMI!.toStringAsFixed(2)),
          WeightMeasurementCard.bMICard,
          ""
      ),
      msrmentDetail(
          //StringLocalization.of(context).getText(StringLocalization.fatRate),
        "Fat Rate",
          Icons.details,
          "The proportion of adipose tissue in body composition, it reflects the level of fat in our body.",
          widget.data.fatRate == null ? widget.data.fatRate : double.parse(widget.data.fatRate!.toStringAsFixed(2)),
          WeightMeasurementCard.fatRateCard,
          "%"
      ),
      msrmentDetail(
         // StringLocalization.of(context).getText(StringLocalization.muscle),
        "Muscle",
          Icons.brightness_medium,
          "The proportion value which calculated from muscles of human body, weight, height,etc, can indicate human's physical health and strength.",
          widget.data.muscle == null ? widget.data.muscle : double.parse(widget.data.muscle!.toStringAsFixed(2)),
          WeightMeasurementCard.muscleCard,
          "%"
      ),
      msrmentDetail(
         // StringLocalization.of(context).getText(StringLocalization.moisture),
        "Moisture",
          Icons.brightness_medium,
          "The percentage of water content in body composition. Adequate water can boost the body's ability to burn fat, which increase the metabolic rate in healthy men and women.",
          widget.data.moisture == null ? widget.data.moisture : double.parse(widget.data.moisture!.toStringAsFixed(2)),
          WeightMeasurementCard.moistureCard,
          "%"
      ),
      msrmentDetail(
          //StringLocalization.of(context).getText(StringLocalization.boneMass),
        "Bone Mass",
          Icons.brightness_medium,
          "Bone tissue consists of bone minerals(calcium, phosphorus etc)and bone matrix(collagen fiber, ground substance, inorganic salt,etc.) per unit volume.",
          widget.data.boneMass == null ? widget.data.boneMass : double.parse(widget.data.boneMass!.toStringAsFixed(2)),
          WeightMeasurementCard.boneMassCard,
          "kg"
      ),
      msrmentDetail(
          //StringLocalization.of(context).getText(StringLocalization.subcutaneousFat),
         "Subcuntaneous Fat",
          Icons.brightness_medium,
          "Subcutaneous adipose tissure (fat)lies between the dermis layer(skin) and fascia layer(connective tissue).",
          widget.data.subcutaneousFat == null ? widget.data.subcutaneousFat : double.parse(widget.data.subcutaneousFat!.toStringAsFixed(2)),
          WeightMeasurementCard.subFatCard,
          "%"
      ),
      msrmentDetail(
          //StringLocalization.of(context).getText(StringLocalization.bMR),
        "BMR",
          Icons.brightness_medium,
          "Basal metabolic rate(BMR)is the minimum necessary energy needed in an inactive state.",
          widget.data.bMR,
          WeightMeasurementCard.bMRCard,
          "kcal"
      ),
      msrmentDetail(

         // StringLocalization.of(context).getText(StringLocalization.proteinRate),
        "Protein Rate",
          Icons.brightness_medium,
          "Protein plays a vital role in the body, as it builds and maintains muscles, organs and other tissue.",
          widget.data.proteinRate == null ? widget.data.proteinRate : double.parse(widget.data.proteinRate!.toStringAsFixed(2)),
          WeightMeasurementCard.proteinRateCard,
          "%"
      ),
      msrmentDetail(
         // StringLocalization.of(context).getText(StringLocalization.visceralFatIndex),
         "Visceral Fat Index",
          Icons.brightness_medium,
          "Visceral fat area can lead to health-related complications more likely to occur.",
          widget.data.visceralFat,
          WeightMeasurementCard.visFatIndexCard,
          ""
      ),
      msrmentDetail(
         // StringLocalization.of(context).getText(StringLocalization.physicalAge),
        "Physical Age",
          Icons.brightness_medium,
          "Metabolic age is based on basal metabolic rate, comprehensively calculated from weight, height, fat, and muscle. It is a reference to evaluate if the you are actually older or younger than Metabolic Age.",
          widget.data.physicalAge,
          WeightMeasurementCard.phyAgeCard,
          ""
      ),
      msrmentDetail(
          "Obesity Level",
          Icons.brightness_medium,
          "Obesity level indicates the difference of actual weight and standar weight. it is an index of fat disease.",
          widget.data.fatLevel,
          WeightMeasurementCard.fatLvlCard,
          ""),
      msrmentDetail(
          "Fat Mass",
          Icons.brightness_medium,
          "Body composition fat tissue ratio.",
          widget.data.fatMass == null ? widget.data.fatMass : double.parse(widget.data.fatMass!.toStringAsFixed(2)),
          WeightMeasurementCard.fatMassCard,
          "kg"
      ),
      msrmentDetail(
          "Muscle Mass",
          Icons.brightness_medium,
          "The total muscle weight, including skeletal muscle, cardiac, and smooth muscle.",
          widget.data.muscleMass == null ? widget.data.muscleMass : double.parse(widget.data.muscleMass!.toStringAsFixed(2)),
          WeightMeasurementCard.muscleMassCard,
          "kg"
      ),
      msrmentDetail(
          "Protein Mass",
          Icons.brightness_medium,
          "Protein is an important component of all cells.The amount of protein refers to the actual weight of the protein in the human body and is one of the indicators of physical health.",
          widget.data.proteinMass == null ? widget.data.proteinMass : double.parse(widget.data.proteinMass!.toStringAsFixed(2)),
          WeightMeasurementCard.proteinMassCard,
          "kg"
      ),
      msrmentDetail(
          'Standard Weight',
          Icons.brightness_medium,
          "Standard weight is one of the important measurement of physical health condition.The relationship between height and weight can be a basic indicator of one's well-being.",
          widget.data.standardWeight,
          WeightMeasurementCard.standardWgCard,
          "kg"
      ),
      msrmentDetail(
          "Weight Control",
          Icons.brightness_medium,
          "Shows the difference between the actual weight and standard weight.",
          widget.data.weightControl == null ? widget.data.weightControl : double.parse(widget.data.weightControl!.toStringAsFixed(2)),
          WeightMeasurementCard.wgControlCard,
          "kg"
      ),
      msrmentDetail(
          "Weight Without Fat",
          Icons.brightness_medium,
          "The weight deducting body fat , it reflects physical health condition.",
          widget.data.weightWithoutFat == null ? widget.data.weightWithoutFat : double.parse(widget.data.weightWithoutFat!.toStringAsFixed(2)),
          WeightMeasurementCard.wgWithoutFatCard,
          "kg"
      ),
    ];


    //ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
//              pageSnapping: true,
              controller: pc,
              onPageChanged: (val){
                setState(() {
                  selectedPage = val;
                });
              },
              scrollDirection: Axis.horizontal,
              children: msrmentDetList),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin : EdgeInsets.only(bottom: 10.h),
              child : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for(int i=0 ; i < msrmentDetList.length ; i++ )
                    Padding(
                      padding: EdgeInsets.symmetric( horizontal : 2.w),
                      child: CircleAvatar(
                        radius: 2.h,
                        backgroundColor: selectedPage != i ? AppColor.primaryColor.withOpacity(0.4) : AppColor.primaryColor ,
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
class WeightMeasurementCard {

  //card functions
  static Widget header(title, val, type) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(title, style: TextStyle(fontSize: 16.sp, color: Colors.white),),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(val != null ? '$val$type' : "--/--", style: TextStyle(fontSize: 16.sp, color: Colors.white),),
        )
      ],
    );
  }
  static Widget singleLine(val, min, max,IconData emojiStatus) {
    double res = ( (val - min)/(max - min) ) * 2 ;
    res = res - 1;
    return Expanded(
        flex: 1,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: double.infinity,
              height: 2,
              color: Colors.white,
            ),
            val!=0? Align(
                alignment : Alignment(res,-1),
                child: Container(color: AppColor.primaryColor,child: Icon(emojiStatus, size: 20, color: Colors.white,))):SizedBox()
          ],
        ));
  }
  static Widget lowerText(txt) {
    return Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 20),
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(txt, style: TextStyle(fontSize: 14.sp, color: Colors.white),),
        ));
  }
  static Widget verticalLine() {
    return DottedLine(
      dashLength: 2,
      dashGapLength: 1,
      lineThickness: 1,
      dashColor: AppColor.white,
      dashGapColor: AppColor.trans,
      direction: Axis.vertical,
      lineLength: 20,
    );
  }


  //cards for all components
  static Widget wgSumCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            header(title, val, msrType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('55.4$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('74.8$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('89.8$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ],
            ),
            Row(
              children: <Widget>[
                val!=null?val.toDouble() < 55.4 ? singleLine(val,0,40, Icons.sentiment_neutral):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 74.8 && val.toDouble() >= 55.4 ?singleLine(val,55.4,74.8, Icons.sentiment_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 89.8 && val.toDouble() > 74.8 ?singleLine(val,74.8,89.8, Icons.sentiment_dissatisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() <=200 && val.toDouble() > 89.8 ?singleLine(val,89.8,200, Icons.sentiment_very_dissatisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
              ],
            ),
            Row(
              children: <Widget>[
                lowerText(stringLocalization.getText(
                    StringLocalization.thin)),
                lowerText(stringLocalization.getText(
                    StringLocalization.ideal)),
                lowerText(stringLocalization.getText(
                    StringLocalization.overWeightText)),
                lowerText(stringLocalization.getText(
                    StringLocalization.obeseText)),
              ],
            ),
          ],
        )
    );
  }

  static Widget bMICard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            header(title, val, msrType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('18.5$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('25$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('30$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ],
            ),
            Row(
              children: <Widget>[
                val!=null?val.toDouble() < 18.5 ? singleLine(val,0,18.5, Icons.sentiment_neutral):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 25 && val.toDouble() > 18.5 ?singleLine(val,18.5,25, Icons.sentiment_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 30 && val.toDouble() > 25 ?singleLine(val,25,30, Icons.sentiment_dissatisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() <=100 && val.toDouble() > 30 ?singleLine(val,30,100, Icons.sentiment_very_dissatisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
              ],
            ),
            Row(
              children: <Widget>[
                lowerText(stringLocalization.getText(
                    StringLocalization.thin)),
                lowerText(stringLocalization.getText(
                    StringLocalization.ideal)),
                lowerText(stringLocalization.getText(
                    StringLocalization.overWeightText)),
                lowerText(stringLocalization.getText(
                    StringLocalization.obeseText)),
              ],
            ),
          ],
        )
    );
  }

  static Widget fatRateCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            header(title, val, msrType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('10$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('21$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('26$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ],
            ),
            Row(
              children: <Widget>[
                val!=null?val.toDouble() < 10 ? singleLine(val,0,10, Icons.sentiment_very_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 21 && val.toDouble() > 10 ?singleLine(val,10,21, Icons.sentiment_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 26 && val.toDouble() > 21 ?singleLine(val,21,26, Icons.sentiment_dissatisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() <=100 && val.toDouble() > 26 ?singleLine(val,26,100, Icons.sentiment_very_dissatisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
              ],
            ),
            Row(
              children: <Widget>[
                lowerText(stringLocalization.getText(
                    StringLocalization.low)),
                lowerText(stringLocalization.getText(
                    StringLocalization.ideal)),
                lowerText(stringLocalization.getText(
                    StringLocalization.highCalibration)),
                lowerText(stringLocalization.getText(
                    StringLocalization.highCalibration)),
              ],
            ),
          ],
        )
    );
  }

  static Widget muscleCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            header(title, val, msrType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('40$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('60$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ],
            ),
            Row(
              children: <Widget>[
                val!=null?val.toDouble() < 40 ? singleLine(val,0,40, Icons.mood):singleLine(0,0,0,Icons.sentiment_neutral):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 60 && val.toDouble() > 40 ?singleLine(val,40,60, Icons.sentiment_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() <= 100 && val.toDouble() > 60 ?singleLine(val,60,100, Icons.sentiment_very_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
              ],
            ),
            Row(
              children: <Widget>[
                lowerText(stringLocalization.getText(
                    StringLocalization.low)),
                lowerText(stringLocalization.getText(
                    StringLocalization.ideal)),
                lowerText(stringLocalization.getText(
                    StringLocalization.excellent)),
              ],
            ),
          ],
        )
    );
  }

  static Widget moistureCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            header(title, val, msrType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('55$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('65$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ],
            ),
            Row(
              children: <Widget>[
                val!=null?val.toDouble() < 55 ? singleLine(val,0,55,Icons.sentiment_neutral):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 65 && val.toDouble() > 55 ?singleLine(val,55,65,Icons.sentiment_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() <= 100 && val.toDouble() > 65 ?singleLine(val,65,100,Icons.sentiment_very_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
              ],
            ),
            Row(
              children: <Widget>[
                lowerText(stringLocalization.getText(
                    StringLocalization.low)),
                lowerText(stringLocalization.getText(
                    StringLocalization.ideal)),
                lowerText(stringLocalization.getText(
                    StringLocalization.excellent)),
              ],
            ),
          ],
        )
    );
  }

  static Widget boneMassCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            header(title, val, msrType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('2.8$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('3.0$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ],
            ),
            Row(
              children: <Widget>[
                val!=null?val.toDouble() < 2.8 ? singleLine(val,0,2.8,Icons.sentiment_neutral):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 3 && val.toDouble() > 2.8 ?singleLine(val,2.8,3,Icons.sentiment_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() <= 5 && val.toDouble() > 3 ?singleLine(val,3,5,Icons.sentiment_very_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
              ],
            ),
            Row(
              children: <Widget>[
                lowerText(stringLocalization.getText(
                    StringLocalization.low)),
                lowerText(stringLocalization.getText(
                    StringLocalization.ideal)),
                lowerText(stringLocalization.getText(
                    StringLocalization.excellent)),
              ],
            ),
          ],
        )
    );
  }

  static Widget subFatCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            header(title, val, msrType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('7$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('15$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white))
              ],
            ),
            Row(
              children: <Widget>[
                val!=null?val.toDouble() < 7 ? singleLine(val,0,7,Icons.sentiment_very_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 15 && val.toDouble() > 7 ?singleLine(val,7,15,Icons.sentiment_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() <= 40 && val.toDouble() > 15 ?singleLine(val,15,40,Icons.sentiment_neutral):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
              ],
            ),
            Row(
              children: <Widget>[
                lowerText(stringLocalization.getText(
                    StringLocalization.low)),
                lowerText(stringLocalization.getText(
                    StringLocalization.ideal)),
                lowerText(stringLocalization.getText(
                    StringLocalization.highCalibration)),
              ],
            ),
          ],
        )
    );
  }

  static Widget bMRCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            header(title, val, msrType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('1637$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ],
            ),
            Row(
              children: <Widget>[
                val!=null?val.toDouble() < 1637 ? singleLine(val,0,1637,Icons.sentiment_neutral):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 2500 && val.toDouble() > 1637 ?singleLine(val,1637,2500,Icons.sentiment_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
              ],
            ),
            Row(
              children: <Widget>[
                lowerText(stringLocalization.getText(
                    StringLocalization.low)),
                lowerText(stringLocalization.getText(
                    StringLocalization.excellent)),
              ],
            ),
          ],
        )
    );
  }

  static Widget proteinRateCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            header(title, val, msrType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('16$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('18$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ],
            ),
            Row(
              children: <Widget>[
                val!=null?val.toDouble() < 16 ? singleLine(val,0,16,Icons.sentiment_neutral):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 18 && val.toDouble() >= 16 ?singleLine(val,16,18,Icons.sentiment_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 40 && val.toDouble() >= 18 ?singleLine(val,18,40,Icons.sentiment_very_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
              ],
            ),
            Row(
              children: <Widget>[
                lowerText(stringLocalization.getText(StringLocalization.low)),
                lowerText(stringLocalization.getText(
                    StringLocalization.ideal)),
                lowerText(stringLocalization.getText(
                    StringLocalization.excellent))
              ],
            ),
          ],
        )
    );
  }

  static Widget visFatIndexCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            header(title, val, msrType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('9$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('14$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ],
            ),
            Row(
              children: <Widget>[
                val!=null?val.toDouble() < 9 ? singleLine(val,0,9,Icons.sentiment_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 14 && val.toDouble() >= 9 ?singleLine(val,9,14,Icons.sentiment_neutral):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 30 && val.toDouble() >= 14 ?singleLine(val,14,30,Icons.sentiment_dissatisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
              ],
            ),
            Row(
              children: <Widget>[
                lowerText(stringLocalization.getText(
                    StringLocalization.ideal)),
                lowerText(stringLocalization.getText(
                    StringLocalization.alert)),
                lowerText(stringLocalization.getText(
                    StringLocalization.alert))
              ],
            ),
          ],
        )
    );
  }

  static Widget phyAgeCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
            child: Text("$title ${val != null ? val: '--/--'}", style: TextStyle(fontSize: 16.sp, color: Colors.white))
        )
    );
  }

  static Widget standardWgCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
            child: Text("$title ${val != null ? '$val$msrType': '--/--'}", style: TextStyle(fontSize: 16.sp, color: Colors.white))
        )
    );
  }

  static Widget fatMassCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            header(title, val, msrType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('6.4$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('13.4$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('16.5$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ],
            ),
            Row(
              children: <Widget>[
                val!=null?val.toDouble() < 6.4 ? singleLine(val,0,6.4,Icons.sentiment_very_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 13.4 && val.toDouble() >= 6.4 ?singleLine(val,6.4,13.4,Icons.sentiment_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 16.5 && val.toDouble() >= 13.4 ?singleLine(val,13.4,16.5,Icons.sentiment_dissatisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 30 && val.toDouble() >= 16.5 ?singleLine(val,16.5,30,Icons.sentiment_very_dissatisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
              ],
            ),
            Row(
              children: <Widget>[
                lowerText(stringLocalization.getText(
                    StringLocalization.low)),
                lowerText(stringLocalization.getText(
                    StringLocalization.ideal)),
                lowerText(stringLocalization.getText(
                    StringLocalization.highCalibration)),
                lowerText(stringLocalization.getText(
                    StringLocalization.highCalibration)),
              ],
            ),
          ],
        )
    );
  }

  static Widget wgWithoutFatCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
            child: Text("$title ${val != null ? '$val$msrType': '--/--'}", style: TextStyle(fontSize: 16.sp, color: Colors.white))
        )
    );
  }

  static Widget muscleMassCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            header(title, val, msrType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('25.0$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('37.6$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white))
              ],
            ),
            Row(
              children: <Widget>[
                val!=null?val.toDouble() < 25 ? singleLine(val,0,25,Icons.sentiment_neutral):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 37.6 && val.toDouble() > 25 ?singleLine(val,25,37.6,Icons.sentiment_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 100 && val.toDouble() > 37.6 ?singleLine(val,37.6,100,Icons.sentiment_very_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
              ],
            ),
            Row(
              children: <Widget>[
                lowerText(stringLocalization.getText(
                    StringLocalization.low)),
                lowerText(stringLocalization.getText(
                    StringLocalization.ideal)),
                lowerText(stringLocalization.getText(
                    StringLocalization.excellent))
              ],
            ),
          ],
        )
    );
  }

  static Widget proteinMassCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            header(title, val, msrType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('10.0$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                Text('11.3$msrType', style: TextStyle(fontSize: 16.sp, color: Colors.white))
              ],
            ),
            Row(
              children: <Widget>[
                val!=null?val.toDouble() < 10 ? singleLine(val,0,10,Icons.sentiment_neutral):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 11.3 && val.toDouble() >= 10 ?singleLine(val,10,11.3,Icons.sentiment_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
                verticalLine(),
                val!=null?val.toDouble() < 30 && val.toDouble() >= 11.3 ?singleLine(val,11.3,50,Icons.sentiment_very_satisfied):singleLine(0,0,0,Icons.face):singleLine(0,0,0,Icons.face),
              ],
            ),
            Row(
              children: <Widget>[
                lowerText(stringLocalization.getText(
                    StringLocalization.low)),
                lowerText(stringLocalization.getText(
                    StringLocalization.ideal)),
                lowerText(stringLocalization.getText(
                    StringLocalization.excellent))
              ],
            ),
          ],
        )
    );
  }

  static Widget fatLvlCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),

        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
            child: Text("$title ${val != null ? val: '--/--'}", style: TextStyle(fontSize: 16.sp, color: Colors.white))
        )
    );
  }

  static Widget wgControlCard(title, val, msrType) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
            child: Text("$title ${val != null ? '$val$msrType': '--/--'}", style: TextStyle(fontSize: 16.sp, color: Colors.white))
        )
    );
  }
}

