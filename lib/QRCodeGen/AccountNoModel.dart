// To parse this JSON data, do
//
//     final accNoModel = accNoModelFromJson(jsonString);

import 'dart:convert';

List<AccNoModel> accNoModelFromJson(String str) => List<AccNoModel>.from(json.decode(str).map((x) => AccNoModel.fromJson(x)));

String accNoModelToJson(List<AccNoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccNoModel {
  AccNoModel({
    this.accNo,
  });

  String accNo;

  factory AccNoModel.fromJson(Map<String, dynamic> json) => AccNoModel(
    accNo: json["Acc_No"],
  );

  Map<String, dynamic> toJson() => {
    "Acc_No": accNo,
  };

  @override
  String toString() {
    return 'AccNoModel{accNo: $accNo}';
  }
}
