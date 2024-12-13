import 'package:flutter/material.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';

class LibraryShareModel with ChangeNotifier {
  List<UserData> contactList = [];
  List<UserData> searchList = [];
  List<UserData> selectedUserList = [];

  void addToContactList(List<UserData> data) {
    for (var d in data) {
      bool flag = false;
      for (var y in contactList) {
        if (d.id == y.id) {
          flag = true;
          break;
        }
      }
      if (!flag) {
        contactList.add(d);
      }
    }
    notifyListeners();
  }

  void searchInList(String query) {
    searchList = [];
    for (var v in contactList) {
      if (v.firstName!.toUpperCase().contains(query.toUpperCase()) ||
          v.lastName!.toUpperCase().contains(query.toUpperCase()) ||
          "${v.firstName!.toUpperCase()} ${v.lastName!.toUpperCase()}"
              .contains(query.toUpperCase())) {
        searchList.add(v);
      }
    }
    notifyListeners();
  }

  void addSelectedToList(index) {
    selectedUserList.add(searchList[index]);
    notifyListeners();
  }

  void stopSearch() {
    searchList = [];
  }

  void clearSelectedUserList() {
    selectedUserList = [];
    notifyListeners();
  }

  void clearAllData() {
    contactList = [];
    searchList = [];
    selectedUserList = [];
    notifyListeners();
  }
}
