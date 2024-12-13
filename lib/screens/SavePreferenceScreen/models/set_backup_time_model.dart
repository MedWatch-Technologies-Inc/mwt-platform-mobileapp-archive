import 'package:flutter/material.dart';
import 'package:health_gauge/utils/gloabals.dart';

class SetBackupTimeModel with ChangeNotifier{
  List<String> optionList = ['A week','15 days','A month'];
  int selectedIndex = 0;

  void setIndex(int index){
    selectedIndex = index;
    notifyListeners();
  }

  SetBackupTimeModel(){
    loadPreference();
  }

  Future loadPreference() async{
    
    int time = preferences?.getInt('backupTime') ?? -1;
    if(time != null){
      setIndex(time);
    }
  }

  Future savePreference() async{
    
    preferences?.setInt('backupTime',selectedIndex);
  }

}