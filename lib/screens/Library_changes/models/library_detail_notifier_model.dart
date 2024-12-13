import 'package:flutter/material.dart';
import 'package:health_gauge/models/library_models/library_list.dart';

class LibraryDetailNotifierModel with ChangeNotifier{
  bool isSearchOpen = false;
  String currentScreen = '';
  String sortBy = 'Name';
  int libraryId = 0;
  int pageId = 1;
  List<LibraryList> dataList = [];
  bool isUploading = false;
  bool openKeyboardFolder = false;

  void changeKeyboard(bool value){
    openKeyboardFolder = value;
    notifyListeners();
  }

  void changeLibraryId(int id){
    libraryId = id;
    notifyListeners();
  }

  void changeIsSearchOpen(){
    isSearchOpen = !isSearchOpen;
    notifyListeners();
  }

  void changeCurrentScreen(String screen){
    currentScreen = screen;
    notifyListeners();
  }

  void changePageID(int id){
    pageId = id;
    notifyListeners();
  }

  void addToDataList(List<LibraryList> libraryList){
    dataList.addAll(libraryList);
    notifyListeners();
  }


  void removeFromList(int index){
    dataList.removeAt(index);
    notifyListeners();
  }

  void clearDataList(){
    dataList = [];
    notifyListeners();
  }

  void changeSortBy(String sortName) {
    sortBy = sortName;
    notifyListeners();
  }

  void deleteDataFromApiID(int id){
    int index = 0;
    for(var i=0;i < dataList.length;i++){
      if(dataList[i].libraryID == id){
        index = i;
        break;
      }
    }
    dataList.removeAt(index);
    notifyListeners();
  }

  void changeIsUploading(){
    isUploading = !isUploading;
    notifyListeners();
  }

}