import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/screens/activity_history/bloc/event/activity_history_event.dart';
import 'package:health_gauge/screens/activity_history/bloc/state/activity_history_state.dart';
import 'package:health_gauge/screens/map_screen/model/activity_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';

class ActivityHistoryBloc
    extends Bloc<ActivityHistoryEvent, ActivityHistoryState> {
  bool isInternetAvailable = false;

  ActivityHistoryBloc(ActivityHistoryState initialState) : super(initialState);

  ActivityHistoryState get initialState => HistoryPageLoadingState();

  @override
  Stream<ActivityHistoryState> mapEventToState(
      ActivityHistoryEvent event) async* {
    Future<List<ActivityModel>> getHistoryData() async {
      List<ActivityModel> historyList = [];
      var lstDocument;
      try {
        historyList.clear();
        String? userId = preferences!.getString(Constants.prefUserIdKeyInt);
        Query query = FirebaseFirestore.instance
            .collection('$userId')
            .where('endTime', isNotEqualTo: null);
        try {
          historyList.removeWhere((element) => element.id == null);
          historyList.forEach((element) {
            query.where('Id', isNotEqualTo: element.id);
          });
        } catch (e) {
          print('Exception at getHistoryData $e');
        }
        query.orderBy('endTime', descending: true);
        if (lstDocument != null) {
          query = FirebaseFirestore.instance
              .collection('$userId')
              .where('endTime', isNotEqualTo: null)
              .orderBy('endTime', descending: true);
        }
        await query.get().then((value) {
          if (value.docs != null) {
            var list = value.docs.map((e) => ActivityModel.fromJson(e.data() as Map<String, dynamic>));
            historyList.addAll(list);
            int index =
                historyList.indexWhere((element) => element.endTime == null);
            if (index > -1) {
              historyList.removeAt(index);
            }
            if ((value.docs.length) > 0) {
              lstDocument = value.docs.last;
            }
          }
          var distinctList = <ActivityModel>[];

          historyList.forEach((element) {
            bool isExists =
                distinctList.any((e) => e.endTime == element.endTime);
            if (!isExists) {
              distinctList.add(element);
            }
          });
          historyList = distinctList;
        }).catchError((onError) {
          print('Exception at getHistoryData $onError');
        });
      } catch (e) {
        print(e);
      }
      return historyList;
    }

    if (event is GetHistoryListEvent) {
      List<ActivityModel> model = await getHistoryData();
      yield HistoryPageLoadedState(model: model);
    }
  }
}
