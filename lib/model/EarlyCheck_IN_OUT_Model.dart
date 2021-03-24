// To parse this JSON data, do
//
//     final earlyCheckInOutModel = earlyCheckInOutModelFromJson(jsonString);

import 'dart:convert';

EarlyCheckInOutModel earlyCheckInOutModelFromJson(String str) => EarlyCheckInOutModel.fromJson(json.decode(str));

String earlyCheckInOutModelToJson(EarlyCheckInOutModel data) => json.encode(data.toJson());

class EarlyCheckInOutModel {
  EarlyCheckInOutModel({
    this.employeeId,
    this.reasion,
    this.status,
    this.deleted,
    this.date,
  });

  String employeeId;
  String reasion;
  int status;
  int deleted;
  String date;

  factory EarlyCheckInOutModel.fromJson(Map<String, dynamic> json) => EarlyCheckInOutModel(
    employeeId: json["employee_id"],
    reasion: json["reasion"],
    status: json["status"],
    deleted: json["deleted"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "employee_id": employeeId,
    "reasion": reasion,
    "status": status,
    "deleted": deleted,
    "date": date,
  };
}
