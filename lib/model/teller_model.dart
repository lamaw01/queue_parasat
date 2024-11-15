// To parse this JSON data, do
//
//     final tellerModel = tellerModelFromJson(jsonString);

import 'dart:convert';

List<TellerModel> tellerModelFromJson(String str) =>
    List<TellerModel>.from(json.decode(str).map((x) => TellerModel.fromJson(x)));

String tellerModelToJson(List<TellerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TellerModel {
  int id;
  String name;
  String type;
  int branchId;
  String branch;

  TellerModel({
    required this.id,
    required this.name,
    required this.type,
    required this.branchId,
    required this.branch,
  });

  factory TellerModel.fromJson(Map<String, dynamic> json) => TellerModel(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        branchId: json["branch_id"],
        branch: json["branch"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "branch_id": branchId,
        "branch": branch,
      };
}
