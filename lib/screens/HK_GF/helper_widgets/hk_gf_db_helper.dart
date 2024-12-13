import 'package:flutter/cupertino.dart';
import 'package:health_gauge/models/health_kit_or_google_fit_model.dart';
import 'package:health_gauge/utils/database_helper.dart';

class HKGFDBHelper {
  static final HKGFDBHelper _instance = HKGFDBHelper();

  static HKGFDBHelper get instance => _instance;

  Future<List<HealthKitOrGoogleFitModel>> getHealthKitDataByType({
    required String userID,
    required String typeName,
    int limit = 50,
    int offset = 0,
  }) async {
    var dataList = <HealthKitOrGoogleFitModel>[];
    try {
      var db = await DatabaseHelper.instance.database;
      List<Map> listDemo = await db.rawQuery(
          "SELECT * FROM HealthKitOrGoogleFitTable where user_id = '$userID' And typeName = '$typeName' ORDER BY startTime DESC LIMIT $limit OFFSET $offset");
      dataList = listDemo.map(HealthKitOrGoogleFitModel.fromMap).toList();
    } catch (e) {
      debugPrint('Exception in db helper class $e');
    }
    return dataList;
  }
}
