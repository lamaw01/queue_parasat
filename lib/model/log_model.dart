// To parse this JSON data, do
//
//     final logModel = logModelFromJson(jsonString);

import 'dart:convert';

List<LogModel> logModelFromJson(String str) => List<LogModel>.from(json.decode(str).map((x) => LogModel.fromJson(x)));

String logModelToJson(List<LogModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LogModel {
  int counter;
  String name;
  String type;
  String window;
  DateTime timeStamp;

  LogModel({
    required this.counter,
    required this.name,
    required this.type,
    required this.window,
    required this.timeStamp,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) => LogModel(
        counter: json["counter"],
        name: json["name"],
        type: json["type"],
        window: json["window"],
        timeStamp: DateTime.parse(json["time_stamp"]),
      );

  Map<String, dynamic> toJson() => {
        "counter": counter,
        "name": name,
        "type": type,
        "window": window,
        "time_stamp": timeStamp.toIso8601String(),
      };
}
