import 'package:flutter/material.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';

import '../../../../models/contact_models/get_invitation_list_model.dart';

class ContactScreenModel with ChangeNotifier {
  bool isSearchOpen = false;
  List<UserData> dataList = [];
  List<UserData> searchList = [];
  List<GetInvitationListModel> getInvitationListModel = [];
  bool searching = false;
  bool isLoading = false;
  int lengthInvitationList = 0;
  bool checkCondition = false;

  void changeLoading(bool v) {
    isLoading = v;
    notifyListeners();
  }

  void changeDataList(List<UserData> data) {
    dataList = [];
    dataList.addAll(data);
    notifyListeners();
  }

  void changeSearching(bool v) {
    searching = v;
    notifyListeners();
  }

  void changeSearchOpen(bool v) {
    isSearchOpen = v;
    notifyListeners();
  }

  void addInSearchList(List<UserData> data) {
    searchList = [];
    searchList.addAll(data);
    notifyListeners();
  }

  void removeData(int index) {
    dataList.removeAt(index);
    notifyListeners();
  }

  void removeSearchData(int index) {
    searchList.removeAt(index);
    notifyListeners();
  }

  void changeInvitationLength(int length) {
    lengthInvitationList = length;
    notifyListeners();
  }

  void removeContactData(int index) {
    getInvitationListModel.remove(index);

    notifyListeners();
  }
}