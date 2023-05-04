// To parse this JSON data, do
//
//     final saveMpin = saveMpinFromJson(jsonString);

import 'dart:convert';

List<SaveMpin> saveMpinFromJson(String str) => List<SaveMpin>.from(json.decode(str).map((x) => SaveMpin.fromJson(x)));

String saveMpinToJson(List<SaveMpin> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SaveMpin {
  SaveMpin({
    this.statuscode,
    this.status,
  });

  int statuscode;
  String status;

  factory SaveMpin.fromJson(Map<String, dynamic> json) => SaveMpin(
    statuscode: json["STATUSCODE"],
    status: json["STATUS"],
  );

  Map<String, dynamic> toJson() => {
    "STATUSCODE": statuscode,
    "STATUS": status,
  };

  @override
  String toString() {
    return 'SaveMpin{statuscode: $statuscode, status: $status}';
  }
}
