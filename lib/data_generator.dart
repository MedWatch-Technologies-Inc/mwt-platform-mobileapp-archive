
import 'package:health_gauge/utils/database_helper.dart';
import 'package:mock_data/mock_data.dart';

class DataGenerator {
  final dbHelper = DatabaseHelper.instance;
  Map<String, dynamic> map ={};
  Map<String, dynamic> sportsMap ={};


  void generate(int userId) async {
    dbHelper.database;

      map['approxSBP'] = mockInteger(40,100);
      map['approxDBP'] = mockInteger(40,110);
      map['approxHr'] = mockInteger(40,100);
      map['hrv'] = mockInteger(40,100);
      map['ecgValue'] = mockInteger(40,100);
      map['ppgValue'] =mockInteger(40,100) ;
      map['user_Id'] = userId;
      map['date'] = DateTime.now().toString();
      map['ecg'] = mockInteger(10,100).toString();
      map['ppg'] = mockInteger(10,100).toString();
      map['tHr'] = mockInteger(0,10);
      map['tSBP'] = mockInteger(40,100);
      map['tDBP'] = mockInteger(110,180);
      map['IsSync'] =mockInteger(0,1);
      print(map);
     await dbHelper.insertMeasurementData(map, userId.toString());
    }

}
