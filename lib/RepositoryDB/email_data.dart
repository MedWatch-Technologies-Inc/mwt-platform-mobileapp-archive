import 'package:health_gauge/models/inbox_models/message_list_model.dart';
import 'package:health_gauge/utils/database_helper.dart';

class EmailData {
  final dbHelper = DatabaseHelper.instance;

  Future insertDraft(InboxData inboxData) =>
      dbHelper.insertEmailData(inboxData.toJsonToInsertInDb(0, 0));

  Future<List<InboxData>> viewDrafts(int userId) async {
    List<InboxData> emailList = <InboxData>[];
    emailList = await dbHelper.getEmailList(4, userId);
    return emailList;
  }
  Future deleteDrafts(int id)=>dbHelper.deleteEmailRow(id);

  Future<List<InboxData>> getMessageList(int messageTypeId , int userId) async {
    List<InboxData> emailList = <InboxData>[];
    emailList = await dbHelper.getEmailList(messageTypeId, userId);
    return emailList;
  }
  Future insertOutbox(InboxData inboxData) =>
      dbHelper.insertEmailData(inboxData.toJsonToInsertInDb(0, 0));

  Future<List<InboxData>> viewOutBox(int userId) async {
    List<InboxData> emailList = <InboxData>[];
    emailList = await dbHelper.getEmailList(5, userId);
    return emailList;
  }
  Future deleteOutbox(int id)=>dbHelper.deleteEmailRow(id);

  Future updateDrafts({InboxData? inboxData,int? id}) async{
    return dbHelper.updateDrafts(inboxData!.toJsonToInsertInDb(inboxData.isViewed!?1:0,inboxData.isDeleted!?1:0),id!);
  }

  Future updateIsSync(int messageId) =>
    dbHelper.updateSyncForEmail(messageId);

  Future deleteTrashEmail(int messageId) =>
      dbHelper.deleteEmailRowFromMessageId(messageId);
}

