import 'package:flutter/material.dart';
import 'package:health_gauge/models/library_models/library_list.dart';

class LibraryNotifierModel with ChangeNotifier {
  bool isSearchOpen = false;
  String currentScreen = 'MyDrive';
  String sortBy = 'Name';
  int libraryId = 0;
  int pageId = 1;
  List<LibraryList> dataList = [];
  List<LibraryList> searchList = [];
  bool isUploading = false;
  bool openKeyboardFolder = false;

  void changeKeyboard(bool value) {
    openKeyboardFolder = value;
    notifyListeners();
  }

  void changeIsSearchOpen() {
    isSearchOpen = !isSearchOpen;
    notifyListeners();
  }

  void changeCurrentScreen(String screen) {
    currentScreen = screen;
    notifyListeners();
  }

  void changePageID(int id) {
    pageId = id;
    notifyListeners();
  }

  void addToDataList(List<LibraryList> libraryList) {
    dataList.addAll(libraryList);
    searchList.addAll(dataList);
    notifyListeners();
  }

  void removeFromList(int index) {
    dataList.removeAt(index);
    searchList.removeAt(index);
    notifyListeners();
  }

  void clearDataList() {
    dataList.clear();
    searchList.clear();
    notifyListeners();
  }

  void changeSortBy(String sortName) {
    sortBy = sortName;
    notifyListeners();
  }

  void deleteDataFromApiID(int id) {
    int index = 0;
    for (var i = 0; i < dataList.length; i++) {
      if (dataList[i].libraryID == id) {
        index = i;
        break;
      }
    }
    dataList.removeAt(index);
    searchList.removeAt(index);
    notifyListeners();
  }

  void changeIsUploading() {
    isUploading = !isUploading;
    notifyListeners();
  }

  void searchData(String query) {
    searchList.clear();
    for (var data in dataList) {
      if (data.virtualFilePath!.toLowerCase().contains(query)) {
        searchList.add(data);
      }
    }
    notifyListeners();
  }
}
