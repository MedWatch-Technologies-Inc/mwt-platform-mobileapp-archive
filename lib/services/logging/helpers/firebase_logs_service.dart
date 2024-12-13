import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_gauge/services/logging/contracts/logger_contract.dart';
import 'package:health_gauge/services/logging/core/logging_service_record.dart';

class FirebaseLogsService extends LoggerContract {
  String? currentUser;
  CollectionReference logs = FirebaseFirestore.instance.collection('logs');

  @override
  Future<void> init() async {
    // TODO: implement init
  }

  @override
  void setUserInfo(String? id) {
    currentUser = id;
  }

  @override
  void unSetUserInfo() {
    currentUser = null;
  }

  @override
  void log(LoggingServiceRecord record) {
    logs
        .doc('Logs')
        .collection(currentUser ?? 'Unknown User')
        .doc(DateTime.now().toString())
        .set(record.getMap());
  }
}
