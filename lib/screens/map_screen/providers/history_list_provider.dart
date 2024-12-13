import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/screens/map_screen/model/activity_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';

class HistoryListProvider extends ChangeNotifier {
  bool _isPageLoad = false;
  bool _isScreenLoad = true;

  bool get isScreenLoad => _isScreenLoad;

  set isScreenLoad(bool value) {
    _isScreenLoad = value;
    notifyListeners();
  }

  bool get isPageLoad => _isPageLoad;

  set isPageLoad(bool value) {
    _isPageLoad = value;
    notifyListeners();
  }

  var lstDocument;

  List<ActivityModel> _historyList = [];

  List<ActivityModel> get historyList => _historyList;

  set historyList(List<ActivityModel> value) {
    _historyList = value;
    notifyListeners();
  }

  void getHistoryData() {
    try {
      if (lstDocument == null) {
        historyList.clear();
      }
      var userId = preferences!.getString(Constants.prefUserIdKeyInt);
      Query query = FirebaseFirestore.instance
          .collection('$userId')
          .where('endTime', isNotEqualTo: null);
      try {
        historyList.removeWhere((element) => element.id == null);
        for (var element in historyList) {
          query.where('Id', isNotEqualTo: element.id);
        }
      } catch (e) {
        print('Exception at getHistoryData $e');
      }
      // query.orderBy('endTime', descending: true).limit(25);
      query.orderBy('endTime', descending: true);
      if (lstDocument != null) {
        query = FirebaseFirestore.instance
            .collection('$userId')
            .where('endTime', isNotEqualTo: null)
            .orderBy('endTime', descending: true);
        // .limit(25)
        // .startAfterDocument(lstDocument);
      }
      query.get().then((value) {
        if (value.docs != null) {
          var list = value.docs.map((e) => ActivityModel.fromJson(e.data() as Map<String, dynamic>));
          historyList.addAll(list);
          var index =
              historyList.indexWhere((element) => element.endTime == null);
          if (index > -1) {
            historyList.removeAt(index);
          }
          if ((value.docs.length) > 0) {
            lstDocument = value.docs.last;
          }
        }
        var distinctList = <ActivityModel>[];

        for (var element in historyList) {
          var isExists = distinctList.any((e) => e.endTime == element.endTime);
          if (!isExists) {
            distinctList.add(element);
          }
        }
        historyList = distinctList;

        isPageLoad = false;
        isScreenLoad = false;
        notifyListeners();
      }).catchError((onError) {
        print('Exception at getHistoryData $onError');
        isPageLoad = false;
        isScreenLoad = false;
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }
}
