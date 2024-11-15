// To parse this JSON data, do
//
//     final branchModel = branchModelFromJson(jsonString);

import 'dart:convert';

List<BranchModel> branchModelFromJson(String str) =>
    List<BranchModel>.from(json.decode(str).map((x) => BranchModel.fromJson(x)));

String branchModelToJson(List<BranchModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BranchModel {
  int id;
  String branch;
  int counter;
  String lastUpdate;
  String updateAt;

  BranchModel({
    required this.id,
    required this.branch,
    required this.counter,
    required this.lastUpdate,
    required this.updateAt,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
        id: json["id"],
        branch: json["branch"],
        counter: json["counter"],
        lastUpdate: json["last_update"],
        updateAt: json["update_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch": branch,
        "counter": counter,
        "last_update": lastUpdate,
        "update_at": updateAt,
      };
}
