import 'package:health_gauge/models/terra_models/daily_data_models/daily_data_model.dart';
import 'package:health_gauge/models/terra_models/daily_data_models/user.dart';

class DailyData {
  DailyData({
    this.data,
    this.status,
    this.type,
    this.user,
  });

  DailyData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DailyDataModel.fromJson(v));
      });
    }
    status = json['status'];
    type = json['type'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  List<DailyDataModel>? data;
  String? status;
  String? type;
  User? user;

  DailyData copyWith({
    List<DailyDataModel>? data,
    String? status,
    String? type,
    User? user,
  }) =>
      DailyData(
        data: data ?? this.data,
        status: status ?? this.status,
        type: type ?? this.type,
        user: user ?? this.user,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['status'] = status;
    map['type'] = type;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}
