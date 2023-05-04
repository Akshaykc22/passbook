// To parse this JSON data, do
//
//     final durationModel = durationModelFromJson(jsonString);

import 'dart:convert';

List<DurationModel> durationModelFromJson(String str) => List<DurationModel>.from(json.decode(str).map((x) => DurationModel.fromJson(x)));

String durationModelToJson(List<DurationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DurationModel {
  DurationModel({
    this.pkcCode,
    this.pkcType,
    this.pkcId,
    this.pkcDesc,
    this.pkcOrdNo,
    this.pkcParentId,
    this.pkcLocked,
  });

  int pkcCode;
  int pkcType;
  int pkcId;
  String pkcDesc;
  int pkcOrdNo;
  int pkcParentId;
  dynamic pkcLocked;

  factory DurationModel.fromJson(Map<String, dynamic> json) => DurationModel(
    pkcCode: json["Pkc_Code"],
    pkcType: json["Pkc_Type"],
    pkcId: json["Pkc_Id"],
    pkcDesc: json["Pkc_Desc"],
    pkcOrdNo: json["Pkc_OrdNo"],
    pkcParentId: json["Pkc_ParentId"],
    pkcLocked: json["Pkc_Locked"],
  );

  Map<String, dynamic> toJson() => {
    "Pkc_Code": pkcCode,
    "Pkc_Type": pkcType,
    "Pkc_Id": pkcId,
    "Pkc_Desc": pkcDesc,
    "Pkc_OrdNo": pkcOrdNo,
    "Pkc_ParentId": pkcParentId,
    "Pkc_Locked": pkcLocked,
  };

  @override
  String toString() {
    return 'DurationModel{pkcCode: $pkcCode, pkcType: $pkcType, pkcId: $pkcId, pkcDesc: $pkcDesc, pkcOrdNo: $pkcOrdNo, pkcParentId: $pkcParentId, pkcLocked: $pkcLocked}';
  }
}
