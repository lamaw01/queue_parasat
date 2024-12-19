// To parse this JSON data, do
//
//     final tellerModel = tellerModelFromJson(jsonString);

import 'dart:convert';

List<TellerModel> tellerModelFromJson(String str) =>
    List<TellerModel>.from(json.decode(str).map((x) => TellerModel.fromJson(x)));

String tellerModelToJson(List<TellerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TellerModel {
  int id;
  int counter;
  String name;
  String type;
  int branchId;
  String branch;
  String window;
  int active;

  TellerModel({
    required this.id,
    required this.counter,
    required this.name,
    required this.type,
    required this.branchId,
    required this.branch,
    required this.window,
    required this.active,
  });

  factory TellerModel.fromJson(Map<String, dynamic> json) => TellerModel(
        id: json["id"],
        counter: json["counter"],
        name: json["name"],
        type: json["type"],
        branchId: json["branch_id"],
        branch: json["branch"],
        window: json["window"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "counter": counter,
        "name": name,
        "type": type,
        "branch_id": branchId,
        "branch": branch,
        "window": window,
        "active": active,
      };
}
