import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/utils/database_helper.dart';

class ContactsData {
  final dbHelper = DatabaseHelper.instance;

  Future insertContact(
      {UserData? contact, int? isAccepted, isRejected, isRemoved}) async {
    dbHelper.insertContactsData(
        contact!.toJsonToInsertInDb(isAccepted ?? 0, isRejected, isRemoved));
  }

  Future getContactsList({int? userId}) async {
    return dbHelper.getContactsList(userId ?? 0);
  }

}