import 'package:flutter/cupertino.dart';
import 'package:health_gauge/utils/database_table_name_and_fields.dart';

class GraphTypeModel {
  int? id;
  String name='';
  String fieldName='';
  String tableName='';
  String color='';
  String image='';
  String userId = '';
  //String titleName;

  GraphTypeModel({this.id, required this.name, required this.fieldName, required this.tableName, required this.color, required this.image});

  GraphTypeModel.fromMap(Map map) {
    if (check(DatabaseTableNameAndFields.GraphTypeId, map)) {
      id = map[DatabaseTableNameAndFields.GraphTypeId];
    }
    if (check(DatabaseTableNameAndFields.GraphTypeName, map)) {
      name = map[DatabaseTableNameAndFields.GraphTypeName];
    }
    if (check(DatabaseTableNameAndFields.GraphTypeFieldName, map)) {
      fieldName = map[DatabaseTableNameAndFields.GraphTypeFieldName];
    }
    if (check(DatabaseTableNameAndFields.GraphTypeTableName, map)) {
      tableName = map[DatabaseTableNameAndFields.GraphTypeTableName];
    }
    if (check(DatabaseTableNameAndFields.GraphTypeColor, map)) {
      color = map[DatabaseTableNameAndFields.GraphTypeColor];
    }
    if (check(DatabaseTableNameAndFields.GraphTypeImage, map)) {
      image = map[DatabaseTableNameAndFields.GraphTypeImage];
    }
    if (check(DatabaseTableNameAndFields.UserId, map)) {
      userId = map[DatabaseTableNameAndFields.UserId];
    }
//    if (check(DatabaseTableNameAndFields.GraphTypeTitleName, map)) {
//      titleName = map[DatabaseTableNameAndFields.GraphTypeTitleName];
//    }
  }

  Map<String,dynamic> toMap(){
    return {
      DatabaseTableNameAndFields.GraphTypeId:id,
      DatabaseTableNameAndFields.GraphTypeName:name,
      DatabaseTableNameAndFields.GraphTypeFieldName:fieldName,
      DatabaseTableNameAndFields.GraphTypeTableName:tableName,
      DatabaseTableNameAndFields.GraphTypeColor:color,
      DatabaseTableNameAndFields.GraphTypeImage:image,
      DatabaseTableNameAndFields.UserId:userId,
      //DatabaseTableNameAndFields.GraphTypeTitleName:titleName,
    };
  }

  check(String key, Map map) {
    if (map != null && map.containsKey(key) && map[key] != null) {
      if (map[key] is String && map[key] == "null") {
        return false;
      }
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return 'GraphTypeModel{id: $id, name: $name, fieldName: $fieldName, tableName: $tableName, color: $color}';
  }
}
